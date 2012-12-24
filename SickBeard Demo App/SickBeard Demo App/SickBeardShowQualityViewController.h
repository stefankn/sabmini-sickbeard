//
//  SickBeardShowQualityViewController.h
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 24-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SSBSickBeardShow;

@protocol SickBeardShowQualityDelegate <NSObject>

- (void)qualitySettingsChanged;

@end

@interface SickBeardShowQualityViewController : UITableViewController

@property (nonatomic, assign) id<SickBeardShowQualityDelegate> delegate;
@property (nonatomic, strong) SSBSickBeardShow *show;

@end
