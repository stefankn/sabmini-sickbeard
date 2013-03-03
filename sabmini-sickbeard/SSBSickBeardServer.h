//
//  SSBSickBeardServer.h
//
//  Created by Stefan Klein Nulent on 16-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSBSickBeardServer : NSObject <NSCoding>

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *friendlyName;
@property (nonatomic, copy) NSString *host;
@property (nonatomic, copy) NSString *port;
@property (nonatomic, copy) NSString *apikey;
@property (nonatomic, assign) BOOL https;
@property (nonatomic, assign) BOOL isDefault;

- (NSString *)urlString;
- (void)setAsDefault;
- (void)remove;

@end