//
//  SSBSharedServer.h
//
//  Created by Stefan Klein Nulent on 21-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SSBSickBeardServer;

@interface SSBSharedServer : NSObject

@property (nonatomic, strong) SSBSickBeardServer *server;

+ (SSBSharedServer *)sharedServer;

@end
