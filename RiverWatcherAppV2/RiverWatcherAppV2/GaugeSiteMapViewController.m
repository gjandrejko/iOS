//
//  GaugeSiteMapViewController.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 6/23/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "GaugeSiteMapViewController.h"
#import "GaugeSite.h"
#import <MapKit/MapKit.h>
@interface GaugeSiteMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation GaugeSiteMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupMap];
	// Do any additional setup after loading the view.
}

-(void)setMeasurementDownloadManager:(MeasurementDownloadManager *)measurementDownloadManager{
    _measurementDownloadManager = measurementDownloadManager;
    [self setupMap];
}


-(void)setupMap{
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    MKPointAnnotation* annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = self.measurementDownloadManager.gaugeSite.coordinate;
    [self.mapView addAnnotation:annotation];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 3000, 3000);
    [self.mapView setRegion:region];
    
}

- (IBAction)changeMapType:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        default:
            break;
    }
}

@end
