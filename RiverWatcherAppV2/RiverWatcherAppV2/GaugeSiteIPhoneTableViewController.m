//
//  GaugeSiteIPhoneTableViewController.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "GaugeSiteIPhoneTableViewController.h"
#import "USGSWebServices.h"
#import "USGSMeasurement.h"
#import "NOAAWebServices.h"
#import "LoadingView.h"
#import "NOAASignificantItem.h"
#import "LatestMeasurementCell.h"
#import "GraphViewController.h"
#import "FavoritesManager.h"
#import "USGSLineGraphViewController.h"
#define SECTION_SIGNIFICANT_DATA @"Major Stages/Flows"
#define SECTION_MOST_RECENT_MEASUREMENTS @"Latests"

#define SECTION_LATEST 0
#define SECTION_USGS 1
#define SECTION_NOAA 2

#define ROW_GRAPHS 0
#define ROW_TABLES 1
#define ROW_FLOOD 2



#define TITLE_TABLE_FLOOD_STAGES @"Flood Stages"
#define TITLE_TABLE_HEIGHT @"Gauge Height"
#define TITLE_TABLE_DISHCARGE @"Discharge"
#define TITLE_TABLE_TEMPERATURE @"Temperature"
#define TITLE_TABLE_NOAA @"NWS Forecast"

#define TITLE_GRAPH_NOAA @"NWS Forecast"
#define TITLE_GRAPH_TEMPERATURE @"Temperature"
#define TITLE_GRAPH_DISCHARGE  @"Discharge"
#define TITLE_GRAPH_HEIGHT  @"Gauge Height"

#define TITLE_RECENT_HEIGHT @"Gauge Height"
#define TITLE_RECENT_TEMPERATURE @"Temperature"
#define TITLE_RECENT_DISCHARGE @"Discharge"

#define KEY_CELL_TITLE @"CellTitle"

@interface TableSection : NSObject
+ (TableSection*)tableSectionWithName:(NSString*)name Order:(NSInteger)order;
@property (strong,nonatomic) NSString* name;
@property (strong,nonatomic) NSNumber* order;
@end


@implementation TableSection

+ (TableSection*)tableSectionWithName:(NSString*)name Order:(NSInteger)order
{
    TableSection* tableSection = [[TableSection alloc] init];
    tableSection.name = name;
    tableSection.order = [NSNumber numberWithInt:order];
    return tableSection;
}


@end

@interface GaugeSiteIPhoneTableViewController ()
@property (strong,nonatomic) NOAAWebServices* noaaWebServices;
@property (strong,nonatomic) NOAAMeasurementData* noaaMeasurementData;
@property (strong,nonatomic) USGSMeasurementData* usgsMeasurementData;
@property (strong,nonatomic) NSMutableArray* latestMeasurementDictionaries;
@property (strong,nonatomic) NSMutableArray* graphCellDictionaries;
@property (strong,nonatomic) NSMutableArray* tableCellDictionaries;
@property (strong,nonatomic) LoadingView* loadingView;


@property (strong,nonatomic) NSMutableArray* tableSections;
@property (nonatomic) NSInteger numberOfWebservicesLoaded;
@property (strong,nonatomic) NSDate* latestMeasurementDate;
@end

@implementation GaugeSiteIPhoneTableViewController


