//
//  RHLineGraphView.m
//  RootHollowLibraries
//
//  Created by George Andrejko on 8/10/12.
//  Copyright (c) 2012 George Andrejko. All rights reserved.
//

#import "RHLineGraphView.h"

@interface RHLineGraphView ()
- (UIBezierPath *)pathFromDataInRect:(CGRect)rect;
- (UIBezierPath *)bottomClipPathFromDataInRect:(CGRect)rect;


@property (nonatomic) CGFloat maxGraphRange;
@property (nonatomic) CGFloat minGraphXValue;
@property (nonatomic) CGFloat minGrpahYValue;
@property (nonatomic) CGFloat maxGraphXValue;
@property (nonatomic) CGFloat maxGraphYalue;

@property (nonatomic) CGGradientRef backgroundGradient;
@property (nonatomic) CGGradientRef graphGradient;
@property (nonatomic) CGPoint initialDataPoint;
@property (strong,nonatomic) NSMutableArray* verticalLabelStrings;
@property (strong,nonatomic) NSMutableArray* horizontalLabelStrings;
@property (nonatomic) NSInteger numberOfPointsInGraph;

@end


@implementation RHLineGraphView
@synthesize dataSource;
@synthesize delegate;
@synthesize backgroundGradient = _backgroundGradient;
@synthesize graphGradient = _graphGradient;
@synthesize initialDataPoint = _initialDataPoint;
/*
 * Creates and returns a path that can be used to clip drawing to the top
 * of the data graph.
 */

-(CGFloat)xValueRange{
    return self.maxGraphXValue - self.minGraphXValue;
}

-(CGFloat)yValueRange{
    return self.maxGraphYalue - self.minGrpahYValue;

}

-(NSMutableArray*)verticalLabelStrings{
    if (!_verticalLabelStrings) {
        _verticalLabelStrings = [[NSMutableArray alloc] init];
    }
    return _verticalLabelStrings;
}


-(NSMutableArray*)horizontalLabelStrings{
    if (!_horizontalLabelStrings) {
        _horizontalLabelStrings = [[NSMutableArray alloc] init];
    }
    return _horizontalLabelStrings;
}


-(UIFont*)verticalLabelsFont{
    if (!_verticalLabelsFont) {
        _verticalLabelsFont = [UIFont systemFontOfSize:14];
    }
    return _verticalLabelsFont;
}

-(UIFont*)horizontalLabelsFont{
    if (!_horizontalLabelsFont) {
        _horizontalLabelsFont = [UIFont systemFontOfSize:14];
    }
    return _horizontalLabelsFont;
}

-(CGSize)maxVerticalLabelSize
{
    CGSize maxSize = CGSizeZero;
    
    for (NSString* string in self.verticalLabelStrings) {
        CGSize labelSize = [string sizeWithFont:self.verticalLabelsFont];
        if (labelSize.width > maxSize.width) {
            maxSize = labelSize;
        }
    }
    return maxSize;
}

-(CGSize)maxHorizontaLabelSize
{
    CGSize maxSize = CGSizeZero;
    
    for (NSString* string in self.horizontalLabelStrings) {
        CGSize labelSize = [string sizeWithFont:self.horizontalLabelsFont];
        if (labelSize.width > maxSize.width) {
            maxSize = labelSize;
        }
    }
    return maxSize;

}

- (CGGradientRef)backgroundGradient {
    if(NULL == _backgroundGradient) {
        CGFloat colors[8] = {0.0, 80.0 / 255.0, 89.0 / 255.0, 1.0,
            0.0, 50.0f / 255.0, 64.0 / 255.0, 1.0};
        CGFloat locations[2] = {0.0, 0.90};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        _backgroundGradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, 2);
        CGColorSpaceRelease(colorSpace);
    }
    return _backgroundGradient;
}

