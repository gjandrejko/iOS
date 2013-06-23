//
//  LineGraphViewController.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/23/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#define USGS_HEIGHT @"Stage"
#define USGS_DISCHARGE @"Flow"
#define USGS_TEMPERATURE @"Temp"
#define NOAA_OBSERVED @"Observed"
#define FLOOD_STAGES @"Flood Stages"

#import <QuartzCore/QuartzCore.h>

#import "LineGraphViewController.h"
#import "USGSMeasurement.h"
#import "NOAAMeasurement.h"
@interface LineGraphViewController ()
@property (strong,nonatomic) UISlider* dayRangeSlider;
@property (weak, nonatomic) IBOutlet UILabel *dayRangeLabel;
@property (nonatomic) NSUInteger dayRange;
@property (nonatomic) NSInteger dayRangeStartIndex;
@property (weak, nonatomic) IBOutlet UISegmentedControl *measurementTypesSegControl;
@property (strong,nonatomic) NSString* noaaForecastPrimary;
@property (strong,nonatomic) NSString* noaaForecastSecondary;

@end

@implementation LineGraphViewController

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
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.measurements = self.usgsMeasurementData.heightMeasurements;
    self.dayRange =   7;
    [self computeStartIndex];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleFullScreen:)];
    
    // Set set segControl background to transparent
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Set set segControl background to transparent
    
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, 10, 10);
    imageLayer.backgroundColor = [UIColor whiteColor].CGColor;
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = 0;
    
    UIGraphicsBeginImageContext(imageLayer.frame.size);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    self.measurementTypesSegControl.layer.cornerRadius  = 0;
    [self.measurementTypesSegControl setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], UITextAttributeTextColor,
      [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0], UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"AvenirNext-Bold" size:20.0], UITextAttributeFont,
      nil]
                                          forState:UIControlStateNormal];
    
    [self.measurementTypesSegControl setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
     [UIColor colorWithRed:0.114 green:0.298 blue:0.373 alpha:1], UITextAttributeTextColor,
      [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0], UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"AvenirNext-Bold" size:20.0], UITextAttributeFont,
      nil]
                                                   forState:UIControlStateSelected];
    
    [self.measurementTypesSegControl setDividerImage:transparentImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.measurementTypesSegControl setBackgroundImage:transparentImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.measurementTypesSegControl setBackgroundImage:roundedImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
 
    [self.view addGestureRecognizer:tapGesture];
    /*
    
    UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"graphBackground"]];
    backgroundImageView.frame = self.view.bounds;
    backgroundImageView.autoresizingMask = self.lineGraph.autoresizingMask;
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
    self.lineGraph.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.1];
*/
    [self setupSlider];
    self.dayRangeSlider.value = 7;
    [self dayRangeChanged:self.dayRangeSlider];
    self.lineGraph.dataSource = self;
    self.lineGraph.delegate = self;
   // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellStripedBackground"]];
   // self.lineGraph.backgroundColor = [UIColor colorWithRed:0.220 green:0.231 blue:0.259 alpha:1];
   // self.view.backgroundColor = [UIColor colorWithRed:0.243 green:0.255 blue:0.282 alpha:1];
}

