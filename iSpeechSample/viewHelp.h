//
//  viewHelp.h
//  SecretApp
//
//  Created by c27 on 19/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface viewHelp : UIViewController
{
    UIButton *btnBack;
    
    UIWebView *wvHelp;
}
@property(nonatomic,retain)IBOutlet UIButton *btnBack;
 @property(nonatomic,retain)IBOutlet   UIWebView *wvHelp;
@end
