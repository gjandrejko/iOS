//
//  MeasurementTableViewCell.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 3/1/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeasurementTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *measurementDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *measurementValueLabel;
@end
