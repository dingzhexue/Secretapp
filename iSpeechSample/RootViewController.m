//
//  RootViewController.m
//  SecretApp
//
//  Created by c62 on 09/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

#import "MenuCustomCell_iPhone.h"
#import "DefaultAlbumView.h"
#import "NotesView_iPhone.h"
#import "AudioRecorder.h"
#import "ContactListView.h"
#import "VideoView.h"
#import "MusicView.h"
#import "BookmarkView.h"
#import "PinCodeViewController.h"
#import "Reachability.h"
#import "IAPHelper.h"
#import "InAppRageIAPHelper.h"
#import "WelcomeScreen.h"
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"
#import "GADInterstitial.h"

@interface RootViewController () <GADInterstitialDelegate, GADBannerViewDelegate>

@property (nonatomic, strong) GADInterstitial *interstitial;


@end

@implementation RootViewController

@synthesize img,dispImgView,closeImgBtn;
@synthesize hud;

@synthesize facebook;
@synthesize facebookLikeView;
@synthesize viewFacebookBar;
@synthesize btnFacebookLike,likeVw;



bool productPurchased,isLiked;
static NSString* kAppId = @"145792598897737";

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    [closeImgBtn release];
    [dispImgView release];
    [img release];
    [super dealloc];
}


/* New Designing */

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.barTintColor=[UIColor blackColor];
        self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    }
    else
    {
        self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    }
    facebook = [[Facebook alloc]initWithAppId:kAppId andDelegate:self];
    dispImgView.hidden=true;
    [self.navigationController setNavigationBarHidden:NO];
    UIBarButtonItem *lefttButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings"
                                                                    style:UIBarButtonSystemItemDone target:self action:@selector(BtnSettingsClicked:)];
    self.navigationItem.leftBarButtonItem = lefttButton;
    [lefttButton release];
    
    likeVw.hidden=true;
    
    app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //    WelcomeScreen *welcomeScreen;
    //    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    //    {
    //        welcomeScreen = [[WelcomeScreen alloc] initWithNibName:@"WelcomeScreen_ipad" bundle:nil];
    //    }
    //    else
    //    {
    //        welcomeScreen = [[WelcomeScreen alloc] initWithNibName:@"WelcomeScreen" bundle:nil];
    //    }
    //    [self.navigationController presentModalViewController:welcomeScreen animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [app hideGADBannerView];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    }
    self.navigationController.navigationBar.hidden=NO;
    UIBarButtonItem *lefttButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings"
                                                                    style:UIBarButtonSystemItemDone target:self action:@selector(BtnSettingsClicked:)];
    self.navigationItem.leftBarButtonItem = lefttButton;
    [lefttButton release];
    likeVw.hidden=YES;
    
    self.title=@"All Albums";
    
#ifdef PROVERSION
    productPurchased = YES;
    self.navigationItem.rightBarButtonItem = nil;
#else
    productPurchased = NO;
    UIButton *upgradeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    upgradeButton.frame = CGRectMake(0, 0, 75, 30);
    [upgradeButton setImage:[UIImage imageNamed:@"iphone_upgrade.png"] forState:UIControlStateNormal];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]  initWithCustomView:upgradeButton];
    [upgradeButton addTarget:self action:@selector(btnUpgradeApp:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
    if (app.flagTapForTap) {
        self.interstitial = [GADHelper createAndLoadInterstitial:self];
        app.flagTapForTap = false;
    }
    if(![[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"BreakInPackagePurchased"] isEqualToString:@"YES"])
    {
        if(![[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"AdPackagePurchased"] isEqualToString:@"YES"])
        {

        if (app.flagTapForTap) {
            self.interstitial = [GADHelper createAndLoadInterstitial:self];
            app.flagTapForTap = false;
        }
        }
    }
    
#endif
    
    NSLog(@"Started In App");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
}

#pragma mark - Upgrade App

-(void)RestorePreviousPurchase
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)timeout:(id)arg {
    
    _hud.labelText = @"Timeout!";
    _hud.detailsLabelText = @"Please try again later.";
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    _hud.mode = MBProgressHUDModeCustomView;
    [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:3.0];
}

- (void)dismissHUD:(id)arg
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    _hud = nil;
}

- (void)productsLoaded:(NSNotification *)notification {
    NSLog(@"productsLoaded");
    NSLog(@"app.Purchase_array%@ ",app.Purchase_array);
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}

