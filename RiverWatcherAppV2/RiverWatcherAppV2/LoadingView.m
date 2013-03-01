//
//  LoadingView.m
//  SDSIncidentViewer
//
//  Created by George Andrejko on 2/8/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//


#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        spinner.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:spinner];
        [spinner startAnimating];
        
        
        
        CGRect labelFrame = CGRectMake(0,0, 400, 200);
        UILabel* downloadingLabel = [[UILabel alloc] initWithFrame:labelFrame];
        downloadingLabel.text = @"Loading...";
        downloadingLabel.textAlignment = UITextAlignmentCenter;
        downloadingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40];
        downloadingLabel.backgroundColor = [UIColor clearColor];
        downloadingLabel.textColor = [UIColor darkGrayColor];
        downloadingLabel.shadowColor = [UIColor whiteColor];
        downloadingLabel.shadowOffset = CGSizeMake(-1, -1);
        downloadingLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 - 100);
        downloadingLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:downloadingLabel];
        

        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        
    }
    return self;
}


@end
