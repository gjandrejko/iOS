//
//  IpadRecentValuesViewController.m
//  RiverWatcherAppV2
//
//  Created by George Andrejko on 3/2/13.
//  Copyright (c) 2013 Root Hollow Apps. All rights reserved.
//

#import "IpadRecentValuesViewController.h"
#import "RWTabBarController.h"
#import "MeasurementDownloadManager.h"
#import "GaugeSite.h"
#import "LoadingView.h"
#import "SVGKFastImageView.h"
#import "UIColor+FlatUI.h"
#import "FavoritesManager.h"
#import "ThermometerView.h"
@interface IpadRecentValuesViewController ()
@property (weak, nonatomic) IBOutlet UILabel *gaugeSiteNameLabel;
@property (strong, nonatomic) LoadingView* loadingView;
@property (weak, nonatomic) IBOutlet ThermometerView *thermometerSVG;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;
@property (weak, nonatomic) IBOutlet UIWebView *weatherWebview;

@end

@implementation IpadRecentValuesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(LoadingView*)loadingView{
    
    if (!_loadingView) {
        _loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - 44)];
        _loadingView.backgroundColor = self.view.backgroundColor;
    }
    return _loadingView;
}


-(void)showLoadingView{
    
    [self.view addSubview:self.loadingView];
}

-(void)hideLoadingView{
    
    [self.loadingView removeFromSuperview];
}

-(void)setMeasurementDownloadManager:(MeasurementDownloadManager *)measurementDownloadManager{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _measurementDownloadManager = measurementDownloadManager;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:MeasuremntDownloadManagerDidDownloadAllNotification object:nil];
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:MeasuremntDownloadManagerDidDownloadUSGSNotification object:nil];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:MeasuremntDownloadManagerDidDownloadNOAANotification object:nil];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.gaugeSiteNameLabel.text = self.measurementDownloadManager.gaugeSite.siteName;
    self.view.backgroundColor = [UIColor whiteColor];

    
    [self showLoadingView];
    
        for (UILabel* label in self.labels) {
                
                
                label.textColor = [UIColor colorWithRed:0.298 green:0.737 blue:0.984 alpha:1];
            
            
        }

    [self configurgeWeatherWebView];
    
	// Do any additional setup after loading the view.
}

- (void)updateUI:(NSNotification*)notification
{
    [self hideLoadingView];
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addRemoveFavorite:(id)sender {
    
    if ([[FavoritesManager sharedManager] gaugeSiteExistsInFavorites:self.measurementDownloadManager.gaugeSite]) {
        [[FavoritesManager sharedManager] deleteFavoriteGaugeSite:self.measurementDownloadManager.gaugeSite];
        
    }else{
        [[FavoritesManager sharedManager] addFavoriteGaugeSite:self.measurementDownloadManager.gaugeSite];

    }
    
}


-(void)configurgeWeatherWebView{
    
   // self.weatherWebview.delegate = self;
    self.weatherWebview.dataDetectorTypes = UIDataDetectorTypeNone;
    NSString* htmlString = [NSString stringWithFormat:@"<iframe id=\"forecast_embed\" type=\"text/html\" frameborder=\"0\" height=\"262\" width=\"650\" src=\"http://forecast.io/embed/#lat=%f&lon=%f&name=%@\"> </iframe>",self.measurementDownloadManager.gaugeSite.coordinate.latitude,self.measurementDownloadManager.gaugeSite.coordinate.longitude,self.measurementDownloadManager.gaugeSite.siteName];
    [self.weatherWebview loadHTMLString:htmlString baseURL:nil];
   
    self.weatherWebview.userInteractionEnabled = NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"%@",request);
    
    NSString* urlString = [[request URL] absoluteString];
    if ([urlString rangeOfString:@"forecast_embed"].location != NSNotFound ) {
        return YES;
    }else{
        return NO;
    }
    
    
}

@end
