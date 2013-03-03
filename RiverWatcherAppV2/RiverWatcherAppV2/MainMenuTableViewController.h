//
//  MainMenuTableViewController.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#define ROW_STATE_SEARCH 0
#define ROW_MAP_SEARCH 1
#define ROW_NAME_SEARCH 2

#define SECTION_SEARCH 0
#define SECTION_FAVORITES 1

#import <UIKit/UIKit.h>

@interface MainMenuTableViewController : UITableViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@property (strong,nonatomic) NSArray* favoritesGaugeSites;
-(void)updateFavoriteMeasurements;
@end