-(void)setupGraphAndTableSections{
    
    self.graphCellDictionaries = [NSMutableArray array];
    self.tableCellDictionaries = [NSMutableArray array];

    
    if ([self.usgsMeasurementData.heightMeasurements count] > 0) {
        
        NSDictionary* graphDictionary = [NSDictionary dictionaryWithObject:TITLE_GRAPH_HEIGHT forKey:KEY_CELL_TITLE];
        NSDictionary* tableDictionary = [NSDictionary dictionaryWithObject:TITLE_TABLE_HEIGHT forKey:KEY_CELL_TITLE];
        [self.graphCellDictionaries addObject:graphDictionary];
        [self.tableCellDictionaries addObject:tableDictionary];

    }
    
    if ([self.usgsMeasurementData.dischargeMeasurements count] > 0) {
        
        NSDictionary* graphDictionary = [NSDictionary dictionaryWithObject:TITLE_GRAPH_DISCHARGE forKey:KEY_CELL_TITLE];
        NSDictionary* tableDictionary = [NSDictionary dictionaryWithObject:TITLE_TABLE_DISHCARGE forKey:KEY_CELL_TITLE];
        [self.graphCellDictionaries addObject:graphDictionary];
        [self.tableCellDictionaries addObject:tableDictionary];
        
    }
    
    if ([self.usgsMeasurementData.temperatureMeasurements count] > 0) {
        
        NSDictionary* graphDictionary = [NSDictionary dictionaryWithObject:TITLE_GRAPH_TEMPERATURE forKey:KEY_CELL_TITLE];
        NSDictionary* tableDictionary = [NSDictionary dictionaryWithObject:TITLE_TABLE_TEMPERATURE forKey:KEY_CELL_TITLE];
        [self.graphCellDictionaries addObject:graphDictionary];
        [self.tableCellDictionaries addObject:tableDictionary];
        
    }
    
    
    if ([self.noaaMeasurementData.forecastMeasurements count] > 0) {
        
        NSDictionary* graphDictionary = [NSDictionary dictionaryWithObject:TITLE_GRAPH_NOAA forKey:KEY_CELL_TITLE];
        NSDictionary* tableDictionary = [NSDictionary dictionaryWithObject:TITLE_TABLE_NOAA forKey:KEY_CELL_TITLE];
        [self.graphCellDictionaries addObject:graphDictionary];
        [self.tableCellDictionaries addObject:tableDictionary];
    }
    
    if ([self.noaaMeasurementData.significantData count] > 0) {
        
        NSDictionary* tableDictionary = [NSDictionary dictionaryWithObject:TITLE_TABLE_FLOOD_STAGES forKey:KEY_CELL_TITLE];
        
    }
    
}

-(void)setupLatestMeasurements
{
    self.latestMeasurementDictionaries = [NSMutableArray array];
    USGSMeasurement* heightMeasurement = [self.usgsMeasurementData.heightMeasurements lastObject];
    USGSMeasurement* tempMeasurement = [self.usgsMeasurementData.temperatureMeasurements lastObject];
    USGSMeasurement* dischargeMeasurement = [self.usgsMeasurementData.dischargeMeasurements lastObject];

    
    if (heightMeasurement) {
        NSString* measurementString = [NSString stringWithFormat:@"%g %@",heightMeasurement.value,heightMeasurement.units];
        NSDictionary* measurementDic = [NSDictionary dictionaryWithObject:measurementString forKey:TITLE_RECENT_HEIGHT];
        [self.latestMeasurementDictionaries addObject:measurementDic];
        self.latestMeasurementDate = heightMeasurement.date;
    }
    
    if (dischargeMeasurement) {
        NSString* measurementString = [NSString stringWithFormat:@"%g %@",dischargeMeasurement.value,dischargeMeasurement.units];
        NSDictionary* measurementDic = [NSDictionary dictionaryWithObject:measurementString forKey:TITLE_RECENT_DISCHARGE];
        [self.latestMeasurementDictionaries addObject:measurementDic];
        self.latestMeasurementDate = dischargeMeasurement.date;

    }
    
    if (tempMeasurement) {
        NSString* measurementString = [NSString stringWithFormat:@"%g %@",tempMeasurement.value,tempMeasurement.units];
        NSDictionary* measurementDic = [NSDictionary dictionaryWithObject:measurementString forKey:TITLE_RECENT_TEMPERATURE];
        [self.latestMeasurementDictionaries addObject:measurementDic];
        self.latestMeasurementDate = tempMeasurement.date;

    }
}

