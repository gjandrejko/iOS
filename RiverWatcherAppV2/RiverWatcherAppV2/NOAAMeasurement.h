//
//  NOAAMeasurement.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeasurementDescriptionProtocol.h"

@interface NOAAMeasurement : NSObject <MeasurementDescriptionProtocol>

@property (strong,nonatomic) NSTimeZone* timeZone;
@property (strong,nonatomic) NSDate* date;
@property (strong,nonatomic) NSString* primaryName;
@property (strong,nonatomic) NSString* primaryUnits;
@property (strong,nonatomic) NSNumber* primaryValue;
@property (strong,nonatomic) NSString* secondaryName;
@property (strong,nonatomic) NSString* secondaryUnits;
@property (strong,nonatomic) NSNumber* secondaryValue;
@property (nonatomic) BOOL isForecast;

@end
