//
//  AlbumProcessView.h
//  SecretApp
//
//  Created by c62 on 23/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Accounts/Accounts.h>
#import "FBConnect.h"
#import "Twitter/Twitter.h"
#import "DDSocialDialog.h"
#import <MessageUI/MFMessageComposeViewController.h>

typedef enum apiCall {
    kAPILogout,
    kAPIGraphUserPermissionsDelete,
    kDialogPermissionsExtended,
    kDialogRequestsSendToMany,
    kAPIGetAppUsersFriendsNotUsing,
    kAPIGetAppUsersFriendsUsing,
    kAPIFriendsForDialogRequests,
    kDialogRequestsSendToSelect,
    kAPIFriendsForTargetDialogRequests,
    kDialogRequestsSendToTarget,
    kDialogFeedUser,
    kAPIFriendsForDialogFeed,
    kDialogFeedFriend,
    kAPIGraphUserPermissions,
    kAPIGraphMe,
    kAPIGraphUserFriends,
    kDialogPermissionsCheckin,
    kDialogPermissionsCheckinForRecent,
    kDialogPermissionsCheckinForPlaces,
    kAPIGraphSearchPlace,
    kAPIGraphUserCheckins,
    kAPIGraphUserPhotosPost,
    kAPIGraphUserVideosPost,
} apiCall;

@interface AlbumProcessView : UIViewController<UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate,UIPopoverControllerDelegate,FBRequestDelegate,FBLoginDialogDelegate,FBSessionDelegate,FBDialogDelegate,DDSocialDialogDelegate, MFMessageComposeViewControllerDelegate>
{
    UIScrollView *scrollVw;
    NSMutableArray *imgArray;
    NSMutableArray *checkedImgArr,*checkedImgPathArr,*checkedVideoArr;
    UIToolbar *toolbar;    
    NSString *databasepath;
    sqlite3 *dbSecret;
    NSString *imgId,*imgPath,*videopathAll,*selVideoPath;
    NSString *selImgID;
    bool ChekUncheckFlag;
    UIButton *checkImgbtn;
    UIActivityIndicatorView *actIndicator;
    UILabel *totalImgLbl;
    UIImageView *lastImg,*videoIcon;
    UIView *CustomLibraryVw;
    UIButton *img1;
    bool isImgFlag;
    CGSize newSize;
    int currentAPICall;
    
    //static NSString* kAppId = @"145792598897737";
    int videos;
    
    AppDelegate *app;
    UIButton *pasteBtn;
    UIBarButtonItem *selectAllBtn ;
}

@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *actIndicator;
@property(nonatomic,retain) IBOutlet UIView *CustomLibraryVw;
@property(nonatomic,retain) IBOutlet UILabel *totalImgLbl,*totalVideoLbl;
@property(nonatomic,retain) IBOutlet  UIImageView *lastImg,*videoIcon;

@property(nonatomic,retain) UIButton *checkImgbtn;
@property(nonatomic,readwrite) bool ChekUncheckFlag;
@property(nonatomic,retain)  NSMutableArray *checkedImgArr,*checkedImgPathArr,*checkedVideoArr;
@property(nonatomic,retain) NSString *imgId,*imgPath,*videopathAll,*selVideoPath;
@property(nonatomic,retain) IBOutlet UIToolbar *toolbar; 
@property(nonatomic,retain) NSMutableArray *imgArray;
@property(nonatomic,retain) IBOutlet UIScrollView *scrollVw;
@property (nonatomic,retain) Facebook *facebook;
@end