- (void)productPurchased:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    NSString *productIdentifier = (NSString *)notification.object;
    NSLog(@"Purchased: %@", productIdentifier);
    
    [app.Purchase_array removeAllObjects];
    [[InAppRageIAPHelper alloc]init];
    if (app.Purchase_array.count>0) {
        productPurchased = YES;
        
        [view removeFromSuperview];
        self.navigationItem.rightBarButtonItem = nil;
    }
    else
    {
        productPurchased = NO;
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"UPGRADE NOW!"
                                                                        style:UIBarButtonSystemItemDone target:self action:@selector(btnUpgradeApp:)];
        rightButton.tintColor = [UIColor colorWithRed:20.0/255.0 green:183.0/255.0 blue:46.0/255.0 alpha:1.0];
        self.navigationItem.rightBarButtonItem = rightButton;
        [rightButton release];
#ifdef LITEVERSION
        if(![[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"BreakInPackagePurchased"] isEqualToString:@"YES"])
        {
            if(![[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"AdPackagePurchased"] isEqualToString:@"YES"])
            {
                /*self.interstitial = [TFTInterstitial interstitialWithDelegate:self];
                 [self.interstitial load];
                 [self.interstitial showWithViewController: self];*/
                self.interstitial = [GADHelper createAndLoadInterstitial:self];
            }
            
        }
#else
#endif
    }
}

- (void)productPurchaseFailed:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notification.object;
    if (transaction.error.code != SKErrorPaymentCancelled) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error!"
                                                         message:transaction.error.localizedDescription
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil] autorelease];
        
        [alert show];
    }
}

-(IBAction)btnUpgradeApp:(id)sender
{
    NSLog(@"Buy Button Clicked...");
    
    NSLog(@"Screen Height :: %f Width :: %f",self.view.bounds.size.height,self.view.bounds.size.width);
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        
        view = [[UIView alloc]initWithFrame:self.view.frame];
        view.backgroundColor = [[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.7];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            view.frame=CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height);
        }
        
        UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(120, 110, 550, 560)];
        
        UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(60, 40, 400, 100)];
        lbl1.text = @"To Gain Access To All Unlimited Features, additional features,";
        lbl1.numberOfLines = 3;
        lbl1.font = [UIFont systemFontOfSize:25.0];
        lbl1.lineBreakMode = NSLineBreakByWordWrapping;
        lbl1.textAlignment = NSTextAlignmentCenter;
        lbl1.textColor = [UIColor whiteColor];
        lbl1.backgroundColor = [UIColor blackColor];
        
        UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 140, 400, 330)];
        lbl2.text = @"1.NO ADS \n2.BREAK-IN ATTEMPTS FEATURE, \n you will be able to view any persons who try and attempt to access your information \n3.SELECT ACTIVE TYPE, you will \n be able to Change your passcode & \nchange the lock Type Voice Authentication, X9 Lock Code, Pin Code \n4. Video Folder, Store a video & record using the built in recorder";
        lbl2.numberOfLines = 10;
        lbl2.font = [UIFont systemFontOfSize:25.0];
        lbl2.textAlignment = NSTextAlignmentCenter;
        lbl2.lineBreakMode = NSLineBreakByWordWrapping;
        lbl2.textColor = [UIColor whiteColor];
        lbl2.backgroundColor = [UIColor blackColor];
        
        //        UILabel *lbl3 = [[UILabel alloc]initWithFrame:CGRectMake(160, 250, 80, 30)];
        //        lbl3.text = @"$1.99";
        //        lbl3.numberOfLines = 1;
        //        lbl3.font = [UIFont systemFontOfSize:25.0];
        //        lbl3.lineBreakMode = UILineBreakModeWordWrap;
        //        lbl3.textAlignment = UITextAlignmentCenter;
        //        lbl3.textColor = [UIColor whiteColor];
        //        lbl3.backgroundColor = [UIColor blackColor];
        //
        UIButton *btnBuy = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnBuy addTarget:self action:@selector(goProClicked:) forControlEvents:UIControlEventTouchDown];
        [btnBuy setTitle:@"Go Pro!" forState:UIControlStateNormal];
        [btnBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnBuy.titleLabel.font = [UIFont systemFontOfSize:24.0];
        btnBuy.frame = CGRectMake(160, 470, 220, 60);
        UIImage *backImage = [UIImage imageNamed:@"iphone-buy.png"];
        [btnBuy setBackgroundImage:backImage forState:UIControlStateNormal];
        
//        UIButton *btnNoThanks = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [btnNoThanks addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchDown];
//        [btnNoThanks setTitle:@"Maybe Later" forState:UIControlStateNormal];
//        [btnNoThanks setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        btnNoThanks.titleLabel.font = [UIFont systemFontOfSize:24.0];
//        btnNoThanks.frame = CGRectMake(260, 460, 220, 60);
//        UIImage *backImage1 = [UIImage imageNamed:@"iphone-buy.png"];
//        [btnNoThanks setBackgroundImage:backImage1 forState:UIControlStateNormal];
        
        
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchDown];
        
        UIImage *image = [UIImage imageNamed:@"close-right-part.png"];
        [btnCancel setImage:image forState:UIControlStateNormal];
        btnCancel.frame = CGRectMake(515, 0, 35, 35);
        //btnCancel.frame = CGRectMake(280, 30, 35, 35);
        
        [subView addSubview:lbl1];
        [subView addSubview:lbl2];
        // [subView addSubview:lbl3];
        [subView addSubview:btnBuy];
