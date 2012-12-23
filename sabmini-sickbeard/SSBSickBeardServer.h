//
//  SSBSickBeardServer.h
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 16-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SSBSickBeardResult;

typedef void (^SSBSickBeardServerRequestCompleteBlock) (SSBSickBeardResult *result);

@interface SSBSickBeardServer : NSObject <NSCoding>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *friendlyName;
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *port;
@property (nonatomic, strong) NSString *apikey;
@property (nonatomic, assign) BOOL https;
@property (nonatomic, assign) BOOL isDefault;

- (NSString *)urlString;
- (void)setAsDefault;
- (void)remove;

@end