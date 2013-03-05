//
//  IpadRecentValuesTableViewController.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 3/3/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USGSMeasurementData.h"
@interface IpadRecentValuesTableViewController : UITableViewController
@property (strong,nonatomic) USGSMeasurementData* usgsMeasurmentData;
@end