-(void)setNumberOfWebservicesLoaded:(NSInteger)numberOfWebservicesLoaded{
    _numberOfWebservicesLoaded = numberOfWebservicesLoaded;
    
    if (_numberOfWebservicesLoaded ==2 ) {
        
        [self setupLatestMeasurements];
        [self setupGraphAndTableSections];
        [self.loadingView removeFromSuperview];
        self.tableView.userInteractionEnabled = YES;
        [self.tableView reloadData];
    }
}



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIView*)viewForTableHeader{
    
    
    CGFloat horizontalInset = 60;
    CGFloat verticalInset = 10;

    UIFont* font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:19];
    CGFloat labelWidth = self.tableView.bounds.size.width - (horizontalInset * 2);
  //  UIColor* textColor = [UIColor colorWithRed:0.298 green:0.337 blue:0.424 alpha:1];
     UIColor* textColor = [UIColor colorWithRed:0 green:0.333 blue:.57 alpha:1];

    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    [label setNumberOfLines:0];
    [label setLineBreakMode:UILineBreakModeWordWrap];
    label.text = self.gaugeSite.siteName;
    CGSize constraint = CGSizeMake(labelWidth, 20000.0f);
    CGSize size = [label.text sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    label.frame = CGRectMake(horizontalInset, verticalInset, size.width, size.height);
    label.textColor = textColor;
    label.font = font;
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0, 1);
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    
    UIView* labelContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, label.bounds.size.height + (verticalInset*2))];
    labelContainerView.backgroundColor = [UIColor clearColor];
    [labelContainerView addSubview:label];
    return labelContainerView;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellStripedDarkBackground"]];
    
    
    self.loadingView = [[LoadingView alloc] initWithFrame:self.tableView.bounds];
    self.loadingView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellStripedDarkBackground"]];
    [self.tableView addSubview:self.loadingView];
    self.tableView.userInteractionEnabled = NO;
    
    if (!self.gaugeSite) {
        self.gaugeSite = [GaugeSite testSite];
    }
    
    self.tableView.tableHeaderView = [self viewForTableHeader];
    
    self.tableSections = [[NSMutableArray alloc] init];

    [USGSWebServices downloadMeasurementsForSiteId:self.gaugeSite.usgsId NumberOfDays:30 Completion:^(USGSMeasurementData *usgsMeasurementData, NSError* error) {
        
        
        TableSection* tableSection = [TableSection tableSectionWithName:SECTION_MOST_RECENT_MEASUREMENTS Order:0];
        [self.tableSections addObject:tableSection];

        self.usgsMeasurementData = usgsMeasurementData;
        self.numberOfWebservicesLoaded++;
        
        NSLog(@"Loaded USGS:%d",[usgsMeasurementData.heightMeasurements count]);
    }];
  
    self.noaaWebServices = [[NOAAWebServices alloc] init];
    
    [self.noaaWebServices downloadMeasurementsForSiteId:self.gaugeSite.nwsId Completion:^(NOAAMeasurementData *noaaMeasurementData, NSError *error) {
        
        self.noaaMeasurementData = noaaMeasurementData;
        
        if ([self.noaaMeasurementData.significantData count] > 0) {
            TableSection* tableSection = [TableSection tableSectionWithName:SECTION_SIGNIFICANT_DATA Order:1];
            [self.tableSections addObject:tableSection];
        }
        self.numberOfWebservicesLoaded++;
        NSLog(@"Loaded NOAA:%d",[noaaMeasurementData.noaaMeasurements count]);

    }];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString* title;

    switch (section) {
        case SECTION_NOAA:{
            if ([self.graphCellDictionaries count] > 0) {
                title = @"National Weather Service";

            }
        }break;
        case SECTION_USGS:{
            if ([self.tableCellDictionaries count] > 0) {
                title = @"USGS";
                
            }
        }break;
        case SECTION_LATEST:{
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateStyle = NSDateFormatterMediumStyle;
            dateFormatter.timeStyle = NSDateFormatterShortStyle;
            title = [dateFormatter stringFromDate:self.latestMeasurementDate];
        }break;
        default:
            break;
    }
    return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSInteger numberOfRows = 0;

    switch (section) {
        case SECTION_LATEST:
            numberOfRows = [self.latestMeasurementDictionaries count];
            break;
        case SECTION_NOAA:
            numberOfRows = 0;
         //   numberOfRows = [self.graphCellDictionaries count];
            break;
        case SECTION_USGS:
            numberOfRows = 2;
            break;
        default:
            break;
    }
        
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

   // NSString* sectionName = [self.tableSections[indexPath.section] name];
    UITableViewCell* cell;
    
    
    switch (indexPath.section) {
            /*
        case SECTION_GAUGE_NAME:{
            static NSString* cellIdentifer = @"GaugeNameCell";
            cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIdentifer];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifer];
            }
            cell.textLabel.text = self.gaugeSite.siteName;
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateStyle = NSDateFormatterMediumStyle;
            dateFormatter.timeStyle = NSDateFormatterMediumStyle;
            cell.detailTextLabel.text = [dateFormatter stringFromDate:self.latestMeasurementDate];
            return cell;
        }break;
             */
        case SECTION_LATEST:
            cell = [self cellForRecentMeasuremnentAtIndexPath:indexPath TableView:tableView];
            break;
        case SECTION_USGS:
            switch (indexPath.row) {
                case ROW_GRAPHS:
                    cell = [self graphCell];
                    break;
                case ROW_TABLES:
                    cell = [self tablesCell];
                    break;
                default:
                    break;
            }
            break;
        case SECTION_NOAA:
            cell = [self graphCell];
            break;
        default:
            break;
    }
   // cell.imageView.contentMode = UIViewContentModeScaleToFill;
    //cell.imageView.bounds = CGRectMake(0, 0, 32, 32);

    cell.contentView.backgroundColor= [UIColor clearColor];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellStripedBackground"]];
    return cell;
}

