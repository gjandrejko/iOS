//
//  SelectionArrowView.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 6/29/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "SelectionArrowView.h"

@implementation SelectionArrowView
@synthesize arrowFillColor = _arrowFillColor;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(UIColor*)arrowFillColor{
    
    if (!_arrowFillColor) {
        _arrowFillColor = [UIColor whiteColor];
    }
    
    return _arrowFillColor;
}

-(void)setArrowFillColor:(UIColor *)arrowFillColor{
    _arrowFillColor = arrowFillColor;
    [self setNeedsDisplay];
    
}

- (void)drawRect:(CGRect)rect
{

    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(CGRectGetMaxX(rect), 0)];
    [path addLineToPoint:CGPointMake(0, CGRectGetMidY(rect))];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
    [path closePath];
    [self.arrowFillColor setFill];
    [path fill];

}


@end
