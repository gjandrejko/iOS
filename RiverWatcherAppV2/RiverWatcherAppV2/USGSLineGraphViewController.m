//
//  LineGraphViewController.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/23/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "USGSLineGraphViewController.h"
#import "USGSMeasurement.h"
#import "NOAAMeasurement.h"
@interface USGSLineGraphViewController ()
@property (strong,nonatomic) UISlider* dayRangeSlider;
@property (weak, nonatomic) IBOutlet UILabel *dayRangeLabel;
@property (nonatomic) NSUInteger dayRange;
@property (nonatomic) NSInteger dayRangeStartIndex;

@end

@implementation USGSLineGraphViewController

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
    self.usgsMeasurements = self.usgsMeasurementData.heightMeasurements;

    UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"graphBackground"]];
    backgroundImageView.frame = self.view.bounds;
    backgroundImageView.autoresizingMask = self.lineGraph.autoresizingMask;
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
    self.lineGraph.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.1];

    [self setupSlider];
    self.dayRangeSlider.value = 7;
    [self dayRangeChanged:self.dayRangeSlider];
    self.lineGraph.dataSource = self;
    self.lineGraph.delegate = self;
   // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellStripedBackground"]];
   // self.lineGraph.backgroundColor = [UIColor colorWithRed:0.220 green:0.231 blue:0.259 alpha:1];
   // self.view.backgroundColor = [UIColor colorWithRed:0.243 green:0.255 blue:0.282 alpha:1];
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

-(void)computeStartIndex{
    
    
    self.dayRangeStartIndex =  [USGSMeasurementData startIndexForDayRange:self.dayRange InUsgsMeasurementsArray:self.usgsMeasurements];

    /*
    switch (self.graphType) {
        case LineGraphTypeNOAADischarge:
            break;
        case LineGraphTypeUSGSDischarge:
            self.dayRangeLastIndex =  [USGSMeasurementData lastIndexForDayRange:self.dayRange InUsgsMeasurementsArray:self.usgsMeasurementData.dischargeMeasurements];
            break;
        case LineGraphTypeUSGSHeight:
            self.dayRangeLastIndex =  [USGSMeasurementData lastIndexForDayRange:self.dayRange InUsgsMeasurementsArray:self.usgsMeasurementData.heightMeasurements];
            break;
        case LineGraphTypeUSGSTemp:
            self.dayRangeLastIndex =  [USGSMeasurementData lastIndexForDayRange:self.dayRange InUsgsMeasurementsArray:self.usgsMeasurementData.temperatureMeasurements];
            break;
        case LineGraphTypeNOAAHeight:
            break;
        default:
            break;
    }
    */
    NSLog(@"%d",self.dayRangeStartIndex);
}

