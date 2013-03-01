//
//  NOAASignificantData.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "NOAASignificantItem.h"

@implementation NOAASignificantItem
/*
-(NSString*)name{
    
    //Capitalize first character in string
    
    if ([_name length] >= 1) {
        
        _name = [_name stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                          withString:[[_name  substringToIndex:1] capitalizedString]];
        
    }
    
    return _name;
    
}

*/
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
        measurementValueString = [NSString stringWithFormat:@"%@ %@",self.stageValue,self.stageUnits];
    }
    
    if (self.stageValue && self.stageUnits && self.flowValue && self.flowUnits) {
        measurementValueString = [measurementValueString stringByAppendingString:@" / "];
    }
    
    if (self.flowValue && self.flowUnits) {
        measurementValueString = [NSString stringWithFormat:@"%@%@ %@",measurementValueString,self.flowValue,self.flowUnits];
    }
    
    if (!([measurementValueString length] > 0)) {
        measurementValueString = @"N/A";
    }
    
    return measurementValueString;
    
}

@end
