//
//  SSBSickBeardServer.m
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 16-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import "SSBSickBeardServer.h"
@class SSBSickBeardServers;

@interface SSBSickBeardServer()

@property (nonatomic, strong) NSString *friendlyName;
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *port;
@property (nonatomic, strong) NSString *apikey;
@property (nonatomic, assign) BOOL https;

@end

@implementation SSBSickBeardServer
@synthesize friendlyName, host, port, apikey, https;

- (id)initWithCoder:(NSCoder *)coder;
{
    if (self = [super init])
    {
        self.friendlyName = [coder decodeObjectForKey:@"friendlyName"];
		self.host = [coder decodeObjectForKey:@"host"];
		self.port = [coder decodeObjectForKey:@"port"];
        self.apikey = [coder decodeObjectForKey:@"apikey"];
        self.https = [coder decodeBoolForKey:@"https"];
    }
	
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.friendlyName forKey:@"friendlyName"];
	[coder encodeObject:self.host forKey:@"host"];
	[coder encodeObject:self.port forKey:@"port"];
	[coder encodeObject:self.apikey forKey:@"apikey"];
	[coder encodeBool:self.https forKey:@"https"];
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

@end

@implementation SSBSickBeardServers

+ (NSArray *)getServers
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *serverData = [defaults objectForKey:@"sickbeard_servers"];
    NSMutableArray *servers = [NSMutableArray array];
    
    if (serverData != NULL) {
        [servers addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:serverData]];
    }
    
    return [NSArray arrayWithArray:servers];
}

+ (SSBSickBeardServer *)createServer:(NSString *)friendlyName withHost:(NSString *)host withPort:(NSString *)port withApikey:(NSString *)apikey enableHttps:(BOOL)https store:(BOOL)store
{
    SSBSickBeardServer *server = [[SSBSickBeardServer alloc] init];
    server.friendlyName = friendlyName;
    server.host = host;
    server.port = port;
    server.apikey = apikey;
    server.https = https;
    
    if (store) {
        NSMutableArray *servers = [NSMutableArray arrayWithArray:[SSBSickBeardServers getServers]];
        
        [servers addObject:self];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:servers];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:data forKey:@"sickbeard_servers"];
        [defaults synchronize];
    }
    
    return server;
}


@end
