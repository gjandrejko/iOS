//
//  RWTabBarController.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 6/23/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeasurementDownloadManager.h"

@interface RWTabBarController : UITabBarController
@property (strong,nonatomic) MeasurementDownloadManager* measurementDownloadManager;
@property (strong,nonatomic) GaugeSite* gaugeSite;

@end
