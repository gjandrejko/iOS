//
//  SiteNameSearchPFQueryTableViewController.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/9/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "SiteNameSearchPFQueryTableViewController.h"
#import "GaugeSite.h"
#import "GaugeSiteIPhoneTableViewController.h"

@interface SiteNameSearchPFQueryTableViewController () <UISearchBarDelegate>
@property (strong,nonatomic) UIFont* fontForCell;
@property (nonatomic) CGFloat cellContentWidth;
@property (nonatomic) CGFloat cellContentMargin;
@property (nonatomic) CGFloat minimumHeight;

@end

@implementation SiteNameSearchPFQueryTableViewController

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
   // self.className = kGaugeSiteParseClassName;
    self.textKey = kGaugeSiteParseSiteNameKey;
    self.pullToRefreshEnabled = NO;
    self.objectsPerPage = 100;
    //self.paginationEnabled = NO;
    self.fontForCell = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];

    
    self.cellContentWidth = self.tableView.bounds.size.width;
    self.cellContentMargin = 5;
    self.minimumHeight = 32;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PFQuery *)queryForTable
{
    PFQuery* query = [PFQuery queryWithClassName:kGaugeSiteParseClassName];
    [query orderByAscending:kGaugeSiteParseSiteNameKey];
    
    if ([self.searchBar.text length] > 0) {

        
        [query whereKey:kGaugeSiteParseSiteNameKey containsString:[self.searchBar.text uppercaseString]];

        
     
    }
    
    return query;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row < [self.objects count]) {
        GaugeSite* gaugeSite = [GaugeSite gaugeSiteWithPFObject:self.objects[indexPath.row]];
        
        
        
        CGSize constraint = CGSizeMake(self.cellContentWidth - (self.cellContentMargin * 2), 20000.0f);
        
        CGSize size = [gaugeSite.siteName sizeWithFont:self.fontForCell constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        ;
        return size.height + (self.cellContentMargin * 2);
        

    }else{
        return [super tableView:self.tableView heightForRowAtIndexPath:indexPath];
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.row < [self.objects count]) {

    
    UITableViewCell *cell;
    UILabel *label = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setLineBreakMode:UILineBreakModeWordWrap];
        label.textColor = [UIColor colorWithRed: 0 green: 0.33 blue: 0.57 alpha: 1]; //Ocean
        [label setNumberOfLines:0];
        [label setFont:self.fontForCell];
        [label setTag:1];
        label.backgroundColor = [UIColor clearColor];
        [[cell contentView] addSubview:label];
    }

    GaugeSite* gaugeSite = [GaugeSite gaugeSiteWithPFObject:self.objects[indexPath.row]];

    
    CGSize constraint = CGSizeMake(self.cellContentWidth - (self.cellContentMargin * 2), 20000.0f);
    
    CGSize size = [gaugeSite.siteName sizeWithFont:self.fontForCell constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    if (!label)
        label = (UILabel*)[cell viewWithTag:1];
    
    [label setText:gaugeSite.siteName];
    [label setFrame:CGRectMake(self.cellContentMargin, self.cellContentMargin, self.cellContentWidth - (self.cellContentMargin * 2), size.height)];
     //   cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellStripedBackground"]];
    return cell;
    }else{
        return [super tableView:self.tableView cellForRowAtIndexPath:indexPath];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    GaugeSiteIPhoneTableViewController* gaugeSiteSummaryController = segue.destinationViewController;
    gaugeSiteSummaryController.gaugeSite = sender;
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self loadObjects];
    [self.searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self loadObjects];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < [self.objects count]) {
        GaugeSite* gaugeSite = [GaugeSite gaugeSiteWithPFObject:self.objects[indexPath.row]];
        [self performSegueWithIdentifier:@"SearchToSummary" sender:gaugeSite];
    }else{
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }


    
}
@end
