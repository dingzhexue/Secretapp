//
//  PinCodeLoginViewController.h
//  SecretApp
//
//  Created by c78 on 08/02/13.
//
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

#import "ABPadLockScreenController.h"

@interface PinCodeLoginViewController : UIViewController <UIAlertViewDelegate, ABLockScreenDelegate>
{
    sqlite3 *dbSecret;
    NSString *databasepath;
}


@end