- (CGGradientRef)graphGradient {
    if(NULL == _graphGradient) {
        CGFloat colors[8] = {0.0, 200.0 / 255.0, 200.0 / 255.0, 1.0,
            0.0, 50.0f / 255.0, 64.0 / 255.0, 1.0};
        CGFloat locations[2] = {0.0, 0.90};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        _graphGradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, 2);
        CGColorSpaceRelease(colorSpace);
    }
    return _graphGradient;
}

-(void)setUpHorizontalLablels{
   
    /*
    NSInteger numberOfHorizontalLabels = [self.delegate numberOfHorizontalLabelsInGraphView:self];
    
    for (int i = 0; i < numberOfHorizontalLabels; i++) {
        
        if (i == 0) {
            [self.horizontalLabelStrings addObject:[self.delegate stringForHorizontalLabelAtIndex:0]];
        }else if (i == numberOfHorizontalLabels - 1){
            [self.horizontalLabelStrings addObject:[self.delegate stringForHorizontalLabelAtIndex:self.numberOfPointsInGraph - 1]];
        }else{
            NSInteger index = ((float)self.numberOfPointsInGraph / (float)numberOfHorizontalLabels) * ((float)i + 1.0);
            [self.horizontalLabelStrings addObject:[self.delegate stringForHorizontalLabelAtIndex:index]];
        }
        
    }
     */
    
    NSInteger numberOfHorizontalLabels = [self.delegate numberOfHorizontalLabelsInGraphView:self];
    
    [self.horizontalLabelStrings removeAllObjects];
    
    for (int i = 0; i < numberOfHorizontalLabels; i++) {
        
        
        CGFloat xValue = self.minGraphXValue + (([self xValueRange] / (numberOfHorizontalLabels - 1)) * i);
        [self.horizontalLabelStrings addObject:[self.delegate stringForXValueLabel:xValue]];
        
    }
    
}

-(void)setUpVerticalLabels{
    NSInteger numberOfVerticalLabels = [self.delegate numberOfVerticalLabelsInGraphView:self];
    
    [self.verticalLabelStrings removeAllObjects];
    
    for (int i = 0; i < numberOfVerticalLabels; i++) {
    
        
        CGFloat yValue = self.minGrpahYValue + (([self yValueRange] / (numberOfVerticalLabels - 1)) * i);
        [self.verticalLabelStrings addObject:[self.delegate stringForYValueLabel:yValue]];
        
    }

}


-(void)reloadGraph
{
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    self.numberOfPointsInGraph = [self.dataSource numberOfPointsInLineGraph];

    
    self.minGraphXValue = [dataSource minimumXValueOfLineGraph];
    self.maxGraphXValue = [dataSource maximumXValueOfLineGraph];
    self.minGrpahYValue = [dataSource minimumYValueOfLineGraph];
    self.maxGraphYalue = [dataSource maximumYValueOfLineGraph];
    
    [self setUpHorizontalLablels];
    [self setUpVerticalLabels];
  //  CGRect graphRect = CGRectMake([self maxVerticalLabelSize].width + 5, [[self.verticalLabelStrings lastObject] sizeWithFont:self.verticalLabelsFont].height / 2, rect.size.width - [self maxHorizontaLabelSize].width, rect.size.height - [self maxVerticalLabelSize].height * 3);
    CGRect graphRect = rect;
    [[UIColor whiteColor] setFill];
   // [self drawVerticalLabels:CGRectMake(0, graphRect.origin.y, [self maxHorizontaLabelSize].width, graphRect.size.height)];

    UIBezierPath* graphOutlinePath = [UIBezierPath bezierPathWithRoundedRect:graphRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(9, 9)];
    graphOutlinePath.lineJoinStyle = kCGLineCapRound;
    graphOutlinePath.lineCapStyle = kCGLineCapRound;
    graphOutlinePath.lineWidth = 3;
    [[UIColor colorWithRed: 0 green: 0.33 blue: 0.57 alpha: 1] setStroke];
    [graphOutlinePath stroke ];
    
    UIBezierPath* pathToDraw = [self pathForDataSourceValuesInRect:graphRect];
    pathToDraw.lineWidth = 3;
    [[UIColor colorWithRed: 0 green: 0.33 blue: 0.57 alpha: 1] setStroke];
    [pathToDraw stroke];
    [pathToDraw addClip];

    
}
/*
-(void)drawVerticalLabels:(CGRect)rect{
    
    for (int i = 0; i < [self.verticalLabelStrings count]; i++) {
        CGSize stringSize = [self.verticalLabelStrings[i] sizeWithFont:self.verticalLabelsFont];
        CGPoint pointToDraw = CGPointMake(0, i * rect.size.height / ([self.verticalLabelStrings count] -1) + rect.origin.y - (stringSize.height / 2) );
        [self.verticalLabelStrings[i] drawAtPoint:pointToDraw withFont:self.verticalLabelsFont];
        
    }
    
}
*/



