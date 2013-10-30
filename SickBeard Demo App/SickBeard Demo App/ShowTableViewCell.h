//
//  ShowTableViewCell.h
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 30-10-13.
//  Copyright (c) 2013 Stefan Klein Nulent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *qualityLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextEpisodeLabel;

@end
