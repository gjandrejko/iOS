//
//  USGSMeasurementData.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "USGSMeasurementData.h"
#import "USGSMeasurement.h"
#import "CGPointAsAClass.h"
@implementation USGSMeasurementData


+(USGSMeasurement*)minMeasurmentInArray:(NSArray*)usgsMeasurments
{
    USGSMeasurement* minMeasurement = [usgsMeasurments firstObject];
   
    
    for (USGSMeasurement* measurment in usgsMeasurments) {
        if(measurment.value < minMeasurement.value){
            minMeasurement = measurment;
        }
    }
    return minMeasurement;
}

+(USGSMeasurement*)maxMeasurmentInArray:(NSArray*)usgsMeasurments
{
    USGSMeasurement* maxMeasurement = [usgsMeasurments firstObject];
    
    
    for (USGSMeasurement* measurment in usgsMeasurments) {
        if(measurment.value > maxMeasurement.value){
            maxMeasurement = measurment;
        }
    }
    return maxMeasurement;
}

+(USGSMeasurement*)maxMeasurmentInArray:(NSArray*)usgsMeasurments WithDayRange:(NSInteger)dayRange
{
    NSInteger startIndex = [USGSMeasurementData startIndexForDayRange:dayRange InUsgsMeasurementsArray:usgsMeasurments];
    USGSMeasurement* maxMeasurement = usgsMeasurments[startIndex];
    
    for (int i = startIndex; i < [usgsMeasurments count]; i++) {
        
        USGSMeasurement* measurment = usgsMeasurments[i];
        if(measurment.value > maxMeasurement.value){
            maxMeasurement = measurment;
        }
    }
    return maxMeasurement;

}
+(USGSMeasurement*)minMeasurmentInArray:(NSArray*)usgsMeasurments WithDayRange:(NSInteger)dayRange
{
    NSInteger startIndex = [USGSMeasurementData startIndexForDayRange:dayRange InUsgsMeasurementsArray:usgsMeasurments];
    USGSMeasurement* minMeasurement = usgsMeasurments[startIndex];
    for (int i = startIndex; i < [usgsMeasurments count]; i++) {
        
        USGSMeasurement* measurment = usgsMeasurments[i];
        if(measurment.value < minMeasurement.value){
            minMeasurement = measurment;
        }
    }
    return minMeasurement;

}

+(NSInteger)lastIndexForDayRange:(NSInteger)dayRange InUsgsMeasurementsArray:(NSArray*)usgsMeasurments
{
    NSInteger lastIndex = 0;
    NSDate* startDate = [[usgsMeasurments firstObject] date];
    NSTimeInterval timeInterval = dayRange * 60 * 60 * 24;
    NSDate* endDate = [startDate dateByAddingTimeInterval:timeInterval];
    
    
    for (int i = 0; i < [usgsMeasurments count]; i++) {
        
        NSDate* measurmentDate = [usgsMeasurments[i] date];
        lastIndex = i;

        if ([endDate laterDate:measurmentDate] == measurmentDate) {
            break;
        }
        
        
    }
    
    return lastIndex;
}

+(NSInteger)startIndexForDayRange:(NSInteger)dayRange InUsgsMeasurementsArray:(NSArray*)usgsMeasurments
{
    NSInteger lastIndex = [usgsMeasurments count] - 1;
    NSDate* startDate = [[usgsMeasurments lastObject] date];
    NSTimeInterval timeInterval = dayRange * 60 * 60 * 24;
    NSDate* endDate = [startDate dateByAddingTimeInterval:(timeInterval * -1)];
    
    
    for (int i = [usgsMeasurments count] - 1; i >= 0; i--) {
        
        NSDate* measurmentDate = [usgsMeasurments[i] date];
        
        if ([endDate earlierDate:measurmentDate] == measurmentDate) {
            break;
        }
        lastIndex = i;

        
    }
    
    return lastIndex;
}

@end
