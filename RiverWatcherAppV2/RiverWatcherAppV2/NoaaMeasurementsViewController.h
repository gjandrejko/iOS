//
//  NoaaMeasurementsViewController.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 3/1/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "MeasurementsViewController.h"
#import "NOAAMeasurementData.h"

@interface NoaaMeasurementsViewController : MeasurementsViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *measurementTypeSegControl;

- (IBAction)measurementTypeChanged:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong,nonatomic) NOAAMeasurementData* noaaMeasurementData;
@end
