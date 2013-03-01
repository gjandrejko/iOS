//
//  GaugeSiteAnnotation.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "GaugeSite.h"
@interface GaugeSiteAnnotation : NSObject <MKAnnotation>
+(GaugeSiteAnnotation*)annotationWithGaugeSite:(GaugeSite*)gaugeSite;
@property (strong,nonatomic) GaugeSite* gaugeSite;


@end
