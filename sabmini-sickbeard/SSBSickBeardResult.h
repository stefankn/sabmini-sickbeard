//
//  SSBSickBeardResult.h
//
//  Created by Stefan Klein Nulent on 21-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSBSickBeardResult : NSObject

@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSDictionary *data;
@property (nonatomic, assign) BOOL success;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
