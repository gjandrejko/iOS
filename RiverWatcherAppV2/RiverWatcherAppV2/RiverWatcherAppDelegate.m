//
//  RiverWatcherAppDelegate.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "RiverWatcherAppDelegate.h"
#import "UIColor+FlatUI.h"
@implementation RiverWatcherAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"PclpAMJlB9RGIyC9wnCNLdfA5CRXD1aNl7pgcxac"
                  clientKey:@"zrQW7Jg8tfO9Uzs26PU3v4FlCeR5s1BlHspegE18"];
    [PFUser enableAutomaticUser];
    
    PFACL *defaultACL = [PFACL ACL];
    
    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicReadAccess:YES];
    
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    UIImage* image = [self imageWithColor:[UIColor toolBarColor]];

    
    UINavigationBar* navAppearance = [UINavigationBar appearance];
    
    [navAppearance setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
     [[UIToolbar appearance] setBackgroundImage:image forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    UIImage* tabBarimage = [self imageWithColor:[UIColor tabBarColor]];

    [[UITabBar appearance] setBackgroundImage:tabBarimage];
    /*
    [navAppearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIColor whiteColor], UITextAttributeTextColor,
                                           [UIFont fontWithName:@"AvenirNext-Bold" size:18.0f], UITextAttributeFont,
                                           nil]];

    */
      // UIImage *navBarImage = [UIImage imageNamed:@"menubar"];
        
     //   [[UINavigationBar appearance] setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
 //   [[UIToolbar appearance] setBackgroundImage:image forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        
    
   // UIImage *barButton = [[UIImage imageNamed:@"menubar-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    
    //[[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal
            //                              barMetrics:UIBarMetricsDefault];
    
   // UIImage *backButton = [[UIImage imageNamed:@"back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 4)];
    
   // [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal
                                                    //barMetrics:UIBarMetricsDefault];
    
    return YES;
}

-(UIImage*)imageWithColor:(UIColor*)color{
    
    CGSize size = CGSizeMake(5, 5);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGRect fillRect = CGRectMake(0,0,size.width,size.height);
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    CGContextFillRect(currentContext, fillRect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    image = [image resizableImageWithCapInsets:UIEdgeInsetsZero];
    return image;
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
