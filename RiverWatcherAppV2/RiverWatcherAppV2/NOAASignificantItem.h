//
//  NOAASignificantData.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NOAASignificantItem : NSObject
@property (strong,nonatomic) NSString* name;
@property (strong,nonatomic) NSNumber* flowValue;
@property (strong,nonatomic) NSNumber* stageValue;
@property (strong,nonatomic) NSString* flowUnits;
@property (strong,nonatomic) NSString* stageUnits;
@end
