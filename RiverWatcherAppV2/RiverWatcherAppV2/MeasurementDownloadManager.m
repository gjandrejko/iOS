//
//  MeasurementDownloadManager.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 6/22/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "MeasurementDownloadManager.h"
#import "NOAAWebServices.h"
#import "USGSWebServices.h"
#import "GaugeSite.h"


NSString* const MeasuremntDownloadManagerDidDownloadUSGSNotification = @"MeasuremntDownloadManagerDidDownloadUSGSNotification";
NSString* const MeasuremntDownloadManagerDidDownloadNOAANotification = @"MeasuremntDownloadManagerDidDownloadNOAANotification";
NSString* const MeasuremntDownloadManagerDidDownloadAllNotification = @"MeasuremntDownloadManagerDidDownloadAllNotification";


@interface MeasurementDownloadManager()

@property (nonatomic) NSInteger numberOfWebservicesDownloaded;
@property (nonatomic) NSInteger numberOfWebservicesFailed;
@property (strong,nonatomic) NOAAWebServices* noaaWebServices;
@property (strong,nonatomic) USGSWebServices* usgsWebsServices;
@property (strong,nonatomic) void(^completion)(NSError* error);

@end

@implementation MeasurementDownloadManager


-(void)setNumberOfWebservicesDownloaded:(NSInteger)numberOfWebservicesDownloaded{
    
    if (_numberOfWebservicesDownloaded != numberOfWebservicesDownloaded) {
        _numberOfWebservicesDownloaded = numberOfWebservicesDownloaded;
        [self checkWebServiceStatus];
    }
}

-(void)setNumberOfWebservicesFailed:(NSInteger)numberOfWebservicesFailed{
    if (_numberOfWebservicesFailed != numberOfWebservicesFailed) {
        _numberOfWebservicesFailed = numberOfWebservicesFailed;
        [self checkWebServiceStatus];
        
    }
}


-(void)checkWebServiceStatus{
    if (self.numberOfWebservicesDownloaded + self.numberOfWebservicesFailed >=2 ) {
        
        NSError* error;
        if (self.numberOfWebservicesFailed > 0) {
            error = [NSError errorWithDomain:@"com.roothollow.error" code:-1 userInfo:nil];
        }else{
            
                [[NSNotificationCenter defaultCenter] postNotificationName:MeasuremntDownloadManagerDidDownloadAllNotification object:self];
            
        }
        
        if (self.completion) {
             [[NSNotificationCenter defaultCenter] postNotificationName:MeasuremntDownloadManagerDidDownloadAllNotification object:self];
            self.completion(error);
        }
    
    }
}

-(NSError*)defaultError{
    
    
    NSError* error;
    
    return error;
}


-(void)downloadUsgsData
{
    self.usgsWebsServices = [[USGSWebServices alloc] init];
    
    [self.usgsWebsServices  downloadMeasurementsForSiteId:self.gaugeSite.usgsId NumberOfDays:30 Completion:^(USGSMeasurementData *usgsMeasurementData, NSError* error) {
        
        
        if (error  ) {
            self.numberOfWebservicesFailed++;
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:MeasuremntDownloadManagerDidDownloadUSGSNotification object:self];
            self.usgsMeasurementData = usgsMeasurementData;
            self.numberOfWebservicesDownloaded++;
            
        }
        [self checkWebServiceStatus];

    }];
}

-(void)downloadNoaaData
{
    self.noaaWebServices = [[NOAAWebServices alloc] init];
    [self.noaaWebServices downloadMeasurementsForSiteId:self.gaugeSite.nwsId Completion:^(NOAAMeasurementData *noaaMeasurementData, NSError *error) {
        NSLog(@"NOAA COMPLETION");
        if (error) {
            self.numberOfWebservicesFailed++;
            
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:MeasuremntDownloadManagerDidDownloadNOAANotification object:self];
            self.noaaMeasurementData = noaaMeasurementData;
            self.numberOfWebservicesDownloaded++;

        }
        [self checkWebServiceStatus];
    }];
}


-(void)fetchDataForGaugeSite:(GaugeSite*)gaugeSite WithCompletion:(void (^)(NSError* error))completion{
    
    self.gaugeSite = gaugeSite;
    [self downloadNoaaData];
    [self downloadUsgsData];
    
}



@end
