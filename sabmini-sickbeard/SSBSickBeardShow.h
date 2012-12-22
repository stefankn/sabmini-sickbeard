//
//  SSBSickBeardShow.h
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 16-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SSBSickBeardResult;

typedef void (^SSBSickBeardShowRequestDataBlock) (NSDictionary *data);
typedef void (^SSBSickBeardShowRequestResponseBlock) (SSBSickBeardResult *result);

@interface SSBSickBeardShow : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, assign) BOOL air_by_date;
@property (nonatomic, strong) NSString *airs;
@property (nonatomic, strong) NSDictionary *show_cache;
@property (nonatomic, assign) BOOL flatten_folders;
@property (nonatomic, strong) NSArray *genre;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *network;
@property (nonatomic, strong) NSString *next_ep_airdate;
@property (nonatomic, assign) BOOL paused;
@property (nonatomic, strong) NSString *quality;
@property (nonatomic, strong) NSDictionary *quality_details;
@property (nonatomic, strong) NSArray *season_list;
@property (nonatomic, strong) NSString *show_name;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *tvrage_id;
@property (nonatomic, strong) NSString *tvrage_name;

- (id)initWithAttributes:(NSDictionary *)attributes showIdentifier:(NSString *)showIdentifier;
- (void)getFullDetails:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed;
- (void)deleteShow:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed;
- (void)getEpisodesForSeason:(int)season onComplete:(SSBSickBeardShowRequestDataBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed;
- (void)pause:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed;
- (void)unpause:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed;
- (void)refresh:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed;
- (void)update:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed;

- (void)cache:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed;
//- (UIImage *)getBanner;
//- (UIImage *)getPoster;
- (void)getQuality:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed;



- (void)getSeasonList:(NSString *)sort onComplete:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed;

- (void)setQuality:(NSArray *)initial archive:(NSArray *)archive onComplete:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed;
- (void)getStatistics:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed;

@end
