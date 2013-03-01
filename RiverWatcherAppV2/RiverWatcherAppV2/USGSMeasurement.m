//
//  Measurement.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "USGSMeasurement.h"

@implementation USGSMeasurement

-(NSString*)measurementDescriptionString{
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"EEE MMM dd, hh:mm a"];
    
    return [dateFormatter stringFromDate:self.date];
    
}

-(NSString*)measurementValueString{
    
    return [NSString stringWithFormat:@"%g %@",self.value,self.units];
}


@end
