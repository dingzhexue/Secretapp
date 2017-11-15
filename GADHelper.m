//
//  GADHelper.m
//  SecretApp
//
//  Created by my on 12/8/14.
//
//

#import "GADHelper.h"

@implementation GADBannerViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [app showGADBannerView:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated]; 
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [app hideGADBannerView];
}

@end

@implementation GADHelper

+ (GADInterstitial *)createAndLoadInterstitial:(id)delegate {
    GADInterstitial *interstitial = [[GADInterstitial alloc] init];
    interstitial.adUnitID = kGADinterstitialUnitID;
    interstitial.delegate = delegate;
    [interstitial loadRequest:[GADRequest request]];
    return interstitial;
}

@end
