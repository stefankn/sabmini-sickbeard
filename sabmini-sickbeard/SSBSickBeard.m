//
//  SSBSickBeard.m
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 16-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import <objc/runtime.h>
#import "SSBSickBeard.h"
#import "SSBSickBeardServer.h"
#import "SSBSickBeardConnector.h"
#import "SSBSickBeardShow.h"
#import "SSBSickBeardEpisode.h"
#import "SSBSharedServer.h"
#import "SSBSickBeardResult.h"

@interface SSBSickBeard()

//@property (nonatomic, strong) SSBSickBeardServer *server;

@end

@implementation SSBSickBeard

+ (NSArray *)getServers
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *serverData = [defaults objectForKey:@"sickbeard_servers"];
    NSMutableArray *servers = [NSMutableArray array];
    
    if (serverData != NULL) {
        [servers addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:serverData]];
    }
    
    return [NSArray arrayWithArray:servers];
}

+ (SSBSickBeardServer *)createServer:(NSString *)friendlyName withHost:(NSString *)host withPort:(NSString *)port withApikey:(NSString *)apikey enableHttps:(BOOL)https setAsDefault:(BOOL)setDefault
{
    SSBSickBeardServer *server = [[SSBSickBeardServer alloc] init];
    server.friendlyName = friendlyName;
    server.host = host;
    server.port = port;
    server.apikey = apikey;
    server.https = https;
    server.isDefault = setDefault;
    
    NSMutableArray *servers = [NSMutableArray arrayWithArray:[SSBSickBeard getServers]];
    
    if (setDefault) {
        NSEnumerator *e = [servers objectEnumerator];
        SSBSickBeardServer *server;
        while (server = [e nextObject]) {
            server.isDefault = NO;
        }
    }
    
    [servers addObject:server];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:servers];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:@"sickbeard_servers"];
    [defaults synchronize];
    
    return server;
}

+ (void)setActiveServer:(SSBSickBeardServer *)server
{
    [SSBSharedServer sharedServer].server = server;
}

+ (SSBSickBeardServer *)getActiveServer
{
    return [SSBSharedServer sharedServer].server;
}

+ (SSBSickBeardServer *)getDefaultServer
{
    NSMutableArray *servers = [NSMutableArray arrayWithArray:[SSBSickBeard getServers]];
    NSEnumerator *e = [servers objectEnumerator];
    SSBSickBeardServer *server;
    while (server = [e nextObject]) {
        if (server.isDefault) {
            return server;
        }
    }
    
    return nil;
}


// Retrieves the shows that are added to SickBeard
// First param defines the sort type (id or name), second param defines if only paused shows should be retrieved

+ (void)getShows:(NSString *)sort onlyPaused:(BOOL)paused onComplete:(SSBSickBeardRequestDataBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@shows&sort=%@&paused=%i", [[SSBSharedServer sharedServer].server urlString], sort, paused]];
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {

        NSDictionary *shows_data = [data objectForKey:@"data"];
        NSMutableArray *shows = [NSMutableArray array];
        for (NSString *key in shows_data) {
            SSBSickBeardShow *show = [[SSBSickBeardShow alloc] initWithAttributes:[shows_data objectForKey:key] showIdentifier:key];
            [shows addObject:show];
        }
        
        complete([NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:shows, [data objectForKey:@"message"], [data objectForKey:@"result"], nil] forKeys:[NSArray arrayWithObjects:@"results", @"message", @"result", nil]]);
    } onFailure:^(SSBSickBeardResult *result) {
        failed(result);
    }];
}

+ (void)getFutureEpisodesForType:(NSString *)type withPaused:(BOOL)paused sortOn:(NSString *)sort onComplete:(SSBSickBeardRequestDataBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@future&sort=%@&type=%@&paused=%i", [[SSBSharedServer sharedServer].server urlString], sort, type, paused]];

    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        
        NSDictionary *episodesData = [data objectForKey:@"data"];
        NSMutableDictionary *mappedEpisodes = [NSMutableDictionary dictionary];
        for (NSString *key in episodesData) {
            
            NSMutableArray *episodes = [NSMutableArray array];
            NSEnumerator *e = [[episodesData objectForKey:key] objectEnumerator];
            NSDictionary *episodeDict;
            while (episodeDict = [e nextObject]) {
                SSBSickBeardEpisode *episode = [[SSBSickBeardEpisode alloc] initWithAttributes:episodeDict];
                [episodes addObject:episode];
            }
            
            [mappedEpisodes setObject:episodes forKey:key];
        }

        complete(mappedEpisodes);
    } onFailure:^(SSBSickBeardResult *result) {
        failed(result);
    }];
}

+ (void)getShow:(NSString *)tvdbId onComplete:(SSBSickBeardShowCompleteBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@show&tvdbid=%@", [[SSBSharedServer sharedServer].server urlString], tvdbId]];
    
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        SSBSickBeardShow *show = [[SSBSickBeardShow alloc] initWithAttributes:[data objectForKey:@"data"] showIdentifier:tvdbId];
        complete(show);
    } onFailure:^(SSBSickBeardResult *result) {
        failed(result);
    }];
}

