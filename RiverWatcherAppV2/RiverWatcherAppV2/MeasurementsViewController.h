//
//  MeasurementsTableViewController.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 3/1/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

//!!This class Requires a cell in storyboard with a reuse identifier MeasurementTableViewCell

@interface MeasurementsViewController : UIViewController <UITableViewDelegate,UITextFieldDelegate>

//Objects in measurements array must follow MeasurementDescriptionProtocol
@property (strong,nonatomic) NSArray* measurements;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
