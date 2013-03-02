//
//  MasterIpadViewController.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 3/2/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface IpadParentViewController : UIViewController
- (IBAction)showHideSideNavView:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *tablesContainerView;
@property (weak, nonatomic) IBOutlet UIView *sideNavView;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIView *recentValuesView;
-(void)toggleViewControllerFullScreen:(UIViewController*)viewController;
@property (weak, nonatomic) IBOutlet UIView *graphContainerView;
@end
