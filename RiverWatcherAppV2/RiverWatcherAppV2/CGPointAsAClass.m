//
//  CGPointAsAClass.m
//  RiverWeather
//
//  Created by George Andrejko on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CGPointAsAClass.h"

@implementation CGPointAsAClass
@synthesize x, y;

+(CGPointAsAClass*)classFromPoint:(CGPoint)point
{
    CGPointAsAClass* retPtr = [[CGPointAsAClass alloc] init];
    retPtr.x = point.x;
    retPtr.y = point.y;
    return retPtr;
    
}

@end
