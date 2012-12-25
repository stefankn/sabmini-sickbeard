//
//  SSBSharedServer.m
//
//  Created by Stefan Klein Nulent on 21-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import "SSBSharedServer.h"
#import "SSBSickBeardServer.h"

@implementation SSBSharedServer

static SSBSharedServer *sharedServer = nil;

+ (SSBSharedServer *)sharedServer {
    if (sharedServer == nil) {
        sharedServer = [[super allocWithZone:NULL] init];
    }
    
    return sharedServer;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedServer == nil) {
            sharedServer = [super allocWithZone:zone];
            return sharedServer;
        }
    }
    
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end
