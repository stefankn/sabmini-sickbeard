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

@implementation SSBSickBeardShow
@synthesize identifier, air_by_date, airs, show_cache, flatten_folders, genres, language, location, network, next_ep_airdate, paused, quality, quality_details, season_list, show_name, status, tvrage_id, tvrage_name;

- (id)initWithAttributes:(NSDictionary *)attributes showIdentifier:(NSString *)showIdentifier
{
    self = [super init];
    if (self) {
        self.identifier = showIdentifier;
        self.air_by_date = [[attributes objectForKey:@"air_by_date"] boolValue];
        self.show_cache = [attributes objectForKey:@"cache"];
        self.language = [attributes objectForKey:@"language"];
        self.network = [attributes objectForKey:@"network"];
        self.next_ep_airdate = [attributes objectForKey:@"next_ep_airdate"];
        self.paused = [[attributes objectForKey:@"paused"] boolValue];
        self.quality = [attributes objectForKey:@"quality"];
        self.show_name = [attributes objectForKey:@"show_name"];
        self.status = [attributes objectForKey:@"status"];
        self.tvrage_id = [[attributes objectForKey:@"tv_rage_id"] stringValue];
        self.tvrage_name = [attributes objectForKey:@"tvrage_name"];
    }
    
    return self;
}

// Checks if the poster/banner SickBeard's image cache is valid
- (SSBSickBeardResult *)cache
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@show.cache&tvdbid=%@", [self.server urlString], self.identifier]];
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
    }];
}

// Delete the show from SickBeard
- (SSBSickBeardResult *)deleteShow
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@show.delete&tvdbid=%@", [self.server urlString], self.identifier]];
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
    }];
}

// Retrieve the stored banner image from SickBeard's cache
- (UIImage *)getBanner {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@show.getbanner&tvdbid=%@", [self.server urlString], self.identifier]];
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
    }];
}

// Retrieve the stored poster image from SickBeard's cache
- (UIImage *)getPoster {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@show.getposter&tvdbid=%@", [self.server urlString], self.identifier]];
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
    }];
}

- (SSBSickBeardResult *)getQuality
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@show.getquality&tvdbid=%@", [self.server urlString], self.identifier]];
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
    }];
}

- (SSBSickBeardResult *)pause
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@show.pause&tvdbid=%@&pause=1", [self.server urlString], self.identifier]];
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
    }];
}

- (SSBSickBeardResult *)resume
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@show.pause&tvdbid=%@&pause=0", [self.server urlString], self.identifier]];
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
    }];
}

- (SSBSickBeardResult *)refresh
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@show.refresh&tvdbid=%@", [self.server urlString], self.identifier]];
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
    }];
}

- (SSBSickBeardResult *)getSeasonList:(NSString *)sort
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@show.seasonlist&tvdbid=%@", [self.server urlString], self.identifier]];
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
    }];
}

- (SSBSickBeardResult *)getEpisodesForSeason:(int)season
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@show.seasons&tvdbid=%@&season=%i", [self.server urlString], self.identifier, season]];
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
    }];
}

@end
