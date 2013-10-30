//
//  ShowTableViewCell.m
//  SickBeard Demo App
//
//  Created by Stefan Klein Nulent on 30-10-13.
//  Copyright (c) 2013 Stefan Klein Nulent. All rights reserved.
//

#import "ShowTableViewCell.h"

@implementation ShowTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
