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

-(NSArray*)observedMeasurements{
    
    NSMutableArray* observedMeasurements = [NSMutableArray array];
    
    for (NOAAMeasurement* noaaMeasurement in self.noaaMeasurements) {
        if (!noaaMeasurement.isForecast) {
            [observedMeasurements addObject:noaaMeasurement];
        }
    }
    
    return observedMeasurements;
}

-(NOAAMeasurement*)latestMeasurement{
    
    NOAAMeasurement* latestMeausurement;
    
    NSArray* observerdMeasurementsSorted = [self.observedMeasurements sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        NOAAMeasurement* measurement1 = ( NOAAMeasurement*)obj1;
        NOAAMeasurement* measurement2 = ( NOAAMeasurement*)obj2;
        return [measurement2.date compare:measurement1.date];
        
    }];
    latestMeausurement = [observerdMeasurementsSorted firstObject];
    NSLog(@"LATEST1:%@",latestMeausurement);

    return latestMeausurement;
}
@end
