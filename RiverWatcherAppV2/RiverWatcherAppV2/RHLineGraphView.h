//
//  RHLineGraphView.h
//  RootHollowLibraries
//
//  Created by George Andrejko on 8/10/12.
//  Copyright (c) 2012 George Andrejko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RHLineGraphView;

@protocol RHLineGraphViewDataSource <NSObject>

-(CGFloat)ValueForXatIndex:(NSInteger)index;
-(CGFloat)ValueForYatIndex:(NSInteger)index;

-(NSInteger)numberOfPointsInLineGraph;
-(CGFloat)minimumXValueOfLineGraph;
-(CGFloat)minimumYValueOfLineGraph;
-(CGFloat)maximumXValueOfLineGraph;
-(CGFloat)maximumYValueOfLineGraph;

@end


@protocol RHLineGraphViewDelegate <NSObject>

-(NSInteger)numberOfHorizontalLabelsInGraphView:(RHLineGraphView*)lineGraphView;
-(NSInteger)numberOfVerticalLabelsInGraphView:(RHLineGraphView*)lineGraphView;

-(NSString*)stringForXValueLabel:(CGFloat)xValue;
-(NSString*)stringForYValueLabel:(CGFloat)xValue;
-(NSString*)stringForYValueSubLabel:(CGFloat)xValue;
-(void)graphEndedTouch;
-(void)graphIsBeingTouchedAtNearestValuePoint:(CGPoint)point XValue:(CGFloat)xValue YValue:(CGFloat)yValue ;


@end

@interface RHLineGraphView : UIView
-(void)reloadGraph;
-(UIView*)lineGraphBackgroundView;
@property (strong,nonatomic) UIColor* labelColor;
@property (strong,nonatomic) UIColor* gridColor;
@property (strong,nonatomic) UIColor* graphStrokeColor;
@property (strong,nonatomic) UIColor* graphFillColor;
@property (strong,nonatomic) UIFont* verticalLabelFont;
@property (strong,nonatomic) UIFont* horizontalLabelFont;


@property (strong,nonatomic) UIFont* verticalLabelsFont;
@property (strong,nonatomic) UIFont* horizontalLabelsFont;
@property (strong,nonatomic) NSNumber* indexToStartDashedPattern;

@property (nonatomic) CGRect graphInsetRect;

@property(nonatomic, assign) id<RHLineGraphViewDataSource> dataSource;
@property(nonatomic, assign) id<RHLineGraphViewDelegate> delegate;


@end
