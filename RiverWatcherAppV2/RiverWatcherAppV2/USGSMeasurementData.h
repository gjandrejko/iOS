//
//  USGSMeasurementData.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USGSMeasurement.h"
@interface USGSMeasurementData : NSObject



@property (strong,nonatomic) NSArray* temperatureMeasurements;
@property (strong,nonatomic) NSArray* dischargeMeasurements;
@property (strong,nonatomic) NSArray* heightMeasurements;

+(USGSMeasurement*)maxMeasurmentInArray:(NSArray*)usgsMeasurments;
+(USGSMeasurement*)minMeasurmentInArray:(NSArray*)usgsMeasurments;

+(USGSMeasurement*)maxMeasurmentInArray:(NSArray*)usgsMeasurments WithDayRange:(NSInteger)dayRange;
+(USGSMeasurement*)minMeasurmentInArray:(NSArray*)usgsMeasurments WithDayRange:(NSInteger)dayRange;

+(NSInteger)lastIndexForDayRange:(NSInteger)dayRange InUsgsMeasurementsArray:(NSArray*)usgsMeasurments;
+(NSInteger)startIndexForDayRange:(NSInteger)dayRange InUsgsMeasurementsArray:(NSArray*)usgsMeasurments;


@end