//        [subView addSubview:btnNoThanks];
        [subView addSubview:btnCancel];
        
        [view addSubview:subView];
        
        [subView.layer setMasksToBounds:YES];
        subView.backgroundColor = [UIColor blackColor];
        
        (subView.layer).cornerRadius = 10.0;
        subView.backgroundColor = [UIColor blackColor];
        (subView.layer).cornerRadius = 10.0;
        (subView.layer).borderColor = [UIColor whiteColor].CGColor;
        (subView.layer).borderWidth = 3.0;
        
        //[self.view addSubview:btnCancel];
        [self.view addSubview:view];
    }
    else
    {
        view = [[UIView alloc]initWithFrame:self.view.frame];
        view.backgroundColor = [[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.7];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            view.frame=CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height);
        }
        CGSize result = [UIScreen mainScreen].bounds.size;
        UIView *subView;
        if(result.height < 568)
        {
            subView = [[UIView alloc] initWithFrame:CGRectMake(30,10,250,400)];
        }
        else
        {
            subView = [[UIView alloc]initWithFrame:CGRectMake(30, 40, 250, 400)];
        }
        UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 210, 60)];
        lbl1.text = @"To Gain Access To All Unlimited Features, additional features,";
        lbl1.numberOfLines = 3;
        lbl1.font = [UIFont systemFontOfSize:15.0];
        lbl1.lineBreakMode = NSLineBreakByWordWrapping;
        lbl1.textAlignment = NSTextAlignmentCenter;
        lbl1.textColor = [UIColor whiteColor];
        lbl1.backgroundColor = [UIColor blackColor];
        
        UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 210, 300)];
        lbl2.text = @"1.NO ADS \n2.BREAK-IN ATTEMPTS FEATURE, \n you will be able to view any persons who try and attempt to access your information \n3.SELECT ACTIVE TYPE, you will be able to Change your passcode & change the lock Type Voice Authentication, X9 Lock Code, Pin Code \n4. Video Folder, Store a video & record using the built in recorder";
        lbl2.numberOfLines = 20;
        lbl2.font = [UIFont systemFontOfSize:15.0];
        lbl2.lineBreakMode = NSLineBreakByWordWrapping;
        lbl2.textAlignment = NSTextAlignmentCenter;
        lbl2.textColor = [UIColor whiteColor];
        lbl2.backgroundColor = [UIColor blackColor];
        
        //        UILabel *lbl3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 170, 210, 30)];
        //        lbl3.text = @"$1.99";
        //        lbl3.numberOfLines = 1;
        //        lbl3.font = [UIFont systemFontOfSize:15.0];
        //        lbl3.lineBreakMode = UILineBreakModeWordWrap;
        //        lbl3.textAlignment = UITextAlignmentCenter;
        //        lbl3.textColor = [UIColor whiteColor];
        //        lbl3.backgroundColor = [UIColor blackColor];
        
        UIButton *btnBuy = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnBuy addTarget:self action:@selector(goProClicked:) forControlEvents:UIControlEventTouchDown];
        [btnBuy setTitle:@"Go Pro!" forState:UIControlStateNormal];
        [btnBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnBuy.frame = CGRectMake(65, 340, 120, 50);
        UIImage *backImage = [UIImage imageNamed:@"iphone-buy.png"];
        [btnBuy setBackgroundImage:backImage forState:UIControlStateNormal];
        
//        UIButton *btnNoThanks = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [btnNoThanks addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchDown];
//        [btnNoThanks setTitle:@"Maybe Later" forState:UIControlStateNormal];
//        [btnNoThanks setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        btnNoThanks.frame = CGRectMake(130, 350, 120, 50);
//        UIImage *backImage1 = [UIImage imageNamed:@"iphone-buy.png"];
//        [btnNoThanks setBackgroundImage:backImage1 forState:UIControlStateNormal];
        
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchDown];
        
        UIImage *image = [UIImage imageNamed:@"close-right-part.png"];
        [btnCancel setImage:image forState:UIControlStateNormal];
        btnCancel.frame = CGRectMake(215, 0, 35, 35);
        //btnCancel.frame = CGRectMake(280, 30, 35, 35);
        
        [subView addSubview:lbl1];
        [subView addSubview:lbl2];
        // [subView addSubview:lbl3];
        [subView addSubview:btnBuy];
