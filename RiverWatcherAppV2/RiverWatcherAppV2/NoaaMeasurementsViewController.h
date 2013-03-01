//
//  NoaaMeasurementsViewController.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 3/1/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "MeasurementsViewController.h"

@interface NoaaMeasurementsViewController : MeasurementsViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *measurementTypeSegControl;

@property (weak, nonatomic) IBOutlet UISegmentedControl *measurementTypeChanged;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@end
