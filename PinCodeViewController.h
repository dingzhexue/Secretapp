//
//  PinCodeViewController.h
//  SecretApp
//
//  Created by c78 on 08/02/13.
//
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"

@interface PinCodeViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate>
{

    NSString *databasepath;
    sqlite3 *dbSecret;
    AVCaptureSession *session;
    AppDelegate *app;
    AVCaptureConnection *videoConnection;
    AVCaptureStillImageOutput *output;
}

@property (nonatomic,retain) IBOutlet UILabel *lbltext;

@property (nonatomic,retain) IBOutlet UITextField *userName;

@property (nonatomic,retain) IBOutlet UITextField *pinDigit1;
@property (nonatomic,retain) IBOutlet UITextField *pinDigit2;
@property (nonatomic,retain) IBOutlet UITextField *pinDigit3;
@property (nonatomic,retain) IBOutlet UITextField *pinDigit4;

@end
