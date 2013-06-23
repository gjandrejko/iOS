//
//  MainMenuTableViewController.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "MainMenuTableViewController.h"
#import "FavoritesManager.h"
#import "RiverWatcherTableViewCell.h"
#import "RiverWatcherDefaultCell.h"
#import "GaugeSite.h"
#import "GaugeSiteIPhoneTableViewController.h"
#import "USGSWebServices.h"
#import "FavoriteMeasurement.h"
#import "FavoriteTableViewCell.h"

@interface MainMenuTableViewController ()
@property (strong,nonatomic) FavoritesManager* favoritesManager;
@property (strong,nonatomic) NSDictionary* favoriteMeausrements;

@end

@implementation MainMenuTableViewController


-(void)updateFavoriteMeasurements{
    self.favoriteMeausrements = nil;
    USGSWebServices* usgsWebService = [[USGSWebServices alloc] init];
    [usgsWebService downloadLatestMeasurementsFoGaugeSites:self.favoritesGaugeSites Completion:^(NSDictionary *measurementDictionaryWithUsgsIdKeys, NSError *error) {
        
        self.favoriteMeausrements = measurementDictionaryWithUsgsIdKeys;
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor =  [UIColor whiteColor];
    //[self styleNavigationBarWithFontName:@"AvenirNext-Bold"];
    self.tableView.separatorColor = [UIColor colorWithRed:0.820 green:0.859 blue:0.941 alpha:1];
    self.favoritesManager = [FavoritesManager sharedManager];
    self.favoritesGaugeSites = [self.favoritesManager favoriteGaugeSites];
    [self updateFavoriteMeasurements];
}


-(void)styleNavigationBarWithFontName:(NSString*)navigationTitleFont{
    
    
    CGSize size = CGSizeMake(320, 44);
    UIColor* color = [UIColor colorWithRed:65.0/255 green:75.0/255 blue:89.0/255 alpha:1.0];
    
    UIGraphicsBeginImageContext(size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGRect fillRect = CGRectMake(0,0,size.width,size.height);
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    CGContextFillRect(currentContext, fillRect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    UINavigationBar* navAppearance = [UINavigationBar appearance];
    
    [navAppearance setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [navAppearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIColor whiteColor], UITextAttributeTextColor,
                                           [UIFont fontWithName:navigationTitleFont size:18.0f], UITextAttributeFont,
                                           nil]];
    /*
    UIImageView* searchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search.png"]];
    searchView.frame = CGRectMake(0, 0, 20, 20);
  
    
    UIBarButtonItem* searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchView];
    
    self.navigationItem.rightBarButtonItem = searchItem;
    
    
    UIImageView* menuView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu.png"]];
    menuView.frame = CGRectMake(0, 0, 28, 20);
    
    UIBarButtonItem* menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuView];
    
    self.navigationItem.leftBarButtonItem = menuItem;
     */
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 24)];
    UILabel* label = [[UILabel alloc] init];
    label.frame = CGRectInset(view.bounds, 10, 0);
    [view addSubview:label];
    label.textColor = [UIColor whiteColor]; 
    view.backgroundColor = [UIColor colorWithRed:0.133 green:0.165 blue:0.263 alpha:1];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"AvenirNext-Bold" size:15];
    label.text = [self tableView:self.tableView titleForHeaderInSection:section];
    return view;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
    
    if (section == SECTION_FAVORITES) {
        return 24;
    }else{
        return 0;
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self.favoritesGaugeSites count] != [[self.favoritesManager favoriteGaugeSites] count]) {
        self.favoritesGaugeSites = [self.favoritesManager favoriteGaugeSites];
        [self updateFavoriteMeasurements];
        [self.tableView reloadData];

    }
    
}

