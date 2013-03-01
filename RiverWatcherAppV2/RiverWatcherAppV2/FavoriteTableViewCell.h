//
//  FavoriteTableViewCell.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/9/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoriteMeasurement.h"
#import "GaugeSite.h"
@interface FavoriteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *siteNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dischargeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

-(void)setUpCellForGaugeSite:(GaugeSite*)gaugeSite FavoriteMeasurement:(FavoriteMeasurement*)favoriteMeasurement;
-(void)setUpLoadingCellForGaugeSite:(GaugeSite*)gaugeSite;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *measurementLabels;

@end
