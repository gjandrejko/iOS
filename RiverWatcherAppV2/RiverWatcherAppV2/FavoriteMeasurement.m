//
//  FavoriteMeasurement.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/10/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "FavoriteMeasurement.h"

@implementation FavoriteMeasurement


-(NSDate*)measurementDate{
    if (self.temperatureMeasurement.date){
        return self.temperatureMeasurement.date;
    }else if (self.heightMeasurement.date){
        return self.heightMeasurement.date;
    }else if (self.dischargeMeasurement.date){
        return self.temperatureMeasurement.date;
    }
}

@end
