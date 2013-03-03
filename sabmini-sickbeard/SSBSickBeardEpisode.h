//
//  SSBSickBeardEpisode.h
//
//  Created by Stefan Klein Nulent on 16-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SSBSickBeardResult;

typedef void (^SSBSickBeardEpisodeRequestDataBlock) (NSDictionary *data);
typedef void (^SSBSickBeardEpisodeRequestResponseBlock) (SSBSickBeardResult *result);

@interface SSBSickBeardEpisode : NSObject

@property (nonatomic, copy) NSString *airdate;
@property (nonatomic, assign) NSUInteger file_size;
@property (nonatomic, copy) NSString *file_size_human;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *quality;
@property (nonatomic, copy) NSString *release_name;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *airs;
@property (nonatomic, copy) NSString *ep_name;
@property (nonatomic, copy) NSString *ep_plot;
@property (nonatomic, copy) NSString *episode;
@property (nonatomic, copy) NSString *network;
@property (nonatomic, assign) BOOL paused;
@property (nonatomic, copy) NSString *season;
@property (nonatomic, copy) NSString *show_name;
@property (nonatomic, copy) NSString *show_status;
@property (nonatomic, copy) NSString *tvdbid;
@property (nonatomic, copy) NSString *weekday;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *provider;
@property (nonatomic, copy) NSString *resource;
@property (nonatomic, copy) NSString *resource_path;

- (id)initWithAttributes:(NSDictionary *)attributes;
- (void)getFullDetails:(SSBSickBeardEpisodeRequestResponseBlock)complete onFailure:(SSBSickBeardEpisodeRequestResponseBlock)failed;
- (void)changeStatus:(NSString *)newStatus onComplete:(SSBSickBeardEpisodeRequestResponseBlock)complete onFailure:(SSBSickBeardEpisodeRequestResponseBlock)failed;

@end
