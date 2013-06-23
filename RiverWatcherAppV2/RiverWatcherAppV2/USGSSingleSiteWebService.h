//
//  USGSSingleSiteWebService.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 6/22/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
@class USGSMeasurementData;
@interface USGSSingleSiteWebService : NSObject
-(void)downloadMeasurementsForSiteId:(NSString*)siteId NumberOfDays:(NSInteger)days Completion:(void (^)(USGSMeasurementData* data,NSError* error))completion;
-(void)cancel;

@end
