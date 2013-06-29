//
//  IpadMeasurementTablesViewController.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 3/2/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "IpadMeasurementTablesViewController.h"
#import "MeasurementTableViewCell.h"
#import "UIColor+FlatUI.h"
#define HEIGHT @"Stage"
#define DISCHARGE @"Flow"
#define TEMPERATURE @"Temp"
#define NOAA_OBSERVED @"Observed"
#define NOAA_FORECAST @"Forecast"
#define FLOOD_STAGES @"Flood Stages"


@interface IpadMeasurementTablesViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) NOAAMeasurementData* noaaMeasurementData;
@property (strong,nonatomic) USGSMeasurementData* usgsMeasurementData;
@property (weak, nonatomic) IBOutlet UISegmentedControl *measurementTypesSegControl;

@end

@implementation IpadMeasurementTablesViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self updateUI:nil];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
}


-(void)setMeasurementDownloadManager:(MeasurementDownloadManager *)measurementDownloadManager{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _measurementDownloadManager = measurementDownloadManager;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:MeasuremntDownloadManagerDidDownloadAllNotification object:nil];
    
    
   
    //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:MeasuremntDownloadManagerDidDownloadUSGSNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:MeasuremntDownloadManagerDidDownloadNOAANotification object:nil];
    
}

- (void)updateUI:(NSNotification*)notification
{

    self.noaaMeasurementData = self.measurementDownloadManager.noaaMeasurementData;
    self.usgsMeasurementData = self.measurementDownloadManager.usgsMeasurementData;

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

-(void)setUSGSMeasurementData:(USGSMeasurementData*)usgsMeasurementData NOAAMeasurementData:(NOAAMeasurementData*)noaaMeasurmentData
{
    
    
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row % 2 == 0) {
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.208 green:0.518 blue:0.655 alpha:1];
    }else{
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.255 green:0.600 blue:0.753 alpha:1];
    }
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
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




- (void)viewDidUnload {
    [self setMeasurementTypesSegControl:nil];
    [super viewDidUnload];
}
@end
