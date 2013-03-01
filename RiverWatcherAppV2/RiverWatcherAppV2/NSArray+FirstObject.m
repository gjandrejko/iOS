//
//  NSArray+FirstObject.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "NSArray+FirstObject.h"
#import <Foundation/NSArray.h>
@implementation NSArray (FirstObject)
-(id)firstObject{
    
    if ([self count] > 0) {
        return self[0];
    }else{
        return nil;
    }
}
@end
