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
#import "IpadParentViewController.h"


@interface LineGraphViewController : UIViewController <RHLineGraphViewDataSource,RHLineGraphViewDelegate>

@property (strong,nonatomic) USGSMeasurementData* usgsMeasurementData;
@property (strong,nonatomic) NOAAMeasurementData* noaaMeasurementData;
@property (weak, nonatomic) IBOutlet RHLineGraphView *lineGraph;
@property (weak, nonatomic) IBOutlet UIView *sliderContainerView;
@property (strong,nonatomic) NSArray* measurements;
@property (strong,nonatomic) IpadParentViewController* ipadParentViewController;
-(void)setUsgsMeasurementData:(USGSMeasurementData *)usgsMeasurementData NOAAMeasurementData:(NOAAMeasurementData*)noaaMeasurementData;
@property (weak, nonatomic) IBOutlet UIView *graphInsetView;
@end
