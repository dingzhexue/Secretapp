//
//  Add_ImportContactView.h
//  SecretApp
//
//  Created by c62 on 17/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"
#import <sqlite3.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "GADHelper.h"

@interface Add_ImportContactView : GADBannerViewController<RateViewDelegate,UIScrollViewDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UIPopoverControllerDelegate>
{
    RateView *rateView;
    UIScrollView *scrlVw;
    UITextField *txtContName,*txtConNum,*txtconEmail;
    UITextView *txtConNote,*textClick;
    UIImageView *contImage;
    sqlite3 *dbSecret;
    NSString *databasepath,*imgpath;
    UIButton *clickImageBtn;
    UIButton *dialBtn,*mailBtn;
    UIView *vwControl;
    
//    UIImageView *background, *steelbg, *addconbutimg, *addconbackimage, *imagetextbox;
//    UIButton *btnconimage, *btnconname, *btnphone, *btnemail, *btnSave, *btnReset;
//    UILabel *lblRate;
//    UITextView *txtAddress;
//    UITextField *txtConName, *txtConPhone, *txtEmail;
    
    
}

@property(nonatomic,retain) IBOutlet UIImageView *imgHeader;
@property(nonatomic,retain) IBOutlet UIButton *dialBtn,*mailBtn;
@property(nonatomic,retain) NSString *imgpath;
@property(nonatomic,retain) IBOutlet UIButton *clickImageBtn;
@property(nonatomic,retain) IBOutlet UIImageView *contImage;
@property(nonatomic,retain) IBOutlet UITextField *txtContName,*txtConNum,*txtconEmail;
@property(nonatomic,retain) IBOutlet UITextView *txtConNote,*textClick;
@property(nonatomic,retain) IBOutlet RateView *rateView;
@property(nonatomic,retain) IBOutlet UIScrollView *scrlVw;
@property(nonatomic,retain) IBOutlet    UIView *vwControl;

@property (nonatomic,retain) IBOutlet UIView *subAdView;

//@property (nonatomic,retain) IBOutlet 

@property(nonatomic,retain) NSString *contactName,*contactPhone,*contactEmail,*contactNote,*contactRating,*contactPic;

-(IBAction)btnClickImagePressed;
-(IBAction)tapBackground:(id)sender;
-(IBAction)btnSaveClicked:(id)sender;
-(IBAction)btnResetClicked:(id)sender;

@end
