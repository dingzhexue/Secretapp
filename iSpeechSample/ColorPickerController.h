//
//  ColorPickerController.h
//  MathMonsters
//
//  Created by Ray Wenderlich on 5/3/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tablKeyPad.h"
#import "tblAutoLogOFF.h"
#import "tblViewAttempts.h"
#import "tblSlideShow.h"
#import "tblViewLogins.h"
#import <MessageUI/MessageUI.h>
#import <Twitter/Twitter.h>
#import "FBConnect.h"
#import "FacebookLikeView.h"
#import "MBProgressHUD.h"


@protocol ColorPickerDelegate
//- (void)colorSelected:(NSString *)color;
@end


//MFMailComposeViewControllerDelegate, FBSessionDelegate, FBDialogDelegate, MFMessageComposeViewControllerDelegate, 
@class AppDelegate;

@interface ColorPickerController : UITableViewController<keyPadSelectedDelegte,UIActionSheetDelegate,tblAutoLogOFFDelegate,tblViewAttemptsDelegate, UITableViewDataSource, UITableViewDelegate,tblSlideShowDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,FBDialogDelegate,FBSessionDelegate,FacebookLikeViewDelegate,FBRequestDelegate,FBLoginDialogDelegate,FacebookLikeViewDelegate> {
    NSMutableArray *_colors;
    sqlite3 *dbTest;
    sqlite3 *dbSecret;
    NSMutableArray *listOfItems;
    id<ColorPickerDelegate> _delegate;
    
    MBProgressHUD *_hud;
    
     TWTweetComposeViewController *tweetSheet;
    
    UIView *Buy_vw,*Info_view;
    AppDelegate *app;
    
    bool isFacebookLike;
    bool isSearching,isFree,isCosume;
    
    bool productPurchased;
    UIView *view;
}

@property (retain) MBProgressHUD *hud;

@property (nonatomic, retain) NSMutableArray *colors,*listOfItems;
@property(nonatomic,retain)TWTweetComposeViewController *tweetSheet;
@property (nonatomic, assign) id<ColorPickerDelegate> delegate;
@property (nonatomic,retain) Facebook *facebook;
@property (nonatomic, retain) IBOutlet FacebookLikeView *facebookLikeView;

@property(nonatomic,retain) IBOutlet UIView *Buy_vw,*Info_view;

-(IBAction)buyButtonClicked:(id)sender;
-(IBAction)RestorePreviousPurchase:(id)sender;

@end
