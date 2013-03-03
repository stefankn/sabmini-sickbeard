//
//  SickBeardEpisodesViewController.h
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 22-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SSBSickBeardShow;

@interface SickBeardEpisodesViewController : UITableViewController {
    SSBSickBeardShow *_show;
    NSUInteger *_season;
}

@property (nonatomic, strong) SSBSickBeardShow *show;
@property (nonatomic, assign) NSUInteger *season;

@end
