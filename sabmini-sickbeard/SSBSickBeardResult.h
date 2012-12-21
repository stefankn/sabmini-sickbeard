//
//  SSBSickBeardResult.h
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 21-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSBSickBeardResult : NSObject

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSString *result;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
