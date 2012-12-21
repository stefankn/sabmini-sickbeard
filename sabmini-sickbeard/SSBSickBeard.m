//
//  SSBSickBeard.m
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 16-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import <objc/runtime.h>
#import "SSBSickBeard.h"
#import "SSBSickBeardServer.h"
#import "SSBSickBeardConnector.h"
#import "SSBSickBeardShow.h"

@interface SSBSickBeard()

@property (nonatomic, strong) SSBSickBeardServer *server;

@end

@implementation SSBSickBeard
@synthesize server;

- (id)initWithServer:(SSBSickBeardServer *)srv
{
    self = [super init];
    if (self) {
        self.server = srv;
    }
    
    return self;
}


// Retrieves the shows that are added to SickBeard
// First param defines the sort type (id or name), second param defines if only paused shows should be retrieved
- (void)getShows:(NSString *)sort onlyPaused:(BOOL)paused onComplete:(SSBSickBeardRequestCompleteBlock)complete onFailure:(SSBSickBeardRequestFailedBlock)failed
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@shows&sort=%@&paused=%i", [self.server urlString], sort, paused]];
    SSBSickBeardConnector *connector = [[SSBSickBeardConnector alloc] initWithURL:url];
    [connector getData:^(NSDictionary *data) {
        NSDictionary *shows_data = [data objectForKey:@"data"];
        NSMutableArray *shows = [NSMutableArray array];
        for (NSString *key in shows_data) {
            SSBSickBeardShow *show = [[SSBSickBeardShow alloc] initWithAttributes:[shows_data objectForKey:key] showIdentifier:key];
            [shows addObject:show];
        }
        
        complete([NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:shows, [data objectForKey:@"message"], [data objectForKey:@"result"], nil] forKeys:[NSArray arrayWithObjects:@"results", @"message", @"result", nil]]);
    }];
}



@end
