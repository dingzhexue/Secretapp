//
//  GADHelper.h
//  SecretApp
//
//  Created by my on 12/8/14.
//
//

#import "GADInterstitial.h"


@interface GADHelper : NSObject

+ (GADInterstitial *)createAndLoadInterstitial:(id)delegate;

@end

@interface GADBannerViewController : UIViewController

@end
