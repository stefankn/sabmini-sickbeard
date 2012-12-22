//
//  SSBSickBeardEpisode.m
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 16-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import "SSBSickBeardEpisode.h"

@implementation SSBSickBeardEpisode
@synthesize airdate, description, file_size, file_size_human, location, name, quality, release_name, status, airs, ep_name, ep_plot, episode, network, paused, season, show_name, show_status, tvdbid, weekday, date, provider, resource, resource_path;

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self) {
//        self.airdate = [attributes objectForKey:@"airdate"];
//        self.description = [attributes objectForKey:@"description"];
//        self.file_size = [[attributes objectForKey:@"file_size"] intValue];
//        self.file_size_human = [attributes objectForKey:@"file_size_human"];
//        self.location = [attributes objectForKey:@"location"];
//        self.name = [attributes objectForKey:@"name"];
//        self.quality = [attributes objectForKey:@"quality"];
//        self.release_name = [attributes objectForKey:@"release_name"];
//        self.status = [attributes objectForKey:@"status"];
//        self.airs = [attributes objectForKey:@"airs"];
//        self.ep_name = [attributes objectForKey:@"ep_name"];
//        self.ep_plot = [attributes objectForKey:@"ep_plot"];
//        self.episode = [attributes objectForKey:@"episode"];
//        self.network = [attributes objectForKey:@"network"];
//        self.paused = [[attributes objectForKey:@"ep_name"] boolValue];
//        self.season = [attributes objectForKey:@"season"];
        self.show_name = [attributes objectForKey:@"show_name"];
//        self.show_status = [attributes objectForKey:@"show_status"];
//        self.tvdbid = [attributes objectForKey:@"tvdbid"];
//        self.weekday = [attributes objectForKey:@"weekday"];
//        self.date = [attributes objectForKey:@"date"];
//        self.provider = [attributes objectForKey:@"provider"];
//        self.resource = [attributes objectForKey:@"resource"];
//        self.resource_path = [attributes objectForKey:@"resource_path"];
    }
    
    return self;
}

@end
