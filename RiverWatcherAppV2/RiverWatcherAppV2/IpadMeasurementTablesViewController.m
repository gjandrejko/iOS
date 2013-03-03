//
//  IpadMeasurementTablesViewController.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 3/2/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "IpadMeasurementTablesViewController.h"
#import "MeasurementTableViewCell.h"
#define HEIGHT @"Stage"
#define DISCHARGE @"Flow"
#define TEMPERATURE @"Temp"
#define NOAA_OBSERVED @"Observed"
#define NOAA_FORECAST @"Forecast"
#define FLOOD_STAGES @"Flood Stages"


@interface IpadMeasurementTablesViewController ()
@property (strong,nonatomic) NOAAMeasurementData* noaaMeasurementData;
@property (strong,nonatomic) USGSMeasurementData* usgsMeasurementData;
@property (weak, nonatomic) IBOutlet UISegmentedControl *measurementTypesSegControl;

@end

@implementation IpadMeasurementTablesViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleFullScreen:)];
    
    
    [self.view addGestureRecognizer:tapGesture];
    
}

-(void)setUSGSMeasurementData:(USGSMeasurementData*)usgsMeasurementData NOAAMeasurementData:(NOAAMeasurementData*)noaaMeasurmentData
{
    self.noaaMeasurementData = noaaMeasurmentData;
    self.usgsMeasurementData = usgsMeasurementData;
    
    [self.measurementTypesSegControl removeAllSegments];
    
    if ([self.usgsMeasurementData.heightMeasurements count]) {
        [self.measurementTypesSegControl insertSegmentWithTitle:HEIGHT atIndex:self.measurementTypesSegControl.numberOfSegments animated:NO];
    }
    
    if ([self.usgsMeasurementData.dischargeMeasurements count]) {
        [self.measurementTypesSegControl insertSegmentWithTitle:DISCHARGE atIndex:self.measurementTypesSegControl.numberOfSegments animated:NO];
    }
    
    
    if ([self.usgsMeasurementData.temperatureMeasurements count]) {
        [self.measurementTypesSegControl insertSegmentWithTitle:TEMPERATURE atIndex:self.measurementTypesSegControl.numberOfSegments animated:NO];
    }
    
    //If usgs failed to load fall back to NOAA data for observed measurements
    if (![self.usgsMeasurementData hasMeasurements] && [self.noaaMeasurementData.observedMeasurements count]) {
        [self.measurementTypesSegControl insertSegmentWithTitle:NOAA_OBSERVED atIndex:self.measurementTypesSegControl.numberOfSegments animated:NO];
    }
    
    
    if ([self.noaaMeasurementData.forecastMeasurements count]) {
        [self.measurementTypesSegControl insertSegmentWithTitle:NOAA_FORECAST atIndex:self.measurementTypesSegControl.numberOfSegments animated:NO];
    }
    
    if ([self.noaaMeasurementData.significantData count]) {
        [self.measurementTypesSegControl insertSegmentWithTitle:FLOOD_STAGES atIndex:self.measurementTypesSegControl.numberOfSegments animated:NO];
    }

    if (self.measurementTypesSegControl.numberOfSegments > 0) {
        self.measurementTypesSegControl.selectedSegmentIndex = 0;
        [self measurementTypeChanged:self.measurementTypesSegControl];
    }else{
        self.measurements = nil;
        [self.tableView reloadData];
    }
}



- (IBAction)measurementTypeChanged:(UISegmentedControl *)sender {
    
    NSString* segmentTitle = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    
    if ([segmentTitle isEqualToString:HEIGHT]) {
        
        //Sort observed measurements descending by date
        self.measurements = [self.usgsMeasurementData.heightMeasurements sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            USGSMeasurement* measurement1 = (USGSMeasurement*)obj1;
            USGSMeasurement* measurement2 = (USGSMeasurement*)obj2;
            return [measurement2.date compare:measurement1.date];
            
        }];
        
    }else if ([segmentTitle isEqualToString:DISCHARGE]) {
        
        //Sort observed measurements descending by date
        self.measurements = [self.usgsMeasurementData.dischargeMeasurements sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            USGSMeasurement* measurement1 = (USGSMeasurement*)obj1;
            USGSMeasurement* measurement2 = (USGSMeasurement*)obj2;
            return [measurement2.date compare:measurement1.date];
            
        }];
        
    }else if ([segmentTitle isEqualToString:TEMPERATURE]) {
       
        //Sort observed measurements descending by date
        self.measurements = [self.usgsMeasurementData.temperatureMeasurements sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            USGSMeasurement* measurement1 = (USGSMeasurement*)obj1;
            USGSMeasurement* measurement2 = (USGSMeasurement*)obj2;
            return [measurement2.date compare:measurement1.date];
            
        }];
        
    }else if ([segmentTitle isEqualToString:NOAA_OBSERVED]) {
        
        //Sort observed measurements descending by date
        self.measurements = [self.noaaMeasurementData.observedMeasurements sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NOAAMeasurement* measurement1 = (NOAAMeasurement*)obj1;
            NOAAMeasurement* measurement2 = (NOAAMeasurement*)obj2;
            return [measurement2.date compare:measurement1.date];
            
        }];

        
    }else if ([segmentTitle isEqualToString:FLOOD_STAGES]) {
        
        self.measurements = self.noaaMeasurementData.significantData;
        
    }else if ([segmentTitle isEqualToString:NOAA_FORECAST]) {
        
        //Sort forecast measurements ascending by date
        self.measurements = [self.noaaMeasurementData.forecastMeasurements sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NOAAMeasurement* measurement1 = (NOAAMeasurement*)obj1;
            NOAAMeasurement* measurement2 = (NOAAMeasurement*)obj2;
            return [measurement1.date compare:measurement2.date];
            
        }];
        
    }
    
    [self.tableView reloadData];
    
}




- (IBAction)toggleFullScreen:(id)sender {
    [self.parentViewController toggleViewControllerFullScreen:self];
}

- (void)viewDidUnload {
    [self setMeasurementTypesSegControl:nil];
    [super viewDidUnload];
}
@end
