//
//  MainMenuTableViewControllerIpad.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/9/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "IpadMainMenuTableViewController.h"
#import "MapSearchViewController.h"

@interface IpadMainMenuTableViewController ()
@property (strong,nonatomic) UIPopoverController* mapPopover;
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
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    CGRect cellRect = [cell convertRect:cell.frame toView:self.tableView];
    if (indexPath.section == SECTION_SEARCH) {
        switch (indexPath.row) {
            case ROW_MAP_SEARCH:{
                
                if (!self.mapPopover) {
                    MapSearchViewController* mapSearchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapSearchViewController"];
                    self.mapPopover = [[UIPopoverController alloc] initWithContentViewController:mapSearchViewController];
                }
                
                [self.mapPopover presentPopoverFromRect:cellRect inView:self.tableView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                
            }
              //  [self performSegueWithIdentifier:@"MapSearchViewController" sender:nil];
                break;
                
            default:
                break;
        }
    }
}
@end
