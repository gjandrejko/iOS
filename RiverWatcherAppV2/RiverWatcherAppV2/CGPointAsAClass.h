//
//  CGPointAsAClass.h
//  RiverWeather
//
//  Created by George Andrejko on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGPointAsAClass : NSObject
+(CGPointAsAClass*)classFromPoint:(CGPoint)point;
@property float x;
@property float y;
@end
