//
//  MeasurementsTableViewController.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 3/1/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "MeasurementsViewController.h"
#import "MeasurementDescriptionProtocol.h"
#import "MeasurementTableViewCell.h"
@interface MeasurementsViewController ()

@end

@implementation MeasurementsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellStripedDarkBackground"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.measurements count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeasurementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeasurementTableViewCell"];
    id<MeasurementDescriptionProtocol> measurement = self.measurements[indexPath.row];
    
    cell.measurementDescriptionLabel.text = [measurement measurementDescriptionString];
    cell.measurementValueLabel.text = [measurement measurementValueString];
    cell.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellStripedBackground"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


@end
