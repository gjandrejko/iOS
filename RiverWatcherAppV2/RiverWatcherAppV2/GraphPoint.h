//
//  GraphPoint.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/23/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GraphPoint <NSObject>
@property (nonatomic) double xValue;
@property (nonatomic) double yValue;
-(NSString) xString;
-(NSString) yString;
@end
