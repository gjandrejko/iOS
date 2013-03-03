//
//  IpadMeasurementTablesViewController.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 3/2/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "MeasurementsViewController.h"
#import "IpadParentViewController.h"
#import "USGSMeasurementData.h"
#import "NOAAMeasurementData.h"
@interface IpadMeasurementTablesViewController : MeasurementsViewController
@property (strong,nonatomic) IpadParentViewController* parentViewController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *resizeButton;
-(void)setUSGSMeasurementData:(USGSMeasurementData*)usgsMeasurementData NOAAMeasurementData:(NOAAMeasurementData*)noaaMeasurmentData;
@end
