//
//  HtmlWebViewController.h
//  Pushwoosh SDK
//  (c) Pushwoosh 2012
//

#import <UIKit/UIKit.h>
#import "PushNotificationManager.h"

@class HtmlWebViewController;

@protocol HtmlWebViewControllerDelegate <NSObject>
- (void) htmlWebViewControllerDidClose: (HtmlWebViewController *) viewController;
@end

@interface HtmlWebViewController : UIViewController <UIWebViewDelegate> {
    UIWebView *webview;
    UIActivityIndicatorView *activityIndicator;
    
    int webViewLoads;
    NSString *urlToLoad;
}

- (instancetype)initWithURLString:(NSString *)url NS_DESIGNATED_INITIALIZER;    //this method is to use it as a standalone webview

@property (nonatomic, assign) id <HtmlWebViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIWebView *webview;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) PWSupportedOrientations supportedOrientations;

@end
