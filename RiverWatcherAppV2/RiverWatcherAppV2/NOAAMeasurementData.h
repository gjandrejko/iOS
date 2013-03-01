//
//  NOAAMeasurementData.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NOAAMeasurement.h"
@interface NOAAMeasurementData : NSObject
@property (strong,nonatomic) NSMutableArray* significantData;
@property (strong,nonatomic) NSMutableArray* noaaMeasurements;
@property (readonly,nonatomic) NSArray* forecastMeasurements;
@property (readonly,nonatomic) NSArray* observedMeasurements;

@property (readonly,nonatomic) NOAAMeasurement* latestMeasurement;

@end
