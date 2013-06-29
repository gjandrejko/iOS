//
//  FavoriteTableViewCell.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/9/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "FavoriteTableViewCell.h"
@interface FavoriteTableViewCell ()
@property (strong,nonatomic) UIActivityIndicatorView* activityIndicator;
@property (strong,nonatomic) UILabel* errorLabel;
@end


@implementation FavoriteTableViewCell

-(void)awakeFromNib{
    CGRect errorLoadingRect = CGRectUnion(self.dateLabel.frame, self.tempLabel.frame);
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.activityIndicator.center = CGPointMake(CGRectGetMidX(errorLoadingRect), CGRectGetMidY(errorLoadingRect));
    
    self.errorLabel = [[UILabel alloc] initWithFrame:errorLoadingRect];
    self.errorLabel.text = @"Unable To Load USGS Measurements";
    self.errorLabel.textColor = [UIColor grayColor];
    self.errorLabel.textAlignment = UITextAlignmentCenter;
    self.errorLabel.backgroundColor = [UIColor clearColor];
    self.errorLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUpCellForGaugeSite:(GaugeSite*)gaugeSite FavoriteMeasurement:(FavoriteMeasurement*)favoriteMeasurement{
    
    [self setMeasurementLabelsHidden:NO];
    [self.activityIndicator removeFromSuperview];
    NSInteger numberOfMeasurements = 0;
    self.siteNameLabel.text = gaugeSite.siteName;
    


    for (UILabel* label in self.measurementLabels) {
        label.text = @"";
    }

    if (favoriteMeasurement.temperatureMeasurement) {
        self.tempLabel.text = [NSString stringWithFormat:@"%g %@",favoriteMeasurement.temperatureMeasurement.value,favoriteMeasurement.temperatureMeasurement.units];
        self.tempLabel.text = [self.tempLabel.text stringByReplacingOccurrencesOfString:@"DEG" withString:@"°"];
        self.tempLabel.text = [self.tempLabel.text stringByReplacingOccurrencesOfString:@"deg" withString:@"°"];

        numberOfMeasurements++;
    }
    
    if (favoriteMeasurement.heightMeasurement) {
        
        self.heightLabel.text = [NSString stringWithFormat:@"%g %@",favoriteMeasurement.heightMeasurement.value,favoriteMeasurement.heightMeasurement.units];
        numberOfMeasurements++;

    }
    
    
    if (favoriteMeasurement.dischargeMeasurement) {
         self.dischargeLabel.text = [NSString stringWithFormat:@"%g %@",favoriteMeasurement.dischargeMeasurement.value,favoriteMeasurement.dischargeMeasurement.units];
        numberOfMeasurements++;

    }
    NSLog(@"%@ %d",gaugeSite.siteName,numberOfMeasurements);
    if (numberOfMeasurements == 0) {
        
        [self.contentView addSubview:self.errorLabel];
        [self.contentView bringSubviewToFront:self.errorLabel];
        [self setMeasurementLabelsHidden:YES];


        
    }else{
        [self.errorLabel removeFromSuperview];
        [self setMeasurementLabelsHidden:NO];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        dateFormatter.dateStyle = NSDateFormatterLongStyle;
        self.dateLabel.text = [dateFormatter stringFromDate:[favoriteMeasurement measurementDate]];
    }
    
    [self layoutSubviews];

}

-(void)setMeasurementLabelsHidden:(BOOL)hidden
{
    for (UILabel* label in self.measurementLabels) {
        label.hidden = hidden;
    }
}

-(void)setUpLoadingCellForGaugeSite:(GaugeSite*)gaugeSite{
    
    
    [self setMeasurementLabelsHidden:YES];
    [self.contentView addSubview:self.activityIndicator];
    [self.contentView bringSubviewToFront:self.activityIndicator];

    self.siteNameLabel.text = gaugeSite.siteName;
    
    [self.activityIndicator startAnimating];
}

@end
