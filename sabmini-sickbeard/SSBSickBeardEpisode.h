//
//  SSBSickBeardEpisode.h
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 16-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SSBSickBeardResult;

typedef void (^SSBSickBeardEpisodeRequestDataBlock) (NSDictionary *data);
typedef void (^SSBSickBeardEpisodeRequestResponseBlock) (SSBSickBeardResult *result);

@interface SSBSickBeardEpisode : NSObject

@property (nonatomic, strong) NSString *airdate;
@property (nonatomic, assign) int file_size; // large int?
@property (nonatomic, strong) NSString *file_size_human;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *quality;
@property (nonatomic, strong) NSString *release_name;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *airs;
@property (nonatomic, strong) NSString *ep_name;
@property (nonatomic, strong) NSString *ep_plot;
@property (nonatomic, strong) NSString *episode;
@property (nonatomic, strong) NSString *network;
@property (nonatomic, assign) BOOL paused;
@property (nonatomic, strong) NSString *season;
@property (nonatomic, strong) NSString *show_name;
@property (nonatomic, strong) NSString *show_status;
@property (nonatomic, strong) NSString *tvdbid;
@property (nonatomic, strong) NSString *weekday;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *provider;
@property (nonatomic, strong) NSString *resource;
@property (nonatomic, strong) NSString *resource_path;

- (id)initWithAttributes:(NSDictionary *)attributes;
- (void)getFullDetails:(SSBSickBeardEpisodeRequestResponseBlock)complete onFailure:(SSBSickBeardEpisodeRequestResponseBlock)failed;
- (void)changeStatus:(NSString *)newStatus onComplete:(SSBSickBeardEpisodeRequestResponseBlock)complete onFailure:(SSBSickBeardEpisodeRequestResponseBlock)failed;

@end
