//
//  USGSWebServices.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USGSMeasurementData.h"

@interface USGSWebServices : NSObject
+(void)downloadMeasurementsForSiteId:(NSString*)siteId NumberOfDays:(NSInteger)days Completion:(void (^)(USGSMeasurementData* data,NSError* error))completion;
+(void)downloadLatestMeasurementsFoGaugeSites:(NSArray*)gaugeSites Completion:(void (^)(NSDictionary* measurementDictionaryWithUsgsIdKeys,NSError* error))completion;
@end
