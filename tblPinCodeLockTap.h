//
//  tblPinCodeLockTap.h
//  SecretApp
//
//  Created by c78 on 06/02/13.
//
//

#import <UIKit/UIKit.h>

#import "ABPadLockScreenController.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import <MessageUI/MFMailComposeViewController.h>


@protocol tblPinCodeLockTapDelegate
//- (void)keyPadSelected:(NSString *)color;
@end

@class AppDelegate;

@interface tblPinCodeLockTap : UITableViewController<UIAlertViewDelegate,ABLockScreenDelegate,MFMailComposeViewControllerDelegate>
{
    sqlite3 *dbSecret;
    NSMutableArray *listOfItems;
    id<tblPinCodeLockTapDelegate> _delegate;
    AppDelegate *app;

}

@property (nonatomic, retain) NSMutableArray *listOfItems;
@property (nonatomic, assign) id<tblPinCodeLockTapDelegate> delegate;

@end
