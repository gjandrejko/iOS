//
//  GraphViewController.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/8/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphViewController : UIViewController

- (IBAction)dismissGraph:(id)sender;
@property (strong,nonatomic) NSArray* pointsToGraphs;


@end
