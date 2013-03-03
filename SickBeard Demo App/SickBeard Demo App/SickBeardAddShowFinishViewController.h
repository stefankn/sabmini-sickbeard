//
//  SickBeardAddShowFinishViewController.h
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 24-12-12.
//  Copyright (c) 2012 Stefan Klein Nulent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SickBeardAddShowFinishViewController : UITableViewController {
    NSDictionary *_searchResult;
}

@property (nonatomic, strong) NSDictionary *searchResult;

@end
