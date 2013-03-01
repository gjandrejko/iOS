//
//  MeasurementDescriptionProtocol.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 3/1/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MeasurementDescriptionProtocol <NSObject>
-(NSString*)measurementDescriptionString;
-(NSString*)measurementValueString;

@end
