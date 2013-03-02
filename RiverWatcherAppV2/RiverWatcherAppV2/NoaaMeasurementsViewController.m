//
//  NoaaMeasurementsViewController.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 3/1/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "NoaaMeasurementsViewController.h"

#define OBSERVED @"Observed"
#define FORECAST @"Predictions"


@interface NoaaMeasurementsViewController ()

@end

@implementation NoaaMeasurementsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupMeasurementTypeSegControl];
}

-(void)setupMeasurementTypeSegControl
{
    [self.measurementTypeSegControl removeAllSegments];
    
    if ([self.noaaMeasurementData.forecastMeasurements count] ) {
        [self.measurementTypeSegControl insertSegmentWithTitle:FORECAST atIndex:[self.measurementTypeSegControl numberOfSegments] animated:NO];
    }
    
    if ([self.noaaMeasurementData.observedMeasurements count]) {
        [self.measurementTypeSegControl insertSegmentWithTitle:OBSERVED atIndex:[self.measurementTypeSegControl numberOfSegments] animated:NO];
    }
    

    self.measurementTypeSegControl.selectedSegmentIndex = 0;
    [self measurementTypeChanged:self.measurementTypeSegControl];
    
    if ([self.measurementTypeSegControl numberOfSegments] <= 1) {
        self.toolbar.hidden = YES;
        self.tableView.frame = self.view.bounds;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 38;
}

- (IBAction)measurementTypeChanged:(UISegmentedControl *)sender {
    
    NSString* selectedSegmentTitle = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    self.title = selectedSegmentTitle;
    
    if ([selectedSegmentTitle isEqualToString:FORECAST]) {
        
        //Sort forecast measurements ascending by date
        self.measurements = [self.noaaMeasurementData.forecastMeasurements sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NOAAMeasurement* measurement1 = (NOAAMeasurement*)obj1;
            NOAAMeasurement* measurement2 = (NOAAMeasurement*)obj2;
            return [measurement1.date compare:measurement2.date];
            
        }];

    }else if ([selectedSegmentTitle isEqualToString:OBSERVED]){
        
        //Sort observed measurements descending by date
        self.measurements = [self.noaaMeasurementData.observedMeasurements sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NOAAMeasurement* measurement1 = (NOAAMeasurement*)obj1;
            NOAAMeasurement* measurement2 = (NOAAMeasurement*)obj2;
            return [measurement2.date compare:measurement1.date];
            
        }];
    }
    
    [self.tableView reloadData];

}
@end
