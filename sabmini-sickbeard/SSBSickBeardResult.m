//
//  SSBSickBeardResult.m
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 21-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import "SSBSickBeardResult.h"

@implementation SSBSickBeardResult

@synthesize message, data, success;

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self) {
        self.message = [attributes objectForKey:@"message"];
        self.data = [attributes objectForKey:@"data"];
        self.success = [[attributes objectForKey:@"result"] isEqualToString:@"success"];
    }
    
    return self;
}

@end