//        [subView addSubview:btnNoThanks];
        [subView addSubview:btnCancel];
        
        [view addSubview:subView];
        
        [subView.layer setMasksToBounds:YES];
        subView.backgroundColor = [UIColor blackColor];
        
        (subView.layer).cornerRadius = 10.0;
        subView.backgroundColor = [UIColor blackColor];
        (subView.layer).cornerRadius = 10.0;
        (subView.layer).borderColor = [UIColor whiteColor].CGColor;
        (subView.layer).borderWidth = 3.0;
        
        //[self.view addSubview:btnCancel];
        [self.view addSubview:view];
    }
}


-(void)cancelClick
{
    [view removeFromSuperview];
    NSLog(@"Cancel Button Clicked...");
}

#pragma mark - Like Us On Facebook

-(IBAction)clickToLikeUsOnFacebook:(id)sender
{
    int x = 0;
    int y = 0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        x = 90;
        y = 24;
    }
    else
    {
        x = 80;
        y = 8;
    }
    if ((self.viewFacebookBar.subviews).count>0)
    {
        [self.facebookLikeView removeFromSuperview];
    }
    self.facebookLikeView=[[FacebookLikeView alloc]initWithFrame:CGRectMake(viewFacebookBar.frame.size.width - x, y, x, 22)];
    
    self.facebookLikeView.href = [NSURL URLWithString:@"http://www.facebook.com/pages/Secret-App-Private-Albums-Manger/419463658136588"];
    self.facebookLikeView.layout = @"button_count";
    self.facebookLikeView.showFaces = NO;
    self.facebookLikeView.delegate=self;
    //self.facebookLikeView.hidden = NO;
    self.facebookLikeView.alpha = 0;
    [self.facebookLikeView load];
    
    [self.viewFacebookBar addSubview:self.facebookLikeView];
    
    [self.viewFacebookBar bringSubviewToFront:self.facebookLikeView];
    
    if (!isLiked)
    {
        [facebook authorize:@[]];
        isLiked=YES;
    }
    else
    {
        isLiked=NO;
    }
    
    
    
    //  [self.facebookLikeView release];
}

- (void)facebookLikeViewRequiresLogin:(FacebookLikeView *)aFacebookLikeView
{
    
    [facebook authorize:@[]];
}

- (void)facebookLikeViewDidRender:(FacebookLikeView *)aFacebookLikeView {
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDelay:0.5];
    self.facebookLikeView.alpha = 1;
    [UIView commitAnimations];
}

- (void)facebookLikeViewDidLike:(FacebookLikeView *)aFacebookLikeView
{
    //    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Liked"
    //                                                     message:@"You liked Secret App. Thanks!"
    //                                                    delegate:self
    //                                           cancelButtonTitle:@"OK"
    //                                           otherButtonTitles:nil] autorelease];
    
    isLiked=YES;
    [self clickToLikeUsOnFacebook:nil];
    
    //    [alert show];
}

- (void)facebookLikeViewDidUnlike:(FacebookLikeView *)aFacebookLikeView
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Unliked"
                                                     message:@"You unliked Secret Card Vault on facebook. Where's the love?"
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil] autorelease];
    [alert show];
}

#pragma mark - Album Method

-(IBAction)defAlbumClicked:(id)sender{
    NSLog(@"Tag::: %ld",(long)[sender tag]);
    // [self OpenPhotoGallery];
    
    DefaultAlbumView *defAlVw;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        defAlVw = [[DefaultAlbumView alloc] initWithNibName:@"DefaultAlbumView_ipad" bundle:nil];
    }
    else {
        defAlVw = [[DefaultAlbumView alloc] initWithNibName:@"DefaultAlbumView" bundle:nil];
    }
    [self.navigationController pushViewController:defAlVw animated:YES];
    
    //[defAlVw release];
}

-(IBAction)BookmarkClicked:(id)sender{
    
    NSLog(@"Tag::: %ld",(long)[sender tag]);
    
    BookmarkView *bookvw;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        bookvw = [[BookmarkView alloc] initWithNibName:@"BookmarkView_ipad" bundle:nil];
    }
    else {
        bookvw = [[BookmarkView alloc] initWithNibName:@"BookmarkView" bundle:nil];
    }
    
    [self.navigationController pushViewController:bookvw animated:YES];
    //[bookvw release];
}

-(IBAction)NotesClicked:(id)sender{
    NSLog(@"Tag::: %ld",(long)[sender tag]);
    NSLog(@"Notes...");
    
    NotesView_iPhone *notesvw;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        notesvw = [[NotesView_iPhone alloc] initWithNibName:@"NotesView_ipad" bundle:nil];
    }
    else {
        notesvw = [[NotesView_iPhone alloc] initWithNibName:@"NotesView_iPhone" bundle:nil];
    }
    
    [self.navigationController pushViewController:notesvw animated:YES];
    //[notesvw release];
}

