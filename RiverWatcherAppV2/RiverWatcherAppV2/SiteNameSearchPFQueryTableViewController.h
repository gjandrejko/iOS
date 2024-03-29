//
//  SiteNameSearchPFQueryTableViewController.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/9/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

//#import "PFQueryTableViewController.h"
#import "GaugeSiteSearchProtocol.h"
@interface SiteNameSearchPFQueryTableViewController : PFQueryTableViewController

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak,nonatomic) id<GaugeSiteSearchProtocol> delegate;
@end
