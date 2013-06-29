//
//  UIColor+RWColors.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 6/23/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "UIColor+RWColors.h"
#import "UIColor+FlatUI.h"
@implementation UIColor (RWColors)
+(UIColor*)ipadMainMenuCellColor
{
    return [UIColor colorWithWhite:.2 alpha:1];
       [UIColor colorWithRed:0.173 green:0.243 blue:0.314 alpha:1];
}
+(UIColor*)ipadMainMenuSectionColor
{
    return [UIColor colorWithWhite:.1 alpha:1];

    return [UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1];

}
+(UIColor*)tabBarColor
{
    return [UIColor toolBarColor];
    
   // return [UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1];
    //return [UIColor colorWithRed:0.302 green:0.749 blue:0.953 alpha:1];
}

+(UIColor*)toolBarColor
{
    return [UIColor midnightBlueColor];

    return [UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1];
    //return [UIColor colorWithRed:0.302 green:0.749 blue:0.953 alpha:1];
}
@end
