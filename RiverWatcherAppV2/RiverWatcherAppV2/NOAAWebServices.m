//
//  NOAAXmlParser.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "NOAAWebServices.h"
#import "NOAAMeasurementData.h"
#import "NOAASignificantItem.h"
#import "NOAAMeasurement.h"
#import "UtilMethods.h"

#define NO_DATA_VALUE @"-999"

typedef enum {
    NOAAWebServicesSectionUnknown = 0,
    NOAAWebServicesSectionSignificantFlows,
    NOAAWebServicesSectionSignificantStages,
    NOAAWebServicesSectionObservedMeasurements,
    NOAAWebServicesSectionComputedMeasurements,
} NOAAWebServicesSection;


@interface NOAAWebServices ()  <NSXMLParserDelegate>
@property (strong,nonatomic) NOAAMeasurementData* noaaMeasurementData;
@property (nonatomic) NOAAWebServicesSection currentSection;
@property (strong,nonatomic) NSXMLParser* xmlParser;
@property (strong,nonatomic)  void (^completion)(NOAAMeasurementData* data,NSError* error) ;
@property (strong,nonatomic)  NSMutableString* currentElement;
@property (strong,nonatomic)  NOAAMeasurement* currentMeasurement;
@property (strong,nonatomic)  NOAASignificantItem* currentSignificantItem;


@end

@implementation NOAAWebServices

-(void)downloadMeasurementsForSiteId:(NSString*)siteId Completion:(void (^)(NOAAMeasurementData* data,NSError* error))completion
{
    NSString* urlString = [NSString stringWithFormat:@"http://water.weather.gov/ahps2/hydrograph_to_xml.php?gage=%@&output=xml",siteId];
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    self.completion = completion;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
        
        if (!error) {
            self.xmlParser = [[NSXMLParser alloc] initWithData:data];
            self.xmlParser.delegate = self;
            self.noaaMeasurementData = [[NOAAMeasurementData alloc] init];
            [self.xmlParser parse];
        }else{
            NSLog(@"ERROR Downloading NOAA Datat");
            self.completion(nil,error);
        }
        

        
    }];
    
    


}

