//
//  GaugeSite.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "GaugeSite.h"
@implementation GaugeSite

-(NSString*)nwsId{
    if (!_nwsId) {
        return @"";
    }else{
        return _nwsId;
    }
}

-(NSString*)usgsId{
    if (!_usgsId) {
        return @"";
    }else{
        return _usgsId;
    }
}

-(NSString*)goesId{
    if (!_goesId) {
        return @"";
    }else{
        return _goesId;
    }
}

-(NSString*)nwsHsa{
    if (!_nwsHsa) {
        return @"";
    }else{
        return _nwsHsa;
    }
}

-(NSString*)siteName{
    if (!_siteName) {
        return @"";
    }else{
        return _siteName;
    }
}





+(GaugeSite*)gaugeSiteWithPFObject:(PFObject*)pFObject
{
    GaugeSite* gaugeSite = [[GaugeSite alloc] init];
    
    gaugeSite.nwsId = [pFObject objectForKey:kGaugeSiteParseNwsIdKey];
    gaugeSite.usgsId = [pFObject objectForKey:kGaugeSiteParseUsgsIdKey];
    gaugeSite.goesId = [pFObject objectForKey:kGaugeSiteParseGoesIdKey];
    gaugeSite.nwsHsa = [pFObject objectForKey:kGaugeSiteParseNwsHsaKey];
    gaugeSite.siteName = [pFObject objectForKey:kGaugeSiteParseSiteNameKey];
    
    PFGeoPoint* geoPoint = [pFObject objectForKey:kGaugeSiteParseGeoPointKey];
    gaugeSite.coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    
    return gaugeSite;

}

+(GaugeSite*)testSite{
    /*
    PFQuery* pfQuery = [PFQuery queryWithClassName:kGaugeSiteParseClassName];
    [pfQuery whereKey:kGaugeSiteParseUsgsIdKey equalTo:@"01447500"];
    NSArray* queryResults = [pfQuery findObjects];
    PFObject* pfObject = [queryResults firstObject];
    GaugeSite* gaugeSite = [GaugeSite gaugeSiteWithPFObject:pfObject];
     */
    
    GaugeSite* gaugeSite = [[GaugeSite alloc] init];
    
    gaugeSite.nwsId = @"wbrp1";
    gaugeSite.usgsId = @"01536500";

    gaugeSite.siteName = @"Susquehanna Wilkes-Barre";
    
    
    return gaugeSite;
    
}

@end