-(void)dayRangeChanged:(UISlider*)slider{
    self.dayRange = round(self.dayRangeSlider.value);
    NSString* dayRangeString = [NSString stringWithFormat:@"%d",self.dayRange];
    self.dayRangeLabel.text = dayRangeString;
    [self computeStartIndex];
    [self.lineGraph reloadGraph];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark RHLineGraphViewDataSource


-(CGFloat)ValueForXatIndex:(NSInteger)index
{
 
   
    CGFloat xValue = 0;
    xValue =  [[self.usgsMeasurements[index + self.dayRangeStartIndex] date] timeIntervalSinceDate:[self.usgsMeasurements[self.dayRangeStartIndex] date]];

     /*
    switch (self.graphType) {
        case LineGraphTypeNOAADischarge:
            break;
        case LineGraphTypeUSGSDischarge:
            xValue =  [[self.usgsMeasurementData.dischargeMeasurements[index] date] timeIntervalSinceDate:[[self.usgsMeasurementData.dischargeMeasurements firstObject] date]];
            break;
        case LineGraphTypeUSGSHeight:{
            xValue =  [[self.usgsMeasurementData.heightMeasurements[index] date] timeIntervalSinceDate:[[self.usgsMeasurementData.heightMeasurements firstObject] date]];        }break;
        case LineGraphTypeUSGSTemp:
            xValue =  [[self.usgsMeasurementData.temperatureMeasurements[index] date] timeIntervalSinceDate:[[self.usgsMeasurementData.temperatureMeasurements firstObject] date]];
            break;
        case LineGraphTypeNOAAHeight:
            break;
        default:
            break;
    }
     */
    return xValue;
}
-(CGFloat)ValueForYatIndex:(NSInteger)index
{
    CGFloat yValue = 0;
    USGSMeasurement* usgsMeasurement = self.usgsMeasurements[index + self.dayRangeStartIndex];
    yValue = usgsMeasurement.value;

    /*
    switch (self.graphType) {
        case LineGraphTypeNOAADischarge:
            break;
        case LineGraphTypeUSGSDischarge:{
            USGSMeasurement* usgsMeasurement = self.usgsMeasurementData.dischargeMeasurements[index];
            yValue = usgsMeasurement.value;
        } break;
        case LineGraphTypeUSGSHeight:{
            USGSMeasurement* usgsMeasurement = self.usgsMeasurementData.heightMeasurements[index];
            yValue = usgsMeasurement.value;
        }break;
        case LineGraphTypeUSGSTemp:{
            USGSMeasurement* usgsMeasurement = self.usgsMeasurementData.temperatureMeasurements[index];
            yValue = usgsMeasurement.value;
        } break;
        case LineGraphTypeNOAAHeight:
            break;
        default:
            break;
    }
     */
    return yValue;
}

-(NSInteger)numberOfPointsInLineGraph
{
    return [self.usgsMeasurements count] - self.dayRangeStartIndex;
 /*
    NSInteger numberOfPointsInLineGraph = 0;
    
    switch (self.graphType) {
        case LineGraphTypeNOAADischarge:
            break;
        case LineGraphTypeUSGSDischarge:
            numberOfPointsInLineGraph = [self.usgsMeasurementData.dischargeMeasurements count];
            break;
        case LineGraphTypeUSGSHeight:
            numberOfPointsInLineGraph = [self.usgsMeasurementData.heightMeasurements count];
            break;
        case LineGraphTypeUSGSTemp:
            numberOfPointsInLineGraph = [self.usgsMeasurementData.temperatureMeasurements count];
            break;
        case LineGraphTypeNOAAHeight:
            break;
        default:
            break;
    }
    return numberOfPointsInLineGraph;
    */
}
-(CGFloat)minimumXValueOfLineGraph
{
    
    return 0;
    
    CGFloat minimumXValueOfLineGraph = 0;
    switch (self.graphType) {
        case LineGraphTypeNOAADischarge:
            break;
        case LineGraphTypeUSGSDischarge:
            minimumXValueOfLineGraph = [[[self.usgsMeasurementData.dischargeMeasurements firstObject] date] timeIntervalSinceReferenceDate];
            break;
        case LineGraphTypeUSGSHeight:
            minimumXValueOfLineGraph = [[[self.usgsMeasurementData.heightMeasurements firstObject] date] timeIntervalSinceReferenceDate]; 
            break;
        case LineGraphTypeUSGSTemp:
            minimumXValueOfLineGraph = [[[self.usgsMeasurementData.temperatureMeasurements firstObject] date] timeIntervalSinceReferenceDate];
            break;
        case LineGraphTypeNOAAHeight:
            break;
        default:
            break;
    }
    
    return minimumXValueOfLineGraph;
}
-(CGFloat)minimumYValueOfLineGraph
{
    CGFloat minimumYValueOfLineGraph = 0;
    USGSMeasurement* maxMeausrement = [USGSMeasurementData maxMeasurmentInArray:self.usgsMeasurements WithDayRange:self.dayRange];
    USGSMeasurement* minMeausrement =  [USGSMeasurementData minMeasurmentInArray:self.usgsMeasurements WithDayRange:self.dayRange];
    CGFloat measurementDifference = maxMeausrement.value - minMeausrement.value;
    minimumYValueOfLineGraph = minMeausrement.value - (measurementDifference * .1);
    /*
    switch (self.graphType) {
        case LineGraphTypeNOAADischarge:
            break;
        case LineGraphTypeUSGSDischarge:
        {
            USGSMeasurement* maxMeausrement = [USGSMeasurementData maxMeasurmentInArray:self.usgsMeasurementData.dischargeMeasurements];
            USGSMeasurement* minMeausrement = [USGSMeasurementData minMeasurmentInArray:self.usgsMeasurementData.dischargeMeasurements];
            CGFloat measurementDifference = maxMeausrement.value - minMeausrement.value;
            minimumYValueOfLineGraph = minMeausrement.value - (measurementDifference * .1);
            
        }break;
        case LineGraphTypeUSGSHeight:
        {
            USGSMeasurement* maxMeausrement = [USGSMeasurementData maxMeasurmentInArray:self.usgsMeasurementData.heightMeasurements];
            USGSMeasurement* minMeausrement = [USGSMeasurementData minMeasurmentInArray:self.usgsMeasurementData.heightMeasurements];
            CGFloat measurementDifference = maxMeausrement.value - minMeausrement.value;
            minimumYValueOfLineGraph = minMeausrement.value - (measurementDifference * .1);
        
        }break;
        case LineGraphTypeUSGSTemp:
        {
            USGSMeasurement* maxMeausrement = [USGSMeasurementData maxMeasurmentInArray:self.usgsMeasurementData.temperatureMeasurements];
            USGSMeasurement* minMeausrement = [USGSMeasurementData minMeasurmentInArray:self.usgsMeasurementData.temperatureMeasurements];
            CGFloat measurementDifference = maxMeausrement.value - minMeausrement.value;
            minimumYValueOfLineGraph = minMeausrement.value - (measurementDifference * .1);
            
        }break;
        case LineGraphTypeNOAAHeight:
            break;
        default:
            break;
    }
     */
    return minimumYValueOfLineGraph;

}
-(CGFloat)maximumXValueOfLineGraph
{
    CGFloat maximumXValueOfLineGraph = 0;
   maximumXValueOfLineGraph = [[[self.usgsMeasurementData.dischargeMeasurements lastObject] date] timeIntervalSinceDate:[self.usgsMeasurementData.dischargeMeasurements[self.dayRangeStartIndex] date]];
    /*
    switch (self.graphType) {
        case LineGraphTypeNOAADischarge:
            break;
        case LineGraphTypeUSGSDischarge:
        {
            maximumXValueOfLineGraph = [[[self.usgsMeasurementData.dischargeMeasurements lastObject] date] timeIntervalSinceDate:[[self.usgsMeasurementData.dischargeMeasurements firstObject] date]];

        }break;
        case LineGraphTypeUSGSHeight:
        {
           maximumXValueOfLineGraph = [[[self.usgsMeasurementData.heightMeasurements lastObject] date] timeIntervalSinceDate:[[self.usgsMeasurementData.heightMeasurements firstObject] date]];            
        }break;
        case LineGraphTypeUSGSTemp:
        {
            maximumXValueOfLineGraph = [[[self.usgsMeasurementData.temperatureMeasurements lastObject] date] timeIntervalSinceDate:[[self.usgsMeasurementData.temperatureMeasurements firstObject] date]];
        }break;
        case LineGraphTypeNOAAHeight:
            break;
        default:
            break;
    }
     */
    return maximumXValueOfLineGraph;

}
-(CGFloat)maximumYValueOfLineGraph
{
    CGFloat maximumYValueOfLineGraph = 0;
    USGSMeasurement* maxMeausrement = [USGSMeasurementData maxMeasurmentInArray:self.usgsMeasurements WithDayRange:self.dayRange];
    USGSMeasurement* minMeausrement =  [USGSMeasurementData minMeasurmentInArray:self.usgsMeasurements WithDayRange:self.dayRange];
    CGFloat measurementDifference = maxMeausrement.value - minMeausrement.value;
    maximumYValueOfLineGraph = maxMeausrement.value + (measurementDifference * .1);
    /*
    
    switch (self.graphType) {
        case LineGraphTypeNOAADischarge:
            break;
        case LineGraphTypeUSGSDischarge:
        {
            USGSMeasurement* maxMeausrement = [USGSMeasurementData maxMeasurmentInArray:self.usgsMeasurementData.dischargeMeasurements];
            USGSMeasurement* minMeausrement = [USGSMeasurementData minMeasurmentInArray:self.usgsMeasurementData.dischargeMeasurements];
            CGFloat measurementDifference = maxMeausrement.value - minMeausrement.value;
            maximumYValueOfLineGraph = maxMeausrement.value + (measurementDifference * .1);
            
        }break;
        case LineGraphTypeUSGSHeight:
        {
            USGSMeasurement* maxMeausrement = [USGSMeasurementData maxMeasurmentInArray:self.usgsMeasurementData.heightMeasurements];
            USGSMeasurement* minMeausrement = [USGSMeasurementData minMeasurmentInArray:self.usgsMeasurementData.heightMeasurements];
            CGFloat measurementDifference = maxMeausrement.value - minMeausrement.value;
            maximumYValueOfLineGraph = maxMeausrement.value + (measurementDifference * .1);

        }break;
        case LineGraphTypeUSGSTemp:
        {
            USGSMeasurement* maxMeausrement = [USGSMeasurementData maxMeasurmentInArray:self.usgsMeasurementData.temperatureMeasurements];
            USGSMeasurement* minMeausrement = [USGSMeasurementData minMeasurmentInArray:self.usgsMeasurementData.temperatureMeasurements];
            CGFloat measurementDifference = maxMeausrement.value - minMeausrement.value;
            maximumYValueOfLineGraph = maxMeausrement.value + (measurementDifference * .1);
            
        }break;        case LineGraphTypeNOAAHeight:
            break;
        default:
            break;
    }
     */
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

-(NSString*)stringForHorizontalLabelAtIndex:(NSInteger)index{
    
    return @"";
    
    NSDate* dateOfMeasurement;
    
    switch (self.graphType) {
        case LineGraphTypeNOAADischarge:
            break;
        case LineGraphTypeUSGSDischarge:
        break;
        case LineGraphTypeUSGSHeight:
        {
            dateOfMeasurement = [self.usgsMeasurementData.heightMeasurements[index] date];
        }break;
        case LineGraphTypeUSGSTemp:
            break;
        case LineGraphTypeNOAAHeight:
            break;
        default:
            break;
    }
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd hh:mm"];
    NSString* dateString = [dateFormatter stringFromDate:dateOfMeasurement];
    return dateString;
}

-(NSString*)stringForXValueLabel:(CGFloat)xValue
{
   
    return @"";

    
    NSDate* dateOfMeasurement;
    
    switch (self.graphType) {
        case LineGraphTypeNOAADischarge:
            break;
        case LineGraphTypeUSGSDischarge:
            break;
        case LineGraphTypeUSGSHeight:
        {
            dateOfMeasurement = [[self.usgsMeasurementData.heightMeasurements[0] date] dateByAddingTimeInterval:xValue];
        }break;
        case LineGraphTypeUSGSTemp:
            break;
        case LineGraphTypeNOAAHeight:
            break;
        default:
            break;
    }
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd hh:mm"];
    NSString* dateString = [dateFormatter stringFromDate:dateOfMeasurement];
    return dateString;
}

-(NSString*)stringForYValueLabel:(CGFloat)yValue
{
    return @"";

    NSString* yValueString = [NSString stringWithFormat:@"%g",yValue];
    return yValueString;
}



-(NSString*)stringForVerticalLabelAtIndex:(NSInteger)index{
    return @"";

    CGFloat value = 0;
    
    switch (self.graphType) {
        case LineGraphTypeNOAADischarge:
            break;
        case LineGraphTypeUSGSDischarge:
            break;
        case LineGraphTypeUSGSHeight:
        {
            value = ((USGSMeasurement*)self.usgsMeasurementData.heightMeasurements[index]).value;
        }break;
        case LineGraphTypeUSGSTemp:
            break;
        case LineGraphTypeNOAAHeight:
            break;
        default:
            break;
    }
    
    NSString* valueString = [NSString stringWithFormat:@"%g",value];
    return valueString;
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


@end