- (UITableViewCell *)graphCell
{
    static NSString *CellIdentifier = @"LatestMeasurementCell";
    LatestMeasurementCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[LatestMeasurementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
        cell.textLabel.textColor = [UIColor colorWithRed: 0 green: 0.33 blue: 0.57 alpha: 1]; //Ocean
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    cell.valueLabel.text = @"";
    cell.icon.image = [UIImage imageNamed:@"16-line-chart"];
    //cell.icon.bounds = CGRectMake(0, 0, 32, 32);
    cell.descriptionLabel.text = @"Graph";
    return cell;
}

- (UITableViewCell *)tablesCell
{
    static NSString *CellIdentifier = @"LatestMeasurementCell";
    LatestMeasurementCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[LatestMeasurementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
      //  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
        //cell.textLabel.textColor = [UIColor colorWithRed: 0 green: 0.33 blue: 0.57 alpha: 1]; //Ocean
    }
    cell.valueLabel.text = @"";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    cell.icon.image = [UIImage imageNamed:@"259-list"];
   // cell.icon.bounds = CGRectMake(0, 0, 32, 32);
    cell.descriptionLabel.text = @"Tables";
    return cell;
}


- (UITableViewCell *)cellForRecentMeasuremnentAtIndexPath:(NSIndexPath*)indexPath TableView:(UITableView*)tableView
{
    static NSString *CellIdentifier = @"LatestMeasurementCell";
    LatestMeasurementCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[LatestMeasurementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary* measurementDic = [self.latestMeasurementDictionaries objectAtIndex:indexPath.row];
    NSString* description = [[measurementDic allKeys] lastObject];
    NSString* value = [[measurementDic allValues] lastObject];

    if ([description isEqualToString:TITLE_RECENT_HEIGHT] ) {
    
        cell.icon.image = [UIImage imageNamed:@"ruler"];
    
    }else  if ([description isEqualToString:TITLE_RECENT_DISCHARGE] ) {
        
        cell.icon.image = [UIImage imageNamed:@"cloud"];
    
    }else if ([description isEqualToString:TITLE_RECENT_TEMPERATURE] ) {
      
        cell.icon.image = [UIImage imageNamed:@"93-thermometer"];
    
    }
    cell.icon.bounds = CGRectMake(0, 0, 32, 32);
    cell.descriptionLabel.text = description;
    cell.valueLabel.text = value;
    cell.accessoryType = UITableViewCellAccessoryNone;

    return cell;
}

- (UITableViewCell *)cellForGraphAndTablesSectionAtIndexPath:(NSIndexPath*)indexPath TableView:(UITableView*)tableView
{
   
    /*
    static NSString *CellIdentifier = @"GraphAndTablesCell";
    LatestMeasurementCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[LatestMeasurementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
        cell.textLabel.textColor = [UIColor colorWithRed: 0 green: 0.33 blue: 0.57 alpha: 1]; //Ocean

    }
    NSDictionary* cellDictionary;
    if (indexPath.section == SECTION_GRAPHS) {
        
        cellDictionary = self.graphCellDictionaries[indexPath.row];
        
    }else if (indexPath.section == SECTION_TABLES) {
        
        cellDictionary = self.tableCellDictionaries[indexPath.row];

    }
    
    NSString* description =  [cellDictionary objectForKey:KEY_CELL_TITLE];
    
    if ([description isEqualToString:TITLE_GRAPH_HEIGHT] || [description isEqualToString:TITLE_TABLE_HEIGHT] ) {
        
        cell.imageView.image = [UIImage imageNamed:@"ruler"];
        
    }else  if ([description isEqualToString:TITLE_GRAPH_DISCHARGE] || [description isEqualToString:TITLE_TABLE_DISHCARGE] ) {
        
        cell.imageView.image = [UIImage imageNamed:@"16-line-chart"];
        
    }else if ([description isEqualToString:TITLE_GRAPH_TEMPERATURE] || [description isEqualToString:TITLE_GRAPH_TEMPERATURE] ) {
        
        cell.imageView.image = [UIImage imageNamed:@"93-thermometer"];
        
    }else if ([description isEqualToString:TITLE_GRAPH_NOAA] || [description isEqualToString:TITLE_TABLE_NOAA] ) {
        
        cell.imageView.image = [UIImage imageNamed:@"25-weather"];
        
    }
    
    cell.textLabel.text = description;
    
    return cell;
     */
}


- (UITableViewCell *)cellForSignificantItemAtIndexPath:(NSIndexPath*)indexPath TableView:(UITableView*)tableView
{
    static NSString *CellIdentifier = @"SignificantItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NOAASignificantItem* significantItem = self.noaaMeasurementData.significantData[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@",significantItem.name ,significantItem.flowUnits ,significantItem.stageUnits ];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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
    
    if (indexPath.section == SECTION_USGS) {
        
        [self performSegueWithIdentifier:@"LineGraphView" sender:indexPath];
        /*
        GraphViewController* graphViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GraphViewController"];
        [self presentViewController:graphViewController animated:YES completion:nil];
         */
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSIndexPath*)sender{
    USGSLineGraphViewController* graphViewController = segue.destinationViewController;
    graphViewController.usgsMeasurementData = self.usgsMeasurementData;
    
    
    if (sender.section == SECTION_USGS) {
        
        NSDictionary* cellDictionary = self.graphCellDictionaries[sender.row];
        NSString* cellTitle = [cellDictionary valueForKey:KEY_CELL_TITLE];
        
        if ([cellTitle isEqualToString:TITLE_GRAPH_DISCHARGE]) {
            graphViewController.graphType = LineGraphTypeUSGSDischarge;
            graphViewController.usgsMeasurements = self.usgsMeasurementData.dischargeMeasurements;
        }else if ([cellTitle isEqualToString:TITLE_GRAPH_HEIGHT]){
            graphViewController.graphType = LineGraphTypeUSGSHeight;
            graphViewController.usgsMeasurements = self.usgsMeasurementData.heightMeasurements;
        }else if ([cellTitle isEqualToString:TITLE_GRAPH_TEMPERATURE]){
            graphViewController.graphType = LineGraphTypeUSGSTemp;
            graphViewController.usgsMeasurements = self.usgsMeasurementData.temperatureMeasurements;
        }
        
        
        
    }
    
    
}

- (IBAction)addOrDeleteFavorite:(UIBarButtonItem *)sender {
    
    if ([[FavoritesManager sharedManager] gaugeSiteExistsInFavorites:self.gaugeSite]) {
        [[FavoritesManager sharedManager] deleteFavoriteGaugeSite:self.gaugeSite];
    }else{
        [[FavoritesManager sharedManager] addFavoriteGaugeSite:self.gaugeSite];

    }
}
@end
