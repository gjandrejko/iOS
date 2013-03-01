//
//  NOAAMeasurement.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NOAAMeasurement : NSObject

@property (strong,nonatomic) NSTimeZone* timeZone;
@property (strong,nonatomic) NSDate* date;
@property (strong,nonatomic) NSString* primaryName;
@property (strong,nonatomic) NSString* primaryUnits;
@property (nonatomic) double primaryValue;
@property (strong,nonatomic) NSString* secondaryName;
@property (strong,nonatomic) NSString* secondaryUnits;
@property (nonatomic) double secondaryValue;
@property (nonatomic) BOOL isForecast;

@end
