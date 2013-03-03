//
//  SickBeardEpisodeViewController.h
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 22-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SSBSickBeardEpisode;

@interface SickBeardEpisodeViewController : UITableViewController {
    SSBSickBeardEpisode *_episode;
}

@property (nonatomic, strong) SSBSickBeardEpisode *episode;

@end