-(IBAction)AudioRecordClicked:(id)sender{
    NSLog(@"Tag::: %ld",(long)[sender tag]);
    
    
    
    AudioRecorder *arec;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        arec = [[AudioRecorder alloc] initWithNibName:@"AudioRecorder_ipad" bundle:nil];
    }
    else {
        arec = [[AudioRecorder alloc] initWithNibName:@"AudioRecorder" bundle:nil];
    }
    
    
    //    AudioRecorder *arec=[[AudioRecorder alloc] initWithNibName:@"AudioRecorder" bundle:nil];
    [self.navigationController pushViewController:arec animated:YES];
    //[arec release];
}

-(IBAction)ContactsClicked:(id)sender{
    NSLog(@"Tag::: %ld",(long)[sender tag]);
    
    ContactListView *contvw;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        contvw = [[ContactListView alloc] initWithNibName:@"ContactListView_ipad" bundle:nil];
    }
    else {
        contvw = [[ContactListView alloc] initWithNibName:@"ContactListView" bundle:nil];
    }
    
    
    // ContactListView *contvw=[[ContactListView alloc] initWithNibName:@"ContactListView" bundle:nil];
    [self.navigationController pushViewController:contvw animated:YES];
    //[contvw release];
}

-(IBAction)VideoClicked:(id)sender{
    NSLog(@"Tag::: %ld",(long)[sender tag]);
#ifdef PROVERSION
    VideoView *videoVW;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        videoVW = [[VideoView alloc] initWithNibName:@"VideoView_ipad" bundle:nil];
    }
    else {
        videoVW = [[VideoView alloc] initWithNibName:@"VideoView" bundle:nil];
    }
    
    
    // VideoView *videoVW=[[VideoView alloc]initWithNibName:@"VideoView" bundle:nil];
    [self.navigationController pushViewController:videoVW animated:YES];
    //[videoVW release];
#else
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        
        view = [[UIView alloc]initWithFrame:self.view.frame];
        view.backgroundColor = [[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.7];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            view.frame=CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height);
        }
        
        UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(120, 110, 550, 560)];
        
        UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(60, 40, 400, 100)];
        lbl1.text = @"To Gain Access To All Unlimited Features, additional features,";
        lbl1.numberOfLines = 3;
        lbl1.font = [UIFont systemFontOfSize:25.0];
        lbl1.lineBreakMode = NSLineBreakByWordWrapping;
        lbl1.textAlignment = NSTextAlignmentCenter;
        lbl1.textColor = [UIColor whiteColor];
        lbl1.backgroundColor = [UIColor blackColor];
        
        UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 140, 400, 330)];
        lbl2.text = @"1.NO ADS \n2.BREAK-IN ATTEMPTS FEATURE, \n you will be able to view any persons who try and attempt to access your information \n3.SELECT ACTIVE TYPE, you will \n be able to Change your passcode & \nchange the lock Type Voice Authentication, X9 Lock Code, Pin Code \n4. Video Folder, Store a video & record using the built in recorder";
        lbl2.numberOfLines = 10;
        lbl2.font = [UIFont systemFontOfSize:25.0];
        lbl2.textAlignment = NSTextAlignmentCenter;
        lbl2.lineBreakMode = NSLineBreakByWordWrapping;
        lbl2.textColor = [UIColor whiteColor];
        lbl2.backgroundColor = [UIColor blackColor];
        
        //        UILabel *lbl3 = [[UILabel alloc]initWithFrame:CGRectMake(160, 250, 80, 30)];
        //        lbl3.text = @"$1.99";
        //        lbl3.numberOfLines = 1;
        //        lbl3.font = [UIFont systemFontOfSize:25.0];
        //        lbl3.lineBreakMode = UILineBreakModeWordWrap;
        //        lbl3.textAlignment = UITextAlignmentCenter;
        //        lbl3.textColor = [UIColor whiteColor];
        //        lbl3.backgroundColor = [UIColor blackColor];
        //
        UIButton *btnBuy = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnBuy addTarget:self action:@selector(goProClicked:) forControlEvents:UIControlEventTouchDown];
        [btnBuy setTitle:@"Go Pro!" forState:UIControlStateNormal];
        [btnBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnBuy.titleLabel.font = [UIFont systemFontOfSize:24.0];
        btnBuy.frame = CGRectMake(160, 470, 220, 60);
        UIImage *backImage = [UIImage imageNamed:@"iphone-buy.png"];
        [btnBuy setBackgroundImage:backImage forState:UIControlStateNormal];
        
//        UIButton *btnNoThanks = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [btnNoThanks addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchDown];
//        [btnNoThanks setTitle:@"Maybe Later" forState:UIControlStateNormal];
//        [btnNoThanks setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        btnNoThanks.titleLabel.font = [UIFont systemFontOfSize:24.0];
//        btnNoThanks.frame = CGRectMake(260, 460, 220, 60);
//        UIImage *backImage1 = [UIImage imageNamed:@"iphone-buy.png"];
//        [btnNoThanks setBackgroundImage:backImage1 forState:UIControlStateNormal];
        
        
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchDown];
        
        UIImage *image = [UIImage imageNamed:@"close-right-part.png"];
        [btnCancel setImage:image forState:UIControlStateNormal];
        btnCancel.frame = CGRectMake(515, 0, 35, 35);
        //btnCancel.frame = CGRectMake(280, 30, 35, 35);
        
        [subView addSubview:lbl1];
        [subView addSubview:lbl2];
        // [subView addSubview:lbl3];
        [subView addSubview:btnBuy];
