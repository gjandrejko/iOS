//
//  Measurement.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "USGSMeasurement.h"
@interface USGSMeasurement()
@property (strong,nonatomic) NSNumberFormatter* numberFormatter;
@end

@implementation USGSMeasurement

-(NSNumberFormatter*)numberFormatter{
    
    if (!_numberFormatter) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        [_numberFormatter setMinimumFractionDigits:0];
        [_numberFormatter setMaximumFractionDigits:2];
    }
    return _numberFormatter;
}

-(NSString*)measurementDescriptionString{
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];

   [dateFormatter setDateFormat:@"EEE MMM dd, hh:mm a"];
    //[dateFormatter setDateFormat:@"hh:mm a"];

    
    return [dateFormatter stringFromDate:self.date];
    
}

-(NSString*)measurementValueString{

    NSNumber* valueNumber = [NSNumber numberWithDouble:self.value];
    NSString* valueString = [self.numberFormatter stringFromNumber:valueNumber];
    
    
    if ([self.units rangeOfString:@"deg" options:NSCaseInsensitiveSearch].location != NSNotFound ) {
          return [NSString stringWithFormat:@"%@ %@",valueString,[[self.units uppercaseString] stringByReplacingOccurrencesOfString:@"DEG" withString:@"°"]];
    }else{
          return [NSString stringWithFormat:@"%@ %@",valueString,self.units];
    }
    

}


+(NSArray*)measurmentsArrayWithArrayOfJsonValues:(NSArray*)values Units:(NSString*)units{
    
    NSMutableArray* measurments = [NSMutableArray array];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    for (NSDictionary* measurementDic in values) {
        
        USGSMeasurement* gaugeSiteMeasurement = [[USGSMeasurement alloc] init];
        gaugeSiteMeasurement.value = [[measurementDic objectForKey:@"value"] doubleValue];
        NSString* dateString = [measurementDic objectForKey:@"dateTime"];
        dateString = [dateString substringToIndex:19];
        gaugeSiteMeasurement.units = units;
        gaugeSiteMeasurement.date = [dateFormatter dateFromString:dateString];
        [measurments addObject:gaugeSiteMeasurement];
    }
    
    if ([measurments count] > 0) {
        return measurments;
    }else{
        return nil;
    }
}


@end
