//
//  ISAppDelegate.m
//  iSpeechSample
//
//  Created by Grant Butler on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "UIDevice+IdentifierAddition.h"
#import "UserLoginView.h"
#import "RootViewController.h"
#import "iSpeechSDK.h"
#import "InAppRageIAPHelper.h"
#import "SplashScreen.h"
#import "iRate.h"
#import "DrawPatternLockViewController.h"
#import "GlobalFunctions.h"
#import "WelcomeScreen.h"

@implementation AppDelegate
@synthesize capImg;
@synthesize window = _window;
@synthesize viewController = _viewController,nav;
@synthesize newLogInPattern;
@synthesize EditContactFlag,conNm,conImg,conRate,conEmail,conPhone,ConNote,conid,LoginUserID,chngePWD,isNewPattern,isReEnterPattern,isnAvigateFromPattern,blNVFromReEnter,blNVFromNewPattern,blAddContactCheck,iSBuyCLick,isFirstRun;

@synthesize userDefaults;

@synthesize Purchase_array;

@synthesize lockcheck;

@synthesize iTuneSongPath,iTuneSongTitle,ZoomImage,AddedSongsArray,objPopOverController;

@synthesize loginMethod;

@synthesize globBmURL,globBmTitle,globBmID;

@synthesize flagTapForTap,buyProduct;

//AlbumTbl
@synthesize albumImagePath,albumVideoPath;

//AudioTbl
@synthesize audioTitle,audioDate,audioPath,audioTime;

//AuthenticatiobCheckTbl
@synthesize  authPattern,authPincode,authVoice;

//AutoLogOffTbl
@synthesize logOfBrekinPhoto,logOffDuration,logOffFacebook,logOffHighQuality,logOffLoginPhoto,logOffRepeat,logOffShuffle,logOffTime,logOffTransition,logOffUseDeskAgent;

//BookmarkTbl
@synthesize bookmarkTblTitle,bookmarkTblUrl;

//ContactTbl
@synthesize contactEmail,contactName,contactNote,contactPhone,contactPic,contactRating;

//MusicTbl
@synthesize musicDate,musicPath,musicTitle;

//NotesTbl
@synthesize noteText;

//VerifyPatternTbl
@synthesize patternCode,decoyPatternCode;

//VerityUserTbl
@synthesize userDecoyCode,userName,userPassword,userPatternCode,userPinCodeText,userVoiceText;

//VideoTbl
@synthesize videoDate,videoPath,videoRecTime,videoTitle;

//ViewImageLogTbl
@synthesize imgLogImagePath,imgLogIsBreakin,imgLogIsLogin,imgLogLoginDate,imgLogLoginTime;

UINavigationController *navigationController1 ;
- (void)dealloc
{
    [newLogInPattern release];
    [_window release];
    [_viewController release];
    [AddedSongsArray release];
    [globBmURL release];
    [globBmID release];
    [globBmTitle release];
    [LoginUserID release];
    [ZoomImage release];
    [iTuneSongPath release];
    [iTuneSongTitle release];
    [ConNote release];
    [conid release];
    [conNm release];
    [conImg release];
    [conRate release];
    [conEmail release];
    [_window release];
    [super dealloc];
}
+ (void)initialize
{
    //set the bundle ID. normally you wouldn't need to do this
    //as it is picked up automatically from your Info.plist file
    //but we want to test with an app that's actually on the store
#ifdef LITEVERSION
    [iRate sharedInstance].applicationBundleID = @"com.sublime.SecretApp";
#else
     [iRate sharedInstance].applicationBundleID = @"com.sublime.SecretAppPro";
#endif
   
	[iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    
    //enable preview mode
    [iRate sharedInstance].previewMode = YES;
    //[iRate sharedInstance].daysUntilPrompt = 5;
    //[iRate sharedInstance].usesUntilPrompt = 15;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    lockArray = [[NSMutableArray alloc] init];
    albumArray = [[NSMutableArray alloc] init];
    bookmarkArray = [[NSMutableArray alloc] init];
    notesArray = [[NSMutableArray alloc] init];
    contactsArray = [[NSMutableArray alloc] init];
    audioArray = [[NSMutableArray alloc] init];
    videoArray = [[NSMutableArray alloc] init];
    musicArray = [[NSMutableArray alloc] init];
    authArray = [[NSMutableArray alloc] init];
    autoLogOffArray = [[NSMutableArray alloc] init];
    viewImageLogArray = [[NSMutableArray alloc] init];
    verifyPatternArray = [[NSMutableArray alloc] init];
    NSLog(@"App Exit");
    
    // Setup Push Notifications APNs
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
#ifdef __IPHONE_8_0
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        [application registerUserNotificationSettings:settings];
#endif
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    // Override point for customization after application launch.
	/*self.viewController = [[[ISViewController alloc] initWithNibName:@"ISViewController" bundle:nil] autorelease];
     self.window.rootViewController = self.viewController;
     [self.window makeKeyAndVisible];
     self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];*/
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    
#define TESTING 1
#ifdef TESTING
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueDeviceIdentifier]];
#endif
    [TestFlight takeOff:@"2938ac4be82f329ffe60347427061424_MTI5NzMzMjAxMi0wOS0xMSAwNDo0Mjo0Ni40NjEzMjg"];
    
    [self copyDatabaseIfNeeded];
    [self copyDatabaseIfNeededNew];

//    NSString *strValue=[self Authentication];
//
//    if([strValue isEqualToString:@"Voice"])
//    {
//            
//           UIViewController *viewController1;
//            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
//           {
//                viewController1 = [[UserLoginView alloc] initWithNibName:@"UserLoginView_Ipad" bundle:nil];
//            }
//            else {
//                viewController1 = [[UserLoginView alloc] initWithNibName:@"UserLoginView" bundle:nil];
//            }
//            UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:viewController1];
//            [viewController1 release]; viewController1 = nil;
//            self.window.rootViewController = navigationController1;
//            
//            self.nav.navigationBar.tintColor=[UIColor blackColor];
//            [self.window makeKeyAndVisible];
//
//    }else {
//        
//        DrawPatternLockViewController *drw=[[DrawPatternLockViewController alloc]init];
//        UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:drw];
//        [drw release]; drw = nil;
//        self.window.rootViewController = navigationController1;
//        self.nav.navigationBar.tintColor=[UIColor blackColor];
//        [self.window makeKeyAndVisible];
//    }
 
    isFirstRun=YES;