//        [subView addSubview:btnNoThanks];
        [subView addSubview:btnCancel];
        
        [view addSubview:subView];
        
        [subView.layer setMasksToBounds:YES];
        subView.backgroundColor = [UIColor blackColor];
        
        (subView.layer).cornerRadius = 10.0;
        subView.backgroundColor = [UIColor blackColor];
        (subView.layer).cornerRadius = 10.0;
        (subView.layer).borderColor = [UIColor whiteColor].CGColor;
        (subView.layer).borderWidth = 3.0;
        
        //[self.view addSubview:btnCancel];
        [self.view addSubview:view];
    }
    else
    {
        view = [[UIView alloc]initWithFrame:self.view.frame];
        view.backgroundColor = [[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.7];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            view.frame=CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height);
        }
        CGSize result = [UIScreen mainScreen].bounds.size;
        UIView *subView;
        if(result.height < 568)
        {
            subView = [[UIView alloc] initWithFrame:CGRectMake(30,10,250,400)];
        }
        else
        {
            subView = [[UIView alloc]initWithFrame:CGRectMake(30, 40, 250, 400)];
        }
        UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 210, 60)];
        lbl1.text = @"To Gain Access To All Unlimited Features, additional features,";
        lbl1.numberOfLines = 3;
        lbl1.font = [UIFont systemFontOfSize:15.0];
        lbl1.lineBreakMode = NSLineBreakByWordWrapping;
        lbl1.textAlignment = NSTextAlignmentCenter;
        lbl1.textColor = [UIColor whiteColor];
        lbl1.backgroundColor = [UIColor blackColor];
        
        UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 210, 300)];
        lbl2.text = @"1.NO ADS \n2.BREAK-IN ATTEMPTS FEATURE, \n you will be able to view any persons who try and attempt to access your information \n3.SELECT ACTIVE TYPE, you will be able to Change your passcode & change the lock Type Voice Authentication, X9 Lock Code, Pin Code \n4. Video Folder, Store a video & record using the built in recorder";
        lbl2.numberOfLines = 20;
        lbl2.font = [UIFont systemFontOfSize:15.0];
        lbl2.lineBreakMode = NSLineBreakByWordWrapping;
        lbl2.textAlignment = NSTextAlignmentCenter;
        lbl2.textColor = [UIColor whiteColor];
        lbl2.backgroundColor = [UIColor blackColor];
        
        //        UILabel *lbl3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 170, 210, 30)];
        //        lbl3.text = @"$1.99";
        //        lbl3.numberOfLines = 1;
        //        lbl3.font = [UIFont systemFontOfSize:15.0];
        //        lbl3.lineBreakMode = UILineBreakModeWordWrap;
        //        lbl3.textAlignment = UITextAlignmentCenter;
        //        lbl3.textColor = [UIColor whiteColor];
        //        lbl3.backgroundColor = [UIColor blackColor];
        
        UIButton *btnBuy = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnBuy addTarget:self action:@selector(goProClicked:) forControlEvents:UIControlEventTouchDown];
        [btnBuy setTitle:@"Go Pro!" forState:UIControlStateNormal];
        [btnBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnBuy.frame = CGRectMake(65, 340, 120, 50);
        UIImage *backImage = [UIImage imageNamed:@"iphone-buy.png"];
        [btnBuy setBackgroundImage:backImage forState:UIControlStateNormal];
        
//        UIButton *btnNoThanks = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [btnNoThanks addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchDown];
//        [btnNoThanks setTitle:@"Maybe Later" forState:UIControlStateNormal];
//        [btnNoThanks setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        btnNoThanks.frame = CGRectMake(130, 350, 120, 50);
//        UIImage *backImage1 = [UIImage imageNamed:@"iphone-buy.png"];
//        [btnNoThanks setBackgroundImage:backImage1 forState:UIControlStateNormal];
        
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchDown];
        
        UIImage *image = [UIImage imageNamed:@"close-right-part.png"];
        [btnCancel setImage:image forState:UIControlStateNormal];
        btnCancel.frame = CGRectMake(215, 0, 35, 35);
        //btnCancel.frame = CGRectMake(280, 30, 35, 35);
        
        [subView addSubview:lbl1];
        [subView addSubview:lbl2];
        // [subView addSubview:lbl3];
        [subView addSubview:btnBuy];
