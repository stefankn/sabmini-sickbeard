//
//  EpisodeTableViewCell.h
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 06-11-13.
//  Copyright (c) 2013 Stefan Klein Nulent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EpisodeTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *numberLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *infoLabel;

@end
