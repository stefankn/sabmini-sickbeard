//
//  SSBSickBeardServer.m
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 16-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import "SSBSickBeardServer.h"

@interface SSBSickBeardServer()

@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *port;
@property (nonatomic, strong) NSString *apikey;
@property (nonatomic, assign) BOOL https;

@end

@implementation SSBSickBeardServer
@synthesize host, port, apikey, https;

- (id)initWithCoder:(NSCoder *)coder;
{
    if (self = [super init])
    {
		self.host = [coder decodeObjectForKey:@"host"];
		self.port = [coder decodeObjectForKey:@"port"];
        self.apikey = [coder decodeObjectForKey:@"apikey"];
        self.https = [coder decodeBoolForKey:@"https"];
    }
	
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
	[coder encodeObject:self.host forKey:@"host"];
	[coder encodeObject:self.port forKey:@"port"];
	[coder encodeObject:self.apikey forKey:@"apikey"];
	[coder encodeBool:self.https forKey:@"https"];
}

@end
