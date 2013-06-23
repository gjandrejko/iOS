//
//  MasterIpadViewController.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 3/2/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "IpadParentViewController.h"
#import "IpadMainMenuTableViewController.h"
#import "IpadMeasurementTablesViewController.h"
#import "IpadRecentValuesViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FavoritesManager.h"
#import "USGSMeasurementData.h"
#import "NOAAMeasurementData.h"
#import "NOAAWebServices.h"
#import "USGSWebServices.h"
#import "LoadingView.h"
#import "LineGraphViewController.h"
#import "IpadRecentValuesTableViewController.h"

@interface IpadParentViewController ()
@property (strong,nonatomic)  IpadMainMenuTableViewController* mainMenuViewController;
@property (strong,nonatomic)  IpadMeasurementTablesViewController* ipadMeasurementTablesViewController;
@property (strong,nonatomic)  IpadRecentValuesTableViewController* ipadRecentValuesTableViewController;
@property (strong,nonatomic)  NOAAMeasurementData* noaaMeasurementData;
@property (strong,nonatomic) NOAAWebServices* noaaWebServices;
@property (strong,nonatomic) USGSWebServices* usgsWebsServices;

@property (strong,nonatomic) LineGraphViewController* lineGraphViewController;

@property (strong,nonatomic)  USGSMeasurementData* usgsMeasurementData;
@property (nonatomic) NSInteger numberOfWebservicesDownloaded;
@property (nonatomic) NSInteger numberOfWebservicesFailed;
@property (strong,nonatomic) LoadingView* loadingView;
@property (nonatomic) CGRect tablesContainerViewOriginalFrame;
@property (nonatomic) CGRect graphContainerViewOriginalFrame;


@end

@implementation IpadParentViewController


#pragma mark Setters

-(void)setNumberOfWebservicesDownloaded:(NSInteger)numberOfWebservicesDownloaded{
    
    if (_numberOfWebservicesDownloaded != numberOfWebservicesDownloaded) {
        _numberOfWebservicesDownloaded = numberOfWebservicesDownloaded;
        [self checkWebServiceStatus];
    }
}

-(void)setNumberOfWebservicesFailed:(NSInteger)numberOfWebservicesFailed{
    if (_numberOfWebservicesFailed != numberOfWebservicesFailed) {
        _numberOfWebservicesFailed = numberOfWebservicesFailed;
        [self checkWebServiceStatus];

    }
}

-(void)checkWebServiceStatus{
    if (self.numberOfWebservicesDownloaded + self.numberOfWebservicesFailed >=2 ) {
        [self.ipadMeasurementTablesViewController setUSGSMeasurementData:self.usgsMeasurementData NOAAMeasurementData:self.noaaMeasurementData];
        [self.lineGraphViewController setUsgsMeasurementData:self.usgsMeasurementData NOAAMeasurementData:self.noaaMeasurementData];
        self.ipadRecentValuesTableViewController.usgsMeasurmentData = self.usgsMeasurementData;
        [self dismissLoadingView];
    }
}

-(void)setGaugeSite:(GaugeSite *)gaugeSite{
    
    //Don't check for equality. This will cause parent controller to refresh views
    //if gauge sites are the same. This is the desired functionality.
    
    _gaugeSite = gaugeSite;
    self.titleLabel.text = gaugeSite.siteName;
    [self configureFavoritesButton];
    //This will always hide the side menu view since the  menu had to be showing for
    //a gauge site to be selected
    [self showHideSideNavView:nil];
    [self downloadGaugeSiteData];
    
}

#pragma mark Lifecycle / Rotation

- (void)viewDidLoad
{
    [super viewDidLoad];

   // [self setupViewControllers];
}

-(void)presentLoadingView{
    
    //Set below toolbar
    CGRect loadingViewFrame = self.mainContainerView.bounds;
    loadingViewFrame.origin.y = 44;
    loadingViewFrame.size.height -= 44;
    self.loadingView = [[LoadingView alloc] initWithFrame:loadingViewFrame];
    self.loadingView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellStripedDarkBackground"]];
    self.loadingView.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.loadingView.downloadingLabel.textColor = [UIColor whiteColor];
    self.loadingView.downloadingLabel.shadowColor = [UIColor lightGrayColor];
    self.loadingView.downloadingLabel.shadowOffset = CGSizeMake(0, -0.5);
    
    
    //In case it was already added, remove it.
    [self.mainContainerView addSubview:self.loadingView];
    [self.mainContainerView bringSubviewToFront:self.loadingView];
}

-(void)dismissLoadingView{
    [UIView animateWithDuration:1 animations:^{
        self.loadingView.alpha = 0;

    } completion:^(BOOL finished) {
        [self.loadingView removeFromSuperview];

        self.loadingView.alpha = 1;

    }];
}



- (void)viewDidUnload {
    [self setRecentValuesView:nil];
    [self setGraphContainerView:nil];
    [self setTitleLabel:nil];
    [self setFavoriteBarButton:nil];
    [super viewDidUnload];
}

#pragma Webservice Methods

-(void)downloadGaugeSiteData{
    
    self.numberOfWebservicesDownloaded = 0;
    self.numberOfWebservicesFailed = 0;
    [self presentLoadingView];
    [self downloadUsgsData];
    [self downloadNoaaData];
    
}


-(void)downloadUsgsData
{
   self.usgsWebsServices = [[USGSWebServices alloc] init];

    [self.usgsWebsServices  downloadMeasurementsForSiteId:self.gaugeSite.usgsId NumberOfDays:30 Completion:^(USGSMeasurementData *usgsMeasurementData, NSError* error) {
        
        
        if (error  ) {
            self.numberOfWebservicesFailed++;
        }else{
                        
            self.usgsMeasurementData = usgsMeasurementData;
            self.numberOfWebservicesDownloaded++;

        }
        
    }];
}