//    SplashScreen *splash;
//    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
//    {
//        splash=[[SplashScreen alloc]initWithNibName:@"SplashScreen_Ipad" bundle:nil];
//    }
//    else
//    {
//        splash=[[SplashScreen alloc]initWithNibName:@"SplashScreen" bundle:nil];
//    }
    runCount = 0;
    if([[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"CheckRunCount"] intValue] < 2)
    {
        runCount = [[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"CheckRunCount"] intValue];
        WelcomeScreen *welcomeScreen;
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            welcomeScreen = [[WelcomeScreen alloc] initWithNibName:@"WelcomeScreen_ipad" bundle:nil];
        }
        else
        {
            welcomeScreen = [[WelcomeScreen alloc] initWithNibName:@"WelcomeScreen" bundle:nil];
        }
        navigationController1 = [[UINavigationController alloc] initWithRootViewController:welcomeScreen];
        [welcomeScreen release];
        welcomeScreen = nil;
        self.window.rootViewController = navigationController1;
        self.nav.navigationBar.tintColor=[UIColor redColor];
        [self.window makeKeyAndVisible];
        runCount ++;
        NSLog(@"%d",runCount);
        [GlobalFunctions setStringValueToUserDefaults:[NSString stringWithFormat:@"%d",runCount] ForKey:@"CheckRunCount"];
    }
    else
    {
        if(iSBuyCLick == YES)
        {
            
        }
        else
        {
            DrawPatternLockViewController *drw=[[DrawPatternLockViewController alloc]init];
            navigationController1 = [[UINavigationController alloc] initWithRootViewController:drw];
            [drw release];
            drw = nil;
            self.window.rootViewController = navigationController1;
            //self.nav.navigationBar.tintColor=[UIColor blackColor];
            [self.window makeKeyAndVisible];
        }
    }
    Purchase_array=[[NSMutableArray alloc]init];
    
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[InAppRageIAPHelper sharedHelper]];
    
	[[iSpeechSDK sharedSDK] setAPIKey:@"developerdemokeydeveloperdemokey"];
	
    //TapForTap
#ifdef LITEVERSION
//    [TFTTapForTap initializeWithAPIKey:@"E8DB15BE08E53873038C7D6B71235B9E"];
#else
    
#endif
    
    

    return YES;
}

