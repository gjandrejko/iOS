//
//  MasterIpadViewController.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 3/2/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "IpadParentViewController.h"
#import "MainMenuTableViewController.h"
#import "IpadMeasurementTablesViewController.h"
#import "IpadRecentValuesViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface IpadParentViewController ()
@property (strong,nonatomic)  MainMenuTableViewController* mainMenuViewController;
@property (strong,nonatomic)  IpadMeasurementTablesViewController* ipadMeasurementTablesViewController;
@property (strong,nonatomic)  IpadRecentValuesViewController* ipadRecentValuesViewController;

@property (nonatomic) CGRect tablesContainerViewOriginalFrame;
@end

@implementation IpadParentViewController

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

    self.mainContainerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellStripedBlueBackground"]];
    [self setupViewControllers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupViewControllers{
    
    self.mainMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuTableViewController"];
    [self addChildViewController:self.mainMenuViewController];
    [self.sideNavView addSubview:self.mainMenuViewController.view];
    self.mainMenuViewController.view.frame = self.sideNavView.bounds;
    
    self.ipadMeasurementTablesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IpadMeasurementTablesViewController"];
    [self addChildViewController:self.ipadMeasurementTablesViewController];
    [self.tablesContainerView addSubview:self.ipadMeasurementTablesViewController.view];
    self.ipadMeasurementTablesViewController.view.frame = self.tablesContainerView.bounds;
    self.ipadMeasurementTablesViewController.parentViewController = self;
    self.tablesContainerViewOriginalFrame = self.tablesContainerView.frame;
    
    self.ipadRecentValuesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IpadRecentValuesViewController"];
    [self addChildViewController:self.ipadRecentValuesViewController];
    [self.recentValuesView addSubview:self.ipadRecentValuesViewController.view];
    self.recentValuesView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellStripedBackground"]];
    self.recentValuesView.layer.cornerRadius = 7;
    self.recentValuesView.layer.masksToBounds = YES;
    
    self.tablesContainerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellStripedBackground"]];
    self.tablesContainerView.layer.cornerRadius = 7;
    self.tablesContainerView.layer.masksToBounds = YES;
    
    self.graphContainerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellStripedBackground"]];
    self.graphContainerView.layer.cornerRadius = 7;
    self.graphContainerView.layer.masksToBounds = YES;
    self.graphContainerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.graphContainerView.layer.shadowOffset = CGSizeMake(10, 10);
    
}

- (IBAction)showHideSideNavView:(id)sender {
    
    if ([self isShowingSideNavView]) {
        
        [UIView animateWithDuration:.5 animations:^{
            
            self.mainContainerView.frame = self.view.bounds;
            
        } completion:^(BOOL finished) {
            

            
        }];
        
        
    }else{
        [UIView animateWithDuration:.5 animations:^{
            
            
            CGRect frame = self.view.bounds;
            frame.origin.x = self.sideNavView.bounds.size.width;
            self.mainContainerView.frame = frame;
            
        } completion:^(BOOL finished) {
        
        }];
    }
    
}

-(BOOL)isShowingSideNavView{
    
    
    if (self.mainContainerView.frame.origin.x > 0) {
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

-(void)toggleViewControllerFullScreen:(UIViewController*)viewController
{
    if ([viewController view].frame.size.height == self.mainContainerView.frame.size.height) {
        
        [UIView animateWithDuration:.5 animations:^{
            
            if (viewController == self.ipadMeasurementTablesViewController) {
                
                [viewController.view superview].frame = self.tablesContainerViewOriginalFrame;

            }
            
        }];
        
    }else{
        
        [UIView animateWithDuration:.5 animations:^{
            [self.mainContainerView bringSubviewToFront:viewController.view.superview];
               [viewController.view superview].frame = self.view.bounds;
            
        }];
        
    }
}

- (void)viewDidUnload {
    [self setRecentValuesView:nil];
    [self setGraphContainerView:nil];
    [super viewDidUnload];
}
@end
