//
//  MainMenuTableViewControllerIpad.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/9/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "MainMenuTableViewController.h"
#import "IpadParentViewController.h"
#import "RWSplitViewController.h"
@interface IpadMainMenuTableViewController : MainMenuTableViewController
@property (strong,nonatomic) IpadParentViewController* ipadParentViewController;
@property (weak,nonatomic) RWSplitViewController* rwSplitViewController;
@end
