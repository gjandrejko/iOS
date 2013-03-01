//
//  FavoritesManager.h
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GaugeSite.h"
@interface FavoritesManager : NSObject

+(FavoritesManager*)sharedManager;

-(NSArray*)favoriteGaugeSites;
-(void)addFavoriteGaugeSite:(GaugeSite*)gaugeSite;
-(void)deleteFavoriteGaugeSite:(GaugeSite*)gaugeSite;
-(BOOL)gaugeSiteExistsInFavorites:(GaugeSite*)gaugeSite;
@end
