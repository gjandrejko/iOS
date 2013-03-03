//
//  FavoritesManager.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//
#define KEY_LATITUDE @"Latitude"
#define KEY_LONGITUDE @"Longitude"
#define KEY_FAVORITES @"Favorites"
#import "FavoritesManager.h"

@implementation FavoritesManager
+(FavoritesManager*)sharedManager{
    static FavoritesManager* sharedObj;
    if (!sharedObj) {
        sharedObj = [[FavoritesManager alloc] init];
    }
    return sharedObj;
}

-(NSArray*)favoriteGaugeSites
{
    NSDictionary* favoriteDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_FAVORITES];
    NSMutableArray* favorites = [NSMutableArray array];

    for (NSDictionary* gaugeSiteDictionary in [favoriteDictionary allValues]) {
        [favorites addObject:[self gaugeSiteForDictionary:gaugeSiteDictionary]];
    }
    return favorites;
}

-(NSDictionary*)dictionaryForGaugeSite:(GaugeSite*)gaugeSite
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:gaugeSite.nwsId forKey:kGaugeSiteParseNwsIdKey];
    [dictionary setObject:gaugeSite.usgsId forKey:kGaugeSiteParseUsgsIdKey];
    [dictionary setObject:gaugeSite.goesId forKey:kGaugeSiteParseGoesIdKey];
    [dictionary setObject:gaugeSite.nwsHsa forKey:kGaugeSiteParseNwsHsaKey];
    [dictionary setObject:gaugeSite.siteName forKey:kGaugeSiteParseSiteNameKey];
    [dictionary setObject:[NSNumber numberWithDouble:gaugeSite.coordinate.latitude] forKey:KEY_LATITUDE];
    [dictionary setObject:[NSNumber numberWithDouble:gaugeSite.coordinate.longitude] forKey:KEY_LONGITUDE];
    return dictionary;
    
}

-(void)addFavoriteGaugeSite:(GaugeSite *)gaugeSite{
 
    NSMutableDictionary* favorites = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_FAVORITES]];
    
    
    
    [favorites setObject:[self dictionaryForGaugeSite:gaugeSite] forKey:gaugeSite.usgsId];
    
    [[NSUserDefaults standardUserDefaults] setObject:favorites forKey:KEY_FAVORITES];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

-(void)deleteFavoriteGaugeSite:(GaugeSite *)gaugeSite{
    
    NSMutableDictionary* favorites = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_FAVORITES]];
    
    [favorites removeObjectForKey:gaugeSite.usgsId];
    
    [[NSUserDefaults standardUserDefaults] setObject:favorites forKey:KEY_FAVORITES];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)gaugeSiteExistsInFavorites:(GaugeSite*)gaugeSite
{
    NSMutableDictionary* favorites = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_FAVORITES]];
    
    NSDictionary* dictionary = [favorites objectForKey:gaugeSite.usgsId];
    
    if (dictionary) {
        return YES;
    }else{
        return NO;
    }
}


-(GaugeSite*)gaugeSiteForDictionary:(NSDictionary*)dictionary{
    
    GaugeSite* gaugeSite = [[GaugeSite alloc] init];
    
    gaugeSite.nwsId = [dictionary objectForKey:kGaugeSiteParseNwsIdKey];
    gaugeSite.usgsId = [dictionary objectForKey:kGaugeSiteParseUsgsIdKey];
    gaugeSite.goesId = [dictionary objectForKey:kGaugeSiteParseGoesIdKey];
    gaugeSite.nwsHsa = [dictionary objectForKey:kGaugeSiteParseNwsHsaKey];
    gaugeSite.siteName = [dictionary objectForKey:kGaugeSiteParseSiteNameKey];
    
    NSNumber* latitude  = [dictionary objectForKey:KEY_LATITUDE] ;
    NSNumber* longitude  = [dictionary objectForKey:KEY_LONGITUDE] ;
    gaugeSite.coordinate = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
    
    return gaugeSite;
}

@end