#pragma mark - Table view data source

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString* title;
    
    if (section == SECTION_SEARCH) {
        
        //title =  @"Find A River";
        
    }else if (section == SECTION_FAVORITES){
        
        title =  @"Favorites";
    }
    
    return title;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2; //Search And Favorites
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == SECTION_SEARCH) {
        return 70;

    }else if (indexPath.section == SECTION_FAVORITES){
        return 90;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    
    if (section == SECTION_SEARCH) {
        
        numberOfRows =  3;
    }else if (section == SECTION_FAVORITES){
        
        numberOfRows = [[self.favoritesManager favoriteGaugeSites] count];
        
        if (numberOfRows == 0) {
            numberOfRows = 1; //There is a default cell for favorites
        }
    }

    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        if (indexPath.section == SECTION_SEARCH) {
           // UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
        
            static NSString* cellIdentifier = @"RiverWatcherDefaultCell";
            RiverWatcherDefaultCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (!cell) {
                cell = [[RiverWatcherDefaultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
              
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            switch (indexPath.row) {
                case ROW_MAP_SEARCH:{
                    cell.titleLabel.text = @"On Map";
                    cell.icon.image = [UIImage imageNamed:@"map"];
                }break;
                case ROW_NAME_SEARCH:{
                    cell.titleLabel.text = @"By Name";
                    cell.icon.image = [UIImage imageNamed:@"magnifiy"];

                }break;
                case ROW_STATE_SEARCH:{
                    cell.titleLabel.text = @"By State";
                    cell.icon.image = [UIImage imageNamed:@"statePA"];

                }break;
                default:
                    break;
            }
            CGRect textLabelFrame = cell.textLabel.frame;
            textLabelFrame.origin.x = 200;
            cell.textLabel.frame = textLabelFrame;
            cell.contentView.backgroundColor= [UIColor whiteColor];

            //cell.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellStripedBackground"]];

            return cell;
            
        }else if (indexPath.section == SECTION_FAVORITES){
            
            if ([[self.favoritesManager favoriteGaugeSites] count] > 0) { //User Has Favorites
                
                static NSString* cellIdentifier = @"FavoriteTableViewCell";

                FavoriteTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                if (!cell) {
                    cell = [[FavoriteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                
                
                GaugeSite* gaugeSite = self.favoritesGaugeSites[indexPath.row];
                FavoriteMeasurement* favovriteMeasurement = [self.favoriteMeausrements objectForKey:gaugeSite.usgsId];

                if (!self.favoriteMeausrements) {
                    [cell setUpLoadingCellForGaugeSite:gaugeSite];
                }else{
                    [cell setUpCellForGaugeSite:gaugeSite FavoriteMeasurement:favovriteMeasurement];
                }
                

                cell.contentView.backgroundColor= [UIColor whiteColor];
                
              //  cell.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellStripedBackground"]];

                return cell;
                
            }else{ //No Favorites
                
                static NSString* cellIdentifier = @"FavoritesDefaultCell";

                UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                
                cell.textLabel.text = @"No Favorites Added Yet";
                cell.textLabel.textColor = [UIColor lightGrayColor];
                return cell;
            }

            
        }else{
            return nil;
        }
    
}



/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SECTION_SEARCH) {
        switch (indexPath.row) {
            case ROW_MAP_SEARCH:
                [self performSegueWithIdentifier:@"MapSearchViewController" sender:nil];
                break;
            case ROW_NAME_SEARCH:
                [self performSegueWithIdentifier:@"SiteNameSearchPFQueryTableViewController" sender:nil];
                break;
            

                
            default:
                break;
        }
    }else if (indexPath.section == SECTION_FAVORITES) {
        GaugeSite* gaugeSite = self.favoritesGaugeSites[indexPath.row];
        [self performSegueWithIdentifier:@"MainMenuToSummary" sender:gaugeSite];
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"MainMenuToSummary"]) {
        
        GaugeSiteIPhoneTableViewController* gaugeSiteSummaryViewController = segue.destinationViewController;
        gaugeSiteSummaryViewController.gaugeSite = sender;
    }
}

@end