- (void)drawLinePatternUnderClosingData:(CGRect)rect clip:(BOOL)shouldClip {
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat lineWidth = 1.0;
    [path setLineWidth:lineWidth];
    // because the line width is odd, offset the horizontal lines by 0.5 points
    [path moveToPoint:CGPointMake(0.0, rint(CGRectGetMinY(rect)) + 0.5)];
    [path addLineToPoint:CGPointMake(rint(CGRectGetMaxX(rect)), rint(CGRectGetMinY(rect)) + 0.5)];
    CGFloat alpha = 0.8;
    UIColor *startColor = [UIColor colorWithWhite:1.0 alpha:alpha];
    [startColor setStroke];
    CGFloat step = 4.0;
    CGFloat stepCount = CGRectGetHeight(rect) / step;
    // alpha starts at 0.8, ends at 0.2
    CGFloat alphaStep = (0.8 - 0.2) / stepCount;
    CGContextSaveGState(ctx);
    CGFloat translation = CGRectGetMinY(rect);
    while(translation < CGRectGetMaxY(rect)) {
        [path stroke];
        CGContextTranslateCTM(ctx, 0.0, lineWidth * step);
        translation += lineWidth * step;
        alpha -= alphaStep;
        startColor = [startColor colorWithAlphaComponent:alpha];
        [startColor setStroke];
    }
    CGContextRestoreGState(ctx);

}


- (UIBezierPath *)pathForDataSourceValuesInRect:(CGRect)rect {
    
    
    
    UIBezierPath* pathToReturn = [UIBezierPath bezierPath];
    NSInteger numberOfPoints = [dataSource numberOfPointsInLineGraph];
    
    if (numberOfPoints == 0) {
        return nil;
    }
    
    CGFloat minimumX = [dataSource minimumXValueOfLineGraph];
    CGFloat maximumX = [dataSource maximumXValueOfLineGraph];
    CGFloat minimumY = [dataSource minimumYValueOfLineGraph];
    CGFloat maximumY = [dataSource maximumYValueOfLineGraph];
    
    CGFloat horizontalScale = CGRectGetWidth(rect) / (maximumX - minimumX);
    CGFloat verticalScale = CGRectGetHeight(rect) / (maximumY - minimumY);

    for (int i = 0; i  < numberOfPoints; i++) {
        
        
        CGFloat xValue = [dataSource ValueForXatIndex:i] ;
        CGFloat yValue = [dataSource ValueForYatIndex:i];
        CGFloat xPointCoords =    horizontalScale  * (xValue - minimumX)  + rect.origin.x;
        CGFloat yPointCoords =   ((yValue - minimumY) * verticalScale) + rect.origin.y;
        if (i == 0) {
            [pathToReturn moveToPoint:CGPointMake(xPointCoords, yPointCoords)];

        }else{
            [pathToReturn addLineToPoint:CGPointMake(xPointCoords, yPointCoords)];

        }

        
    }
    
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, CGRectGetHeight(rect));
    [pathToReturn applyTransform:flipVertical];

    return pathToReturn;
}

@end
