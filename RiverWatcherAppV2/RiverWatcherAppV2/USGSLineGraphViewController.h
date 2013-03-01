//
//  LineGraphViewController.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/23/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USGSMeasurementData.h"
#import "NOAAMeasurementData.h"
#import "RHLineGraphView.h"
typedef enum  {
    LineGraphTypeUnknown,     
    LineGraphTypeUSGSTemp,
    LineGraphTypeUSGSHeight,
    LineGraphTypeUSGSDischarge,
    LineGraphTypeNOAAHeight,
    LineGraphTypeNOAADischarge
}LineGraphType;

@interface USGSLineGraphViewController : UIViewController <RHLineGraphViewDataSource,RHLineGraphViewDelegate>

@property (nonatomic) LineGraphType graphType;
@property (strong,nonatomic) USGSMeasurementData* usgsMeasurementData;
@property (strong,nonatomic) NOAAMeasurementData* noaaMeasurementData;
@property (weak, nonatomic) IBOutlet RHLineGraphView *lineGraph;
@property (weak, nonatomic) IBOutlet UIView *sliderContainerView;
@property (strong,nonatomic) NSArray* usgsMeasurements;

@end
