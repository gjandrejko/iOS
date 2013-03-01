//
//  GaugeSite.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface GaugeSite : NSObject

+(GaugeSite*)gaugeSiteWithPFObject:(PFObject*)pFObject;
+(GaugeSite*)testSite;
@property (strong,nonatomic) NSString* nwsId;
@property (strong,nonatomic) NSString* usgsId;
@property (strong,nonatomic) NSString* goesId;
@property (strong,nonatomic) NSString* nwsHsa;
@property (strong,nonatomic) NSString* siteName;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@end
