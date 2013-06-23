//
//  USGSMultipleSitesWebService.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 6/22/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USGSMultipleSitesWebService : NSObject
-(void)downloadLatestMeasurementsFoGaugeSites:(NSArray*)gaugeSites Completion:(void (^)(NSDictionary* measurementDictionaryWithUsgsIdKeys,NSError* error))completion;
-(void)cancel;
@end
