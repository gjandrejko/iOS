//
//  MainMenuTableViewControllerIpad.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/9/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "IpadMainMenuTableViewController.h"
#import "MapSearchViewController.h"
#import "GaugeSiteSearchProtocol.h"
#import "SiteNameSearchPFQueryTableViewController.h"
@interface IpadMainMenuTableViewController () <GaugeSiteSearchProtocol>
@property (strong,nonatomic) UIPopoverController* mainMenuPopoverController;
@end

@implementation IpadMainMenuTableViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.mainMenuPopoverController.isPopoverVisible) {
        
    
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    CGRect cellRect = [cell convertRect:cell.frame toView:self.tableView];
    if (indexPath.section == SECTION_SEARCH) {
        switch (indexPath.row) {
            case ROW_MAP_SEARCH:{
                
                MapSearchViewController* mapSearchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapSearchViewController"];
                    mapSearchViewController.delegate = self;
                self.mainMenuPopoverController = [[UIPopoverController alloc] initWithContentViewController:mapSearchViewController];
                
                
                [self.mainMenuPopoverController presentPopoverFromRect:cellRect inView:self.tableView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                
            }break;
            case ROW_NAME_SEARCH:{
                
                SiteNameSearchPFQueryTableViewController* siteNameSearchController = [self.storyboard instantiateViewControllerWithIdentifier:@"SiteNameSearchController"];
                siteNameSearchController.delegate = self;
                self.mainMenuPopoverController = [[UIPopoverController alloc] initWithContentViewController:siteNameSearchController];
                
                
                [self.mainMenuPopoverController presentPopoverFromRect:cellRect inView:self.tableView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                
            }
                        default:
                break;
        }
    }else if (indexPath.section == SECTION_FAVORITES){
        GaugeSite* gaugeSite = self.favoritesGaugeSites[indexPath.row];
        self.ipadParentViewController.gaugeSite = gaugeSite;

    }
        
    }
}

-(void)viewController:(UIViewController *)viewController didSelectGaugeSite:(GaugeSite *)gaugeSite{
    
    [self.mainMenuPopoverController dismissPopoverAnimated:YES];
    self.ipadParentViewController.gaugeSite = gaugeSite;
    
}
@end
