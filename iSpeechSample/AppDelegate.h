//
//  ISAppDelegate.h
//  iSpeechSample
//
//  Created by Grant Butler on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawPatternLockViewController.h"
#import "PushNotificationManager.h"
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"
#import "RootViewController.h"
#import "iSpeechSDK.h"



@class UserLoginView;

@interface AppDelegate : UIResponder <UIApplicationDelegate, GADBannerViewDelegate>
{
    
    UIImage *capImg;
    Boolean isnAvigateFromPattern;
    Boolean chngePWD,isNewPattern,isReEnterPattern;
    
    Boolean blNVFromReEnter,blNVFromNewPattern;
    NSString *isFromScreen;
    
    sqlite3 *dbSecret;

    UINavigationController *nav;
    UIPopoverController *objPopOverController;
    BOOL EditContactFlag;
    NSString *conid,*conNm,*conPhone,*conEmail,*ConNote,*conRate,*conImg;
    NSString *iTuneSongPath,*iTuneSongTitle,*ZoomImage; 
    NSString *LoginUserID;
    NSString *newLogInPattern;
    NSString *globBmTitle,*globBmURL,*globBmID;
    NSMutableArray *AddedSongsArray;
    
    NSString *loginMethod;
    
    Boolean blAddContactCheck;
    
    NSUserDefaults *userDefaults;
    
    bool lockchek;
    BOOL iSBuyCLick;
    bool isFirstRun;
    bool isFirstTimeUser;
    bool flagTapForTap;
    int runCount;
    NSString *selectedVersion;
    NSMutableArray *lockArray;
    NSMutableArray *albumArray;
    NSMutableArray *bookmarkArray;
    NSMutableArray *notesArray;
    NSMutableArray *contactsArray;
    NSMutableArray *audioArray;
    NSMutableArray *videoArray;
    NSMutableArray *musicArray;
    NSMutableArray *authArray;
    NSMutableArray *autoLogOffArray;
    NSMutableArray *viewImageLogArray;
    NSMutableArray *verifyPatternArray;
}
@property(nonatomic,retain) UIImage *capImg;
@property(nonatomic,retain)  NSMutableArray *AddedSongsArray;
@property (nonatomic,retain) NSString *LoginUserID,*newLogInPattern;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) UINavigationController *nav;
@property (strong, nonatomic) UserLoginView *viewController;

@property (nonatomic,retain) NSUserDefaults *userDefaults;

@property(nonatomic,retain) NSString *conid,*conNm,*conPhone,*conEmail,*ConNote,*conRate,*conImg;
@property(nonatomic,readwrite) BOOL EditContactFlag,iSBuyCLick;
@property(nonatomic,readwrite) Boolean chngePWD ,isNewPattern,isReEnterPattern,isnAvigateFromPattern,blNVFromReEnter,blNVFromNewPattern,blAddContactCheck;

@property(nonatomic,retain) UIPopoverController *objPopOverController;
@property(nonatomic,retain) NSString *iTuneSongPath,*iTuneSongTitle,*ZoomImage;
@property(nonatomic,retain) NSString *globBmTitle,*globBmURL,*globBmID;

//AlbumTbl
@property(nonatomic,retain) NSString *albumImagePath, *albumVideoPath;

//AudioTbl
@property(nonatomic,retain) NSString *audioTitle, *audioPath, *audioTime, *audioDate;

//AuthenticationCheckTbl
@property(nonatomic,retain) NSString *authVoice, *authPattern, *authPincode;

//AutoLogOffTbl
@property(nonatomic,retain) NSString *logOffTime,*logOfBrekinPhoto, *logOffLoginPhoto, *logOffHighQuality, *logOffDuration, *logOffTransition, *logOffRepeat, *logOffShuffle, *logOffUseDeskAgent, *logOffFacebook;

//BookmarkTbl
@property(nonatomic,retain) NSString *bookmarkTblTitle, *bookmarkTblUrl;

//ContactTbl
@property(nonatomic,retain) NSString *contactName, *contactPhone, *contactEmail, *contactRating, *contactNote, *contactPic;

//MusicTbl
@property(nonatomic,retain) NSString *musicTitle, *musicPath, *musicDate;

//NotesTbl
@property(nonatomic,retain) NSString *noteText;

//VerifyPatternTbl
@property(nonatomic,retain) NSString *patternCode, *decoyPatternCode;

//VerifyUserTbl
@property(nonatomic,retain) NSString *userName, *userPassword, *userVoiceText, *userPatternCode, *userDecoyCode, *userPinCodeText;

//VideoTbl
@property(nonatomic,retain) NSString *videoPath, *videoTitle, *videoDate, *videoRecTime;

//ViewImageLogTbl
@property(nonatomic,retain) NSString *imgLogImagePath, *imgLogIsBreakin, *imgLogIsLogin, *imgLogLoginTime, *imgLogLoginDate;

@property(nonatomic) bool lockcheck,isFirstRun;

//In-App-Purchase
@property(nonatomic,retain) NSMutableArray *Purchase_array;

@property(nonatomic,retain) NSString *loginMethod;

@property(nonatomic, readwrite) bool flagTapForTap;
@property (nonatomic,retain) NSString *buyProduct;

@property (nonatomic, strong) GADBannerView *bannerView;

- (void)showGADBannerView:(UIViewController *)viewController;
- (void)hideGADBannerView;

- (void) copyDatabaseIfNeeded;
@property (NS_NONATOMIC_IOSONLY, getter=getDBPath, readonly, copy) NSString *DBPath;
- (void) copyDatabaseIfNeededNew;
@property (NS_NONATOMIC_IOSONLY, getter=getDBPathNew, readonly, copy) NSString *DBPathNew;
+(sqlite3 *) getDBConUserData;
+(sqlite3 *) getDBConUserDataNew;
-(void) BackUpOldDB;
-(void)FetchFromBackUp;

@end
