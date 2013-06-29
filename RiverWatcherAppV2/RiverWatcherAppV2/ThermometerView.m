//
//  ThermometerView.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 6/23/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//
#import "UIColor+FlatUI.h"
#import "ThermometerView.h"

@implementation ThermometerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* color0 = [UIColor midnightBlueColor];
    UIColor* color1 = [color0 colorWithAlphaComponent:.4];

    CGRect frame =rect;
    //// Subframes
    
    //// Subframes
    CGRect group2 = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame));
    
    
    //// Group 2
    {
        //// Group
        {
            //// Bezier Drawing
            UIBezierPath* bezierPath = [UIBezierPath bezierPath];
            [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.50000 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.07143 * CGRectGetHeight(group2))];
            [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.66667 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.14286 * CGRectGetHeight(group2)) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.59200 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.07143 * CGRectGetHeight(group2)) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.66667 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.10339 * CGRectGetHeight(group2))];
            [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.66667 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.66268 * CGRectGetHeight(group2))];
            [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.83333 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.78571 * CGRectGetHeight(group2)) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.76575 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.68743 * CGRectGetHeight(group2)) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.83333 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.73300 * CGRectGetHeight(group2))];
            [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.50000 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.92857 * CGRectGetHeight(group2)) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.83333 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.86468 * CGRectGetHeight(group2)) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.68408 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.92857 * CGRectGetHeight(group2))];
            [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.16667 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.78571 * CGRectGetHeight(group2)) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.31592 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.92857 * CGRectGetHeight(group2)) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.16667 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.86468 * CGRectGetHeight(group2))];
            [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.33333 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.66268 * CGRectGetHeight(group2)) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.16667 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.73296 * CGRectGetHeight(group2)) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.23417 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.68743 * CGRectGetHeight(group2))];
            [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.33333 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.14286 * CGRectGetHeight(group2))];
            [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.50000 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.07143 * CGRectGetHeight(group2)) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.33333 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.10339 * CGRectGetHeight(group2)) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.40792 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.07143 * CGRectGetHeight(group2))];
            [bezierPath closePath];
            [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.50000 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.00000 * CGRectGetHeight(group2))];
            [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.16667 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.14286 * CGRectGetHeight(group2)) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.31617 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.00000 * CGRectGetHeight(group2)) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.16667 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.06411 * CGRectGetHeight(group2))];
            [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.16667 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.62675 * CGRectGetHeight(group2))];
            [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.00000 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.78571 * CGRectGetHeight(group2)) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.06208 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.66707 * CGRectGetHeight(group2)) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.00000 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.72482 * CGRectGetHeight(group2))];
            [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.50000 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 1.00000 * CGRectGetHeight(group2)) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.00000 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.90389 * CGRectGetHeight(group2)) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.22425 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 1.00000 * CGRectGetHeight(group2))];
            [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 1.00000 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.78571 * CGRectGetHeight(group2)) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.77575 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 1.00000 * CGRectGetHeight(group2)) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 1.00000 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.90389 * CGRectGetHeight(group2))];
            [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.83333 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.62675 * CGRectGetHeight(group2)) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 1.00000 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.72482 * CGRectGetHeight(group2)) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.93783 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.66707 * CGRectGetHeight(group2))];
            [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.83333 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.14286 * CGRectGetHeight(group2))];
            [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.50000 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.00000 * CGRectGetHeight(group2)) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.83333 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.06411 * CGRectGetHeight(group2)) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.68383 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.00000 * CGRectGetHeight(group2))];
            [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.50000 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.00000 * CGRectGetHeight(group2))];
            [bezierPath closePath];
            bezierPath.miterLimit = 4;
            
            [color0 setFill];
            [bezierPath fill];
            
            
            //// Bezier 2 Drawing
            UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
            [bezier2Path moveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.33333 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.32143 * CGRectGetHeight(group2))];
            [bezier2Path addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.33333 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.66268 * CGRectGetHeight(group2))];
            [bezier2Path addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.16667 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.78571 * CGRectGetHeight(group2)) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.23417 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.68746 * CGRectGetHeight(group2)) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.16667 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.73300 * CGRectGetHeight(group2))];
            [bezier2Path addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.50000 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.92857 * CGRectGetHeight(group2)) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.16667 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.86468 * CGRectGetHeight(group2)) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.31592 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.92857 * CGRectGetHeight(group2))];
            [bezier2Path addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.83333 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.78571 * CGRectGetHeight(group2)) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.68408 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.92857 * CGRectGetHeight(group2)) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.83333 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.86468 * CGRectGetHeight(group2))];
            [bezier2Path addCurveToPoint: CGPointMake(CGRectGetMinX(group2) + 0.66667 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.66268 * CGRectGetHeight(group2)) controlPoint1: CGPointMake(CGRectGetMinX(group2) + 0.83333 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.73296 * CGRectGetHeight(group2)) controlPoint2: CGPointMake(CGRectGetMinX(group2) + 0.76575 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.68743 * CGRectGetHeight(group2))];
            [bezier2Path addLineToPoint: CGPointMake(CGRectGetMinX(group2) + 0.66667 * CGRectGetWidth(group2), CGRectGetMinY(group2) + 0.32143 * CGRectGetHeight(group2))];
            bezier2Path.miterLimit = 4;
            
            [color1 setFill];
            [bezier2Path fill];
            
            
            //// Rectangle Drawing
            UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(group2) + floor(CGRectGetWidth(group2) * 0.24490 + 0.5), CGRectGetMinY(group2) + floor(CGRectGetHeight(group2) * 0.49565 + 0.5), floor(CGRectGetWidth(group2) * 0.40816 + 0.5) - floor(CGRectGetWidth(group2) * 0.24490 + 0.5), floor(CGRectGetHeight(group2) * 0.53913 + 0.5) - floor(CGRectGetHeight(group2) * 0.49565 + 0.5))];
            [color0 setFill];
            [rectanglePath fill];
            
            
            //// Rectangle 2 Drawing
            UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(group2) + floor(CGRectGetWidth(group2) * 0.24490 + 0.5), CGRectGetMinY(group2) + floor(CGRectGetHeight(group2) * 0.28696 + 0.5), floor(CGRectGetWidth(group2) * 0.40816 + 0.5) - floor(CGRectGetWidth(group2) * 0.24490 + 0.5), floor(CGRectGetHeight(group2) * 0.32174 + 0.5) - floor(CGRectGetHeight(group2) * 0.28696 + 0.5))];
            [color0 setFill];
            [rectangle2Path fill];
            
            
            //// Rectangle 3 Drawing
            UIBezierPath* rectangle3Path = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(group2) + floor(CGRectGetWidth(group2) * 0.24490 + 0.5), CGRectGetMinY(group2) + floor(CGRectGetHeight(group2) * 0.39130 + 0.5), floor(CGRectGetWidth(group2) * 0.51020 + 0.5) - floor(CGRectGetWidth(group2) * 0.24490 + 0.5), floor(CGRectGetHeight(group2) * 0.42609 + 0.5) - floor(CGRectGetHeight(group2) * 0.39130 + 0.5))];
            [color0 setFill];
            [rectangle3Path fill];
            
            
            //// Rectangle 4 Drawing
            UIBezierPath* rectangle4Path = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(group2) + floor(CGRectGetWidth(group2) * 0.24490 + 0.5), CGRectGetMinY(group2) + floor(CGRectGetHeight(group2) * 0.18261 + 0.5), floor(CGRectGetWidth(group2) * 0.51020 + 0.5) - floor(CGRectGetWidth(group2) * 0.24490 + 0.5), floor(CGRectGetHeight(group2) * 0.21739 + 0.5) - floor(CGRectGetHeight(group2) * 0.18261 + 0.5))];
            [color0 setFill];
            [rectangle4Path fill];
        }
    }

}


@end
