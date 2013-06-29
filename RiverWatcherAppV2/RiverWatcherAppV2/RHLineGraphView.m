//
//  RHLineGraphView.m
//  RootHollowLibraries
//
//  Created by George Andrejko on 8/10/12.
//  Copyright (c) 2012 George Andrejko. All rights reserved.
//

#import "RHLineGraphView.h"
#import "UIColor+FlatUI.h"
#import "UIColor+MLPFlatColors.h"
@interface CGPointWithIndex : NSObject
@property (nonatomic) CGPoint point;
@property (nonatomic) NSInteger index;
@end


@implementation CGPointWithIndex

+(CGPointWithIndex*)cgPoint:(CGPoint)point Index:(NSInteger)index{
    CGPointWithIndex* cgPointWithIndex = [[CGPointWithIndex alloc] init];
    cgPointWithIndex.point = point;
    cgPointWithIndex.index = index;
    return cgPointWithIndex;
}

@end

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
@property (strong,nonatomic) UIBezierPath* pathToDraw;
@property (strong,nonatomic) UIBezierPath* dashedPathToDraw;
@property (strong,nonatomic) NSMutableArray* cgPointWithIndexes;
@property (nonatomic) BOOL isTouching;
@property (nonatomic,strong) CGPointWithIndex *closestPointToTouch;


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

-(UIColor*)labelColor{
    
    if (!_labelColor) {
        _labelColor = [UIColor flatBlackColor];
    }
    
    return _labelColor;
    
}



-(UIColor*)gridColor{
    
    if (!_gridColor) {
        _gridColor = [UIColor flatGrayColor];
    }
    
    return _gridColor;
    
}



-(UIColor*)graphStrokeColor{
    
    if (!_graphStrokeColor) {
        
        _graphStrokeColor = [UIColor peterRiverColor];
        
    }
    
    return _graphStrokeColor;
    
}


-(UIColor*)graphFillColor{
    
    if (!_graphFillColor) {
        
        _graphFillColor = [UIColor clearColor];
        
    }
    
    return _graphFillColor;
    
}

-(UIFont*)verticalLabelFont{
    if (!_verticalLabelFont) {
        _verticalLabelFont = [UIFont fontWithName:@"AvenirNextCondensed-Bold" size:15];
    }
    return _verticalLabelFont;
}

-(UIFont*)horizontalLabelFont{
    
    if (!_horizontalLabelFont) {
        _horizontalLabelFont = [UIFont fontWithName:@"AvenirNextCondensed-Bold" size:15];
    }
    return _horizontalLabelFont;
}

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
        _verticalLabelsFont = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:15];
    }
    return _verticalLabelsFont;
}

-(UIFont*)horizontalLabelsFont{
    if (!_horizontalLabelsFont) {
        _horizontalLabelsFont = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:15];
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
    
    for (int i = numberOfVerticalLabels -1; i >= 0; i--) {
    
        
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
    self.cgPointWithIndexes = [NSMutableArray arrayWithCapacity:self.numberOfPointsInGraph];

    self.minGraphXValue = [dataSource minimumXValueOfLineGraph];
    self.maxGraphXValue = [dataSource maximumXValueOfLineGraph];
    self.minGrpahYValue = [dataSource minimumYValueOfLineGraph];
    self.maxGraphYalue = [dataSource maximumYValueOfLineGraph];
    
    [self setUpHorizontalLablels];
    [self setUpVerticalLabels];
    CGRect graphRect = self.graphInsetRect;
    
 
    
    [self drawHorizontalLabels:CGRectZero];

    [self.gridColor setStroke];

    [self drawGridLinesInRect:self.graphInsetRect];
    UIBezierPath* graphOutlinePath = [UIBezierPath bezierPathWithRoundedRect:graphRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(1, 1)];
    graphOutlinePath.lineJoinStyle = kCGLineCapRound;
    graphOutlinePath.lineCapStyle = kCGLineCapRound;
    graphOutlinePath.lineWidth = 1;
    
    [self drawGraphDataInRect:graphRect];
 
    [self drawVerticalLabels:CGRectMake(0, graphRect.origin.y, graphRect.size.width, graphRect.size.height)];

    
}

-(void)drawVerticalLabels:(CGRect)rect{
    [self.labelColor setFill];

    for (int i = 0; i < [self.verticalLabelStrings count]; i++) {
        
        
        CGSize stringSize = [self.verticalLabelStrings[i] sizeWithFont:self.verticalLabelsFont];
        CGRect rectToDraw = CGRectMake(10, i * rect.size.height / ([self.verticalLabelStrings count] -1) + rect.origin.y - (stringSize.height * .7) - 4 , stringSize.width, stringSize.height);
        [self.verticalLabelStrings[i] drawInRect:rectToDraw withFont:self.verticalLabelsFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentLeft];
    }
    
    
}


-(void)drawHorizontalLabels:(CGRect)rect{

    
    [self.labelColor setFill];
    

    CGFloat xInterval = CGRectGetWidth(self.graphInsetRect) / ([self.horizontalLabelStrings count] - 1);
    for (int i = 0; i < [self.horizontalLabelStrings count]; i++) {
        
        
        CGSize stringSize = [self.horizontalLabelStrings[i] sizeWithFont:self.horizontalLabelsFont];
        
        CGFloat xOrigin = CGRectGetMinX(self.graphInsetRect) + (i*xInterval) ;
        CGRect rectToDraw = CGRectMake(xOrigin - stringSize.width/2, CGRectGetMaxY(self.graphInsetRect) + 10,stringSize.width,stringSize.height);
        [self.horizontalLabelStrings[i] drawInRect:rectToDraw withFont:self.horizontalLabelsFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentRight];
    }
    
}



- (void)drawGraphDataInRect:(CGRect)rect {
    
    
    
    UIBezierPath* pathToDraw = [UIBezierPath bezierPath];
    NSInteger numberOfPoints = [dataSource numberOfPointsInLineGraph];
    
    if (numberOfPoints == 0) {
        return ;
    }
    
    CGFloat minimumX = [dataSource minimumXValueOfLineGraph];
    CGFloat maximumX = [dataSource maximumXValueOfLineGraph];
    CGFloat minimumY = [dataSource minimumYValueOfLineGraph];
    CGFloat maximumY = [dataSource maximumYValueOfLineGraph];
    
    CGFloat horizontalScale = CGRectGetWidth(rect) / (maximumX - minimumX);
    CGFloat verticalScale = CGRectGetHeight(rect) / (minimumY - maximumY  );

    for (int i = 0; i  < numberOfPoints; i++) {
        
        
        CGFloat xValue = [dataSource ValueForXatIndex:i] ;
        CGFloat yValue = [dataSource ValueForYatIndex:i];
        CGFloat xPointCoords =    horizontalScale  * (xValue - minimumX)  + rect.origin.x;
        CGFloat yPointCoords =   ((yValue - maximumY) * verticalScale) + rect.origin.y;
        
        
        [self.cgPointWithIndexes addObject:[CGPointWithIndex cgPoint:CGPointMake(xPointCoords, yPointCoords) Index:i]];
        if (i == 0) {
            [pathToDraw moveToPoint:CGPointMake(xPointCoords, yPointCoords)];

        }else{
            [pathToDraw addLineToPoint:CGPointMake(xPointCoords, yPointCoords)];

        }
        
        
    }
    [self.graphStrokeColor setStroke];
    pathToDraw.lineWidth = 4;
    [pathToDraw stroke];

    
    
    
     UIBezierPath* fillPath = [pathToDraw copy];
     [pathToDraw addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
     [pathToDraw addLineToPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))];
     [pathToDraw closePath];
    [[self.graphStrokeColor colorWithAlphaComponent:.4] setFill];
    
    // [pathToDraw fill];
     
     
     
     //[pathToDraw addClip];
     


}


