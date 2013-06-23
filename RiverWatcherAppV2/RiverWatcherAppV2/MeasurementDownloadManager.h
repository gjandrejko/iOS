//
//  MeasurementDownloadManager.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 6/22/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NOAAMeasurementData;
@class USGSMeasurementData;
@class GaugeSite;
@interface MeasurementDownloadManager : NSObject

-(MeasurementDownloadManager*)sharedManager;
@property (strong,nonatomic)  NOAAMeasurementData* noaaMeasurementData;
@property (strong,nonatomic)  USGSMeasurementData* usgsMeasurementData;
-(void)fetchDataForGaugeSite:(GaugeSite*)gaugeSite WithCompletion:(void (^)(NSError* error))completion;
@end
