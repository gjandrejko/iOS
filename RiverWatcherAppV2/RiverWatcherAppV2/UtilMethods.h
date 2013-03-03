//
//  UtilMethods.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 3/1/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilMethods : NSObject

//Example self.view.backgroundColor = UIColorFromRGB(0xCECECE);
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

+(NSDate*)dateFromNoaaDateString:(NSString*)string;

@end
