//
//  IpadRecentValuesViewController.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 3/2/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeasurementDownloadManager.h"
@interface IpadRecentValuesViewController : UIViewController
@property (strong,nonatomic) MeasurementDownloadManager* measurementDownloadManager;
@end
