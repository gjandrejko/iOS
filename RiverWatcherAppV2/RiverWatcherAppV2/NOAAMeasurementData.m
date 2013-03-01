//
//  NOAAMeasurementData.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "NOAAMeasurementData.h"
#import "NOAAMeasurement.h"
@implementation NOAAMeasurementData
-(NSArray*)forecastMeasurements{
    
    NSMutableArray* forecastMeasurements = [NSMutableArray array];
    
    for (NOAAMeasurement* noaaMeasurement in self.noaaMeasurements) {
        if (noaaMeasurement.isForecast) {
            [forecastMeasurements addObject:noaaMeasurement];
        }
    }
    
    return forecastMeasurements;
}
@end
