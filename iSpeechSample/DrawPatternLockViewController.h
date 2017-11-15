//
//  ViewController.h
//  Lock Pattern
//
//  Created by Purnama Santo on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"
#import "ColorPickerController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@protocol addnNewPropertyDelegate

@required
- (void) setSelectedImager:(UIImage *)capImage;
@end

@class AppDelegate;
@interface DrawPatternLockViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    NSMutableArray* _paths;
    UINavigationController *nav;

  // after pattern is drawn, call this:
    id _target;
    SEL _action;
    NSString *UserName;
    NSString *loggedinUserID;
    UIImagePickerController *imagePicker;
    AVCaptureSession *session;
    id<addnNewPropertyDelegate> addnewpropertydelegate;

    NSString *databasepath;
    sqlite3 *dbSecret;
    bool isUserRegistered;
    
    AppDelegate *app;
    NSInteger passwordCounter;
    UIView *camBtnvw;
    UIButton *capture_btn;
    UIButton *backbtn;
    UILabel *lbl;
    UITextField  *txtName;
    NSInteger intTickCount;
    NSTimer *tmrLock;
    Boolean timerFlag;
    UIImage *image;
    AVCaptureConnection *videoConnection;
    AVCaptureStillImageOutput *output;
}
@property (nonatomic,retain) UINavigationController *nav;
@property(nonatomic,assign)id<addnNewPropertyDelegate> addnewpropertydelegate;
@property (nonatomic, retain) NSString *loggedinNm,*loggedinPass;
@property (NS_NONATOMIC_IOSONLY, getter=getKey, readonly, copy) NSString *key;
- (void)setTarget:(id)target withAction:(SEL)action;

@end