-(void)drawGridLinesInRect:(CGRect)rect{
    CGFloat yInterval = CGRectGetHeight(self.graphInsetRect) / ([self.verticalLabelStrings count] - 1);
    for (int i = 0 ; i < [self.verticalLabelStrings count] ; i ++) {
        
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect) + (i*yInterval))];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect) + (i*yInterval))];
        bezierPath.lineWidth = .5;
        [bezierPath stroke ];
        
    }
    
    CGFloat xInterval = CGRectGetWidth(rect) / ([self.horizontalLabelStrings count] - 1);
    for (int i = 1 ; i < [self.horizontalLabelStrings count] - 1; i ++) {
        
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointMake(CGRectGetMinX(rect) + (i*xInterval), CGRectGetMaxY(rect) - 10)];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(rect) + (i*xInterval), CGRectGetMaxY(rect) )];
        bezierPath.lineWidth = .5;
        //   [bezierPath stroke ];
        
    }
    
}
/*
-(void)drawGridLines{
    CGFloat yInterval = CGRectGetHeight(self.graphInsetRect) / ([self.verticalLabelStrings count] - 1);
    for (int i = 1 ; i < [self.verticalLabelStrings count] - 1; i ++) {
        
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointMake(CGRectGetMinX(self.graphInsetRect), CGRectGetMinY(self.graphInsetRect) + (i*yInterval))];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(self.graphInsetRect), CGRectGetMinY(self.graphInsetRect) + (i*yInterval))];
        bezierPath.lineWidth = .5;
        [bezierPath stroke ];
        
    }
    
    CGFloat xInterval = CGRectGetWidth(self.graphInsetRect) / ([self.horizontalLabelStrings count] - 1);
    for (int i = 1 ; i < [self.horizontalLabelStrings count] - 1; i ++) {
        
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointMake(CGRectGetMinX(self.graphInsetRect) + (i*xInterval), CGRectGetMaxY(self.graphInsetRect) - 10)];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(self.graphInsetRect) + (i*xInterval), CGRectGetMaxY(self.graphInsetRect) )];
        bezierPath.lineWidth = .5;
     //   [bezierPath stroke ];
        
    }
     
}
 */

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.isTouching = YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.isTouching = NO;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    CGPointWithIndex* closestPoint = [self.cgPointWithIndexes firstObject];

    for (CGPointWithIndex* cgPointWithIndex in self.cgPointWithIndexes) {
        
        CGFloat distance = abs(cgPointWithIndex.point.x - touchPoint.x);
        if (distance < abs(closestPoint.point.x - touchPoint.x))
        {
            closestPoint = cgPointWithIndex;
        }
    
    }
    self.closestPointToTouch = closestPoint;
    CGFloat xValue = [self.dataSource ValueForXatIndex:closestPoint.index];
    CGFloat yValue = [self.dataSource ValueForYatIndex:closestPoint.index];
    
    NSString* xString = [self.delegate stringForXValueLabel:xValue];
    NSString* yString = [self.delegate stringForYValueLabel:yValue];

    
    [self.delegate graphIsBeingTouchedAtNearestValuePoint:closestPoint.point XValue:xValue YValue:yValue];
    NSLog(@"X:%g Y:%g",touchPoint.x, touchPoint.y);
    NSLog(@"X:%@ Y:%@",xString, yString);

}

@end
