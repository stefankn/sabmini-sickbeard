//
//  SSBSickBeardShow.h
//
//  Created by Stefan Klein Nulent on 16-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SSBSickBeardResult;

typedef void (^SSBSickBeardShowRequestDataBlock) (NSDictionary *data);
typedef void (^SSBSickBeardShowRequestResponseBlock) (SSBSickBeardResult *result);
typedef void (^SSBSickBeardShowRequestImageBlock) (UIImage *image);

@interface SSBSickBeardShow : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) BOOL air_by_date;
@property (nonatomic, copy) NSString *airs;
@property (nonatomic, copy) NSDictionary *show_cache;
@property (nonatomic, assign) BOOL flatten_folders;
@property (nonatomic, copy) NSArray *genre;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *network;
@property (nonatomic, copy) NSString *next_ep_airdate;
@property (nonatomic, assign) BOOL paused;
@property (nonatomic, copy) NSString *quality;
@property (nonatomic, copy) NSDictionary *quality_details;
@property (nonatomic, copy) NSArray *season_list;
@property (nonatomic, copy) NSString *show_name;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *tvrage_id;
@property (nonatomic, copy) NSString *tvrage_name;

- (id)initWithAttributes:(NSDictionary *)attributes showIdentifier:(NSString *)showIdentifier;
- (void)getFullDetails:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed;
- (void)deleteShow:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed;
- (void)getEpisodesForSeason:(int)season onComplete:(SSBSickBeardShowRequestDataBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed;
- (void)pause:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed;
- (void)unpause:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed;
- (void)refresh:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed;
- (void)update:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed;
- (void)getBanner:(SSBSickBeardShowRequestImageBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed;
- (void)getPoster:(SSBSickBeardShowRequestImageBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed;
- (void)changeStatus:(NSString *)newStatus forSeason:(int)season onComplete:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed;
- (void)getStatistics:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed;
- (void)setQuality:(NSArray *)initial archive:(NSArray *)archive onComplete:(SSBSickBeardShowRequestResponseBlock)complete onFailure:(SSBSickBeardShowRequestResponseBlock)failed;

@end