-(void)downloadNoaaData
{
    self.noaaWebServices = [[NOAAWebServices alloc] init];
    [self.noaaWebServices downloadMeasurementsForSiteId:self.gaugeSite.nwsId Completion:^(NOAAMeasurementData *noaaMeasurementData, NSError *error) {
        NSLog(@"NOAA COMPLETION");
        if (error) {
            self.numberOfWebservicesFailed++;
            
        }else{

            self.noaaMeasurementData = noaaMeasurementData;
            self.numberOfWebservicesDownloaded++;
            
        }
        
    }];
    self.noaaWebServices = nil;
}




-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}




#pragma mark Target Actions

- (IBAction)addRemoveFavorite:(id)sender {
    
    //Prevents sending an empty gauge site into favorites
    if (self.gaugeSite) {
        
    
    if ([[FavoritesManager sharedManager] gaugeSiteExistsInFavorites:self.gaugeSite]) {
        [[FavoritesManager sharedManager] deleteFavoriteGaugeSite:self.gaugeSite];
    }else{
        [[FavoritesManager sharedManager] addFavoriteGaugeSite:self.gaugeSite];
        
    }
    
    //Update data and refresh UI in the menu pane to reflect modifications in favorites
    self.mainMenuViewController.favoritesGaugeSites = [FavoritesManager sharedManager].favoriteGaugeSites;
    [self.mainMenuViewController.tableView reloadData];
    [self.mainMenuViewController updateFavoriteMeasurements];
        [self configureFavoritesButton];
    }
}

-(void)configureFavoritesButton{
    if ([[FavoritesManager sharedManager] gaugeSiteExistsInFavorites:self.gaugeSite]) {
        self.favoriteBarButton.image = [UIImage imageNamed:@"28-star"];
    }else{
        self.favoriteBarButton.image = [UIImage imageNamed:@"starEmpty"];

    }
}

- (IBAction)showHideSideNavView:(id)sender {
    
    if ([self isShowingSideNavView]) {
        
        //Animate dismiss the left menu
        [UIView animateWithDuration:.5 animations:^{
            
            self.mainContainerView.frame = self.view.bounds;
            
        }];        
        
    }else{
        //Animate present the left menu
        [UIView animateWithDuration:.5 animations:^{
    
            
            CGRect frame = self.view.bounds;
            frame.origin.x = self.sideNavView.bounds.size.width;
            self.mainContainerView.frame = frame;
            
        } ];
    }
    
}

#pragma mark Other Methods


- (void)setupViewControllers
{
  
    self.mainMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuTableViewController"];
    [self addChildViewController:self.mainMenuViewController];
    self.mainMenuViewController.ipadParentViewController = self;
    [self.sideNavView addSubview:self.mainMenuViewController.view];
    CGRect sideNavFrame = self.sideNavView.bounds;
    sideNavFrame.size.width--;
    self.sideNavView.backgroundColor = [UIColor blackColor];
    self.mainMenuViewController.view.frame = sideNavFrame;
 
    self.ipadMeasurementTablesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IpadMeasurementTablesViewController"];
    [self addChildViewController:self.ipadMeasurementTablesViewController];
    [self.tablesContainerView addSubview:self.ipadMeasurementTablesViewController.view];
    self.ipadMeasurementTablesViewController.view.frame = CGRectInset(self.tablesContainerView.bounds, 1,1 );
    self.ipadMeasurementTablesViewController.parentViewController = self;
    //  self.tablesContainerViewOriginalFrame = CGRectInset(self.tablesContainerView.bounds, 2,2 );
    
    
    self.ipadRecentValuesTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IpadRecentValuesTableViewController"];
    [self addChildViewController:self.ipadRecentValuesTableViewController];
    [self.recentValuesView addSubview:self.ipadRecentValuesTableViewController.tableView];
    self.ipadRecentValuesTableViewController.tableView.frame = CGRectInset(self.recentValuesView.bounds, 1,1 );
    self.recentValuesView.clipsToBounds =YES;


    
    self.lineGraphViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LineGraphViewController"];
    [self addChildViewController:self.lineGraphViewController];
    self.lineGraphViewController.view.frame = CGRectInset(self.graphContainerView.bounds, 1,1 );
    [self.graphContainerView addSubview:self.lineGraphViewController.view];
    self.lineGraphViewController.ipadParentViewController = self;

    
    
    self.graphContainerView.backgroundColor = [UIColor colorWithRed:0.114 green:0.298 blue:0.376 alpha:1];
    self.recentValuesView.backgroundColor = [UIColor colorWithRed:0.282 green:0.655 blue:0.816 alpha:1];
}

- (void)toggleViewControllerFullScreen:(UIViewController*)viewController
{
    return;
    if ([viewController view].frame.size.height == self.mainContainerView.frame.size.height) {
        
        [UIView animateWithDuration:.5 animations:^{
            
            if (viewController == self.ipadMeasurementTablesViewController) {
                
                [viewController.view superview].frame = self.tablesContainerViewOriginalFrame;
                
            }else if (viewController == self.lineGraphViewController){
                [viewController.view superview].frame = self.graphContainerViewOriginalFrame;

            }
            
        }];
        
    }else{
        
        [UIView animateWithDuration:.5 animations:^{
            [self.mainContainerView bringSubviewToFront:viewController.view.superview];
            [viewController.view superview].frame = self.view.bounds;
            
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

@end