#pragma mark NSXMLParserDelegate Methods
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!self.currentElement) {
        self.currentElement = [[NSMutableString alloc] init];
    }
    
    [self.currentElement appendString:string];
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if (self.currentSection == NOAAWebServicesSectionSignificantFlows || self.currentSection == NOAAWebServicesSectionSignificantStages) {
        
        
        
        self.currentSignificantItem = nil;
        
        for (NOAASignificantItem* significantItem in self.noaaMeasurementData.significantData) {
            
            if ([significantItem.name isEqualToString:elementName]) {
                self.currentSignificantItem = significantItem;
                break;
            }
        }
        
        if (!self.currentSignificantItem) {
            self.currentSignificantItem = [[NOAASignificantItem alloc] init];

        }
        
        if (self.currentSection == NOAAWebServicesSectionSignificantFlows){
            
            self.currentSignificantItem.flowUnits = [attributeDict objectForKey:@"units"];
            
        }else if (self.currentSection == NOAAWebServicesSectionSignificantStages){
            
            self.currentSignificantItem.stageUnits = [attributeDict objectForKey:@"units"];

        }

        self.currentSignificantItem.name = elementName;

        
    }else if([elementName isEqualToString:@"sigstages"] ){
        
        self.currentSection = NOAAWebServicesSectionSignificantStages;
        
        if (!self.noaaMeasurementData.significantData) {
            self.noaaMeasurementData.significantData = [NSMutableArray array];
        }
        
    }else if( [elementName isEqualToString:@"sigflows"]){
        
        self.currentSection = NOAAWebServicesSectionSignificantFlows;
        
        if (!self.noaaMeasurementData.significantData) {
            self.noaaMeasurementData.significantData = [NSMutableArray array];
        }
        
    }else if ([elementName isEqualToString:@"observed"]){
        
        self.currentSection = NOAAWebServicesSectionObservedMeasurements;
     
        if (!self.noaaMeasurementData.noaaMeasurements) {
            self.noaaMeasurementData.noaaMeasurements = [[NSMutableArray alloc] init];
        }


    }else if ([elementName isEqualToString:@"forecast"]){
        
        if (!self.noaaMeasurementData.noaaMeasurements) {
            self.noaaMeasurementData.noaaMeasurements = [[NSMutableArray alloc] init];
        }
        
        self.currentSection = NOAAWebServicesSectionComputedMeasurements;

        
    }else if ([elementName isEqualToString:@"datum"] && (self.currentSection == NOAAWebServicesSectionComputedMeasurements || self.currentSection == NOAAWebServicesSectionObservedMeasurements)){
        
        self.currentMeasurement = [[NOAAMeasurement alloc] init];
        
        if(self.currentSection == NOAAWebServicesSectionComputedMeasurements){
            self.currentMeasurement.isForecast = YES;
        }
        
    }else if ([elementName isEqualToString:@"valid"] && (self.currentSection == NOAAWebServicesSectionComputedMeasurements || self.currentSection == NOAAWebServicesSectionObservedMeasurements)){
        
        self.currentMeasurement.timeZone = [NSTimeZone timeZoneWithAbbreviation:[attributeDict objectForKey:@"timezone"]];
                                            
    }else if ([elementName isEqualToString:@"primary"] && (self.currentSection == NOAAWebServicesSectionComputedMeasurements || self.currentSection == NOAAWebServicesSectionObservedMeasurements)){
        
        self.currentMeasurement.primaryName = [attributeDict objectForKey:@"name"];
        self.currentMeasurement.primaryUnits = [attributeDict objectForKey:@"units"];

    }else if ([elementName isEqualToString:@"secondary"] && (self.currentSection == NOAAWebServicesSectionComputedMeasurements || self.currentSection == NOAAWebServicesSectionObservedMeasurements)){
        
        self.currentMeasurement.secondaryName = [attributeDict objectForKey:@"name"];
        self.currentMeasurement.secondaryUnits = [attributeDict objectForKey:@"units"];
        
    }

}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{

              
    
    if([elementName isEqualToString:@"sigstages"] || [elementName isEqualToString:@"sigflows"]){
        
        self.currentSection = NOAAWebServicesSectionUnknown;
        
    }else if ([elementName isEqualToString:@"observed"]){
        
        self.currentSection = NOAAWebServicesSectionUnknown;
    
        
    }else if ([elementName isEqualToString:@"forecast"]){
        
        self.currentSection = NOAAWebServicesSectionUnknown;
        
    }else if ([elementName isEqualToString:@"datum"] && (self.currentSection == NOAAWebServicesSectionComputedMeasurements || self.currentSection == NOAAWebServicesSectionObservedMeasurements)){
        
        [self.noaaMeasurementData.noaaMeasurements addObject:self.currentMeasurement];
        
    }else if ([elementName isEqualToString:@"valid"] && (self.currentSection == NOAAWebServicesSectionComputedMeasurements || self.currentSection == NOAAWebServicesSectionObservedMeasurements)){
#warning need to handle timezones
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
        self.currentMeasurement.date = [dateFormatter dateFromString:self.currentElement];
        
    }else if ([elementName isEqualToString:@"primary"] && (self.currentSection == NOAAWebServicesSectionComputedMeasurements || self.currentSection == NOAAWebServicesSectionObservedMeasurements)){
        
        if (![self.currentElement isEqualToString:NO_DATA_VALUE]) {
            self.currentMeasurement.primaryValue =  [NSNumber numberWithDouble:[self.currentElement doubleValue]];

        }
        

        
    }else if ([elementName isEqualToString:@"secondary"] && (self.currentSection == NOAAWebServicesSectionComputedMeasurements || self.currentSection == NOAAWebServicesSectionObservedMeasurements)){
        
        if (![self.currentElement isEqualToString:NO_DATA_VALUE]) {
            self.currentMeasurement.secondaryValue =  [NSNumber numberWithDouble:[self.currentElement doubleValue]];
            
        }

        
    }else if (self.currentSection == NOAAWebServicesSectionSignificantFlows){
        
        self.currentSignificantItem.flowValue = [NSNumber numberWithDouble:[self.currentElement doubleValue]];
        
        if (![self.noaaMeasurementData.significantData containsObject:self.currentSignificantItem]) {
            [self.noaaMeasurementData.significantData addObject:self.currentSignificantItem];
        }

    }else if (self.currentSection == NOAAWebServicesSectionSignificantStages){
        
        self.currentSignificantItem.stageValue = [NSNumber numberWithDouble:[self.currentElement doubleValue]];
        
        if (![self.noaaMeasurementData.significantData containsObject:self.currentSignificantItem]) {
            [self.noaaMeasurementData.significantData addObject:self.currentSignificantItem];
        }

    }
    self.currentElement = nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    self.completion(nil,parseError);

}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.completion(self.noaaMeasurementData,nil);
    }];
    
}

@end
