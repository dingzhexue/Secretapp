//
//  UserLoginView.h
//  SecretApp
//
//  Created by c62 on 13/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "iSpeechSDK.h"
#import <sqlite3.h>

@interface UserLoginView : UIViewController<ISSpeechRecognitionDelegate,UIAlertViewDelegate>
{
    UITextField *txtUserNm;
    UIButton *btnRecognize;
    UILabel *lblPassword;
    NSString *databasepath;
    sqlite3 *dbSecret;
    NSString *loggedinUserID;
    AVCaptureSession *session;
    bool isUserRegistered;
}

@property(nonatomic,retain) IBOutlet UILabel *lblPassword;
@property(nonatomic,retain) IBOutlet UITextField *txtUserNm;
@property(nonatomic,retain) IBOutlet UIButton *btnRecognize;

@end
