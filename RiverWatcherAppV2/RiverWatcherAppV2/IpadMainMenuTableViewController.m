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
#import "FavoritesManager.h"
#import "UIColor+FlatUI.h"
#import "UIColor+MLPFlatColors.h"
#import "RWTabBarController.h"
#import "MPColorTools.h"
#import <QuartzCore/QuartzCore.h>
@interface IpadMainMenuTableViewController () <GaugeSiteSearchProtocol>
@property (strong,nonatomic) UIPopoverController* mainMenuPopoverController;
@property (strong,nonatomic) MapSearchViewController* mapSearchViewController;
@property (strong,nonatomic) UINavigationController* siteNameSearchNavigationController;
@end

@implementation IpadMainMenuTableViewController


-(MapSearchViewController*)mapSearchViewController{
    
    if(!_mapSearchViewController){
        
        _mapSearchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapSearchViewController"];
        _mapSearchViewController.delegate = self;
    }

    return _mapSearchViewController;
}


-(UINavigationController*)siteNameSearchNavigationController{
    
    if (!_siteNameSearchNavigationController) {
        _siteNameSearchNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"SiteNameSearchController"] ;
        ((SiteNameSearchPFQueryTableViewController*)[_siteNameSearchNavigationController topViewController]).delegate = self;
    }
    
    return _siteNameSearchNavigationController;
    
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
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor ipadMainMenuCellColor];
    
    self.tableView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.tableView.layer.shadowOffset = CGSizeMake(2, 1);
    self.tableView.layer.shadowOpacity = .7;
    self.tableView.layer.shadowRadius = 3;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFavoritesModification) name:FavoritesManagerWasModifiedNotification object:nil];
}

-(void)handleFavoritesModification{
    
    [self updateFavoriteMeasurements];

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    static BOOL firstCall = YES;
    
    if (firstCall) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:ROW_NAME_SEARCH inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        self.rwSplitViewController.rwDetailViewController = self.siteNameSearchNavigationController;
        firstCall = NO;
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor =[UIColor ipadMainMenuCellColor];
    
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor =  [cell.contentView.backgroundColor colorByAddingLightness:.10];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == SECTION_SEARCH) {
        return 50;
        
    }else if (indexPath.section == SECTION_FAVORITES){
        return 90;
    }else{
        return 0;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    if (indexPath.section == SECTION_SEARCH) {
        switch (indexPath.row) {
            case ROW_MAP_SEARCH:{
                
                self.rwSplitViewController.rwDetailViewController = self.mapSearchViewController;

            }break;
            case ROW_NAME_SEARCH:{
                
     
                
                self.rwSplitViewController.rwDetailViewController = self.siteNameSearchNavigationController;
            }break;
                        default:
                break;
        }
    }else if (indexPath.section == SECTION_FAVORITES){
        GaugeSite* gaugeSite = self.favoritesGaugeSites[indexPath.row];        
        RWTabBarController* rwTabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"RWTabBarController"];
        rwTabBarController.gaugeSite = gaugeSite;
        self.rwSplitViewController.rwDetailViewController = rwTabBarController;


    }
        
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"FIND A RIVER";
            break;
        case 1:
            return @"FAVORITES";
            break;
        default:
            return nil;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }else{
        return 23;
    }
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CGFloat viewHeight = [self tableView:tableView heightForHeaderInSection:section];
    
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, viewHeight)];
    headerView.backgroundColor = [UIColor ipadMainMenuSectionColor];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectInset(headerView.bounds, 10, 0)];
    label.textColor = [UIColor cloudsColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:17];
    [headerView addSubview:label];
    return headerView;
}



-(void)viewController:(UIViewController *)viewController didSelectGaugeSite:(GaugeSite *)gaugeSite{
    
    [self.tableView selectRowAtIndexPath:nil animated:YES scrollPosition:UITableViewScrollPositionNone];
    RWTabBarController* rwTabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"RWTabBarController"];
    rwTabBarController.gaugeSite = gaugeSite;
    self.rwSplitViewController.rwDetailViewController = rwTabBarController;
    self.ipadParentViewController.gaugeSite = gaugeSite;
    
}
@end
