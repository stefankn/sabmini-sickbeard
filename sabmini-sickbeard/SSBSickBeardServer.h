//
//  SSBSickBeardServer.h
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 16-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SSBSickBeardServerDelegate <NSObject>

@optional
- (void)shutdownResponse;
- (void)restartResponse;

@end

@interface SSBSickBeardServer : NSObject

- (NSString *)urlString;
- (void)restartSickBeard;
- (void)shutdownSickBeard;

@end

@interface SSBSickBeardServers : NSObject

+ (NSArray *)getServers;
+ (SSBSickBeardServer *)createServer:(NSString *)friendlyName withHost:(NSString *)host withPort:(NSString *)port withApikey:(NSString *)apikey enableHttps:(BOOL)https store:(BOOL)store;

@end