// FOR PUSH NOTIFICATIONS, THIS FUNCTION IS REQUIRED
- (void) onPushAccepted:(PushNotificationManager *)pushManager withNotification:(NSDictionary *)pushNotification {
    NSLog(@"Push notification received");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
     NSLog(@"App Exit 1");
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

	chngePWD=NO;
    isNewPattern=NO;
    isReEnterPattern=NO;
   // LoginUserID=nil;
    isnAvigateFromPattern=NO;
    iSBuyCLick=NO;
    
    NSLog(@"App Exit 2");
    /*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }


    iSBuyCLick=NO;
	 NSLog(@"App Exit 3");
    /*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
     NSLog(@"App Exit 4");
    
    chngePWD=NO;
    isNewPattern=NO;
    isReEnterPattern=NO;
    // LoginUserID=nil;
    isnAvigateFromPattern=NO;
    
    if(isFirstRun!=YES)
    {
        NSString *strValue=[self Authentication];
        
        if([strValue isEqualToString:@"true"])
        {
            
            UIViewController *viewController1;
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
            {
                viewController1 = [[UserLoginView alloc] initWithNibName:@"UserLoginView_Ipad" bundle:nil];
            }
            else {
                viewController1 = [[UserLoginView alloc] initWithNibName:@"UserLoginView" bundle:nil];
            }
            UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:viewController1];
            [viewController1 release]; viewController1 = nil;
            self.window.rootViewController = navigationController1;
            self.nav.navigationBar.tintColor=[UIColor blackColor];
            [self.window makeKeyAndVisible];
            
        }else
        {
            if (iSBuyCLick==YES) {
                
            }
            else
            {
                runCount = 0;
                if([[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"CheckRunCount"] intValue] < 2)
                {
                    runCount = [[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"CheckRunCount"] intValue];
                    WelcomeScreen *welcomeScreen;
                    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
                    {
                        welcomeScreen = [[WelcomeScreen alloc] initWithNibName:@"WelcomeScreen_ipad" bundle:nil];
                    }
                    else
                    {
                        welcomeScreen = [[WelcomeScreen alloc] initWithNibName:@"WelcomeScreen" bundle:nil];
                    }
                    navigationController1 = [[UINavigationController alloc] initWithRootViewController:welcomeScreen];
                    [welcomeScreen release];
                    welcomeScreen = nil;
                    self.window.rootViewController = navigationController1;
                    self.nav.navigationBar.tintColor=[UIColor redColor];
                    [self.window makeKeyAndVisible];
                    runCount ++;
                    NSLog(@"%d",runCount);
                    [GlobalFunctions setStringValueToUserDefaults:[NSString stringWithFormat:@"%d",runCount] ForKey:@"CheckRunCount"];
                }
                else
                {
                    if(iSBuyCLick == YES)
                    {
                        
                    }
                    else
                    {
                        DrawPatternLockViewController *drw=[[DrawPatternLockViewController alloc]init];
                        navigationController1 = [[UINavigationController alloc] initWithRootViewController:drw];
                        [drw release];
                        drw = nil;
                        self.window.rootViewController = navigationController1;
                        //self.nav.navigationBar.tintColor=[UIColor blackColor];
                        [self.window makeKeyAndVisible];
                    }
                }

              
            }
        }
    }
    else
    {
        isFirstRun=NO;
        BOOL success;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"SecretAppDB.sqlite3"];
        success = [fileManager fileExistsAtPath:writableDBPath];
        if (success)
        {
            [self BackUpOldDB];
            //[self FetchFromBackUp];
        }

        
    }
    /*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	 NSLog(@"App Exit 5");
    
    
    /*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

- (void) copyDatabaseIfNeeded
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
    NSLog(@"Path=== %@",dbPath);
	BOOL success = [fileManager fileExistsAtPath:dbPath];
	
	if(!success)
	{
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"SecretAppDB.sqlite3"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		if (!success)
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}

- (NSString *) getDBPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"SecretAppDB.sqlite3"];
}
- (void) copyDatabaseIfNeededNew
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPathNew];
    NSLog(@"Path=== %@",dbPath);
	BOOL success = [fileManager fileExistsAtPath:dbPath];
	
	if(!success)
	{
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"SecretAppDBNew.sqlite3"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		if (!success)
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}

- (NSString *) getDBPathNew
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"SecretAppDBNew.sqlite3"];
}

+(sqlite3 *) getDBConUserData
{
    sqlite3 *newDBconnection;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"SecretAppDB.sqlite3"];
    if (sqlite3_open([path UTF8String], &newDBconnection) == SQLITE_OK)
    {
        // NSLog(@"Database Successfully Opened");
    }
    else
    {
        NSLog(@"Error in opening database");
    }
    
    return newDBconnection;
}
+(sqlite3 *) getDBConUserDataNew
{
    sqlite3 *newDBconnection;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"SecretAppDBNew.sqlite3"];
    if (sqlite3_open([path UTF8String], &newDBconnection) == SQLITE_OK)
    {
        // NSLog(@"Database Successfully Opened");
    }
    else
    {
        NSLog(@"Error in opening database");
    }
    
    return newDBconnection;
}
-(void) BackUpOldDB
{
    NSLog(@"From BackUpDB");
    [self VerifyUserDB];
    [self AuntenticationCheckDB];
    [self autoLogOffDB];
    [self VerifyPatternDB];
    [self viewImageLogDB];
    [self albumDB];
    [self bookmarkDB];
    [self notesDB];
    [self contactsDB];
    [self audioDB];
    [self videoDB];
    [self musicDB];
    
}
-(void)FetchFromBackUp
{
    sqlite3 *db = [AppDelegate getDBConUserDataNew];
    NSMutableString *query;
    
    sqlite3_stmt *statement = nil;
    for (int i = 0; i < [lockArray count] ; i++)
    {
        AppDelegate *lock = [lockArray objectAtIndex:i];
        NSString *uname = [NSString stringWithFormat:@"%@",lock.userName];
        NSString *pwdtxt = [NSString stringWithFormat:@"%@",lock.userPassword];
        NSString *voicetxt = [NSString stringWithFormat:@"%@",lock.userVoiceText];
        NSString *patterncode = [NSString stringWithFormat:@"%@",lock.userPatternCode];
        NSString *decoyCode = [NSString stringWithFormat:@"%@",lock.userDecoyCode];
        NSString *pincodetxt = [NSString stringWithFormat:@"%@",lock.userPinCodeText];
        query = [NSMutableString stringWithFormat:@"insert into VerifyUserTbl(UserName,UserPasswordTxt,UserVoiceTxt,PatternCode,DecoyCode,UserPinCodeText) values ('%@','%@','%@','%@','%@','%@')",uname,pwdtxt,voicetxt,patterncode,decoyCode,pincodetxt];
        NSLog(@"%@",query);
        const char *sql = [query UTF8String];
        if(sqlite3_prepare_v2(db,sql, -1, &statement, NULL)!= SQLITE_OK)
            NSAssert1(0,@"error preparing statement in Insert",sqlite3_errmsg(db));
        else
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSLog(@"Record Inserted");
            }
        }
    }
    for (int i = 0; i < [authArray count] ; i++)
    {
        AppDelegate *auth = [authArray objectAtIndex:i];
        NSString *voiceAuth = [NSString stringWithFormat:@"%@",auth.authVoice];
        NSString *patternAuth = [NSString stringWithFormat:@"%@",auth.authPattern];
        NSString *pinAuth = [NSString stringWithFormat:@"%@",auth.authPincode];
        NSString *uid = [NSString stringWithFormat:@"%@",auth.LoginUserID];
               query = [NSMutableString stringWithFormat:@"insert into AuthentictionCheckTbl(VoiceAuth,PatternAuth,UserID,PinCodeAuth) values ('%@','%@','%@','%@')",voiceAuth,patternAuth,uid,pinAuth];
        NSLog(@"%@",query);
        const char *sql = [query UTF8String];
        if(sqlite3_prepare_v2(db,sql, -1, &statement, NULL)!= SQLITE_OK)
            NSAssert1(0,@"error preparing statement in Insert",sqlite3_errmsg(db));
        else
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSLog(@"Record Inserted");
            }
        }
    }
    
    for (int i = 0; i < [verifyPatternArray count] ; i++)
    {
        AppDelegate *pattern = [verifyPatternArray objectAtIndex:i];
        NSString *patterncode = [NSString stringWithFormat:@"%@",pattern.patternCode];
        NSString *decoypatterncode = [NSString stringWithFormat:@"%@",pattern.decoyPatternCode];
        query = [NSMutableString stringWithFormat:@"insert into VerifyPatternTbl(PatternCode,DecoyPatternCode) values ('%@','%@')",patterncode,decoypatterncode];
        NSLog(@"%@",query);
        const char *sql = [query UTF8String];
        if(sqlite3_prepare_v2(db,sql, -1, &statement, NULL)!= SQLITE_OK)
            NSAssert1(0,@"error preparing statement in Insert",sqlite3_errmsg(db));
        else
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSLog(@"Record Inserted");
            }
        }
    }

    for (int i = 0; i < [albumArray count] ; i++)
    {
        AppDelegate *album = [albumArray objectAtIndex:i];
        NSString *userID = [NSString stringWithFormat:@"%@",album.LoginUserID];
        NSString *imgpath = [NSString stringWithFormat:@"%@",album.albumImagePath];
        NSString *vdopath = [NSString stringWithFormat:@"%@",album.albumVideoPath];
        query = [NSMutableString stringWithFormat:@"insert into AlbumTbl(UserID,ImagePath,VideoPath) values ('%@','%@','%@')",userID,imgpath,vdopath];
        NSLog(@"%@",query);
        const char *sql = [query UTF8String];
        if(sqlite3_prepare_v2(db,sql, -1, &statement, NULL)!= SQLITE_OK)
            NSAssert1(0,@"error preparing statement in Insert",sqlite3_errmsg(db));
        else
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSLog(@"Record Inserted");
            }
        }
    }

    for (int i = 0; i < [bookmarkArray count] ; i++)
    {
        AppDelegate *bookmark = [bookmarkArray objectAtIndex:i];
        NSString *userID = [NSString stringWithFormat:@"%@",bookmark.LoginUserID];
        NSString *bookmarkTitle = [NSString stringWithFormat:@"%@",bookmark.bookmarkTblTitle];
        NSString *bookmarkUrl = [NSString stringWithFormat:@"%@",bookmark.bookmarkTblUrl];
        query = [NSMutableString stringWithFormat:@"insert into BookmarkTbl(UserID,BookmarkTitle,BookmarkURL) values ('%@','%@','%@')",userID,bookmarkTitle,bookmarkUrl];
        NSLog(@"%@",query);
        const char *sql = [query UTF8String];
        if(sqlite3_prepare_v2(db,sql, -1, &statement, NULL)!= SQLITE_OK)
            NSAssert1(0,@"error preparing statement in Insert",sqlite3_errmsg(db));
        else
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSLog(@"Record Inserted");
            }
        }
    }

    for (int i = 0; i < [notesArray count] ; i++)
    {
        AppDelegate *notes = [notesArray objectAtIndex:i];
        NSString *userID = [NSString stringWithFormat:@"%@",notes.LoginUserID];
        NSString *notetext = [NSString stringWithFormat:@"%@",notes.noteText];
        query = [NSMutableString stringWithFormat:@"insert into NotesTbl(UserID,NoteText) values ('%@','%@')",userID,notetext];
        NSLog(@"%@",query);
        const char *sql = [query UTF8String];
        if(sqlite3_prepare_v2(db,sql, -1, &statement, NULL)!= SQLITE_OK)
            NSAssert1(0,@"error preparing statement in Insert",sqlite3_errmsg(db));
        else
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSLog(@"Record Inserted");
            }
        }
    }

    for (int i = 0; i < [contactsArray count] ; i++)
    {
        AppDelegate *contacts = [contactsArray objectAtIndex:i];
        NSString *userID = [NSString stringWithFormat:@"%@",contacts.LoginUserID];
        NSString *conName = [NSString stringWithFormat:@"%@",contacts.contactName];
        NSString *conPhne = [NSString stringWithFormat:@"%@",contacts.contactPhone];
        NSString *conMail = [NSString stringWithFormat:@"%@",contacts.contactEmail];
        NSString *conRating = [NSString stringWithFormat:@"%@",contacts.contactRating];
        NSString *conNote = [NSString stringWithFormat:@"%@",contacts.contactNote];
        NSString *conPic = [NSString stringWithFormat:@"%@",contacts.contactPic];
        query = [NSMutableString stringWithFormat:@"insert into ContactTbl(UserID,ContName,ContPhone,ContactEmail,ContactRating,ContNote,ContPic) values ('%@','%@','%@','%@','%@','%@','%@')",userID,conName,conPhne,conMail,conRating,conNote,conPic];
        NSLog(@"%@",query);
        const char *sql = [query UTF8String];
        if(sqlite3_prepare_v2(db,sql, -1, &statement, NULL)!= SQLITE_OK)
            NSAssert1(0,@"error preparing statement in Insert",sqlite3_errmsg(db));
        else
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSLog(@"Record Inserted");
            }
        }
    }

    for (int i = 0; i < [audioArray count] ; i++)
    {
        AppDelegate *audio = [audioArray objectAtIndex:i];
        NSString *userID = [NSString stringWithFormat:@"%@",audio.LoginUserID];
        NSString *audTitle = [NSString stringWithFormat:@"%@",audio.audioTitle];
        NSString *audPath = [NSString stringWithFormat:@"%@",audio.audioPath];
        NSString *audDate = [NSString stringWithFormat:@"%@",audio.audioDate];
        NSString *audTime = [NSString stringWithFormat:@"%@",audio.audioTime];
        query = [NSMutableString stringWithFormat:@"insert into AudioTbl(UserID,AudioTitle,AudioPath,AudioTime,AudioDate) values ('%@','%@','%@','%@','%@')",userID,audTitle,audPath,audDate,audTime];
        NSLog(@"%@",query);
        const char *sql = [query UTF8String];
        if(sqlite3_prepare_v2(db,sql, -1, &statement, NULL)!= SQLITE_OK)
            NSAssert1(0,@"error preparing statement in Insert",sqlite3_errmsg(db));
        else
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSLog(@"Record Inserted");
            }
        }
    }

    for (int i = 0; i < [videoArray count] ; i++)
    {
        AppDelegate *video = [videoArray objectAtIndex:i];
        NSString *userID = [NSString stringWithFormat:@"%@",video.LoginUserID];
        NSString *vdoPath = [NSString stringWithFormat:@"%@",video.videoPath];
        NSString *vdoTitle = [NSString stringWithFormat:@"%@",video.videoTitle];
        NSString *vdoDate = [NSString stringWithFormat:@"%@",video.videoDate];
        NSString *vdorectime = [NSString stringWithFormat:@"%@",video.videoRecTime];
        query = [NSMutableString stringWithFormat:@"insert into VideoTbl(UserID,VideoPath,VideoTitle,VideoDate,VideoRecTime) values ('%@','%@','%@','%@','%@')",userID,vdoPath,vdoTitle,vdoDate,vdorectime];
        NSLog(@"%@",query);
        const char *sql = [query UTF8String];
        if(sqlite3_prepare_v2(db,sql, -1, &statement, NULL)!= SQLITE_OK)
            NSAssert1(0,@"error preparing statement in Insert",sqlite3_errmsg(db));
        else
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSLog(@"Record Inserted");
            }
        }
    }

    for (int i = 0; i < [musicArray count] ; i++)
    {
        AppDelegate *music = [musicArray objectAtIndex:i];
        NSString *userID = [NSString stringWithFormat:@"%@",music.LoginUserID];
        NSString *musictitle = [NSString stringWithFormat:@"%@",music.musicTitle];
        NSString *musicpath = [NSString stringWithFormat:@"%@",music.musicPath];
        NSString *musicdate = [NSString stringWithFormat:@"%@",music.musicDate];
        query = [NSMutableString stringWithFormat:@"insert into MusicTbl(UserID,MusicTitle,MuscPath,MusicDate) values ('%@','%@','%@','%@')",userID,musictitle,musicpath,musicdate];
        NSLog(@"%@",query);
        const char *sql = [query UTF8String];
        if(sqlite3_prepare_v2(db,sql, -1, &statement, NULL)!= SQLITE_OK)
            NSAssert1(0,@"error preparing statement in Insert",sqlite3_errmsg(db));
        else
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSLog(@"Record Inserted");
            }
        }
    }
    
    for (int i = 0; i < [autoLogOffArray count] ; i++)
    {
        AppDelegate *autoLog = [autoLogOffArray objectAtIndex:i];
        NSString *userID = [NSString stringWithFormat:@"%@",autoLog.LoginUserID];
        NSString *time = [NSString stringWithFormat:@"%@",autoLog.logOffTime];
        NSString *breakinphoto = [NSString stringWithFormat:@"%@",autoLog.logOfBrekinPhoto];
        NSString *loginphoto = [NSString stringWithFormat:@"%@",autoLog.logOffLoginPhoto];
        NSString *highquality = [NSString stringWithFormat:@"%@",autoLog.logOffHighQuality];
        NSString *duration = [NSString stringWithFormat:@"%@",autoLog.logOffDuration];
        NSString *transition = [NSString stringWithFormat:@"%@",autoLog.logOffTransition];
        NSString *repeat = [NSString stringWithFormat:@"%@",autoLog.logOffRepeat];
        NSString *shuffle = [NSString stringWithFormat:@"%@",autoLog.logOffShuffle];
        NSString *userdeskagent = [NSString stringWithFormat:@"%@",autoLog.logOffUseDeskAgent];
        NSString *facebook = [NSString stringWithFormat:@"%@",autoLog.logOffFacebook];
        query = [NSMutableString stringWithFormat:@"insert into AutoLogOffTbl(UserID,Time,BrekinPhoto,LoginPhoto,HighQuality,Duration,Transition,Repeat,Shuffle,UseDeskAgent,Facebook) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",userID,time,breakinphoto,loginphoto,highquality,duration,transition,repeat,shuffle,userdeskagent,facebook];
        NSLog(@"%@",query);
        const char *sql = [query UTF8String];
        if(sqlite3_prepare_v2(db,sql, -1, &statement, NULL)!= SQLITE_OK)
            NSAssert1(0,@"error preparing statement in Insert",sqlite3_errmsg(db));
        else
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSLog(@"Record Inserted");
            }
        }
    }

    for (int i = 0; i < [viewImageLogArray count] ; i++)
    {
        AppDelegate *viewImage = [viewImageLogArray objectAtIndex:i];
        NSString *userID = [NSString stringWithFormat:@"%@",viewImage.LoginUserID];
        NSString *imgpath = [NSString stringWithFormat:@"%@",viewImage.imgLogImagePath];
        NSString *isbreakin = [NSString stringWithFormat:@"%@",viewImage.imgLogIsBreakin];
        NSString *islogin = [NSString stringWithFormat:@"%@",viewImage.imgLogIsLogin];
        NSString *logintime = [NSString stringWithFormat:@"%@",viewImage.imgLogLoginTime];
        NSString *logindate = [NSString stringWithFormat:@"%@",viewImage.imgLogLoginDate];
        query = [NSMutableString stringWithFormat:@"insert into ViewImageLogtbl(UserID,ImagePath,isBreakIn,isLogin,logInTime,loginDate) values ('%@','%@','%@','%@','%@','%@')",userID,imgpath,isbreakin,islogin,logintime,logindate];
        NSLog(@"%@",query);
        const char *sql = [query UTF8String];
        if(sqlite3_prepare_v2(db,sql, -1, &statement, NULL)!= SQLITE_OK)
            NSAssert1(0,@"error preparing statement in Insert",sqlite3_errmsg(db));
        else
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSLog(@"Record Inserted");
            }
        }
    }

    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(db);
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *DBPath = [documentsDirectory stringByAppendingPathComponent:@"SecretAppDB.sqlite3"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:DBPath error:NULL];
    
}

-(void)VerifyUserDB
{
    sqlite3 *db = [AppDelegate getDBConUserData];
    NSMutableString *query;
    query = [NSMutableString stringWithFormat:@"select * from VerifyUserTbl"];
    const char *sql = [query UTF8String];
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(db,sql, -1, &statement, NULL)!= SQLITE_OK)
        NSAssert1(0,@"error preparing statement in BackUp",sqlite3_errmsg(db));
    else
    {
        [lockArray removeAllObjects];
        while(sqlite3_step(statement)==SQLITE_ROW)
        {
            const char *username = ((const char *) sqlite3_column_text(statement, 1) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 1);
            const char *userpasswordtext = ((const char *) sqlite3_column_text(statement, 2) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 2);
            const char *uservoicetext = ((const char *) sqlite3_column_text(statement, 3) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 3);
            const char *userpatterncode = ((const char *) sqlite3_column_text(statement, 4) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 4);
            const char *decoycode = ((const char *) sqlite3_column_text(statement, 5) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 5);
            const char *userpincodetext = ((const char *) sqlite3_column_text(statement, 6) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 6);
            AppDelegate *userObj = [[AppDelegate alloc] init];
            userObj.userName = [NSString stringWithUTF8String:username];
            userObj.userPassword = [NSString stringWithUTF8String:userpasswordtext];
            userObj.userVoiceText = [NSString stringWithUTF8String:uservoicetext];
            userObj.userPatternCode = [NSString stringWithUTF8String:userpatterncode];
            userObj.userDecoyCode = [NSString stringWithUTF8String:decoycode];
            userObj.userPinCodeText = [NSString stringWithUTF8String:userpincodetext];
            [lockArray addObject:userObj];
            NSLog(@"Array :::::%@",userObj);
        }
        
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(db);
    
}
-(void)VerifyPatternDB
{
    sqlite3 *db = [AppDelegate getDBConUserData];
    NSMutableString *query;
    query = [NSMutableString stringWithFormat:@"select * from VerifyPatternTbl"];
    const char *sql = [query UTF8String];
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(db,sql, -1, &statement, NULL)!= SQLITE_OK)
        NSAssert1(0,@"error preparing statement in BackUp",sqlite3_errmsg(db));
    else
    {
        [verifyPatternArray removeAllObjects];
        while(sqlite3_step(statement)==SQLITE_ROW)
        {
            const char *pttrncode = ((const char *) sqlite3_column_text(statement, 0) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 0);
            const char *decoypttrncode = ((const char *) sqlite3_column_text(statement, 1) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 1);
            
            AppDelegate *patternObj = [[AppDelegate alloc] init];
            patternObj.patternCode = [NSString stringWithUTF8String:pttrncode];
            patternObj.decoyPatternCode = [NSString stringWithUTF8String:decoypttrncode];
            [verifyPatternArray addObject:patternObj];
            NSLog(@"Array :::::%@",patternObj);
        }
        
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(db);

    
}
-(void)AuntenticationCheckDB
{
    sqlite3 *db = [AppDelegate getDBConUserData];
    NSMutableString *query;
    query = [NSMutableString stringWithFormat:@"select * from AuthentictionCheckTbl"];
    const char *sql = [query UTF8String];
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(db,sql, -1, &statement, NULL)!= SQLITE_OK)
        NSAssert1(0,@"error preparing statement in BackUp",sqlite3_errmsg(db));
    else
    {
        [authArray removeAllObjects];
        while(sqlite3_step(statement)==SQLITE_ROW)
        {
            const char *authvoice = ((const char *) sqlite3_column_text(statement, 0) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 0);
            const char *authpattern = ((const char *) sqlite3_column_text(statement, 1) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 1);
            const char *userid = ((const char *) sqlite3_column_text(statement, 2) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 2);
            const char *pincodeauth = ((const char *) sqlite3_column_text(statement, 3) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 3);
            AppDelegate *authObj = [[AppDelegate alloc] init];
            authObj.authVoice = [NSString stringWithUTF8String:authvoice];
            authObj.authPattern = [NSString stringWithUTF8String:authpattern];
            authObj.authPincode = [NSString stringWithUTF8String:pincodeauth];
            authObj.LoginUserID = [NSString stringWithUTF8String:userid];
            [authArray addObject:authObj];
            NSLog(@"Array :::::%@",authObj);
        }
        
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(db);
 
}

-(void)albumDB
{
    sqlite3 *db = [AppDelegate getDBConUserData];
    NSMutableString *query;
    query = [NSMutableString stringWithFormat:@"select * from AlbumTbl"];
    const char *sql = [query UTF8String];
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(db,sql, -1, &statement, NULL)!= SQLITE_OK)
        NSAssert1(0,@"error preparing statement in BackUp",sqlite3_errmsg(db));
    else
    {
        [albumArray removeAllObjects];
        while(sqlite3_step(statement)==SQLITE_ROW)
        {
            const char *userID = ((const char *) sqlite3_column_text(statement, 1) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 1);
            const char *imagePath = ((const char *) sqlite3_column_text(statement, 2) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 2);
            const char *videopath = ((const char *) sqlite3_column_text(statement, 3) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 3);
            
            AppDelegate *albumObj = [[AppDelegate alloc] init];
            albumObj.LoginUserID = [NSString stringWithUTF8String:userID];
            albumObj.albumImagePath = [NSString stringWithUTF8String:imagePath];
            albumObj.albumVideoPath = [NSString stringWithUTF8String:videopath];
            [albumArray addObject:albumObj];
            NSLog(@"Array :::::%@",albumObj);
        }
        
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(db);

}
-(void)bookmarkDB
{
    sqlite3 *db = [AppDelegate getDBConUserData];
    NSMutableString *query;
    query = [NSMutableString stringWithFormat:@"select * from BookmarkTbl"];
    const char *sql = [query UTF8String];
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(db,sql, -1, &statement, NULL)!= SQLITE_OK)
        NSAssert1(0,@"error preparing statement in BackUp",sqlite3_errmsg(db));
    else
    {
        [bookmarkArray removeAllObjects];
        while(sqlite3_step(statement)==SQLITE_ROW)
        {
            const char *userID = ((const char *) sqlite3_column_text(statement, 1) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 1);
            const char *bookmarkTitle = ((const char *) sqlite3_column_text(statement, 2) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 2);
            const char *bookmarkUrl = ((const char *) sqlite3_column_text(statement, 3) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 3);
            
            AppDelegate *bookmarkObj = [[AppDelegate alloc] init];
            bookmarkObj.LoginUserID = [NSString stringWithUTF8String:userID];
            bookmarkObj.bookmarkTblTitle = [NSString stringWithUTF8String:bookmarkTitle];
            bookmarkObj.bookmarkTblUrl = [NSString stringWithUTF8String:bookmarkUrl];
            [bookmarkArray addObject:bookmarkObj];
            NSLog(@"Array :::::%@",bookmarkObj);
        }
        
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(db);
    
}
-(void)notesDB
{
    sqlite3 *db = [AppDelegate getDBConUserData];
    NSMutableString *query;
    query = [NSMutableString stringWithFormat:@"select * from NotesTbl"];
    const char *sql = [query UTF8String];
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(db,sql, -1, &statement, NULL)!= SQLITE_OK)
        NSAssert1(0,@"error preparing statement in BackUp",sqlite3_errmsg(db));
    else
    {
        [notesArray removeAllObjects];
        while(sqlite3_step(statement)==SQLITE_ROW)
        {
            const char *userID = ((const char *) sqlite3_column_text(statement, 1) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 1);
            const char *notesText = ((const char *) sqlite3_column_text(statement, 2) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 2);
            
            AppDelegate *notesObj = [[AppDelegate alloc] init];
            notesObj.LoginUserID = [NSString stringWithUTF8String:userID];
            notesObj.noteText = [NSString stringWithUTF8String:notesText];
            [albumArray addObject:notesObj];
            NSLog(@"Array :::::%@",notesObj);
        }
        
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(db);
    
}
-(void)contactsDB
{
    sqlite3 *db = [AppDelegate getDBConUserData];
    NSMutableString *query;
    query = [NSMutableString stringWithFormat:@"select * from ContactTbl"];
    const char *sql = [query UTF8String];
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(db,sql, -1, &statement, NULL)!= SQLITE_OK)
        NSAssert1(0,@"error preparing statement in BackUp",sqlite3_errmsg(db));
    else
    {
        [contactsArray removeAllObjects];
        while(sqlite3_step(statement)==SQLITE_ROW)
        {
            const char *userID = ((const char *) sqlite3_column_text(statement, 1) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 1);
            const char *conName = ((const char *) sqlite3_column_text(statement, 2) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 2);
            const char *conPhne = ((const char *) sqlite3_column_text(statement, 3) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 3);
            const char *conMail = ((const char *) sqlite3_column_text(statement, 4) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 4);
            const char *conRating = ((const char *) sqlite3_column_text(statement, 5) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 5);
            const char *conNote = ((const char *) sqlite3_column_text(statement, 6) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 6);
            const char *conPic = ((const char *) sqlite3_column_text(statement, 7) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 7);
            
            AppDelegate *contactObj = [[AppDelegate alloc] init];
            contactObj.LoginUserID = [NSString stringWithUTF8String:userID];
            contactObj.contactName = [NSString stringWithUTF8String:conName];
            contactObj.contactPhone = [NSString stringWithUTF8String:conPhne];
            contactObj.contactEmail = [NSString stringWithUTF8String:conMail];
            contactObj.contactRating = [NSString stringWithUTF8String:conRating];
            contactObj.contactNote = [NSString stringWithUTF8String:conNote];
            contactObj.contactPic = [NSString stringWithUTF8String:conPic];
            [contactsArray addObject:contactObj];
            NSLog(@"Array :::::%@",contactObj);
        }
        
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(db);
    
}
-(void)audioDB
{
    sqlite3 *db = [AppDelegate getDBConUserData];
    NSMutableString *query;
    query = [NSMutableString stringWithFormat:@"select * from AudioTbl"];
    const char *sql = [query UTF8String];
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(db,sql, -1, &statement, NULL)!= SQLITE_OK)
        NSAssert1(0,@"error preparing statement in BackUp",sqlite3_errmsg(db));
    else
    {
        [audioArray removeAllObjects];
        while(sqlite3_step(statement)==SQLITE_ROW)
        {
            const char *userID = ((const char *) sqlite3_column_text(statement, 1) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 1);
            const char *audTitle = ((const char *) sqlite3_column_text(statement, 2) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 2);
            const char *audPath = ((const char *) sqlite3_column_text(statement, 3) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 3);
            const char *audTime = ((const char *) sqlite3_column_text(statement, 4) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 4);
            const char *audDate = ((const char *) sqlite3_column_text(statement, 5) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 5);

            AppDelegate *audioObj=[[AppDelegate alloc] init];
            audioObj.LoginUserID = [NSString stringWithUTF8String:userID];
            audioObj.audioTitle = [NSString stringWithUTF8String:audTitle];
            audioObj.audioPath = [NSString stringWithUTF8String:audPath];
            audioObj.audioTime = [NSString stringWithUTF8String:audTime];
            audioObj.audioDate = [NSString stringWithUTF8String:audDate];
            [audioArray addObject:audioObj];
            NSLog(@"Array :::::%@",audioObj);
        }
        
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(db);
    
}
-(void)videoDB
{
    sqlite3 *db = [AppDelegate getDBConUserData];
    NSMutableString *query;
    query = [NSMutableString stringWithFormat:@"select * from VideoTbl"];
    const char *sql = [query UTF8String];
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(db,sql, -1, &statement, NULL)!= SQLITE_OK)
        NSAssert1(0,@"error preparing statement in BackUp",sqlite3_errmsg(db));
    else
    {
        [videoArray removeAllObjects];
        while(sqlite3_step(statement)==SQLITE_ROW)
        {
            const char *userID = ((const char *) sqlite3_column_text(statement, 1) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 1);
            const char *vdoPath = ((const char *) sqlite3_column_text(statement, 2) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 2);
            const char *vdoTitle = ((const char *) sqlite3_column_text(statement, 3) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 3);
            const char *vdoDate = ((const char *) sqlite3_column_text(statement, 4) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 4);
            const char *vdoRecTime = ((const char *) sqlite3_column_text(statement, 5) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 5);
            
            AppDelegate *videoObj = [[AppDelegate alloc] init];
            videoObj.LoginUserID = [NSString stringWithUTF8String:userID];
            videoObj.videoPath = [NSString stringWithUTF8String:vdoPath];
            videoObj.videoTitle = [NSString stringWithUTF8String:vdoTitle];
            videoObj.videoDate = [NSString stringWithUTF8String:vdoDate];
            videoObj.videoRecTime = [NSString stringWithUTF8String:vdoRecTime];
            [videoArray addObject:videoObj];
            NSLog(@"Array :::::%@",videoObj);
        }
        
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(db);
    
}
-(void)musicDB
{
    sqlite3 *db = [AppDelegate getDBConUserData];
    NSMutableString *query;
    query = [NSMutableString stringWithFormat:@"select * from MusicTbl"];
    const char *sql = [query UTF8String];
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(db,sql, -1, &statement, NULL)!= SQLITE_OK)
        NSAssert1(0,@"error preparing statement in BackUp",sqlite3_errmsg(db));
    else
    {
        [musicArray removeAllObjects];
        while(sqlite3_step(statement)==SQLITE_ROW)
        {
            const char *userID = ((const char *) sqlite3_column_text(statement, 1) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 1);
            const char *musictitle = ((const char *) sqlite3_column_text(statement, 2) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 2);
            const char *musicpath = ((const char *) sqlite3_column_text(statement, 3) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 3);
            const char *musicdate = ((const char *) sqlite3_column_text(statement, 3) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 3);
            
            AppDelegate *musicObj = [[AppDelegate alloc] init];
            musicObj.LoginUserID = [NSString stringWithUTF8String:userID];
            musicObj.musicTitle = [NSString stringWithUTF8String:musictitle];
            musicObj.musicPath = [NSString stringWithUTF8String:musicpath];
            musicObj.musicDate = [NSString stringWithUTF8String:musicdate];
            [musicArray addObject:musicObj];
            NSLog(@"Array :::::%@",musicObj);
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(db);
    
    [self FetchFromBackUp];
}
-(void)autoLogOffDB
{
    sqlite3 *db = [AppDelegate getDBConUserData];
    NSMutableString *query;
    query = [NSMutableString stringWithFormat:@"select * from AutoLogOffTbl"];
    const char *sql = [query UTF8String];
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(db,sql, -1, &statement, NULL)!= SQLITE_OK)
        NSAssert1(0,@"error preparing statement in BackUp",sqlite3_errmsg(db));
    else
    {
        [autoLogOffArray removeAllObjects];
        while(sqlite3_step(statement)==SQLITE_ROW)
        {
            const char *userID = ((const char *) sqlite3_column_text(statement, 0) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 0);
            const char *time = ((const char *) sqlite3_column_text(statement, 1) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 1);
            const char *brekinphoto = ((const char *) sqlite3_column_text(statement, 2) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 2);
            const char *loginphoto = ((const char *) sqlite3_column_text(statement, 3) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 3);
            const char *highquality = ((const char *) sqlite3_column_text(statement, 4) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 4);
            const char *duration = ((const char *) sqlite3_column_text(statement, 5) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 5);
            const char *transition = ((const char *) sqlite3_column_text(statement, 6) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 6);
            const char *repeat = ((const char *) sqlite3_column_text(statement, 7) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 7);
            const char *shuffle = ((const char *) sqlite3_column_text(statement, 8) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement,8);
            const char *usedeskagent = ((const char *) sqlite3_column_text(statement, 9) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 9);
            const char *facebook = ((const char *) sqlite3_column_text(statement, 10) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 10);

            AppDelegate *autoLogObj = [[AppDelegate alloc] init];
            autoLogObj.LoginUserID = [NSString stringWithUTF8String:userID];
            autoLogObj.logOffTime = [NSString stringWithUTF8String:time];
            autoLogObj.logOfBrekinPhoto = [NSString stringWithUTF8String:brekinphoto];
            autoLogObj.logOffLoginPhoto = [NSString stringWithUTF8String:loginphoto];
            autoLogObj.logOffHighQuality = [NSString stringWithUTF8String:highquality];
            autoLogObj.logOffDuration = [NSString stringWithUTF8String:duration];
            autoLogObj.logOffTransition = [NSString stringWithUTF8String:transition];
            autoLogObj.logOffRepeat = [NSString stringWithUTF8String:repeat];
            autoLogObj.logOffShuffle = [NSString stringWithUTF8String:shuffle];
            autoLogObj.logOffUseDeskAgent = [NSString stringWithUTF8String:usedeskagent];
            autoLogObj.logOffFacebook = [NSString stringWithUTF8String:facebook];
            [autoLogOffArray addObject:autoLogObj];
            NSLog(@"Array :::::%@",autoLogObj);
        }
        
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(db);
}
-(void)viewImageLogDB
{
    sqlite3 *db = [AppDelegate getDBConUserData];
    NSMutableString *query;
    query = [NSMutableString stringWithFormat:@"select * from ViewImageLogtbl"];
    const char *sql = [query UTF8String];
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(db,sql, -1, &statement, NULL)!= SQLITE_OK)
        NSAssert1(0,@"error preparing statement in BackUp",sqlite3_errmsg(db));
    else
    {
        [viewImageLogArray removeAllObjects];
        while(sqlite3_step(statement)==SQLITE_ROW)
        {
            const char *userID = ((const char *) sqlite3_column_text(statement, 1) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 1);
            const char *imgpath = ((const char *) sqlite3_column_text(statement, 2) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 2);
            const char *isbreakin = ((const char *) sqlite3_column_text(statement, 3) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 3);
            const char *islogin = ((const char *) sqlite3_column_text(statement, 4) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 4);
            const char *logintime = ((const char *) sqlite3_column_text(statement, 5) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 5);
            const char *logindate = ((const char *) sqlite3_column_text(statement, 6) == NULL) ? [[NSString stringWithFormat:@""] UTF8String] : (const char *) sqlite3_column_text(statement, 6);
            AppDelegate *viewImageLogObj = [[AppDelegate alloc] init];
            viewImageLogObj.LoginUserID = [NSString stringWithUTF8String:userID];
            viewImageLogObj.imgLogImagePath = [NSString stringWithUTF8String:imgpath];
            viewImageLogObj.imgLogIsBreakin = [NSString stringWithUTF8String:isbreakin];
            viewImageLogObj.imgLogIsLogin = [NSString stringWithUTF8String:islogin];
            viewImageLogObj.imgLogLoginTime = [NSString stringWithUTF8String:logintime];
            viewImageLogObj.imgLogLoginDate = [NSString stringWithUTF8String:logindate];
            [viewImageLogArray addObject:viewImageLogObj];
            NSLog(@"Array :::::%@",viewImageLogObj);
        }
        
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(db);
}

-(NSString *) Authentication
{
    NSString *strReturn=@"false";
      NSString *databasepath=[self getDBPathNew];
        if (sqlite3_open([databasepath UTF8String], &dbSecret) == SQLITE_OK) 
        {
            NSString *selectSql = [NSString stringWithFormat:@"select VoiceAuth from AuthentictionCheckTbl where UserID = %@",LoginUserID];
            
            NSLog(@"Query : %@",selectSql);
            const char *sqlStatement = [selectSql UTF8String];
            sqlite3_stmt *query_stmt;
            
            if(sqlite3_prepare_v2(dbSecret, sqlStatement, -1, &query_stmt, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(query_stmt) == SQLITE_ROW) 
                {
                    NSString *checkValue = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(query_stmt, 0)];
                    
                    NSLog(@"User id=== %@",checkValue);
                    
                    
                    if([ checkValue isEqualToString: @"true"])
                    {
                        //sqlite3_close(dbSecret);  
                        strReturn= @"true";
                    }
                    else
                    {
                        //sqlite3_close(dbSecret);  
                      strReturn= @"false";
                    }
                }     
               
                sqlite3_finalize(query_stmt);
            }else {
                
            }
        }
        sqlite3_close(dbSecret);  
    return strReturn;
}

#pragma mark - GADBannerView

- (void)showGADBannerView:(UIViewController *)viewController {
#ifdef LITEVERSION
    if([[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"BreakInPackagePurchased"] isEqualToString:@"YES"])
    {
        if(self.bannerView) {
            [self.bannerView removeFromSuperview];
            self.bannerView = nil;
        }
        return;
    }
    if([[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"AdPackagePurchased"] isEqualToString:@"YES"]) {
        if(self.bannerView) {
            [self.bannerView removeFromSuperview];
            self.bannerView = nil;
        }
        return;
    }
    if(!self.bannerView) {
        self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
        [self.window addSubview:self.bannerView];
        self.bannerView.adUnitID = kGADBannerUnitID;
        self.bannerView.rootViewController = self.window.rootViewController;
        GADRequest *request = [GADRequest request];
        [self.bannerView loadRequest:request];
    }
    
    CGRect bannerFrame = self.bannerView.frame;
    bannerFrame.origin.y = self.window.bounds.size.height - bannerFrame.size.height;
    if([viewController respondsToSelector:@selector(toolbar)]) {
        UIToolbar *toolbar = [viewController performSelector:@selector(toolbar)];
        bannerFrame.origin.y -= toolbar.bounds.size.height;
        
    }
    [self.bannerView setFrame:bannerFrame];
    
    self.bannerView.hidden = NO;
#else
#endif
}

- (void)hideGADBannerView {
#ifdef LITEVERSION
    if([[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"BreakInPackagePurchased"] isEqualToString:@"YES"])
    {
        if(self.bannerView) {
            [self.bannerView removeFromSuperview];
            self.bannerView = nil;
        }
        return;
    }
    if([[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"AdPackagePurchased"] isEqualToString:@"YES"]) {
        if(self.bannerView) {
            [self.bannerView removeFromSuperview];
            self.bannerView = nil;
        }
        return;
    }
    if(self.bannerView)
        self.bannerView.hidden = YES;
#else
#endif
}

@end
