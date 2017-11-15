//
//  viewVoiceAuthentication.h
//  SecretApp
//
//  Created by c27 on 21/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface viewVoiceAuthentication : UIViewController <ISSpeechRecognitionDelegate, MFMailComposeViewControllerDelegate>
{
    UIButton *btnSpeak;
    NSString *loggedinPass,*strNewPass,*strConfirmPass;
    Boolean isNewPassword,isReEnterPassword;
    NSString *databasepath;
    sqlite3 *dbSecret;
    NSString *strMail;
    AppDelegate *app;

}
@property(nonatomic,readwrite)    Boolean isNewPassword,isReEnterPassword;
@property (retain, nonatomic) IBOutlet UILabel *lblTextChange;
@property (retain, nonatomic) IBOutlet UIButton *btnSpeak;
@property (retain, nonatomic) NSString *strMail;
- (IBAction)btnSpeakClicked:(id)sender;

@end
