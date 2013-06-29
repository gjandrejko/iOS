//
//  RWSplitViewController.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 6/23/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "RWSplitViewController.h"
#import "IpadMainMenuTableViewController.h"
@interface RWSplitViewController ()
@property (weak,nonatomic) UINavigationController* detailNavigationController;
@end

@implementation RWSplitViewController

-(void)setRwDetailViewController:(UIViewController *)rwDetailViewController{
    
    if (_rwDetailViewController != rwDetailViewController ) {
        _rwDetailViewController = rwDetailViewController;
        [self.detailNavigationController setViewControllers:@[_rwDetailViewController] animated:YES];
    }
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    IpadMainMenuTableViewController* ipadMainMenuTableViewController = [self.viewControllers[0] topViewController];
    ipadMainMenuTableViewController.rwSplitViewController = self;
    self.detailNavigationController = self.viewControllers[1];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
