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
        
        
        
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.spinner.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        self.spinner.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:self.spinner];
        [self.spinner startAnimating];
        
        
        
        CGRect labelFrame = CGRectMake(0,0, 400, 200);
        self.downloadingLabel = [[UILabel alloc] initWithFrame:labelFrame];
        self.downloadingLabel.text = @"Loading...";
        self.downloadingLabel.textAlignment = UITextAlignmentCenter;
        self.downloadingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40];
        self.downloadingLabel.backgroundColor = [UIColor clearColor];
        self.downloadingLabel.textColor = [UIColor darkGrayColor];
        self.downloadingLabel.shadowColor = [UIColor whiteColor];
        self.downloadingLabel.shadowOffset = CGSizeMake(-1, -1);
        self.downloadingLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 - 100);
        self.downloadingLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:self.downloadingLabel];
        

        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        
    }
    return self;
}


@end
