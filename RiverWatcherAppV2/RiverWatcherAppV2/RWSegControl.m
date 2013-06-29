//
//  RWSegControl.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 6/23/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "RWSegControl.h"
#import "UIColor+FlatUI.h"
#import <QuartzCore/QuartzCore.h>
@implementation RWSegControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib{
    

    
    CGFloat fontSize = 15;
    
 
#ifdef IS_IPAD
    fontSize = 20;
#endif
    
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
    imageLayer.frame = CGRectMake(0, 0, 1, 1);
    imageLayer.backgroundColor = [UIColor cloudsColor].CGColor;
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = 0;
    
    UIGraphicsBeginImageContext(imageLayer.frame.size);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    self.layer.cornerRadius  = 0;
    [self setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor cloudsColor], UITextAttributeTextColor,
      [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0], UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"AvenirNextCondensed-Bold" size:fontSize], UITextAttributeFont,
      nil]
                                                   forState:UIControlStateNormal];
    
    [self setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor toolBarColor], UITextAttributeTextColor,
      [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0], UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"AvenirNextCondensed-Bold" size:fontSize], UITextAttributeFont,
      nil]
                                                   forState:UIControlStateSelected];
    
    [self setDividerImage:transparentImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:transparentImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:roundedImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    

    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
