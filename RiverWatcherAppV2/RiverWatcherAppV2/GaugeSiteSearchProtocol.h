//
//  GaugeSiteSearchProtocol.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 3/2/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GaugeSite.h"

@protocol GaugeSiteSearchProtocol <NSObject>
-(void)viewController:(UIViewController*)viewController didSelectGaugeSite:(GaugeSite*)gaugeSite;
@end
