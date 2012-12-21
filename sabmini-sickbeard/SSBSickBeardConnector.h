//
//  SSBSickBeardConnector.h
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 17-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SSBSickBeardConnectorFinishedBlock) (NSDictionary *data);

@interface SSBSickBeardConnector : NSObject

- (id)initWithURL:(NSURL *)url;
- (void)getData:(SSBSickBeardConnectorFinishedBlock)callback;

@end
