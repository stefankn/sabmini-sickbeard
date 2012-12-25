//
//  SSBSickBeardConnector.h
//
//  Created by Stefan Klein Nulent on 17-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SSBSickBeardResult;

typedef void (^SSBSickBeardConnectorFinishedBlock) (NSDictionary *data);
typedef void (^SSBSickBeardConnectorFailedBlock) (SSBSickBeardResult *result);

@interface SSBSickBeardConnector : NSObject

- (id)initWithURL:(NSURL *)url;
- (void)getData:(SSBSickBeardConnectorFinishedBlock)callback onFailure:(SSBSickBeardConnectorFailedBlock)failure;

@end
