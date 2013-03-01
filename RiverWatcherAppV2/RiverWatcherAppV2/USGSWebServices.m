//
//  USGSWebServices.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "USGSWebServices.h"
#import "USGSMeasurement.h"
#import "GaugeSite.h"
#import "FavoriteMeasurement.h"

#define PARAM_CODE_TEMP @"00010"
#define PARAM_CODE_HEIGHT @"00065"
#define PARAM_CODE_DISCHARGE @"00060"


@implementation USGSWebServices


+(void)downloadLatestMeasurementsFoGaugeSites:(NSArray*)gaugeSites Completion:(void (^)(NSDictionary* measurementDictionaryWithUsgsIdKeys,NSError* error))completion{

    NSString* gaugeSitesCsvString = @"";
    
    for (int i = 0; i < [gaugeSites count]; i ++) {
        
        NSString* gaugeSiteUsgsId = [gaugeSites[i] usgsId];
        
        if (i < [gaugeSites count] -1 ) {
            gaugeSiteUsgsId = [gaugeSiteUsgsId stringByAppendingString:@","];
        }
        
        gaugeSitesCsvString = [gaugeSitesCsvString stringByAppendingString:gaugeSiteUsgsId];
        
    }
    NSLog(@"LATEST:%@",gaugeSitesCsvString);
    NSString* urlString = [NSString stringWithFormat:@"http://waterservices.usgs.gov/nwis/iv/?format=json,1.1&sites=%@&parameterCd=00060,00065,00010",gaugeSitesCsvString];

     NSURL* url = [NSURL URLWithString:urlString];
    
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {

        if (!error) {
            
            NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSError* jsonError;

            if (!jsonError) {
                NSArray* timeSeries = [jsonDictionary valueForKeyPath:@"value.timeSeries"];
                
                NSMutableDictionary* completionDictionary = [NSMutableDictionary dictionary];
                
                for (NSDictionary* timeSeriesDic in timeSeries) {
                    
                    NSString* usgsId = [[[timeSeriesDic valueForKeyPath:@"sourceInfo.siteCode"] firstObject] valueForKey:@"value"];
                    
                    FavoriteMeasurement* favoriteMeasurement = [completionDictionary objectForKey:usgsId];
                    
                    
                    if (!favoriteMeasurement) {
                        favoriteMeasurement = [[FavoriteMeasurement alloc] init];

                    }
                    
            
                    
                    NSString* measurementType = [[[timeSeriesDic valueForKeyPath:@"variable.variableCode"] firstObject] valueForKey:@"value"];
                    NSLog(@"%@",measurementType);
                    NSArray* jsonValues = [[timeSeriesDic valueForKeyPath:@"values.value"] firstObject];
                    NSString* units = [timeSeriesDic valueForKeyPath:@"variable.unit.unitAbbreviation"];
                    
                  
                    
                    if ([measurementType isEqualToString:PARAM_CODE_TEMP]) {
                        
                        favoriteMeasurement.temperatureMeasurement = [[USGSWebServices measurmentsArrayWithArrayOfJsonValues:jsonValues Units:units] firstObject];
                        
                    }else if ([measurementType isEqualToString:PARAM_CODE_HEIGHT]){
                        
                         favoriteMeasurement.heightMeasurement = [[USGSWebServices measurmentsArrayWithArrayOfJsonValues:jsonValues Units:units] firstObject];
                         
                        
                    }else if ([measurementType isEqualToString:PARAM_CODE_DISCHARGE]){
                        
                          favoriteMeasurement.dischargeMeasurement = [[USGSWebServices measurmentsArrayWithArrayOfJsonValues:jsonValues Units:units] firstObject];
                      
                        
                    }
                    
                    [completionDictionary setObject:favoriteMeasurement forKey:usgsId];
                     
                }
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    completion(completionDictionary,nil);
                }];
                
                
            }else{
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    completion(nil,jsonError);
                }];
                
            }
            
     
            
        }else{
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completion(nil,error);
            }];
        }
    
    }];
    
    
}


+(void)downloadMeasurementsForSiteId:(NSString*)siteId NumberOfDays:(NSInteger)days Completion:(void (^)(USGSMeasurementData* data,NSError* error))completion;{
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
                    
                    usgsMeasurementData.temperatureMeasurements = [USGSWebServices measurmentsArrayWithArrayOfJsonValues:jsonValues Units:units];
                    
                }else if ([measurementType isEqualToString:PARAM_CODE_HEIGHT]){
                    
                    usgsMeasurementData.heightMeasurements = [USGSWebServices measurmentsArrayWithArrayOfJsonValues:jsonValues Units:units];

                    
                }else if ([measurementType isEqualToString:PARAM_CODE_DISCHARGE]){
                    
                    usgsMeasurementData.dischargeMeasurements = [USGSWebServices measurmentsArrayWithArrayOfJsonValues:jsonValues Units:units];

                    
                }
            }
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completion(usgsMeasurementData,nil);
            }];
        }
        }
    }];
}

+(NSArray*)measurmentsArrayWithArrayOfJsonValues:(NSArray*)values Units:(NSString*)units{
    
    NSMutableArray* measurments = [NSMutableArray array];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    for (NSDictionary* measurementDic in values) {
        
        USGSMeasurement* gaugeSiteMeasurement = [[USGSMeasurement alloc] init];
        gaugeSiteMeasurement.value = [[measurementDic objectForKey:@"value"] doubleValue];
        NSString* dateString = [measurementDic objectForKey:@"dateTime"];
        dateString = [dateString substringToIndex:19];
        gaugeSiteMeasurement.units = units;
        gaugeSiteMeasurement.date = [dateFormatter dateFromString:dateString];
        [measurments addObject:gaugeSiteMeasurement];
    }
    
    if ([measurments count] > 0) {
        return measurments;
    }else{
        return nil;
    }
}

@end
