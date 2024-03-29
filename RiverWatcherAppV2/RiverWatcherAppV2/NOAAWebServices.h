//
//  NOAAXmlParser.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NOAAMeasurementData.h"
@interface NOAAWebServices : NSObject

-(void)downloadMeasurementsForSiteId:(NSString*)siteId Completion:(void (^)(NOAAMeasurementData* data,NSError* error))completion;
@end
