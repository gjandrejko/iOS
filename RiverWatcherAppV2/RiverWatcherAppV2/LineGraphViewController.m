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
#import "UIColor+FlatUI.h"
@interface LineGraphViewController ()
@property (strong,nonatomic) UISlider* dayRangeSlider;
@property (weak, nonatomic) IBOutlet UILabel *dayRangeLabel;
@property (nonatomic) NSUInteger dayRange;
@property (nonatomic) NSInteger dayRangeStartIndex;
@property (weak, nonatomic) IBOutlet UISegmentedControl *measurementTypesSegControl;
@property (strong,nonatomic) NSString* noaaForecastPrimary;
@property (strong,nonatomic) NSString* noaaForecastSecondary;
@property (strong,nonatomic) UIView* graphTouchView;
@property (strong,nonatomic) UIView* graphTouchPointView;

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



-(void)setMeasurementDownloadManager:(MeasurementDownloadManager *)measurementDownloadManager{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _measurementDownloadManager = measurementDownloadManager;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:MeasuremntDownloadManagerDidDownloadAllNotification object:nil];
    
    
}

- (void)updateUI:(NSNotification*)notification
{
    [self setUsgsMeasurementData:self.measurementDownloadManager.usgsMeasurementData NOAAMeasurementData:self.measurementDownloadManager.noaaMeasurementData];
    
    
    
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.measurements = self.usgsMeasurementData.heightMeasurements;
    self.dayRange =   7;
    [self computeStartIndex];

    [self setupSlider];
    self.dayRangeSlider.value = 7;
    [self dayRangeChanged:self.dayRangeSlider];
    self.lineGraph.dataSource = self;
    self.lineGraph.delegate = self;
    
    [self updateUI:nil];
    self.lineGraph.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithWhite:.95 alpha:1];
    
    self.graphTouchView = [[UIView alloc] initWithFrame:CGRectMake(0, self.graphInsetView.frame.origin.y, 2, self.graphInsetView.frame.size.height)];
    self.graphTouchView.hidden = YES;
    self.graphTouchView.backgroundColor = [UIColor redColor];
    [self.lineGraph addSubview:self.graphTouchView];
    
    self.graphTouchPointView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 16, 16)];
    self.graphTouchPointView.layer.cornerRadius = 8;
    self.graphTouchPointView.hidden = YES;
    self.graphTouchPointView.backgroundColor = [UIColor redColor];
    [self.lineGraph addSubview:self.graphTouchPointView];
}

-(void)setUsgsMeasurementData:(USGSMeasurementData *)usgsMeasurementData NOAAMeasurementData:(NOAAMeasurementData*)noaaMeasurementData
{
    self.usgsMeasurementData = usgsMeasurementData;
    self.noaaMeasurementData = noaaMeasurementData;
    

}
- (IBAction)measurementTypeChanged:(UISegmentedControl*)sender {
    
    NSString* segmentTitle = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    
    if ([segmentTitle isEqualToString:USGS_HEIGHT]) {
        
        self.measurements = self.measurementDownloadManager.usgsMeasurementData.heightMeasurements;
        
    }else if ([segmentTitle isEqualToString:USGS_DISCHARGE]) {
        
        self.measurements = self.measurementDownloadManager.usgsMeasurementData.dischargeMeasurements;

         
    }else if ([segmentTitle isEqualToString:USGS_TEMPERATURE]) {
        
        self.measurements = self.measurementDownloadManager.usgsMeasurementData.temperatureMeasurements;

        
    }else if ([segmentTitle isEqualToString:self.noaaForecastPrimary] || [segmentTitle isEqualToString:self.noaaForecastSecondary]) {
        
        self.measurements = [self.measurementDownloadManager.noaaMeasurementData.noaaMeasurements sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
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

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    self.lineGraph.graphInsetRect = self.graphInsetView.frame;
    [self.lineGraph reloadGraph];


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
    
    if (self.measurementTypesSegControl.selectedSegmentIndex < 0 ) {
        return NOAAMeasurementTypeUnknown;
    } 
    
    NSString* measurementTitle = [self.measurementTypesSegControl titleForSegmentAtIndex:self.measurementTypesSegControl.selectedSegmentIndex];
    if ([measurementTitle isEqualToString:self.noaaForecastPrimary]) {
        return NOAAMeasurementTypePrimary;
    }else if ([measurementTitle isEqualToString:self.noaaForecastSecondary]) {
        return NOAAMeasurementTypeSecondary;
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

    return  floor(minimumYValueOfLineGraph);

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

    return ceil(maximumYValueOfLineGraph);

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

    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber* number = [NSNumber numberWithFloat:yValue];
    
    if (yValue > 100) {
        [numberFormatter setMaximumFractionDigits:0];
    }else if (yValue > 10){
        [numberFormatter setMinimumFractionDigits:1];
        [numberFormatter setMaximumFractionDigits:1];
    }else{
        [numberFormatter setMaximumFractionDigits:2];
        [numberFormatter setMinimumFractionDigits:2];

    }
    
    NSString* numberString = [numberFormatter stringFromNumber:number];
    NSString* yValueString = [NSString stringWithFormat:@"%@",numberString];
    return yValueString;
}


-(void)graphIsBeingTouchedAtNearestValuePoint:(CGPoint)point XValue:(CGFloat)xValue YValue:(CGFloat)yValue
{
    self.graphTouchView.hidden = NO;
    self.graphTouchPointView.hidden = NO;
    self.graphTouchPointView.center = point;

    CGRect newFrame = self.graphTouchView.frame;
    newFrame.origin.x = point.x - (self.graphTouchView.bounds.size.width / 2);
    self.graphTouchView.frame = newFrame;
    
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
