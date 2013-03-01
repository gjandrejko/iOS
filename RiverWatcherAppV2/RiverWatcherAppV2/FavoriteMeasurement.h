//
//  FavoriteMeasurement.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/10/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USGSMeasurement.h"
@interface FavoriteMeasurement : NSObject
@property (strong,nonatomic) USGSMeasurement* heightMeasurement;
@property (strong,nonatomic) USGSMeasurement* temperatureMeasurement;
@property (strong,nonatomic) USGSMeasurement* dischargeMeasurement;
-(NSDate*)measurementDate;
@end