+ (void)getHistory:(int)limit forType:(NSString *)type onComplete:(SSBSickBeardRequestDataBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@history&limit=%i&type=%@", [[SSBSharedServer sharedServer].server urlString], limit, type]];
    
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        NSMutableArray *episodes = [NSMutableArray array];
        NSEnumerator *e = [[data objectForKey:@"data"] objectEnumerator];
        NSDictionary *episodeDict;
        while (episodeDict = [e nextObject]) {
            SSBSickBeardEpisode *episode = [[SSBSickBeardEpisode alloc] initWithAttributes:episodeDict];
            [episodes addObject:episode];
        }
        
        complete([NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:episodes, [data objectForKey:@"message"], [data objectForKey:@"result"], nil] forKeys:[NSArray arrayWithObjects:@"results", @"message", @"result", nil]]);
    } onFailure:^(SSBSickBeardResult *result) {
        failed(result);
    }];
}

+ (void)clearHistory:(SSBSickBeardRequestCompleteBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@history.clear", [[SSBSharedServer sharedServer].server urlString]]];
    
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
    } onFailure:^(SSBSickBeardResult *result) {
        failed(result);
    }];
}

+ (void)trimHistory:(SSBSickBeardRequestCompleteBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@history.trim", [[SSBSharedServer sharedServer].server urlString]]];
    
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
    } onFailure:^(SSBSickBeardResult *result) {
        failed(result);
    }];
}

+ (void)restartActiveServer:(SSBSickBeardRequestCompleteBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sb.restart", [[SSBSharedServer sharedServer].server urlString]]];
    
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
    } onFailure:^(SSBSickBeardResult *result) {
        failed(result);
    }];
}

+ (void)shutdownActiveServer:(SSBSickBeardRequestCompleteBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sb.shutdown", [[SSBSharedServer sharedServer].server urlString]]];
    
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
    } onFailure:^(SSBSickBeardResult *result) {
        failed(result);
    }];
}

+ (void)forceSearch:(SSBSickBeardRequestCompleteBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sb.forcesearch", [[SSBSharedServer sharedServer].server urlString]]];
    
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
    } onFailure:^(SSBSickBeardResult *result) {
        failed(result);
    }];
}

+ (void)searchTvdb:(NSString *)name tvdb:(NSString *)tvdbId language:(NSString *)lang onComplete:(SSBSickBeardRequestDataBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed;
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sb.searchtvdb&name=%@&tvdbid=%@&lang=%@", [[SSBSharedServer sharedServer].server urlString], [name stringByReplacingOccurrencesOfString:@" " withString:@"+"], tvdbId, lang]];

    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete([data objectForKey:@"data"]);
    } onFailure:^(SSBSickBeardResult *result) {
        failed(result);
    }];
}

+ (void)getRootDirs:(SSBSickBeardRequestDataBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sb.getrootdirs", [[SSBSharedServer sharedServer].server urlString]]];
    
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete(data);
    } onFailure:^(SSBSickBeardResult *result) {
        failed(result);
    }];
}

+ (void)getDefaults:(SSBSickBeardRequestDataBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sb.getdefaults", [[SSBSharedServer sharedServer].server urlString]]];
    
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete(data);
    } onFailure:^(SSBSickBeardResult *result) {
        failed(result);
    }];
}

+ (void)addNewShow:(NSString *)tvdbId showLocation:(NSString *)location flattenFolders:(BOOL)flattenFolders initial:(NSArray *)initial archive:(NSArray *)archive initialStatus:(NSString *)status language:(NSString *)lang onComplete:(SSBSickBeardRequestCompleteBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed
{
    NSString *initialQualityParameter = [initial componentsJoinedByString:@"|"];
    NSString *archivedQualityParameter;

    NSString *urlString;
    if ([archive count] != 0) {
        archivedQualityParameter = [archive componentsJoinedByString:@"|"];
        urlString = [NSString stringWithFormat:@"%@show.addnew&tvdbid=%@&location=%@&status=%@&lang=%@&initial=%@&archive=%@&flatten_folders=%i", [[SSBSharedServer sharedServer].server urlString], tvdbId, location, status, lang, initialQualityParameter, archivedQualityParameter, flattenFolders];
    }
    else {
        urlString = [NSString stringWithFormat:@"%@show.addnew&tvdbid=%@&location=%@&status=%@&lang=%@&initial=%@&flatten_folders=%i", [[SSBSharedServer sharedServer].server urlString], tvdbId, location, status, lang, initialQualityParameter, flattenFolders];
    }
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
    } onFailure:^(SSBSickBeardResult *result) {
        failed(result);
    }];
}

+ (void)getLogs:(NSString *)min_level onComplete:(SSBSickBeardRequestDataBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@logs&min_level=%@", [[SSBSharedServer sharedServer].server urlString], min_level]];
    
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete(data);
    } onFailure:^(SSBSickBeardResult *result) {
        failed(result);
    }];
}

@end
