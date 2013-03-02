//
//  IpadMeasurementTablesViewController.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 3/2/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "MeausrementTablesViewController.h"
#import "IpadParentViewController.h"

@interface IpadMeasurementTablesViewController : MeausrementTablesViewController 
@property (strong,nonatomic) IpadParentViewController* parentViewController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *resizeButton;

@end
