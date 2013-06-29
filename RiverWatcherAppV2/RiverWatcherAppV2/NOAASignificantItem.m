//
//  NOAASignificantData.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "NOAASignificantItem.h"
@interface NOAASignificantItem ()
@property (strong,nonatomic) NSNumberFormatter* numberFormatter;
@end

@implementation NOAASignificantItem


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
    //Capitalize first character 
    NSString* descriptionString = self.name;
    if ([descriptionString length] >= 1) {

            descriptionString = [descriptionString stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                          withString:[[descriptionString  substringToIndex:1] capitalizedString]];
    }
    return descriptionString;
}

-(NSString*)measurementValueString
{
    NSString* measurementValueString = @"";
    
    if (self.stageValue && self.stageUnits) {
        measurementValueString = [NSString stringWithFormat:@"%@ %@",[self.numberFormatter stringFromNumber:self.stageValue],self.stageUnits];
    }
    
    if (self.stageValue && self.stageUnits && self.flowValue && self.flowUnits) {
        measurementValueString = [measurementValueString stringByAppendingString:@" / "];
    }
    
    if (self.flowValue && self.flowUnits) {
        measurementValueString = [NSString stringWithFormat:@"%@%@ %@",measurementValueString,[self.numberFormatter stringFromNumber:self.flowValue],self.flowUnits];
    }
    
    if (!([measurementValueString length] > 0)) {
        measurementValueString = @"N/A";
    }
    
    return measurementValueString;
    
}

@end
