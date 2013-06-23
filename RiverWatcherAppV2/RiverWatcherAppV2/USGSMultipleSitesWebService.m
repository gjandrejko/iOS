//
//  USGSMultipleSitesWebService.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 6/22/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "USGSMultipleSitesWebService.h"

@interface USGSMultipleSitesWebService ()
@property (strong,nonatomic) void (^completion)(NSDictionary* measurementDictionaryWithUsgsIdKeys,NSError* error);
@property (strong,nonatomic) NSURLConnection* urlConnection;
@end

@implementation USGSMultipleSitesWebService


-(void)downloadLatestMeasurementsFoGaugeSites:(NSArray*)gaugeSites Completion:(void (^)(NSDictionary* measurementDictionaryWithUsgsIdKeys,NSError* error))completion
{
    
    
    
    
}




-(void)cancel
{
    [self.urlConnection cancel];
    
}

@end