//        [subView addSubview:btnNoThanks];
        [subView addSubview:btnCancel];
        
        [view addSubview:subView];
        
        [subView.layer setMasksToBounds:YES];
        subView.backgroundColor = [UIColor blackColor];
        
        (subView.layer).cornerRadius = 10.0;
        subView.backgroundColor = [UIColor blackColor];
        (subView.layer).cornerRadius = 10.0;
        (subView.layer).borderColor = [UIColor whiteColor].CGColor;
        (subView.layer).borderWidth = 3.0;
        
        //[self.view addSubview:btnCancel];
        [self.view addSubview:view];
    }
#endif
    
}
-(IBAction)goProClicked:(id)sender
{
    //GoProLink
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://itunes.apple.com/us/app/secret-vault-pro-plus/id873504069?ls=1&mt=8"]];
}

-(IBAction)MusicClicked:(id)sender{
    
    NSLog(@"Tag::: %ld",(long)[sender tag]);
    
    MusicView *musicVW;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        musicVW = [[MusicView alloc] initWithNibName:@"MusicView_Ipad" bundle:nil];
    }
    else {
        musicVW = [[MusicView alloc] initWithNibName:@"MusicView" bundle:nil];
    }
    //    MusicView *musicVW=[[MusicView alloc] initWithNibName:@"MusicView" bundle:nil];
    [self.navigationController pushViewController:musicVW animated:YES];
    //[musicVW release];
    
}

-(IBAction) closeImgView:(id)sender{
    [self.navigationController setNavigationBarHidden:NO];
    dispImgView.hidden=true;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)BtnSettingsClicked:(id)sender
{
    ColorPickerController *_colorPicker;
    _colorPicker = [[ColorPickerController alloc] initWithStyle:UITableViewStyleGrouped];
    _colorPicker.delegate = self;
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        UINavigationController* navController = [[UINavigationController alloc] init];
        [navController pushViewController:_colorPicker animated:YES];
        app.objPopOverController = [[UIPopoverController alloc] initWithContentViewController:navController];
        app.objPopOverController.delegate=self;
        [app.objPopOverController presentPopoverFromRect:CGRectMake(5,10, 1,1)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
    }else {
        [self.navigationController pushViewController:_colorPicker animated:YES];
    }
}
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    // do something now that it's been dismissed
    if (app.Purchase_array.count>0) {
        
    }
    else
    {
#ifdef LITEVERSION
        if(![[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"BreakInPackagePurchased"] isEqualToString:@"YES"])
        {
            if(![[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"AdPackagePurchased"] isEqualToString:@"YES"])
            {
                /*self.interstitial = [TFTInterstitial interstitialWithDelegate:self];
                 [self.interstitial load];
                 [self.interstitial showWithViewController: self];*/
                self.interstitial = [GADHelper createAndLoadInterstitial:self];
            }
            
        }
#else
#endif
    }
    NSLog(@"Dismissed");
}
-(IBAction)BtnEditClicked:(id)sender{
    NSLog(@"Edit Clicked...");
}

-(IBAction)btnBackgroundPressed:(id)sender
{
    NSLog(@"Button tag::: %ld",(long)[sender tag]);
    
    if([sender tag] == 0)
    {
        NSLog(@"Default Album...");
        [self OpenPhotoGallery];
    }
    else if ([sender tag] == 2)
    {
        NSLog(@"Notes...");
        NotesView_iPhone *notesvw=[[NotesView_iPhone alloc] initWithNibName:@"NotesView_iPhone" bundle:nil];
        [self.navigationController pushViewController:notesvw animated:YES];
        //[notesvw release];
    }
    else if ([sender tag] == 3)
    {
        NSLog(@"Contacts...");
        ContactListView *contvw=[[ContactListView alloc] initWithNibName:@"ContactListView" bundle:nil];
        [self.navigationController pushViewController:contvw animated:YES];
        //[contvw release];
    }
}