-(void)setUsgsMeasurementData:(USGSMeasurementData *)usgsMeasurementData NOAAMeasurementData:(NOAAMeasurementData*)noaaMeasurementData
{
    self.usgsMeasurementData = usgsMeasurementData;
    self.noaaMeasurementData = noaaMeasurementData;
    
    [self.measurementTypesSegControl removeAllSegments];
    
    if ([self.usgsMeasurementData.heightMeasurements count]) {
        [self.measurementTypesSegControl insertSegmentWithTitle:USGS_HEIGHT atIndex:self.measurementTypesSegControl.numberOfSegments animated:NO];
    }
    
    if ([self.usgsMeasurementData.dischargeMeasurements count]) {
        [self.measurementTypesSegControl insertSegmentWithTitle:USGS_DISCHARGE atIndex:self.measurementTypesSegControl.numberOfSegments animated:NO];
    }
    
    
    if ([self.usgsMeasurementData.temperatureMeasurements count]) {
        [self.measurementTypesSegControl insertSegmentWithTitle:USGS_TEMPERATURE atIndex:self.measurementTypesSegControl.numberOfSegments animated:NO];
    }
    
    
    if ([self.noaaMeasurementData.forecastMeasurements count]) {
        
        NOAAMeasurement* noaaMeasurement = [self.noaaMeasurementData.forecastMeasurements firstObject];
        self.noaaForecastPrimary = [NSString stringWithFormat:@"%@ Forecast",noaaMeasurement.primaryName];
        self.noaaForecastSecondary = [NSString stringWithFormat:@"%@ Forecast",noaaMeasurement.secondaryName];

        if (noaaMeasurement.primaryUnits && noaaMeasurement.primaryValue) {
            [self.measurementTypesSegControl insertSegmentWithTitle:self.noaaForecastPrimary atIndex:self.measurementTypesSegControl.numberOfSegments animated:NO];
        }
        
        
        if (noaaMeasurement.secondaryUnits && noaaMeasurement.secondaryValue) {
            [self.measurementTypesSegControl insertSegmentWithTitle:self.noaaForecastSecondary atIndex:self.measurementTypesSegControl.numberOfSegments animated:NO];
        }
        
    }

    if (self.measurementTypesSegControl.numberOfSegments > 0) {
        self.measurementTypesSegControl.selectedSegmentIndex = 0;
        [self measurementTypeChanged:self.measurementTypesSegControl];
    }else{
        self.measurements = nil;
        [self.lineGraph reloadGraph];
    }
    

}
- (IBAction)measurementTypeChanged:(UISegmentedControl*)sender {
    
    NSString* segmentTitle = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    
    if ([segmentTitle isEqualToString:USGS_HEIGHT]) {
        
        self.measurements = self.usgsMeasurementData.heightMeasurements;
        
    }else if ([segmentTitle isEqualToString:USGS_DISCHARGE]) {
        
        self.measurements = self.usgsMeasurementData.dischargeMeasurements;

        
    }else if ([segmentTitle isEqualToString:USGS_TEMPERATURE]) {
        
        self.measurements = self.usgsMeasurementData.temperatureMeasurements;

        
    }else if ([segmentTitle isEqualToString:self.noaaForecastPrimary] || [segmentTitle isEqualToString:self.noaaForecastSecondary]) {
        
        self.measurements = [self.noaaMeasurementData.noaaMeasurements sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NOAAMeasurement* noaaMeasurement1 = (NOAAMeasurement*)obj1;
            NOAAMeasurement* noaaMeasurement2 = (NOAAMeasurement*)obj2;
            
            return [noaaMeasurement1.date compare:noaaMeasurement2.date];

        }];
        
        
    }
    
    [self computeStartIndex];
    
    [self.lineGraph reloadGraph];

}

