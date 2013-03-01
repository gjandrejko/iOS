//
//  RiverWatcherTableViewCell.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/8/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "RiverWatcherTableViewCell.h"

@implementation RiverWatcherTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /*
        
        UIImage* backgroundImage = [[UIImage imageNamed:@"list-item-bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 0, 3, 0)];
       UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:backgroundImageView];
        [self.contentView sendSubviewToBack:backgroundImageView];
         */
        self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundPattern"]];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor colorWithRed: 0 green: 0.33 blue: 0.57 alpha: 1]; //Ocean
        self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:19];
        self.textLabel.shadowColor = [UIColor whiteColor];
        self.textLabel.shadowOffset = CGSizeMake(0, 1);
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