-(IBAction)OpenPhotoGallery
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([UIImagePickerController isSourceTypeAvailable :UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker =[[UIImagePickerController alloc]init];
        picker.delegate  = self ;
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        //  [self.navigationController pushViewController:picker animated:YES];
        [self presentViewController:picker animated:YES completion:nil];
        //[picker release];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
       didFinishPickingImage:(UIImage *)image
                 editingInfo:(NSDictionary *)editingInfo
{
    [self dismissViewControllerAnimated:YES completion:nil];
    dispImgView.hidden=false;
    img.image=image;
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    NSLog(@"Image Use clicked..");
    
    [self dismissViewControllerAnimated:YES completion:nil];
    dispImgView.hidden=false;
    
    [self.navigationController setNavigationBarHidden:YES];
    UIButton  *delButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [delButton setImage:[UIImage imageNamed:@"button_red_close.png"] forState:UIControlStateNormal];
    [delButton addTarget:self action:@selector(closeImgView:) forControlEvents:UIControlEventTouchUpInside];
    delButton.frame = CGRectMake(280, 0, 40, 40);
    delButton.showsTouchWhenHighlighted=YES;
    
    // self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:delButton];
    [self.dispImgView addSubview:delButton];
    
    NSData *dataImage = UIImageJPEGRepresentation(info[@"UIImagePickerControllerOriginalImage"],1);
    
    img.image = [[UIImage alloc] initWithData:dataImage];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *) picker
{
    dispImgView.hidden=true;
    [self.navigationController setNavigationBarHidden:NO];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)btnAddPressed:(id)sender{
    NSLog(@"Add Clicked...");
}

-(IBAction)btnFBPressed:(id)sender{
    NSLog(@"FB Clicked...");
}

-(IBAction)btnWebPressed:(id)sender{
    NSLog(@"Web Clicked...");
}


//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//
//    return [listOfItems count];
//    //return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//
//    NSDictionary *objdict = [listOfItems objectAtIndex:section];
//    NSString *str = [NSString stringWithFormat:@"%i",section];
//    NSArray *objarray = [objdict objectForKey:str];
//    return [objarray count];
//
//    // NSLog(@"Managers arr count:: %d",[settingmenunamearr count]);
//
////    return [settingmenunamearr count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//
//
//    static NSString *CellIdentifier = @"SettingsCellIdentifier";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//
//    NSDictionary *objdict = [listOfItems objectAtIndex:indexPath.section];
//    NSString *str = [NSString stringWithFormat:@"%i",indexPath.section];
//    NSArray *objarray = [objdict objectForKey:str];
//    cell.textLabel.textColor = [UIColor colorWithRed:103.0/255.0 green:0.0/255.0 blue:85.0/255.0 alpha:1.0];
//    cell.textLabel.text = [objarray objectAtIndex:indexPath.row];
//
//
//    return cell;
//
////    static NSString *CustomCellIdentifier = @"MenuCustomCell_iPhone";
////
////    MenuCustomCell_iPhone *cell = (MenuCustomCell_iPhone *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
////    if (cell == nil) {
////        NSArray *nib;
////        nib = [[NSBundle mainBundle] loadNibNamed:@"MenuCustomCell_iPhone" owner:self options:nil];
////        for(id oneObject in nib)
////            if([oneObject isKindOfClass:[MenuCustomCell_iPhone class]])
////                cell = (MenuCustomCell_iPhone *)oneObject;
////    }
////
////    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
////
////    cell.iconimage.image = [UIImage imageNamed:[settingIconArr objectAtIndex:indexPath.row]];
////    cell.menuNmLbl.text=[settingmenunamearr objectAtIndex:indexPath.row];
////
////    [cell.rightArrowBtn addTarget:self action:@selector(btnBackgroundPressed:) forControlEvents:UIControlEventTouchUpInside];
////    [cell.rightArrowBtn setTag:indexPath.row];
////
////    return cell;
//}
//
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//
//    if(section == 0)
//    {
//        return @"Share";
//    }
//    else if(section == 2)
//    {
//        return @"App Settings";
//    }
//    else
//    {
//        return @"";
//    }
//
//}
//
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
// 
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 52;
//}
//

#pragma mark - GADDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    if(self == self.navigationController.topViewController)
        [self.interstitial presentFromRootViewController:self];
}

- (void)monsterSelectionChanged:(Monster *)curSelection {
    return;
}

- (void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    return;
}

- (void)fbDidLogin {
    return;
}

- (void)fbDidLogout {
    return;
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    return;
}

- (void)fbSessionInvalidated {
    return;
}

- (void)fbDialogLogin:(NSString *)token expirationDate:(NSDate *)expirationDate {
    return;
}

- (void)fbDialogNotLogin:(BOOL)cancelled {
    return;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    return;
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    return;
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    return;
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    return;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    return;
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    return;
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
    return;
}

- (void)setNeedsFocusUpdate {
    return;
}

- (void)updateFocusIfNeeded {
    return;
}

@end
