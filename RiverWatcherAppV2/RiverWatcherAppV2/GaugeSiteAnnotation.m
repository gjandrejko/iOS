//
//  GaugeSiteAnnotation.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "GaugeSiteAnnotation.h"
#import <MapKit/MapKit.h>
@implementation GaugeSiteAnnotation  

+(GaugeSiteAnnotation*)annotationWithGaugeSite:(GaugeSite*)gaugeSite{
    
    GaugeSiteAnnotation* gaugeSiteAnnotation = [[GaugeSiteAnnotation alloc] init];
    
    gaugeSiteAnnotation.gaugeSite = gaugeSite;
   
    return gaugeSiteAnnotation;
}

- (CLLocationCoordinate2D)coordinate {
    
    return self.gaugeSite.coordinate;
}

- (NSString*)subtitle{
    
    return nil;
}

- (NSString*)title{
    
    return self.gaugeSite.siteName;
}

@end
