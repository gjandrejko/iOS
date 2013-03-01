//
//  MapSearchViewController.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 2/6/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "MapSearchViewController.h"
#import "GaugeSite.h"
#import "GaugeSiteAnnotation.h"
#import "GaugeSiteIPhoneTableViewController.h"

@interface MapSearchViewController ()
@property (strong,nonatomic) PFQuery* pFQuery;
@property (strong,nonatomic) NSArray* annotations;
@end

@implementation MapSearchViewController


-(void)setAnnotations:(NSArray *)annotations{
    
    _annotations = annotations;
    [self.mapview removeAnnotations:self.mapview.annotations];
    [self.mapview addAnnotations:_annotations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapview.showsUserLocation = YES;
    self.pFQuery = [PFQuery queryWithClassName:kGaugeSiteParseClassName];
    

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMapview:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}

#pragma mark MKMapviewDelegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation{
    
    static NSString* reuseIdentifer = @"AnnotationReuseIdentifer";
    
    MKPinAnnotationView* annotationView = (MKPinAnnotationView*)[self.mapview dequeueReusableAnnotationViewWithIdentifier:reuseIdentifer];
    
    if (!annotationView) {
        GaugeSiteAnnotation* gaugeSiteAnnotation = (GaugeSiteAnnotation*)annotation;
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:gaugeSiteAnnotation reuseIdentifier:reuseIdentifer];
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    
    GaugeSiteAnnotation* gaugeSiteAnnotaion = view.annotation;
    GaugeSite* gaugeSite = gaugeSiteAnnotaion.gaugeSite;
    [self performSegueWithIdentifier:@"GaugeSiteSummary" sender:gaugeSite];
    NSLog(@"Gauge Site:%@",gaugeSite.siteName);
    
    
}


-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    [self.pFQuery cancel]; //Cancel any existing requests
    
    
    //Compute Bounding Coordinates From SW Corner Of Mapview to NE Corner Of Mapview
    CGPoint southWestPoint = CGPointMake(0, CGRectGetMaxY(self.mapview.frame));
    CGPoint northEastPoint = CGPointMake(CGRectGetMaxX(self.mapview.frame),0 );

    CLLocationCoordinate2D southwestCoordinate = [self.mapview convertPoint:southWestPoint toCoordinateFromView:self.mapview];
    CLLocationCoordinate2D northeastCoordinate = [self.mapview convertPoint:northEastPoint toCoordinateFromView:self.mapview];
    
    PFGeoPoint* southWestGeoPoint = [PFGeoPoint geoPointWithLatitude:southwestCoordinate.latitude  longitude:southwestCoordinate.longitude];
    PFGeoPoint* northeastGeoPoint = [PFGeoPoint geoPointWithLatitude:northeastCoordinate.latitude  longitude:northeastCoordinate.longitude];
    
    
    //Find Gauge Sites Within Mapview
    [self.pFQuery whereKey:kGaugeSiteParseGeoPointKey withinGeoBoxFromSouthwest:southWestGeoPoint toNortheast:northeastGeoPoint];
    self.pFQuery.limit = 50;
    [self.activityIndicator startAnimating];
    
    [self.pFQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    
    [self.activityIndicator stopAnimating];

        if (error) {
            NSLog(@"PFQuery Error:%@",error);
        }else{
            
            //Update Mapview Annotations
            
            NSMutableArray* gaugeSiteAnnotations = [NSMutableArray array];
            
            for (PFObject* pFObject in objects) {
                
                GaugeSite* gaugeSite = [GaugeSite gaugeSiteWithPFObject:pFObject];
                GaugeSiteAnnotation* gaugeSiteAnnotation = [GaugeSiteAnnotation annotationWithGaugeSite:gaugeSite];
                
                [gaugeSiteAnnotations addObject:gaugeSiteAnnotation];
                
            }
            self.annotations = gaugeSiteAnnotations;

        }
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    GaugeSiteIPhoneTableViewController* gaugeSiteSummaryController = segue.destinationViewController;
    gaugeSiteSummaryController.gaugeSite = sender;
    
}

- (IBAction)changeMapType:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.mapview.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapview.mapType = MKMapTypeSatellite;
            break;
        case 2:
            self.mapview.mapType = MKMapTypeHybrid;
            break;
        default:
            break;
    }
}

- (IBAction)zoomToUserLocation:(id)sender {
   MKCoordinateRegion userLocationRegion = MKCoordinateRegionMakeWithDistance(self.mapview.userLocation.coordinate, 100000, 100000);
    [self.mapview setRegion:userLocationRegion animated:YES];
}
@end
