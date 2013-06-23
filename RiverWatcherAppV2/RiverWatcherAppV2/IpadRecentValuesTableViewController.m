//
//  IpadRecentValuesTableViewController.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 3/3/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "IpadRecentValuesTableViewController.h"

@interface IpadRecentValuesTableViewController ()
@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *tableCells;
@property (weak, nonatomic) IBOutlet UILabel *flowLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *valuelabels;
@property (strong,nonatomic) UIColor* originalColor;

@end

@implementation IpadRecentValuesTableViewController

-(void)setUsgsMeasurmentData:(USGSMeasurementData *)usgsMeasurmentData{
    _usgsMeasurmentData = usgsMeasurmentData;
    USGSMeasurement* tempMeasurement = [_usgsMeasurmentData.temperatureMeasurements lastObject];
    USGSMeasurement* heightMeasurement = [_usgsMeasurmentData.heightMeasurements lastObject];
    USGSMeasurement* dischargeMeasurment = [_usgsMeasurmentData.dischargeMeasurements lastObject];

    self.temperatureLabel.text = [tempMeasurement measurementValueString];
    self.flowLabel.text = [dischargeMeasurment measurementValueString];
    self.heightLabel.text = [heightMeasurement measurementValueString];
    self.dateLabel.text = [heightMeasurement measurementDescriptionString];
    
    for (UILabel* label in self.valuelabels) {
        if (!label.text) {
            label.text = @"N/A";
            label.textColor = [UIColor lightGrayColor];
        }else{
            label.textColor = self.originalColor;
        }
        label.textColor = [UIColor colorWithRed:0.192 green:0.282 blue:0.369 alpha:1];
        label.shadowColor = [UIColor clearColor];
        label.shadowColor = [UIColor whiteColor];
        label.shadowOffset = CGSizeMake(0, 1);
    }
    
    for (UILabel* descriptionLabel in self.descriptionLabels) {
        descriptionLabel.textColor = [UIColor colorWithRed:0.192 green:0.282 blue:0.369 alpha:1];
        descriptionLabel.shadowColor = [UIColor whiteColor];
        descriptionLabel.shadowOffset = CGSizeMake(0, 1);
                                                   
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.originalColor = self.heightLabel.textColor;
    for (UITableViewCell* cell in self.tableCells) {
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
    }
}



- (void)viewDidUnload {
    [self setFlowLabel:nil];
    [self setTemperatureLabel:nil];
    [self setHeightLabel:nil];
    [self setTableCells:nil];
    [self setDateLabel:nil];
    [self setValuelabels:nil];

    [self setDescriptionLabels:nil];
    [super viewDidUnload];
}
@end
