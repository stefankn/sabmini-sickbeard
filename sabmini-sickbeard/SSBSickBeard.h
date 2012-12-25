//
//  SSBSickBeard.h
//
//  Created by Stefan Klein Nulent on 16-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SSBSickBeardServer;
@class SSBSickBeardResult;
@class SSBSickBeardEpisode;
@class SSBSickBeardShow;

typedef void (^SSBSickBeardRequestCompleteBlock) (SSBSickBeardResult *result);
typedef void (^SSBSickBeardRequestDataBlock) (NSDictionary *data);
typedef void (^SSBSickBeardRequestFailedBlock) (SSBSickBeardResult *result);
typedef void (^SSBSickBeardShowCompleteBlock) (SSBSickBeardShow *show);

@interface SSBSickBeard : NSObject

+ (NSArray *)getServers;
+ (SSBSickBeardServer *)getDefaultServer;
+ (void)setActiveServer:(SSBSickBeardServer *)server;
+ (SSBSickBeardServer *)getActiveServer;
+ (SSBSickBeardServer *)createServer:(NSString *)friendlyName withHost:(NSString *)host withPort:(NSString *)port withApikey:(NSString *)apikey enableHttps:(BOOL)https setAsDefault:(BOOL)setDefault;

+ (void)forceSearch:(SSBSickBeardRequestCompleteBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed;
+ (void)restartActiveServer:(SSBSickBeardRequestCompleteBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed;
+ (void)shutdownActiveServer:(SSBSickBeardRequestCompleteBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed;
+ (void)getShows:(NSString *)sort onlyPaused:(BOOL)paused onComplete:(SSBSickBeardRequestDataBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed;
+ (void)getFutureEpisodesForType:(NSString *)type withPaused:(BOOL)paused sortOn:(NSString *)sort onComplete:(SSBSickBeardRequestDataBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed;
+ (void)getShow:(NSString *)tvdbId onComplete:(SSBSickBeardShowCompleteBlock)show onFailure:(SSBSickBeardRequestFailedBlock)failed;
+ (void)getHistory:(int)limit forType:(NSString *)type onComplete:(SSBSickBeardRequestDataBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed;
+ (void)clearHistory:(SSBSickBeardRequestCompleteBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed;
+ (void)trimHistory:(SSBSickBeardRequestCompleteBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed;
+ (void)searchTvdb:(NSString *)name tvdb:(NSString *)tvdbId language:(NSString *)lang onComplete:(SSBSickBeardRequestDataBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed;
+ (void)getRootDirs:(SSBSickBeardRequestDataBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed;
+ (void)getDefaults:(SSBSickBeardRequestDataBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed;
+ (void)addNewShow:(NSString *)tvdbId showLocation:(NSString *)location flattenFolders:(BOOL)flattenFolders initial:(NSArray *)initial archive:(NSArray *)archive initialStatus:(NSString *)status language:(NSString *)lang onComplete:(SSBSickBeardRequestCompleteBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed;
+ (void)getLogs:(NSString *)min_level onComplete:(SSBSickBeardRequestDataBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed;

@end
