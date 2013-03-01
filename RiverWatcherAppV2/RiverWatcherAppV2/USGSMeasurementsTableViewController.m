//
//  MultipleMeasurementsViewController.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 3/1/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "USGSMeasurementsTableViewController.h"

#define HEIGHT @"Stage"
#define DISCHARGE @"Flow"
#define TEMPERATURE @"Temperature"

@interface USGSMeasurementsTableViewController ()

@end

@implementation USGSMeasurementsTableViewController



- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupMeasurementTypeSegControl];
    

}

-(void)setupMeasurementTypeSegControl
{
    [self.measurementTypeSegmetedControl removeAllSegments];
    
    if (self.usgsMeasurementData.heightMeasurements) {
        [self.measurementTypeSegmetedControl insertSegmentWithTitle:HEIGHT atIndex:[self.measurementTypeSegmetedControl numberOfSegments] animated:NO];
    }
    
    if (self.usgsMeasurementData.dischargeMeasurements) {
        [self.measurementTypeSegmetedControl insertSegmentWithTitle:DISCHARGE atIndex:[self.measurementTypeSegmetedControl numberOfSegments] animated:NO];
    }
    
    if (self.usgsMeasurementData.temperatureMeasurements) {
        [self.measurementTypeSegmetedControl insertSegmentWithTitle:TEMPERATURE atIndex:[self.measurementTypeSegmetedControl numberOfSegments] animated:NO];
    }
    
    self.measurementTypeSegmetedControl.selectedSegmentIndex = 0;
    [self measurementTypeChanged:self.measurementTypeSegmetedControl];
    
    if ([self.measurementTypeSegmetedControl numberOfSegments] <= 1) {
        self.toolbar.hidden = YES;
        self.tableView.frame = self.view.bounds;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 38;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)measurementTypeChanged:(UISegmentedControl *)sender {
    
    NSString* selectedSegmentTitle = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    self.title = selectedSegmentTitle;
    
    if ([selectedSegmentTitle isEqualToString:HEIGHT]) {
        self.measurements = self.usgsMeasurementData.heightMeasurements;
    }else if ([selectedSegmentTitle isEqualToString:DISCHARGE]){
        self.measurements = self.usgsMeasurementData.dischargeMeasurements;

    }else if ([selectedSegmentTitle isEqualToString:TEMPERATURE]){
        self.measurements = self.usgsMeasurementData.temperatureMeasurements;

    }
    
    self.measurements = [self.measurements sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        USGSMeasurement* measurement1 = (USGSMeasurement*)obj1;
        USGSMeasurement* measurement2 = (USGSMeasurement*)obj2;
        return [measurement2.date compare:measurement1.date];
        
    }];
    
    
    [self.tableView reloadData];
}
@end
