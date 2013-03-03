//
//  LoadingView.h
//  SDSIncidentViewer
//
//  Created by George Andrejko on 2/8/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface LoadingView : UIView
@property (strong,nonatomic) UIActivityIndicatorView* spinner;
@property (strong,nonatomic) UILabel* downloadingLabel;

@end
