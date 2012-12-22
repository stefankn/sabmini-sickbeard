//
//  SSBSickBeardShow.m
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 16-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import "SSBSickBeardShow.h"
#import "SSBSickBeardConnector.h"
#import "SSBSickBeardResult.h"
#import "SSBSharedServer.h"
#import "SSBSickBeardServer.h"
#import "SSBSickBeardEpisode.h"

@interface SSBSickBeardShow()

- (void)setAttributes:(NSDictionary *)attributes;

@end

@implementation SSBSickBeardShow
@synthesize identifier, air_by_date, airs, show_cache, flatten_folders, genre, language, location, network, next_ep_airdate, paused, quality, quality_details, season_list, show_name, status, tvrage_id, tvrage_name;

- (id)initWithAttributes:(NSDictionary *)attributes showIdentifier:(NSString *)showIdentifier
{
    self = [super init];
    if (self) {
        self.identifier = showIdentifier;
        [self setAttributes:attributes];
    }
    
    return self;
}

- (void)setAttributes:(NSDictionary *)attributes
{
    self.air_by_date = [[attributes objectForKey:@"air_by_date"] boolValue];
    self.airs = [attributes objectForKey:@"airs"];
    self.show_cache = [attributes objectForKey:@"cache"];
    self.flatten_folders = [[attributes objectForKey:@"flatten_folders"] boolValue];
    self.genre = [attributes objectForKey:@"genre"];
    self.language = [attributes objectForKey:@"language"];
    self.location = [attributes objectForKey:@"location"];
    self.network = [attributes objectForKey:@"network"];
    self.next_ep_airdate = [attributes objectForKey:@"next_ep_airdate"];
    self.paused = [[attributes objectForKey:@"paused"] boolValue];
    self.quality = [attributes objectForKey:@"quality"];
    self.quality_details = [attributes objectForKey:@"quality_details"];
    self.season_list = [[attributes objectForKey:@"season_list"] sortedArrayUsingSelector:@selector(compare:)];
    self.show_name = [attributes objectForKey:@"show_name"];
    self.status = [attributes objectForKey:@"status"];
    self.tvrage_id = [[attributes objectForKey:@"tv_rage_id"] stringValue];
    self.tvrage_name = [attributes objectForKey:@"tvrage_name"];
}

- (void)getFullDetails:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@show&tvdbid=%@", [[SSBSharedServer sharedServer].server urlString], self.identifier]];
    
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        [self setAttributes:[data objectForKey:@"data"]];
        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
    }];
}

// Delete the show from SickBeard
- (void)deleteShow:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@show.delete&tvdbid=%@", [[SSBSharedServer sharedServer].server urlString], self.identifier]];
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
    }];
}

- (void)getEpisodesForSeason:(int)season onComplete:(SSBSickBeardShowRequestDataBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@show.seasons&tvdbid=%@&season=%i", [[SSBSharedServer sharedServer].server urlString], self.identifier, season]];
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {

        NSMutableArray *episodes = [NSMutableArray array];
        NSArray *unsortedArray = [NSArray arrayWithArray:[[data objectForKey:@"data"] allKeys]];
        NSArray *keys = [unsortedArray sortedArrayUsingComparator:^(id firstObject, id secondObject) {
            return [((NSString *)firstObject) compare:((NSString *)secondObject) options:NSNumericSearch];
        }];
        
        for (NSString *key in keys) {
            NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[[data objectForKey:@"data"] objectForKey:key]];
            [attributes setObject:key forKey:@"episode"];
            SSBSickBeardEpisode *episode = [[SSBSickBeardEpisode alloc] initWithAttributes:attributes];
            [episodes addObject:episode];
        }
        
        complete([NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:episodes, [data objectForKey:@"message"], [data objectForKey:@"result"], nil] forKeys:[NSArray arrayWithObjects:@"results", @"message", @"result", nil]]);
    }];
}







// Checks if the poster/banner SickBeard's image cache is valid
- (void)cache:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@show.cache&tvdbid=%@", [[SSBSharedServer sharedServer].server urlString], self.identifier]];
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
    }];
}

//// Retrieve the stored banner image from SickBeard's cache
//- (UIImage *)getBanner {
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@show.getbanner&tvdbid=%@", [[SSBSharedServer sharedServer].server urlString], self.identifier]];
//    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
//    [connector getData:^(NSDictionary *data) {
//        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
//    }];
//}
//
//// Retrieve the stored poster image from SickBeard's cache
//- (UIImage *)getPoster {
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@show.getposter&tvdbid=%@", [[SSBSharedServer sharedServer].server urlString], self.identifier]];
//    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
//    [connector getData:^(NSDictionary *data) {
//        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
//    }];
//}

- (void)getQuality:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@show.getquality&tvdbid=%@", [[SSBSharedServer sharedServer].server urlString], self.identifier]];
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
    }];
}

- (void)pause:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@show.pause&tvdbid=%@&pause=1", [[SSBSharedServer sharedServer].server urlString], self.identifier]];
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
    }];
}

- (void)resume:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@show.pause&tvdbid=%@&pause=0", [[SSBSharedServer sharedServer].server urlString], self.identifier]];
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
    }];
}

- (void)refresh:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@show.refresh&tvdbid=%@", [[SSBSharedServer sharedServer].server urlString], self.identifier]];
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
    }];
}

- (void)getSeasonList:(NSString *)sort onComplete:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@show.seasonlist&tvdbid=%@", [[SSBSharedServer sharedServer].server urlString], self.identifier]];
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
    }];
}

- (void)setQuality:(NSArray *)initial archive:(NSArray *)archive onComplete:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed
{
    
}

- (void)getStatistics:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed
{
    
}

- (void)update:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed
{
    
}

@end
