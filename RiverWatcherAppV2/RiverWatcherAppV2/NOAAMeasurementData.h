//
//  NOAAMeasurementData.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NOAAMeasurement.h"

typedef enum{
 NOAAMeasurementTypeUnknown,
 NOAAMeasurementTypePrimary,
 NOAAMeasurementTypeSecondary,
}NOAAMeasurementType;


@interface NOAAMeasurementData : NSObject
@property (strong,nonatomic) NSMutableArray* significantData;
@property (strong,nonatomic) NSMutableArray* noaaMeasurements;
@property (readonly,nonatomic) NSArray* forecastMeasurements;
@property (readonly,nonatomic) NSArray* observedMeasurements;

@property (readonly,nonatomic) NOAAMeasurement* latestMeasurement;


+(NOAAMeasurement*)maxMeasurmentInArray:(NSArray*)noaaMeasurements NOAAMeasurementType:(NOAAMeasurementType)noaaMeasurementType;
+(NOAAMeasurement*)minMeasurmentInArray:(NSArray*)noaaMeasurements NOAAMeasurementType:(NOAAMeasurementType)noaaMeasurementType;

+(NOAAMeasurement*)maxMeasurmentInArray:(NSArray*)noaaMeasurements WithDayRange:(NSInteger)dayRange  NOAAMeasurementType:(NOAAMeasurementType)noaaMeasurementType;
+(NOAAMeasurement*)minMeasurmentInArray:(NSArray*)noaaMeasurements WithDayRange:(NSInteger)dayRange  NOAAMeasurementType:(NOAAMeasurementType)noaaMeasurementType;

+(NSInteger)lastIndexForDayRange:(NSInteger)dayRange InMeasurementsArray:(NSArray*)noaaMeasurements;
+(NSInteger)startIndexForDayRange:(NSInteger)dayRange InMeasurementsArray:(NSArray*)noaaMeasurements;

@end
