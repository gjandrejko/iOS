//
//  USGSSingleSiteWebService.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 6/22/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//
#import "USGSMeasurementData.h"
#import "USGSSingleSiteWebService.h"
#import "USGSMeasurement.h"

#define PARAM_CODE_TEMP @"00010"
#define PARAM_CODE_HEIGHT @"00065"
#define PARAM_CODE_DISCHARGE @"00060"


@interface USGSSingleSiteWebService ()
@property (strong,nonatomic) void (^completion)(USGSMeasurementData* data,NSError* error);
@property (strong,nonatomic) NSURLConnection* urlConnection;
@end

@implementation USGSSingleSiteWebService



-(void)downloadMeasurementsForSiteId:(NSString*)siteId NumberOfDays:(NSInteger)days Completion:(void (^)(USGSMeasurementData* data,NSError* error))completion;{
    NSString* urlString = [NSString stringWithFormat:@"http://waterservices.usgs.gov/nwis/iv/?format=json,1.1&sites=%@&period=P%dD&parameterCd=00060,00065,00010",siteId,days];
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
        NSError* jsonError;
        
        if (error || !data) {
            completion(nil,error);
        }else{
            
            NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (!jsonError) {
                USGSMeasurementData* usgsMeasurementData = [[USGSMeasurementData alloc] init];
                NSArray* timeSeries = [jsonDictionary valueForKeyPath:@"value.timeSeries"];
                
                for (NSDictionary* timeSeriesDic in timeSeries) {
                    
                    NSString* measurementType = [[[timeSeriesDic valueForKeyPath:@"variable.variableCode"] firstObject] valueForKey:@"value"];
                    NSLog(@"%@",measurementType);
                    NSArray* jsonValues = [[timeSeriesDic valueForKeyPath:@"values.value"] firstObject];
                    NSString* units = [timeSeriesDic valueForKeyPath:@"variable.unit.unitAbbreviation"];
                    if ([measurementType isEqualToString:PARAM_CODE_TEMP]) {
                        
                        usgsMeasurementData.temperatureMeasurements = [USGSMeasurement measurmentsArrayWithArrayOfJsonValues:jsonValues Units:units];
                        
                    }else if ([measurementType isEqualToString:PARAM_CODE_HEIGHT]){
                        
                        usgsMeasurementData.heightMeasurements = [USGSMeasurement measurmentsArrayWithArrayOfJsonValues:jsonValues Units:units];
                        
                        
                    }else if ([measurementType isEqualToString:PARAM_CODE_DISCHARGE]){
                        
                        usgsMeasurementData.dischargeMeasurements = [USGSMeasurement measurmentsArrayWithArrayOfJsonValues:jsonValues Units:units];
                        
                        
                    }
                }
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    completion(usgsMeasurementData,nil);
                }];
            }
        }
    }];
}


-(void)cancel
{
    
    
}

@end
