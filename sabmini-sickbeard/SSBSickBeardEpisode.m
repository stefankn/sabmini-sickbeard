//
//  SSBSickBeardEpisode.m
//
//  Created by Stefan Klein Nulent on 16-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import "SSBSickBeardEpisode.h"
#import "SSBSharedServer.h"
#import "SSBSickBeardServer.h"
#import "SSBSickBeardConnector.h"
#import "SSBSickBeardResult.h"

@interface SSBSickBeardEpisode()

- (void)setAttributes:(NSDictionary *)attributes;

@end

@implementation SSBSickBeardEpisode

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self) {
        [self setAttributes:attributes];
    }
    
    return self;
}

- (void)setAttributes:(NSDictionary *)attributes
{
    if ([attributes objectForKey:@"airdate"]) self.airdate = [attributes objectForKey:@"airdate"];
    if ([attributes objectForKey:@"description"]) self.ep_plot = [attributes objectForKey:@"description"];
    if ([attributes objectForKey:@"file_size"]) self.file_size = [[attributes objectForKey:@"file_size"] intValue];
    if ([attributes objectForKey:@"file_size_human"]) self.file_size_human = [attributes objectForKey:@"file_size_human"];
    if ([attributes objectForKey:@"location"]) self.location = [attributes objectForKey:@"location"];
    if ([attributes objectForKey:@"name"]) self.name = [attributes objectForKey:@"name"];
    if ([attributes objectForKey:@"quality"]) self.quality = [attributes objectForKey:@"quality"];
    if ([attributes objectForKey:@"release_name"]) self.release_name = [attributes objectForKey:@"release_name"];
    if ([attributes objectForKey:@"status"]) self.status = [attributes objectForKey:@"status"];
    if ([attributes objectForKey:@"airs"]) self.airs = [attributes objectForKey:@"airs"];
    if ([attributes objectForKey:@"ep_name"]) self.ep_name = [attributes objectForKey:@"ep_name"];
    if ([attributes objectForKey:@"ep_plot"]) self.ep_plot = [attributes objectForKey:@"ep_plot"];
    if ([attributes objectForKey:@"episode"]) self.episode = [attributes objectForKey:@"episode"];
    if ([attributes objectForKey:@"network"]) self.network = [attributes objectForKey:@"network"];
    if ([attributes objectForKey:@"paused"]) self.paused = [[attributes objectForKey:@"paused"] boolValue];
    if ([attributes objectForKey:@"season"]) self.season = [attributes objectForKey:@"season"];
    if ([attributes objectForKey:@"show_name"]) self.show_name = [attributes objectForKey:@"show_name"];
    if ([attributes objectForKey:@"show_status"]) self.show_status = [attributes objectForKey:@"show_status"];
    if ([attributes objectForKey:@"tvdbid"]) self.tvdbid = [attributes objectForKey:@"tvdbid"];
    if ([attributes objectForKey:@"weekday"]) self.weekday = [attributes objectForKey:@"weekday"];
    if ([attributes objectForKey:@"date"]) self.date = [attributes objectForKey:@"date"];
    if ([attributes objectForKey:@"provider"]) self.provider = [attributes objectForKey:@"provider"];
    if ([attributes objectForKey:@"resource"]) self.resource = [attributes objectForKey:@"resource"];
    if ([attributes objectForKey:@"resource_path"]) self.resource_path = [attributes objectForKey:@"resource_path"];
}

- (void)getFullDetails:(SSBSickBeardEpisodeRequestResponseBlock)complete onFailure:(SSBSickBeardEpisodeRequestResponseBlock)failed
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@episode&tvdbid=%@&season=%@&episode=%@", [[SSBSharedServer sharedServer].server urlString], self.tvdbid, self.season, self.episode]];
    
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        [self setAttributes:[data objectForKey:@"data"]];
        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
    } onFailure:^(SSBSickBeardResult *result) {
        failed(result);
    }];
}

- (void)changeStatus:(NSString *)newStatus onComplete:(SSBSickBeardEpisodeRequestResponseBlock)complete onFailure:(SSBSickBeardEpisodeRequestResponseBlock)failed
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@episode.setstatus&tvdbid=%@&season=%@&episode=%@&status=%@", [[SSBSharedServer sharedServer].server urlString], self.tvdbid, self.season, self.episode, newStatus]];
    
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        complete([[SSBSickBeardResult alloc] initWithAttributes:data]);
    } onFailure:^(SSBSickBeardResult *result) {
        failed(result);
    }];
}

@end
