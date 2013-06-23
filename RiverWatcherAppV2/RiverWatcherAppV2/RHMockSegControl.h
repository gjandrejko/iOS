//
//  MockSegControl.h
//  CustomSegControl
//
//  Created by George Andrejko on 3/15/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHMockSegControl : UIView

@property (strong,nonatomic) NSArray* segmentTitles;
@property (strong,nonatomic) UIColor* selectedSegmentColor;
@property (strong,nonatomic) UIFont* titleFont;
@property (strong,nonatomic) UIColor* selectedSegmentTitleColor;
@property (strong,nonatomic) UIColor* titleColor;
@property (nonatomic) NSInteger selectedSegmentIndex;


@end
