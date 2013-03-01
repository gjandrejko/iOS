//
//  GaugeSiteIPhoneTableViewController.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GaugeSite.h"

@interface GaugeSiteIPhoneTableViewController : UITableViewController
@property (strong,nonatomic) GaugeSite* gaugeSite;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *favoritesButton;
- (IBAction)addOrDeleteFavorite:(UIBarButtonItem *)sender;
@end
