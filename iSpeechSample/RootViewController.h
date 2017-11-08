//
//  RootViewController.h
//  SecretApp
//
//  Created by c62 on 09/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonsterSelectionDelegate.h"
#import "ColorPickerController.h"
#import "tablKeyPad.h"
#import "MBProgressHUD.h"
#import "Facebook.h"
#import "FacebookLikeView.h"
#import "GADHelper.h"

@interface RootViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,UITableViewDataSource,UITableViewDelegate,MonsterSelectionDelegate, UISplitViewControllerDelegate, ColorPickerDelegate,keyPadSelectedDelegte, FBDialogDelegate,FBSessionDelegate,FacebookLikeViewDelegate,FBRequestDelegate,FBLoginDialogDelegate, FacebookLikeViewDelegate,UIAlertViewDelegate>
{
   // UITableView *menuTbl;
    NSMutableArray *settingmenunamearr,*settingIconArr;
   // UIToolbar *toolbar;
    UIImageView *img;
    UIView *dispImgView;
    UIButton *closeImgBtn;

    MBProgressHUD *_hud;
    
    UIView *viewFacebookBar;
    UIButton *btnFacebookLike;
    
    //FacebookLikeView *facebookLike;
    
    UIWebView *likeVw;
}

@property(nonatomic,retain)IBOutlet UIButton *closeImgBtn;
@property(nonatomic,retain) IBOutlet UIView *dispImgView;
@property(nonatomic,retain) IBOutlet UIImageView *img;
//@property(nonatomic,retain) IBOutlet  UITableView *menuTbl;
//@property(nonatomic,retain) IBOutlet  UIToolbar *toolbar;

@property (retain) MBProgressHUD *hud;

@property(nonatomic,retain) IBOutlet UIWebView *likeVw;

@property (nonatomic,retain) Facebook *facebook;
@property(nonatomic, retain) IBOutlet FacebookLikeView *facebookLikeView;

@property(nonatomic, retain) IBOutlet UIView *viewFacebookBar;
@property(nonatomic, retain) IBOutlet UIButton *btnFacebookLike;

-(IBAction)clickToLikeUsOnFacebook:(id)sender;

-(IBAction)BtnSettingsClicked:(id)sender;
-(IBAction)BtnEditClicked:(id)sender;
-(IBAction)btnBackgroundPressed:(id)sender;
-(IBAction)btnAddPressed:(id)sender;
-(IBAction)btnFBPressed:(id)sender;
-(IBAction)btnWebPressed:(id)sender;

/* New Designing */

-(IBAction)defAlbumClicked:(id)sender;
-(IBAction)BookmarkClicked:(id)sender;
-(IBAction)NotesClicked:(id)sender;
-(IBAction)AudioRecordClicked:(id)sender;
-(IBAction)ContactsClicked:(id)sender;
-(IBAction)VideoClicked:(id)sender;
-(IBAction)MusicClicked:(id)sender;
-(IBAction) closeImgView:(id)sender;

@end
