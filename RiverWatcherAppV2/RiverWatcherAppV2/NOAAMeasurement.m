//
//  NOAAMeasurement.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "NOAAMeasurement.h"
@interface NOAAMeasurement ()
@property (strong,nonatomic) NSNumberFormatter* numberFormatter;
@end
@implementation NOAAMeasurement


-(NSNumberFormatter*)numberFormatter{
    
    if (!_numberFormatter) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        [_numberFormatter setMinimumFractionDigits:0];
        [_numberFormatter setMaximumFractionDigits:2];
    }
    return _numberFormatter;
}

-(NSString*)measurementDescriptionString
{

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"EEE MMM dd, hh:mm a"];
    
    return [dateFormatter stringFromDate:self.date];
}

-(NSString*)measurementValueString
{
    NSString* measurementValueString = @"";
    
    if (self.primaryValue && self.primaryUnits) {
        measurementValueString = [NSString stringWithFormat:@"%@ %@",[self.numberFormatter stringFromNumber:self.primaryValue],self.primaryUnits];
    }
    
    if (self.primaryUnits && self.primaryValue && self.secondaryUnits && self.secondaryValue) {
        measurementValueString = [measurementValueString stringByAppendingString:@" / "];
    }
    
    if (self.secondaryValue && self.secondaryUnits) {
        measurementValueString = [NSString stringWithFormat:@"%@%@ %@",measurementValueString,[self.numberFormatter stringFromNumber:self.secondaryValue],self.secondaryUnits];
    }
    
    if (!([measurementValueString length] > 0)) {
        measurementValueString = @"N/A";
    }
    
    return measurementValueString;
    
}

@end