-(void)setupSlider{
    self.dayRangeSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, self.sliderContainerView.
    bounds.size.height, self.sliderContainerView.bounds.size.width)];
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI *  -0.5);
    self.dayRangeSlider.transform = trans;
    self.dayRangeSlider.center = CGPointMake(self.sliderContainerView.bounds.size.width/2, self.sliderContainerView.bounds.size.height/2);
    self.sliderContainerView.backgroundColor = [UIColor clearColor];
    self.dayRangeSlider.minimumValue = 1;
    self.dayRangeSlider.maximumValue = 30;
    [self.dayRangeSlider addTarget:self action:@selector(dayRangeChanged:) forControlEvents:UIControlEventValueChanged];
    [self.sliderContainerView addSubview:self.dayRangeSlider];
    [self.dayRangeSlider setThumbImage:[UIImage imageNamed:@"sliderThumb"] forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated{
    self.lineGraph.graphInsetRect = self.graphInsetView.frame;
    self.graphInsetView.backgroundColor = [UIColor clearColor];
    [self.lineGraph reloadGraph];
    [super viewWillAppear:animated];
}

-(void)computeStartIndex{
    
    if ([self isCurrentMeasurementTypeUSGS]) {
        self.dayRangeStartIndex =  [USGSMeasurementData startIndexForDayRange:self.dayRange InUsgsMeasurementsArray:self.measurements];

    }else{
        self.dayRangeStartIndex =  [NOAAMeasurementData startIndexForDayRange:self.dayRange InMeasurementsArray:self.measurements];

    }

}

-(BOOL)isCurrentMeasurementTypeUSGS{
    
    if (self.measurementTypesSegControl.numberOfSegments) {
        
   
    
    NSString* measurementTitle = [self.measurementTypesSegControl titleForSegmentAtIndex:self.measurementTypesSegControl.selectedSegmentIndex];
    
    if ([measurementTitle isEqualToString:USGS_DISCHARGE] || [measurementTitle isEqualToString:USGS_HEIGHT] || [measurementTitle isEqualToString:USGS_TEMPERATURE]) {
        return YES;
    }else{
        return NO;
    }
    }else{
        return NO;
    }
}

-(NOAAMeasurementType)currentNoaaMeausurementType{
    
    NSString* measurementTitle = [self.measurementTypesSegControl titleForSegmentAtIndex:self.measurementTypesSegControl.selectedSegmentIndex];
    if ([measurementTitle isEqualToString:self.noaaForecastPrimary]) {
        return NOAAMeasurementTypePrimary;
    }else if ([measurementTitle isEqualToString:self.noaaForecastSecondary]) {
        return NOAAMeasurementTypePrimary;
    }else{
        return NOAAMeasurementTypeUnknown;
    }
}

-(void)dayRangeChanged:(UISlider*)slider{
    self.dayRange = round(self.dayRangeSlider.value);
    NSString* dayRangeString = [NSString stringWithFormat:@"%d",self.dayRange];
    self.dayRangeLabel.text = dayRangeString;
    [self computeStartIndex];
    [self.lineGraph reloadGraph];
}



#pragma mark RHLineGraphViewDataSource


-(CGFloat)ValueForXatIndex:(NSInteger)index
{
 
    CGFloat xValue = 0;
    xValue =  [[self.measurements[index + self.dayRangeStartIndex] date] timeIntervalSinceDate:[self.measurements[self.dayRangeStartIndex] date]];
    return xValue;
    
}
-(CGFloat)ValueForYatIndex:(NSInteger)index
{
    CGFloat yValue = 0;
    if ([self isCurrentMeasurementTypeUSGS]) {

        USGSMeasurement* usgsMeasurement = self.measurements[index + self.dayRangeStartIndex];
        yValue = usgsMeasurement.value;
    }else{
        
        NOAAMeasurement* noaaMeasurement = self.measurements[index + self.dayRangeStartIndex];

        
        if ([self currentNoaaMeausurementType] == NOAAMeasurementTypePrimary) {
            
            yValue = [noaaMeasurement.primaryValue doubleValue];

            
        }else if ([self currentNoaaMeausurementType] == NOAAMeasurementTypeSecondary) {
            yValue = [noaaMeasurement.secondaryValue doubleValue];
        }
    }
    
  //  NSLog(@"Y %g",yValue);

    return yValue;
}

-(NSInteger)numberOfPointsInLineGraph
{
    return [self.measurements count] - self.dayRangeStartIndex;

}
-(CGFloat)minimumXValueOfLineGraph
{
    //Time Intervals of measurements are adjusted so that the earliest is zero
    return 0;
    
}



-(CGFloat)minimumYValueOfLineGraph
{
    CGFloat minimumYValueOfLineGraph = 0;
    
    if ([self isCurrentMeasurementTypeUSGS]) {
        USGSMeasurement* maxMeausrement = [USGSMeasurementData maxMeasurmentInArray:self.measurements WithDayRange:self.dayRange];
        USGSMeasurement* minMeausrement =  [USGSMeasurementData minMeasurmentInArray:self.measurements WithDayRange:self.dayRange];
        CGFloat measurementDifference = maxMeausrement.value - minMeausrement.value;
        minimumYValueOfLineGraph = minMeausrement.value - (measurementDifference * .1);
    }else{
        
        NOAAMeasurement* maxMeausrement = [NOAAMeasurementData maxMeasurmentInArray:self.measurements WithDayRange:self.dayRange NOAAMeasurementType:[self currentNoaaMeausurementType]];
        NOAAMeasurement* minMeausrement = [NOAAMeasurementData minMeasurmentInArray:self.measurements WithDayRange:self.dayRange NOAAMeasurementType:[self currentNoaaMeausurementType]];
        
        if ([self currentNoaaMeausurementType] == NOAAMeasurementTypePrimary) {
            
            CGFloat measurementDifference = [maxMeausrement.primaryValue doubleValue] - [minMeausrement.primaryValue doubleValue];
            minimumYValueOfLineGraph = [minMeausrement.primaryValue doubleValue] - (measurementDifference * .1);
            
        }else if ([self currentNoaaMeausurementType] == NOAAMeasurementTypeSecondary) {
            
            CGFloat measurementDifference = [maxMeausrement.secondaryValue doubleValue] - [minMeausrement.secondaryValue doubleValue];
            minimumYValueOfLineGraph = [minMeausrement.secondaryValue doubleValue] - (measurementDifference * .1);
        }
        
    }
    NSLog(@"MinY %g",minimumYValueOfLineGraph);

    return minimumYValueOfLineGraph;

}
- (IBAction)toggleFullScreen:(id)sender {
    [self.ipadParentViewController toggleViewControllerFullScreen:self];
}
-(CGFloat)maximumXValueOfLineGraph
{
    CGFloat maximumXValueOfLineGraph = 0;
   maximumXValueOfLineGraph = [[[self.measurements lastObject] date] timeIntervalSinceDate:[self.measurements[self.dayRangeStartIndex] date]];
    
  //  NSLog(@"MaxX %g",maximumXValueOfLineGraph);

    return maximumXValueOfLineGraph;

}
-(CGFloat)maximumYValueOfLineGraph
{

    
    CGFloat maximumYValueOfLineGraph = 0;
 
    if ([self isCurrentMeasurementTypeUSGS]) {
        USGSMeasurement* maxMeausrement = [USGSMeasurementData maxMeasurmentInArray:self.measurements WithDayRange:self.dayRange];
        USGSMeasurement* minMeausrement =  [USGSMeasurementData minMeasurmentInArray:self.measurements WithDayRange:self.dayRange];
        CGFloat measurementDifference = maxMeausrement.value - minMeausrement.value;
        maximumYValueOfLineGraph = maxMeausrement.value + (measurementDifference * .1);
    }else{
        
        NOAAMeasurement* maxMeausrement = [NOAAMeasurementData maxMeasurmentInArray:self.measurements WithDayRange:self.dayRange NOAAMeasurementType:[self currentNoaaMeausurementType]];
        NOAAMeasurement* minMeausrement = [NOAAMeasurementData minMeasurmentInArray:self.measurements WithDayRange:self.dayRange NOAAMeasurementType:[self currentNoaaMeausurementType]];
        
        if ([self currentNoaaMeausurementType] == NOAAMeasurementTypePrimary) {
            
            CGFloat measurementDifference = [maxMeausrement.primaryValue doubleValue] - [minMeausrement.primaryValue doubleValue];
            maximumYValueOfLineGraph = [maxMeausrement.primaryValue doubleValue] + (measurementDifference * .1);
            
        }else if ([self currentNoaaMeausurementType] == NOAAMeasurementTypeSecondary) {
            
            CGFloat measurementDifference = [maxMeausrement.secondaryValue doubleValue] - [minMeausrement.secondaryValue doubleValue];
            maximumYValueOfLineGraph = [maxMeausrement.secondaryValue doubleValue] + (measurementDifference * .1);
        }
        
    }
    NSLog(@"MaxY %g",maximumYValueOfLineGraph);

    return maximumYValueOfLineGraph;

}


-(NSInteger)numberOfHorizontalLabelsInGraphView:(RHLineGraphView*)lineGraphView
{
    return 4;
}
-(NSInteger)numberOfVerticalLabelsInGraphView:(RHLineGraphView*)lineGraphView
{
    return 4;
}



-(NSString*)stringForXValueLabel:(CGFloat)xValue
{
   

    
    NSDate* dateOfMeasurement =  [[self.measurements[self.dayRangeStartIndex] date] dateByAddingTimeInterval:xValue];;

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd hh:mm a"];
    NSString* dateString = [dateFormatter stringFromDate:dateOfMeasurement];
    if (!dateString) {
        dateString = @"";
    }
    return dateString;
}

-(NSString*)stringForYValueLabel:(CGFloat)yValue
{

    NSString* yValueString = [NSString stringWithFormat:@"%g",yValue];
    return yValueString;
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}


- (IBAction)dismissView:(id)sender {
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidUnload {
    [self setGraphInsetView:nil];
    [self setMeasurementTypesSegControl:nil];
    [super viewDidUnload];
}
@end
