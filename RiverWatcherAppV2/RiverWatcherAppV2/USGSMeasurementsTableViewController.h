//
//  MultipleMeasurementsViewController.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 3/1/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "MeasurementsViewController.h"
#import "USGSMeasurementData.h"
@interface USGSMeasurementsTableViewController : MeasurementsViewController

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *measurementTypeSegmetedControl;
- (IBAction)measurementTypeChanged:(UISegmentedControl *)sender;
@property (strong,nonatomic) USGSMeasurementData* usgsMeasurementData;
@end
