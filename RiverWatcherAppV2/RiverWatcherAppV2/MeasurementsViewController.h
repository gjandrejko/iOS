//
//  MeasurementsTableViewController.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 3/1/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeasurementsViewController : UIViewController <UITableViewDelegate,UITextFieldDelegate>

//Objects in measurements array must follow MeasurementDescriptionProtocol
@property (strong,nonatomic) NSArray* measurements;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
