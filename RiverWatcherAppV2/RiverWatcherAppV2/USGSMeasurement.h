//
//  Measurement.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "MeasurementDescriptionProtocol.h"

@interface USGSMeasurement : NSObject <MeasurementDescriptionProtocol>

@property (strong,nonatomic) NSDate* date;
@property (nonatomic) double value;
@property (strong,nonatomic) NSString* units;


+(NSArray*)measurmentsArrayWithArrayOfJsonValues:(NSArray*)values Units:(NSString*)units;
@end
