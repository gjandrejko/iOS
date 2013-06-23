//
//  MockSegControl.m
//  CustomSegControl
//
//  Created by George Andrejko on 3/15/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "RHMockSegControl.h"
#import <QuartzCore/QuartzCore.h>

@interface RHMockSegControl ()
@property (strong,nonatomic) NSMutableArray* segmentButtons;
@end



@implementation RHMockSegControl




-(void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    [self setUpSegments];
}

-(void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
    [self setUpSegments];
}

-(void)setSelectedSegmentColor:(UIColor *)selectedSegmentColor{
    _selectedSegmentColor = selectedSegmentColor;
    [self setUpSegments];

}

-(void)setSelectedSegmentTitleColor:(UIColor *)selectedSegmentTitleColor{
    _selectedSegmentTitleColor = selectedSegmentTitleColor;
    [self setUpSegments];
}

-(void)setSegmentTitles:(NSArray *)segmentTitles{
    
    _segmentTitles = segmentTitles;
    
    [self setUpSegments];
    
}

-(void)setUpSegments{
    self.segmentButtons = [[NSMutableArray alloc] initWithCapacity:[self.segmentTitles count]];
    
    for (int i = 0; i < [self.segmentTitles count]; i++)
    {
        CGFloat buttonWidth = self.bounds.size.width / [self.segmentTitles count];
        CGRect buttonFrame = CGRectMake(i * buttonWidth, 0, buttonWidth, self.bounds.size.height);
        UIButton* button = [[UIButton alloc] initWithFrame:buttonFrame];
        [button setTitle:self.segmentTitles[i] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventTouchUpInside];
        button.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:button];
        button.titleLabel.font = self.titleFont;
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];

        [self.segmentButtons addObject:button];
        button.layer.cornerRadius = 15;
        
    }
    
}


-(void)segmentSelected:(UIButton*)button
{
    for (UIButton* button in self.segmentButtons) {
        button.backgroundColor = [UIColor clearColor];
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];

    }
    
    button.backgroundColor = self.selectedSegmentColor;
    [button setTitleColor:self.selectedSegmentTitleColor forState:UIControlStateNormal];
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
