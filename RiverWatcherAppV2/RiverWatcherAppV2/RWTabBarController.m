//
//  RWTabBarController.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 6/23/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "RWTabBarController.h"
#import "UIView+Origami.h"
#import "UITabBar+FlatUI.h"
#import "UIColor+FlatUI.h"

@interface RWTabBarController ()

@end

@implementation RWTabBarController


-(void)setGaugeSite:(GaugeSite *)gaugeSite{
    

    _gaugeSite = gaugeSite;
    self.measurementDownloadManager = [[MeasurementDownloadManager alloc] init];
    [self.measurementDownloadManager fetchDataForGaugeSite:_gaugeSite WithCompletion:nil];
    
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
   // [self.tabBar configureFlatTabBarWithColor:[UIColor peterRiverColor]  selectedColor:[UIColor clearColor]];
    for (UIViewController* viewController in self.viewControllers) {
        
        if ([viewController respondsToSelector:@selector(setMeasurementDownloadManager:)]) {
            [(id)viewController setMeasurementDownloadManager:self.measurementDownloadManager];
        }
    }
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
