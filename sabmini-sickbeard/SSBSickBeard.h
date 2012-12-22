//
//  SSBSickBeard.h
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 16-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SSBSickBeardServer;
@class SSBSickBeardResult;
@class SSBSickBeardEpisode;
@class SSBSickBeardShow;

typedef void (^SSBSickBeardRequestCompleteBlock) (NSDictionary *data);
typedef void (^SSBSickBeardRequestFailedBlock) (SSBSickBeardResult *result);
typedef void (^SSBSickBeardShowCompleteBlock) (SSBSickBeardShow *show);

@interface SSBSickBeard : NSObject

+ (void)setActiveServer:(SSBSickBeardServer *)server;
+ (void)getShows:(NSString *)sort onlyPaused:(BOOL)paused onComplete:(SSBSickBeardRequestCompleteBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed;
+ (void)getFutureEpisodesForType:(NSString *)type withPaused:(BOOL)paused sortOn:(NSString *)sort onComplete:(SSBSickBeardRequestCompleteBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed;
+ (void)getShow:(NSString *)tvdbId onComplete:(SSBSickBeardShowCompleteBlock)show onFailure:(SSBSickBeardRequestFailedBlock)failed;

- (NSArray *)getHistory:(int)limit forType:(NSString *)type;
- (SSBSickBeardResult *)clearHistory;
- (SSBSickBeardResult *)trimHistory;
- (NSArray *)getLogs:(NSString *)min_level;
- (SSBSickBeardEpisode *)getEpisodeDetails:(NSString *)tvdbId forSeason:(int)season forEpisode:(int)episode showFullPath:(BOOL)showPath;
- (SSBSickBeardResult *)episodeExists:(NSString *)tvdbId forSeason:(int)season forEpisode:(int)episode;
- (SSBSickBeardResult *)addExistingShow:(NSString *)tvdbId showLocation:(NSString *)location flattenFolders:(BOOL)flattenFolders initial:(NSArray *)initial archive:(NSArray *)archive;
- (SSBSickBeardResult *)addNewShow:(NSString *)tvdbId showLocation:(NSString *)location flattenFolders:(BOOL)flattenFolders initial:(NSArray *)initial archive:(NSArray *)archive initialStatus:(NSString *)status language:(NSString *)lang;
- (SSBSickBeardResult *)showCache:(NSString *)tvdbId;
- (NSDictionary *)getStatistics;
- (NSDictionary *)getSickBeardInfo;
- (SSBSickBeardResult *)addRootDir:(NSString *)location setDefault:(BOOL)default_dir;
- (NSDictionary *)checkScheduler;
- (SSBSickBeardResult *)deleteRootDir:(NSString *)location;
- (SSBSickBeardResult *)forceSearch;
- (NSDictionary *)getDefaults;
- (NSArray *)getMessages;
- (NSArray *)getRootDirs;
- (SSBSickBeardResult *)pauseBacklog:(BOOL)pause;
- (SSBSickBeardResult *)ping;
- (SSBSickBeardResult *)restart;
- (NSArray *)searchTvdb:(NSString *)name tvdb:(NSString *)tvdbId language:(NSString *)lang;
- (SSBSickBeardResult *)setDefaults:(BOOL)futureShowPaused status:(NSString *)status flattenFolders:(BOOL)flattenFolders initial:(NSArray *)initial archive:(NSArray *)archive;
- (SSBSickBeardResult *)shutdown;

@end
