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

+(NOAAMeasurement*)maxMeasurmentInArray:(NSArray*)noaaMeasurements NOAAMeasurementType:(NOAAMeasurementType)noaaMeasurementType
{
    NOAAMeasurement* maxMeasurement = [noaaMeasurements firstObject];
    
    
    for (NOAAMeasurement* measurment in noaaMeasurements) {
        
        if (noaaMeasurementType == NOAAMeasurementTypeSecondary) {
            
            if([measurment.secondaryValue doubleValue] > [maxMeasurement.secondaryValue doubleValue]){
                maxMeasurement = measurment;
            }
        }else if (noaaMeasurementType == NOAAMeasurementTypePrimary) {
            
            if([measurment.primaryValue doubleValue] > [maxMeasurement.primaryValue doubleValue]){
                maxMeasurement = measurment;
            }
        }
        
        
    }
    return maxMeasurement;
}
+(NOAAMeasurement*)minMeasurmentInArray:(NSArray*)noaaMeasurements NOAAMeasurementType:(NOAAMeasurementType)noaaMeasurementType
{
    NOAAMeasurement* minMeasurement = [noaaMeasurements firstObject];
    
    
    for (NOAAMeasurement* measurment in noaaMeasurements) {
                
        if (noaaMeasurementType == NOAAMeasurementTypeSecondary) {
            
            if([measurment.secondaryValue doubleValue] < [minMeasurement.secondaryValue doubleValue]){
                minMeasurement = measurment;
            }
        }else if (noaaMeasurementType == NOAAMeasurementTypePrimary) {
            
            if([measurment.primaryValue doubleValue] < [minMeasurement.primaryValue doubleValue]){
                minMeasurement = measurment;
            }
        }
        
     
    }
    return minMeasurement;
}

+(NOAAMeasurement*)maxMeasurmentInArray:(NSArray*)noaaMeasurements WithDayRange:(NSInteger)dayRange  NOAAMeasurementType:(NOAAMeasurementType)noaaMeasurementType
{
    NSInteger startIndex = [NOAAMeasurementData startIndexForDayRange:dayRange InMeasurementsArray:noaaMeasurements];
    NOAAMeasurement* maxMeasurement = noaaMeasurements[startIndex];
    for (int i = startIndex; i < [noaaMeasurements count]; i++) {
        
        NOAAMeasurement* measurment = noaaMeasurements[i];
        
        if (noaaMeasurementType == NOAAMeasurementTypeSecondary) {
            
            if([measurment.secondaryValue doubleValue] > [maxMeasurement.secondaryValue doubleValue]){
                maxMeasurement = measurment;
            }
        }else if (noaaMeasurementType == NOAAMeasurementTypePrimary) {
            
            if([measurment.primaryValue doubleValue] > [maxMeasurement.primaryValue doubleValue]){
                maxMeasurement = measurment;
            }
        }
    }
    return maxMeasurement;
}
+(NOAAMeasurement*)minMeasurmentInArray:(NSArray*)noaaMeasurements WithDayRange:(NSInteger)dayRange  NOAAMeasurementType:(NOAAMeasurementType)noaaMeasurementType
{
    NSInteger startIndex = [NOAAMeasurementData startIndexForDayRange:dayRange InMeasurementsArray:noaaMeasurements];
    NOAAMeasurement* minMeasurement = noaaMeasurements[startIndex];
    for (int i = startIndex; i < [noaaMeasurements count]; i++) {
        
        NOAAMeasurement* measurment = noaaMeasurements[i];
        
        if (noaaMeasurementType == NOAAMeasurementTypeSecondary) {
            
            if([measurment.secondaryValue doubleValue] < [minMeasurement.secondaryValue doubleValue]){
                minMeasurement = measurment;
            }
        }else if (noaaMeasurementType == NOAAMeasurementTypePrimary) {
            
            if([measurment.primaryValue doubleValue] < [minMeasurement.primaryValue doubleValue]){
                minMeasurement = measurment;
            }
        }
    }
    return minMeasurement;
}

+(NSInteger)lastIndexForDayRange:(NSInteger)dayRange InMeasurementsArray:(NSArray*)noaaMeasurements
{
    NSInteger lastIndex = 0;
    NSDate* startDate = [[noaaMeasurements firstObject] date];
    NSTimeInterval timeInterval = dayRange * 60 * 60 * 24;
    NSDate* endDate = [startDate dateByAddingTimeInterval:timeInterval];
    
    
    for (int i = 0; i < [noaaMeasurements count]; i++) {
        
        NSDate* measurmentDate = [noaaMeasurements[i] date];
        lastIndex = i;
        
        if ([endDate laterDate:measurmentDate] == measurmentDate) {
            break;
        }
        
        
    }
    
    return lastIndex;
}
+(NSInteger)startIndexForDayRange:(NSInteger)dayRange InMeasurementsArray:(NSArray*)noaaMeasurements
{
    NSInteger lastIndex = [noaaMeasurements count] - 1;
    NSDate* startDate = [[noaaMeasurements lastObject] date];
    NSTimeInterval timeInterval = dayRange * 60 * 60 * 24;
    NSDate* endDate = [startDate dateByAddingTimeInterval:(timeInterval * -1)];
    
    
    for (int i = [noaaMeasurements count] - 1; i >= 0; i--) {
        
        NSDate* measurmentDate = [noaaMeasurements[i] date];
        
        if ([endDate earlierDate:measurmentDate] == measurmentDate) {
            break;
        }
        lastIndex = i;
        
        
    }
    
    return lastIndex;
}
@end
