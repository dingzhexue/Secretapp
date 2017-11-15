//
//  PinCodeLoginViewController.h
//  SecretApp
//
//  Created by c78 on 08/02/13.
//
//

#import <UIKit/UIKit.h>
#import "ABPadLockScreenController.h"

@interface PinCodeLoginViewController : UIViewController <UIAlertViewDelegate, ABLockScreenDelegate>
{
    sqlite3 *dbSecret;
    NSString *databasepath;
    UIView *vw_Name;
    AppDelegate *app;
}


@end
