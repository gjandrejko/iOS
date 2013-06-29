//
//  MeasurementDownloadManager.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 6/22/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

FOUNDATION_EXPORT NSString* const MeasuremntDownloadManagerDidDownloadUSGSNotification;
FOUNDATION_EXPORT NSString* const MeasuremntDownloadManagerDidDownloadNOAANotification;
FOUNDATION_EXPORT NSString* const MeasuremntDownloadManagerDidDownloadAllNotification;

#import <Foundation/Foundation.h>
@class NOAAMeasurementData;
@class USGSMeasurementData;
@class GaugeSite;
@interface MeasurementDownloadManager : NSObject

@property (strong,nonatomic)  NOAAMeasurementData* noaaMeasurementData;
@property (strong,nonatomic)  USGSMeasurementData* usgsMeasurementData;
-(void)fetchDataForGaugeSite:(GaugeSite*)gaugeSite WithCompletion:(void (^)(NSError* error))completion;
@property (strong,nonatomic) GaugeSite* gaugeSite;

@end
