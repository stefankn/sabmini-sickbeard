//
//  SSBSickBeardServer.m
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 16-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import "SSBSickBeardServer.h"
#import "SSBSickBeard.h"

@implementation SSBSickBeardServer
@synthesize identifier, friendlyName, host, port, apikey, https, isDefault;

- (id)init
{
    self = [super init];
    if (self) {
        self.identifier = [NSMutableString stringWithFormat:@"%d", arc4random() % 100000000];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)coder;
{
    if (self = [super init])
    {
        self.identifier = [coder decodeObjectForKey:@"identifier"];
        self.friendlyName = [coder decodeObjectForKey:@"friendlyName"];
		self.host = [coder decodeObjectForKey:@"host"];
		self.port = [coder decodeObjectForKey:@"port"];
        self.apikey = [coder decodeObjectForKey:@"apikey"];
        self.https = [coder decodeBoolForKey:@"https"];
        self.isDefault = [coder decodeBoolForKey:@"isDefault"];
    }
	
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.identifier forKey:@"identifier"];
    [coder encodeObject:self.friendlyName forKey:@"friendlyName"];
	[coder encodeObject:self.host forKey:@"host"];
	[coder encodeObject:self.port forKey:@"port"];
	[coder encodeObject:self.apikey forKey:@"apikey"];
	[coder encodeBool:self.https forKey:@"https"];
    [coder encodeBool:self.isDefault forKey:@"isDefault"];
}

- (NSString *)urlString
{
    if (self.https) {
        return [NSString stringWithFormat:@"https://%@:%@/api/%@/?cmd=", self.host, self.port, self.apikey];
    }
    else {
        return [NSString stringWithFormat:@"http://%@:%@/api/%@/?cmd=", self.host, self.port, self.apikey];
    }
}

- (void)setAsDefault
{
    self.isDefault = YES;
    
    // We need to unset other default servers if there are any
    NSMutableArray *servers = [NSMutableArray arrayWithArray:[SSBSickBeard getServers]];
    
    NSEnumerator *e = [servers objectEnumerator];
    SSBSickBeardServer *server;
    while (server = [e nextObject]) {
        if ([self.identifier isEqualToString:server.identifier]) {
            server.isDefault = YES;
        }
        else {
            server.isDefault = NO;
        }
    }

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:servers];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:@"sickbeard_servers"];
    [defaults synchronize];
}

- (void)remove
{
    NSMutableArray *servers = [NSMutableArray arrayWithArray:[SSBSickBeard getServers]];
    NSMutableArray *newServers = [NSMutableArray array];
    NSEnumerator *e = [servers objectEnumerator];
    SSBSickBeardServer *server;
    while (server = [e nextObject]) {
        if (![self.identifier isEqualToString:server.identifier]) {
            [newServers addObject:server];
        }
    }

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:newServers];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:@"sickbeard_servers"];
    [defaults synchronize];
}


@end
