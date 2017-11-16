//
//  DefaultAlbumView.m
//  SecretApp
//
//  Created by c62 on 21/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DefaultAlbumView.h"
#import "AlbumProcessView.h"
#import "ZoomViewController.h"
#import "MenuCustomCell_iPhone.h"
#import "NotesView_iPhone.h"
#import "AudioRecorder.h"
#import "ContactListView.h"
#import "VideoView.h"
#import "MusicView.h"
#import "BookmarkView.h"
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"
#import "GADInterstitial.h"


@interface DefaultAlbumView () <GADInterstitialDelegate, GADBannerViewDelegate>

@property (nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation DefaultAlbumView

@synthesize scrollVw,imgArray,toolbar,docImgPath,playImgsVw,slideImage,selVideoPath,videopathAll,uiDemo;

@synthesize imgPath,imgId,UIImagetypeArr,thumbImage,videopath,insertVideoFlag,scrollView,playImagesArr,moviePlayer;

@synthesize backgroundImg;



int imgnum=0;
UIBarButtonItem *addButton;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)dealloc
{
    [backgroundImg release];
    [playImagesArr release];
    [moviePlayer release];
    [videopathAll release];
    [selVideoPath release];
    [videopath release];
    [thumbImage release];
    [UIImagetypeArr release];
    [slideImage release];
    [playImgsVw release];
    [imgId release];
    [imgPath release];
    [docImgPath release];
    [toolbar release];
    [imgArray release];
    [scrollVw release];
    [super dealloc];
}
/*For ipad
 Nevil*/

-(IBAction) closeImgView:(id)sender
{
    
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
    [bookvw release];
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
    [notesvw release];
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
    [arec release];
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
    [contvw release];
}

-(IBAction)VideoClicked:(id)sender{
    NSLog(@"Tag::: %ld",(long)[sender tag]);
    
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
    [videoVW release];
    
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
    [musicVW release];
    
}
/*Nevil*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationItem.backBarButtonItem.tintColor = [UIColor redColor];
        self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
        toolbar.barTintColor = [UIColor blackColor];
    }
    [self.navigationController setNavigationBarHidden:NO];
    app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    imgArray=[[NSMutableArray alloc] init];
    UIImagetypeArr=[[NSMutableArray alloc] init];
    
    // set scrollview properties //
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:5];
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        scrollVw.scrollEnabled = YES;
        scrollVw.delegate = self;
        // scrollVw.frame=CGRectMake(scrollVw.frame.origin.x, scrollVw.frame.origin.y, scrollVw.frame.size.width,2000);
        scrollVw.contentSize=CGSizeMake(768, 5000);
        [self.view addSubview:scrollVw];
#ifdef LITEVERSION
        // Tap For Tap Adview Starts Here
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
        // Tap For Tap Adview Ends Here
#else
        
#endif
        
        addButton = [[UIBarButtonItem alloc]
                     initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(continueImgProcesss)];
        addButton.style = UIBarButtonItemStyleBordered;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            addButton.tintColor=[UIColor whiteColor];
        }
        addButton.enabled=false;
        [buttons addObject:addButton];
        [addButton release];
        UIBarButtonItem *flexibaleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//        flexibaleSpaceBarButton.width = 130;
        flexibaleSpaceBarButton.tintColor = [UIColor whiteColor];
        [buttons addObject:flexibaleSpaceBarButton];
        [flexibaleSpaceBarButton release];
        
        UIButton *addvideoButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [addvideoButton addTarget:self action:@selector(openVideo) forControlEvents:UIControlEventTouchUpInside];
        addvideoButton.frame = CGRectMake(300.00, 300.0, 30.0, 30.0);
        [addvideoButton setBackgroundImage:[UIImage imageNamed:@"videoadd4.png"] forState:UIControlStateNormal];
        [self.view addSubview:addvideoButton];
        
        UIBarButtonItem *doneButton =[[UIBarButtonItem alloc]initWithCustomView:addvideoButton];
        doneButton.style = UIBarButtonItemStyleBordered;
        
        [buttons addObject:doneButton];
        [doneButton release];
        
        UIBarButtonItem *flexibaleSpaceBarButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//        flexibaleSpaceBarButton1.width = 130;
        flexibaleSpaceBarButton1.tintColor = [UIColor whiteColor];
        [buttons addObject:flexibaleSpaceBarButton1];
        [flexibaleSpaceBarButton1 release];
        
        UIButton *cameraAddBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [cameraAddBtn addTarget:self action:@selector(btnAddImagePressed) forControlEvents:UIControlEventTouchUpInside];
        cameraAddBtn.frame = CGRectMake(330.00, 300.0, 30.0, 30.0);
        [cameraAddBtn setBackgroundImage:[UIImage imageNamed:@"addimg1.png"] forState:UIControlStateNormal];
        [self.view addSubview:cameraAddBtn];
        
        UIBarButtonItem *wwwlayerbtn =[[UIBarButtonItem alloc]initWithCustomView:cameraAddBtn];
        wwwlayerbtn.style = UIBarButtonItemStyleBordered;
        [buttons addObject:wwwlayerbtn];
        [wwwlayerbtn release];
        
        UIBarButtonItem *flexibaleSpaceBarButton2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//        flexibaleSpaceBarButton2.width = 130;
        flexibaleSpaceBarButton2.tintColor = [UIColor whiteColor];
        [buttons addObject:flexibaleSpaceBarButton2];
        [flexibaleSpaceBarButton2 release];
        
        UIButton *slideshowBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [slideshowBtn addTarget:self action:@selector(btnPlayPressed) forControlEvents:UIControlEventTouchUpInside];
        slideshowBtn.frame = CGRectMake(330.00, 300.0, 30.0, 30.0);
        [slideshowBtn setBackgroundImage:[UIImage imageNamed:@"slideplay2.png"] forState:UIControlStateNormal];
        [self.view addSubview:slideshowBtn];
        
        UIBarButtonItem *sslayerbtn =[[UIBarButtonItem alloc]initWithCustomView:slideshowBtn];
        sslayerbtn.style = UIBarButtonItemStyleBordered;
        [buttons addObject:sslayerbtn];
        [sslayerbtn release];
        
        UIBarButtonItem *flexibaleSpaceBarButton3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//        flexibaleSpaceBarButton3.width = 140;
        flexibaleSpaceBarButton3.tintColor = [UIColor whiteColor];
        [buttons addObject:flexibaleSpaceBarButton3];
        [flexibaleSpaceBarButton3 release];
        
        UIButton *openCameraBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [openCameraBtn addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
        openCameraBtn.frame = CGRectMake(330.00, 300.0, 30.0, 30.0);
        [openCameraBtn setBackgroundImage:[UIImage imageNamed:@"camera2.png"] forState:UIControlStateNormal];
        [self.view addSubview:openCameraBtn];
        
        UIBarButtonItem *cmlayerbtn =[[UIBarButtonItem alloc]initWithCustomView:openCameraBtn];
        cmlayerbtn.style = UIBarButtonItemStyleBordered;
        [buttons addObject:cmlayerbtn];
        [cmlayerbtn release];
        
        toolbar.items = buttons;
        [buttons release];
    }else
    {
        
        CGSize result = [UIScreen mainScreen].bounds.size;
        if (result.height < 568){
            NSLog(@"Login From iphone 4");
            self.backgroundImg.image = [UIImage imageNamed:@"iphone-n-back.png"];
        }
        else
        {
            NSLog(@"Login From iphone 5");
            self.backgroundImg.image = [UIImage imageNamed:@"iphone-n-back@2x.png"];
        }
        
        scrollVw.scrollEnabled = YES;
        scrollVw.delegate = self;
        scrollVw.contentSize=CGSizeMake(320, 5000);
        [self.view addSubview:scrollVw];
        
#ifdef LITEVERSION
        // Tap For Tap Adview Starts Here
       if(![[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"BreakInPackagePurchased"] isEqualToString:@"YES"])
        {
            if(![[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"AdPackagePurchased"] isEqualToString:@"YES"])
            {
                self.interstitial = [GADHelper createAndLoadInterstitial:self];
            }
            
        }
        // Tap For Tap Adview Ends Here
#else
        
#endif
        addButton = [[UIBarButtonItem alloc]
                     initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(continueImgProcesss)];
        addButton.style = UIBarButtonItemStyleBordered;
        addButton.enabled=false;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            addButton.tintColor=[UIColor whiteColor];
        }
        [buttons addObject:addButton];
        [addButton release];
        
        UIBarButtonItem *flexibaleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//        flexibaleSpaceBarButton.width = 35;
        flexibaleSpaceBarButton.tintColor = [UIColor whiteColor];
        [buttons addObject:flexibaleSpaceBarButton];
        [flexibaleSpaceBarButton release];
        
        UIButton *addvideoButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [addvideoButton addTarget:self action:@selector(openVideo) forControlEvents:UIControlEventTouchUpInside];
        addvideoButton.frame = CGRectMake(300.00, 300.0, 30.0, 30.0);
        [addvideoButton setBackgroundImage:[UIImage imageNamed:@"videoadd4.png"] forState:UIControlStateNormal];
        [self.view addSubview:addvideoButton];
        
        
        UIBarButtonItem *doneButton =[[UIBarButtonItem alloc]initWithCustomView:addvideoButton];
        doneButton.style = UIBarButtonItemStyleBordered;
        
        [buttons addObject:doneButton];
        [doneButton release];
        
        UIBarButtonItem *flexibaleSpaceBarButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//        flexibaleSpaceBarButton1.width = 35;
        [buttons addObject:flexibaleSpaceBarButton1];
        [flexibaleSpaceBarButton1 release];
        
        UIButton *cameraAddBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [cameraAddBtn addTarget:self action:@selector(btnAddImagePressed) forControlEvents:UIControlEventTouchUpInside];
        cameraAddBtn.frame = CGRectMake(330.00, 300.0, 30.0, 30.0);
        [cameraAddBtn setBackgroundImage:[UIImage imageNamed:@"addimg1.png"] forState:UIControlStateNormal];
        [self.view addSubview:cameraAddBtn];
        
        UIBarButtonItem *wwwlayerbtn =[[UIBarButtonItem alloc]initWithCustomView:cameraAddBtn];
        wwwlayerbtn.style = UIBarButtonItemStyleBordered;
        [buttons addObject:wwwlayerbtn];
        [wwwlayerbtn release];
        
        UIBarButtonItem *flexibaleSpaceBarButton2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//        flexibaleSpaceBarButton2.width = 35;
        [buttons addObject:flexibaleSpaceBarButton2];
        [flexibaleSpaceBarButton2 release];
        
        UIButton *slideshowBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [slideshowBtn addTarget:self action:@selector(btnPlayPressed) forControlEvents:UIControlEventTouchUpInside];
        slideshowBtn.frame = CGRectMake(330.00, 300.0, 30.0, 30.0);
        [slideshowBtn setBackgroundImage:[UIImage imageNamed:@"slideplay2.png"] forState:UIControlStateNormal];
        [self.view addSubview:slideshowBtn];
        
        UIBarButtonItem *sslayerbtn =[[UIBarButtonItem alloc]initWithCustomView:slideshowBtn];
        sslayerbtn.style = UIBarButtonItemStyleBordered;
        [buttons addObject:sslayerbtn];
        [sslayerbtn release];
        
        UIBarButtonItem *flexibaleSpaceBarButton3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//        flexibaleSpaceBarButton3.width = 35;
        [buttons addObject:flexibaleSpaceBarButton3];
        [flexibaleSpaceBarButton3 release];
        
        UIButton *openCameraBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [openCameraBtn addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
        openCameraBtn.frame = CGRectMake(330.00, 300.0, 30.0, 30.0);
        [openCameraBtn setBackgroundImage:[UIImage imageNamed:@"camera2.png"] forState:UIControlStateNormal];
        [self.view addSubview:openCameraBtn];
        
        UIBarButtonItem *cmlayerbtn =[[UIBarButtonItem alloc]initWithCustomView:openCameraBtn];
        cmlayerbtn.style = UIBarButtonItemStyleBordered;
        [buttons addObject:cmlayerbtn];
        [cmlayerbtn release];
        
        toolbar.items = buttons;
        [buttons release];
    }
    [self getImages];
}



-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
    isImgFlag=false;
    insertVideoFlag=false;
    
    self.title=@"Photo/Camera Album";
    
    tempPath=@"";
    imgArray=[[NSMutableArray alloc] init];
    playImagesArr=[[NSMutableArray alloc] init];
    
    playImgsVw.hidden=true ;
    [self getImages];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)continueImgProcesss{
    
    AlbumProcessView *albumPr;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        albumPr = [[AlbumProcessView alloc] initWithNibName:@"AlbumProcessView_Ipad" bundle:nil];
    }
    else
    {
        albumPr = [[AlbumProcessView alloc] initWithNibName:@"AlbumProcessView" bundle:nil];
    }
    
    //    AlbumProcessView *albumPr=[[AlbumProcessView alloc] initWithNibName:@"AlbumProcessView" bundle:nil];
    [self.navigationController pushViewController:albumPr animated:YES];
    self.navigationItem.backBarButtonItem.tintColor = [UIColor redColor];
    [albumPr release];
}

-(void)openVideo
{
#ifdef PROVERSION
    
    [self startMediaBrowserFromViewController: self usingDelegate: self];
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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://itunes.apple.com/us/app/secret-vault-pro-plus/id873504069?ls=1&mt=8"]];
}
-(void)cancelClick
{
    [view removeFromSuperview];
    NSLog(@"Cancel Button Clicked...");
}

//Displays only videos //
- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate{
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        
        if (([UIImagePickerController isSourceTypeAvailable:
              UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
            || (delegate == nil)
            || (controller == nil))
            return NO;
        
        UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
        mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (__bridge NSString *) kUTTypeMovie, nil];
        mediaUI.allowsEditing = YES;
        mediaUI.delegate = delegate;
        insertVideoFlag=true;
        //[controller presentModalViewController: mediaUI animated: YES];
        
        app.objPopOverController = [[UIPopoverController alloc] initWithContentViewController:mediaUI];
        (app.objPopOverController).delegate = self;
        [app.objPopOverController presentPopoverFromRect:CGRectMake(205,920, 1,1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    else
    {
        if (([UIImagePickerController isSourceTypeAvailable:
              UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
            || (delegate == nil)
            || (controller == nil))
            return NO;
        
        UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
        mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (__bridge NSString *) kUTTypeMovie, nil];
        mediaUI.allowsEditing = YES;
        mediaUI.delegate = delegate;
        insertVideoFlag=true;
        [controller presentViewController:mediaUI animated:YES completion:nil];
    }
    return YES;
}
// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info
{
    NSLog(@"insert video flag== %@",insertVideoFlag ? @"YES" : @"NO");
    if(insertVideoFlag)
    {
        insertVideoFlag=false;
        NSString *type = info[UIImagePickerControllerMediaType];
        
        if ([type isEqualToString:(NSString *)kUTTypeVideo] ||
            [type isEqualToString:(NSString *)kUTTypeMovie])
        {
            videoURL = info[UIImagePickerControllerMediaURL];
            NSLog(@"found a video");
            
            // Code To give Name to video and store to DocumentDirectory //
            
            NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = paths[0];
            
            NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
            dateFormat.dateFormat = @"dd-MM-yyyy||HH:mm:SS";
            NSDate *now = [[[NSDate alloc] init] autorelease];
            theDate = [dateFormat stringFromDate:now];
            
            NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"Default Album"];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
                [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
            
            videopath= [[NSString alloc ] initWithString:[NSString stringWithFormat:@"%@/%@.mp4",documentsDirectory,theDate]];
            
            BOOL success = [videoData writeToFile:videopath atomically:NO];
            
            NSLog(@"Successs:::: %@",success ? @"YES" : @"NO");
            NSLog(@"video path-->%@",videopath);
            [picker dismissViewControllerAnimated:YES completion:nil];
        }
        
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
        AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        gen.appliesPreferredTrackTransform = YES;
        CMTime time = CMTimeMakeWithSeconds(0.0, 600);
        NSError *error = nil;
        CMTime actualTime;
        
        CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        thumbImage = [[UIImage alloc] initWithCGImage:image];
        CGImageRelease(image);
        [gen release];
        
        NSLog(@"thumb View img=== %@",thumbImage);
        
        // Code to store thumbimage in document directory ///
        
        NSString *nameofimg=[NSString stringWithFormat:@"%@",thumbImage];
        NSLog(@"image.... %@",image);
        
        NSString *substring=[nameofimg substringFromIndex:10];
        NSString *new=[substring substringToIndex:8];
        NSLog(@"image name:::: %@",new);
        NSData * imageData = UIImageJPEGRepresentation(thumbImage, 1.0);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = paths[0]; // Get documents folder
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"Thumbnails"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
            [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
        
        NSString *newFilePath = [NSString stringWithFormat:[dataPath stringByAppendingPathComponent: @"/%@.png"],new];
        
        NSLog(@"image path==== %@",newFilePath);
        self.docImgPath=[NSString stringWithFormat:@"%@",newFilePath];
        
        if (imageData != nil)
        {
            [imageData writeToFile:newFilePath atomically:YES];
        }
        
        // ***********************//
        NSString *mediaType = info[UIImagePickerControllerMediaType];
        
        // Handle a movie capture
        if (CFStringCompare ((CFStringRef)mediaType, kUTTypeMovie, 0)
            == kCFCompareEqualTo) {
            
            NSString *moviePath = [info[UIImagePickerControllerMediaURL] path];
            
            NSLog(@"Movie Path== %@",moviePath);
            MPMoviePlayerViewController* theMovie =
            [[MPMoviePlayerViewController alloc] initWithContentURL: info[UIImagePickerControllerMediaURL]];
            [self presentMoviePlayerViewControllerAnimated:theMovie];
            
            // Register for the playback finished notification
            [[NSNotificationCenter defaultCenter]
             addObserver: self
             selector: @selector(myMovieFinishedCallback:)
             name: MPMoviePlayerPlaybackDidFinishNotification
             object: theMovie];
        }
        
        [self insertImage];
    }
    else
    {
        insertVideoFlag=false;
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        NSData *dataImage = UIImageJPEGRepresentation(info[@"UIImagePickerControllerOriginalImage"],1);
        
        //  UIImage *attachimage = [[UIImage alloc] initWithData:dataImage];
        
        UIImage *attachimage = [self scaleImage:[[UIImage alloc] initWithData:dataImage] toSize:CGSizeMake(320.0f,460.0f)];
        
        NSURL *assetURL = info[UIImagePickerControllerReferenceURL];
        NSLog(@"img url::: %@",assetURL);
        
        NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
        dateFormat.dateFormat = @"dd-MM-yyyy||HH:mm:SS";
        NSDate *now = [[[NSDate alloc] init] autorelease];
        theDate = [dateFormat stringFromDate:now];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = paths[0]; // Get documents folder
        //    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"Images"];
        
        NSString *newFilePath = [NSString stringWithFormat:[documentsDirectory stringByAppendingPathComponent: @"/%@.png"],theDate];
        
        NSLog(@"file path=== %@",newFilePath);
        
        docImgPath=[NSString stringWithFormat:@"%@",newFilePath];
        
        NSData * imgData = UIImagePNGRepresentation(attachimage);
        
        if (imgData != nil)
        {
            [imgData writeToFile:newFilePath atomically:YES];
            [imgArray addObject:docImgPath];
            NSLog(@"Img arr count== %lu",(unsigned long)imgArray.count);
            NSLog(@"Image taken=== %@",imgArray);
            [self insertImage];
        }
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize {
    
    float width = newSize.width;
    float height = newSize.height;
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect: CGRectMake(0, 0, width, height)];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return smallImage;
}

// When the movie is done, release the controller. //
-(void) myMovieFinishedCallback: (NSNotification*) aNotification
{
    [self dismissMoviePlayerViewControllerAnimated];
    
    MPMoviePlayerController* theMovie = aNotification.object;
    
    [[NSNotificationCenter defaultCenter]
     removeObserver: self
     name: MPMoviePlayerPlaybackDidFinishNotification
     object: theMovie];
    
    // Release the movie instance created in playMovieAtURL:
}

-(void)btnAddImagePressed
{
    // [self dismissModalViewControllerAnimated:NO];
    insertVideoFlag=false;
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        UIImagePickerController *UserPhotoPicker = [[UIImagePickerController alloc]init];
        UserPhotoPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        UserPhotoPicker.delegate = self;
        //    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        //    {
        //        UserPhotoPicker.navigationBar.barStyle=UIBarStyleBlack;
        //    }
        UserPhotoPicker.navigationBar.tintColor = [UIColor blackColor];
        
        app.objPopOverController = [[UIPopoverController alloc] initWithContentViewController:UserPhotoPicker];
        (app.objPopOverController).delegate = self;
        [app.objPopOverController presentPopoverFromRect:CGRectMake(370,920, 1,1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }else {
        
        
        if ([UIImagePickerController isSourceTypeAvailable :UIImagePickerControllerSourceTypePhotoLibrary])
        {
            UIImagePickerController *picker =[[UIImagePickerController alloc]init];
            picker.delegate  = self   ;
            picker.editing=YES;
            picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            //        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
            //        {
            //            picker.navigationBar.barStyle=UIBarStyleBlack;
            //            picker.navigationBar.tintColor=[UIColor whiteColor];
            //        }
            //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
            [self presentViewController:picker animated:YES completion:nil];
            [picker release];
        }
    }
}

-(void)openCamera
{
    @try
    {
        insertVideoFlag=false;
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        imagePicker.showsCameraControls = YES;
        imagePicker.navigationBarHidden = YES;
        imagePicker.wantsFullScreenLayout = YES;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    @catch (NSException *exception)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Camera" message:@"Camera is not available  " delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

#pragma mark - set Image from gallery & camera

-(void)insertImage{
    
    sqlite3_stmt *stmt;
    databasepath=[app getDBPathNew];
    const char *dbpath=databasepath.UTF8String;
    
    if(sqlite3_open(dbpath, &dbSecret) == SQLITE_OK)
    {
        NSString *insertquery=[NSString stringWithFormat:@"Insert into AlbumTbl(UserID,ImagePath,VideoPath) VALUES(%d,\"%@\",\"%@\")",(app.LoginUserID).intValue,docImgPath,videopath];
        
        NSLog(@"insert query== %@",insertquery);
        
        const char *insert_query=insertquery.UTF8String;
        sqlite3_prepare(dbSecret, insert_query, -1, &stmt, NULL);
        
        if(sqlite3_step(stmt)== SQLITE_DONE)
        {
            NSLog(@"img/video Inserted..");
            docImgPath=@"";
            videopath=@"";
            
            addButton.enabled=true;
            
            /* UIAlertView *alert = [[UIAlertView alloc]
             initWithTitle:@"Message" message:@"Image Added Successfully...!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             [alert release];*/
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry" message:@"Failed To Insert Data.." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        sqlite3_finalize(stmt);
        sqlite3_close(dbSecret);
    }
    [self getImages];
}

-(void)dispImg
{
    
    for(UIView * view1 in scrollVw.subviews)
    {
        if([view1 isKindOfClass:[UIButton class]] || [view1 isKindOfClass:[UIImageView class]])
        {
            [view1 removeFromSuperview];
            view1 = nil;
        }
    }
    if(imgArray.count== 0 )
    {
        NSLog(@"no img");
    }
    else
    {
        NSLog(@"num of Images :::: %ld",(long)imgArray.count);
        
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
            
            
            int width=240 ;
            int height=240;
            int x=15;
            int y=10;
            
            [playImagesArr removeAllObjects];
            
            for(int i=1;i<=imgArray.count;i++)
            {
                DefaultAlbumView *defAlObj=imgArray[i-1];
                NSLog(@"video path== %@",defAlObj.videopathAll);
                
                if([defAlObj.videopathAll isEqualToString:@"(null)"] || [defAlObj.videopathAll isEqualToString:@""])
                {
                    NSLog(@"img found at index= %d..",i-1);
                    //set View for Images Only //
                    
                    img1=[[UIButton alloc] init];
                    img1.frame=CGRectMake(x,y,width,height);
                    [img1 setImage:[UIImage imageWithContentsOfFile:defAlObj.imgPath ]forState:UIControlStateNormal];
                    [img1 addTarget:self action:@selector(imgVideoSelectActivity:) forControlEvents:(UIControlEventTouchUpInside)];
                    img1.tag = i-1;
                    
                    [playImagesArr addObject:defAlObj.imgPath];
                    
                    isImgFlag=true;
                }
                else
                {
                    //set View for Videos //
                    NSLog(@"Video found at index= %d",i-1);
                    
                    
                    img1=[[UIButton alloc] init];
                    img1.frame=CGRectMake(x,y,width,height);
                    [img1 setImage:[UIImage imageWithContentsOfFile:defAlObj.imgPath ]forState:UIControlStateNormal];
                    [img1 addTarget:self action:@selector(imgVideoSelectActivity:) forControlEvents:(UIControlEventTouchUpInside)];
                    img1.tag = i-1;
                    
                    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"movie.png"]];
                    img.frame = CGRectMake(0,200, 60, 60);
                    [img1 addSubview:img];
                    
                }
                
                (i%3)==0 ? (y=y+250) : (y=y);
                (i%3)==0 ? (x=15) : (x=x+250);
                
                [scrollVw addSubview:img1];
                [self.view addSubview:scrollVw];
            }
            
        }
        else
        {
            int width=100;
            int height=100;
            int x=5;
            int y=5;
            
            [playImagesArr removeAllObjects];
            
            for(int i=1;i<=imgArray.count;i++)
            {
                DefaultAlbumView *defAlObj=imgArray[i-1];
                NSLog(@"video path== %@",defAlObj.videopathAll);
                
                if([defAlObj.videopathAll isEqualToString:@"(null)"] || [defAlObj.videopathAll isEqualToString:@""])
                {
                    NSLog(@"img found at index= %d..",i-1);
                    //set View for Images Only //
                    
                    img1=[[UIButton alloc] init];
                    img1.frame=CGRectMake(x,y,width,height);
                    [img1 setImage:[UIImage imageWithContentsOfFile:defAlObj.imgPath ]forState:UIControlStateNormal];
                    [img1 addTarget:self action:@selector(imgVideoSelectActivity:) forControlEvents:(UIControlEventTouchUpInside)];
                    img1.tag = i-1;
                    [playImagesArr addObject:defAlObj.imgPath];
                    
                    isImgFlag=true;
                }
                else
                {
                    //set View for Videos //
                    NSLog(@"Video found at index= %d",i-1);
                    
                    
                    img1=[[UIButton alloc] init];
                    img1.frame=CGRectMake(x,y,width,height);
                    [img1 setImage:[UIImage imageWithContentsOfFile:defAlObj.imgPath ]forState:UIControlStateNormal];
                    [img1 addTarget:self action:@selector(imgVideoSelectActivity:) forControlEvents:(UIControlEventTouchUpInside)];
                    img1.tag = i-1;
                    
                    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"movie.png"]];
                    img.frame = CGRectMake(0,70, 40, 40);
                    [img1 addSubview:img];
                    
                }
                
                (i%3)==0 ? (y=y+105) : (y=y);
                (i%3)==0 ? (x=5) : (x=x+105);
                
                [scrollVw addSubview:img1];
                //[self.view addSubview:scrollVw];
            }
        }
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *) picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)imgVideoSelectActivity:(id)sender{
    
    NSLog(@"btn tag== %ld",(long)[sender tag]);
    
    DefaultAlbumView *defAlObj=imgArray[[sender tag]];
    app.ZoomImage=defAlObj.imgPath;
    NSLog(@"app img== %@",app.ZoomImage);
    
    if(UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)
    {
        if([defAlObj.videopathAll isEqualToString:@"(null)"] || [defAlObj.videopathAll isEqualToString:@""])
        {
            ZoomViewController *zoom=[[ZoomViewController alloc] initWithNibName:@"ZoomViewController" bundle:nil];
            [self.navigationController pushViewController:zoom animated:YES];
            [zoom release];
            
            scrollView.contentSize= CGSizeMake(img1.frame.size.width+100, img1.frame.size.height+100);
            scrollView.maximumZoomScale=10.0;
            scrollView.minimumZoomScale=50.0;
            scrollView.clipsToBounds=YES;
            scrollView.delegate=self;
            [scrollView addSubview:img1];
            scrollView.imageContainer=img1;
        }
        else
        {
            UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Photo/Camera Album"
                                                                            style:UIBarButtonSystemItemDone target:self action:@selector(DefAlbumbtn)];
            self.navigationItem.leftBarButtonItem = rightButton;
            [rightButton release];
            // editdoneButton.enabled=FALSE;
            [self.navigationItem setRightBarButtonItem:nil animated:NO];
            self.title=@"";
            
            selVideoPath=defAlObj.videopathAll;
            NSLog(@"video path to play== %@",selVideoPath);
            [self playVideo];
        }
        
    }
    else
    {
        if([defAlObj.videopathAll isEqualToString:@"(null)"] || [defAlObj.videopathAll isEqualToString:@""])
        {
            ZoomViewController *zoom=[[ZoomViewController alloc] initWithNibName:@"ZoomViewController" bundle:nil];
            [self.navigationController pushViewController:zoom animated:YES];
            [zoom release];
            
            scrollView.contentSize= CGSizeMake(img1.frame.size.width, img1.frame.size.height);
            scrollView.maximumZoomScale=3.0;
            scrollView.minimumZoomScale=20.0;
            scrollView.clipsToBounds=YES;
            scrollView.delegate=self;
            [scrollView addSubview:img1];
            scrollView.imageContainer=img1;
        }
        else
        {
            UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Photo/Camera Album"
                                                                            style:UIBarButtonSystemItemDone target:self action:@selector(DefAlbumbtn)];
            self.navigationItem.leftBarButtonItem = rightButton;
            [rightButton release];
            // editdoneButton.enabled=FALSE;
            [self.navigationItem setRightBarButtonItem:nil animated:NO];
            self.title=@"";
            
            selVideoPath=defAlObj.videopathAll;
            NSLog(@"video path to play== %@",selVideoPath);
            [self playVideo];
        }
    }
}

-(void)DefAlbumbtn
{
    self.title=@"Photo/Camera Album";
    [moviePlayer.view removeFromSuperview];
    //editdoneButton.enabled=true;
    
    [self.navigationItem setLeftBarButtonItem:nil animated:NO];
}

-(IBAction)playVideo
{
    if(UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)
    {
        moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:selVideoPath]];
        moviePlayer.view.frame = CGRectMake(0, 0, 760, 1000);
        [self.view addSubview:moviePlayer.view];
        [moviePlayer play];
    }
    else {
        moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:selVideoPath]];
        moviePlayer.view.frame = CGRectMake(0, 0, 320, 420);
        [self.view addSubview:moviePlayer.view];
        [moviePlayer play];
    }
    
    
}

-(void) getImages
{
    [imgArray removeAllObjects];
    databasepath = [app getDBPathNew];
    
    if (sqlite3_open(databasepath.UTF8String, &dbSecret) == SQLITE_OK) {
        
        NSString *sql = [NSString stringWithFormat:@"select * from AlbumTbl where UserID=%d ORDER BY ImageID ASC",(app.LoginUserID).intValue];
        
        //NSString *sql = [NSString stringWithFormat:@"select * from ViewImageLogtbl where UserID=%@ ",app.LoginUserID];
        NSLog(@"query is %@",sql);
        sqlite3_stmt *selectstmt;
        const char *sel_query=sql.UTF8String;
        
        if(sqlite3_prepare(dbSecret, sel_query, -1, &selectstmt, NULL) == SQLITE_OK) {
            
            while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {
                DefaultAlbumView *albumObj = [[DefaultAlbumView alloc] init];
                
                albumObj.imgId =@((char *)sqlite3_column_text(selectstmt, 0));
                
                albumObj.imgPath = @((char *)sqlite3_column_text(selectstmt, 2));
                
                albumObj.videopathAll=[NSString stringWithFormat:@"%s", sqlite3_column_text(selectstmt, 3)];
                
                [imgArray addObject:albumObj];
                //[contObj release];
            }
        }
        sqlite3_close(dbSecret);
        sqlite3_finalize(selectstmt);
    }
    else
        sqlite3_close(dbSecret);
    
    NSLog(@"img count::: %lu",(unsigned long)imgArray.count);
    addButton.enabled=true;
    if(imgArray.count == 0)
        addButton.enabled=false;
    
    [self dispImg];
}
-(NSString *) getProperties :(NSString *)strProperty
{
    NSString *strReturn=@"false";
    databasepath=[app getDBPathNew];
    NSString *selectSql = nil;
    if (sqlite3_open(databasepath.UTF8String, &dbSecret) == SQLITE_OK)
    {
        
        if([strProperty isEqualToString:@"Duration"])
        {
            selectSql = [NSString stringWithFormat:@"select Duration from AutoLogOffTbl where UserID = %@ ",app.LoginUserID];
        }else if([strProperty isEqualToString:@"Transition"]){
            selectSql = [NSString stringWithFormat:@"select Transition from AutoLogOffTbl where UserID = %@ ",app.LoginUserID];
        }else if([strProperty isEqualToString:@"Repeat"]){
            selectSql = [NSString stringWithFormat:@"select Repeat from AutoLogOffTbl where UserID = %@ ",app.LoginUserID];
        }else if([strProperty isEqualToString:@"Shuffle"]){
            selectSql = [NSString stringWithFormat:@"select Shuffle from AutoLogOffTbl where UserID = %@ ",app.LoginUserID];
        }
        
        NSLog(@"Query : %@",selectSql);
        const char *sqlStatement = selectSql.UTF8String;
        sqlite3_stmt *query_stmt;
        
        if(sqlite3_prepare_v2(dbSecret, sqlStatement, -1, &query_stmt, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(query_stmt) == SQLITE_ROW)
            {
                NSString *checkValue = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(query_stmt, 0)];
                
                NSLog(@"Value == %@",checkValue);
                
                strReturn=checkValue;
            }
            
            sqlite3_finalize(query_stmt);
        }else {
            strReturn =@"nil";
        }
    }
    sqlite3_close(dbSecret);
    return strReturn;
}

-(void)btnPlayPressed{
    
    NSString *strReturnedShuffle=[self getProperties:@"Shuffle"];
    NSString *strReturnedRepeat=[self getProperties:@"Repeat"];
    NSString *strReturned=[self getProperties:@"Duration"];
    NSInteger intAnimationTime=strReturned.integerValue;
    
    NSString *strReturnedForAni=[self getProperties:@"Transition"];
    NSInteger intAnimationType=strReturnedForAni.integerValue;
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        
        playImgsVw.hidden=false;
        self.scrollVw.hidden=true;
        
        if(![strReturnedRepeat isEqualToString:@"true"])
        {
            if(imgnum ==playImagesArr.count)
            {
                [self.playImgsVw removeFromSuperview];
                playImgsVw.hidden=true;
                self.scrollVw.hidden=false;
                imgnum=0;
                
            }else {
                [self.view addSubview:playImgsVw];
                [playImgsVw addSubview:slideImage];
                
                [UIView beginAnimations:@"Images transition" context:nil];
                [UIView setAnimationDuration:intAnimationTime];
                
                
                if(intAnimationType==1)
                {
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:playImgsVw cache:YES];
                }else if(intAnimationType==2)
                {
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:playImgsVw cache:YES];
                }else if(intAnimationType==3)
                {
                    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:playImgsVw cache:YES];
                }else {
                    
                    NSInteger randNo=  arc4random()%3;
                    NSLog(@"%ld",(long)randNo);
                    if(randNo==1)
                    {
                        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:playImgsVw cache:YES];
                    }else if(randNo==2){
                        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:playImgsVw cache:YES];
                    }else {
                        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:playImgsVw cache:YES];
                    }
                    
                }
                
                if([strReturnedShuffle isEqualToString:@"true"])
                {
                    NSInteger randShuffle=   arc4random()% playImagesArr.count ;
                    slideImage.image= [UIImage imageWithContentsOfFile:playImagesArr[randShuffle]];
                }
                else {
                    slideImage.image= [UIImage imageWithContentsOfFile:playImagesArr[imgnum]];
                }
                
                [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                [UIView commitAnimations];
                
                imgnum++;
                NSLog(@"img num== %d",imgnum);
                
                [self performSelector:@selector(btnPlayPressed) withObject:nil afterDelay:intAnimationTime];
                
            }
        }
        else
        {
            if(imgnum ==playImagesArr.count)
            {
                imgnum=0;
            }
            [self.view addSubview:playImgsVw];
            [playImgsVw addSubview:slideImage];
            
            [UIView beginAnimations:@"Images transition" context:nil];
            [UIView setAnimationDuration:intAnimationTime];
            
            
            if(intAnimationType==1)
            {
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:playImgsVw cache:YES];
            }else if(intAnimationType==2)
            {
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:playImgsVw cache:YES];
            }else if(intAnimationType==3)
            {
                [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:playImgsVw cache:YES];
            }else {
                
                NSInteger randNo=  arc4random()%3;
                NSLog(@"%ld",(long)randNo);
                if(randNo==1)
                {
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:playImgsVw cache:YES];
                }else if(randNo==2){
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:playImgsVw cache:YES];
                }else {
                    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:playImgsVw cache:YES];
                }
                
            }
            
            if([strReturnedShuffle isEqualToString:@"true"])
            {
                NSInteger randShuffle=   arc4random()% playImagesArr.count ;
                slideImage.image= [UIImage imageWithContentsOfFile:playImagesArr[randShuffle]];
            }
            else {
                slideImage.image= [UIImage imageWithContentsOfFile:playImagesArr[imgnum]];
            }
            
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            [UIView commitAnimations];
            
            imgnum++;
            NSLog(@"img num== %d",imgnum);
            
            [self performSelector:@selector(btnPlayPressed) withObject:nil afterDelay:intAnimationTime];
        }
    }
    else {
        playImgsVw.hidden=false;
        self.scrollVw.hidden=true;
        
        
        
        if(![strReturnedRepeat isEqualToString:@"true"])
        {
            if(imgnum ==playImagesArr.count)
            {
                [self.playImgsVw removeFromSuperview];
                playImgsVw.hidden=true;
                self.scrollVw.hidden=false;
                imgnum=0;
                
            }else {
                [self.view addSubview:playImgsVw];
                [playImgsVw addSubview:slideImage];
                
                // 1  UIViewAnimationCurveEaseOut
                // 2 UIViewAnimationCurveEaseInOut
                // 3 UIViewAnimationTransitionFlipFromLeft
                // 4 UIViewAnimationTransitionCurlUp
                // 4 UIViewAnimationTransitionCurlUp
                [UIView beginAnimations:@"Images transition" context:nil];
                [UIView setAnimationDuration:intAnimationTime];
                
                if(intAnimationType==1)
                {
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:playImgsVw cache:YES];
                }else if(intAnimationType==2)
                {
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:playImgsVw cache:YES];
                }else if(intAnimationType==3)
                {
                    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:playImgsVw cache:YES];
                }else {
                    
                    NSInteger randNo=  arc4random()%3;
                    NSLog(@"%ld",(long)randNo);
                    if(randNo==1)
                    {
                        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:playImgsVw cache:YES];
                    }else if(randNo==2){
                        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:playImgsVw cache:YES];
                    }else {
                        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:playImgsVw cache:YES];
                    }
                    
                }
                
                if([strReturnedShuffle isEqualToString:@"true"])
                {
                    NSInteger randShuffle=   arc4random()% playImagesArr.count ;
                    slideImage.image= [UIImage imageWithContentsOfFile:playImagesArr[randShuffle]];
                }
                else {
                    slideImage.image= [UIImage imageWithContentsOfFile:playImagesArr[imgnum]];
                }
                [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                [UIView commitAnimations];
                
                imgnum++;
                NSLog(@"img num== %d",imgnum);
                
                [self performSelector:@selector(btnPlayPressed) withObject:nil afterDelay:intAnimationTime];
                
            }
        }
        else
        {
            if(imgnum ==playImagesArr.count)
            {
                imgnum=0;
            }
            
            [self.view addSubview:playImgsVw];
            [playImgsVw addSubview:slideImage];
            
            // 1  UIViewAnimationCurveEaseOut
            // 2 UIViewAnimationCurveEaseInOut
            // 3 UIViewAnimationTransitionFlipFromLeft
            // 4 UIViewAnimationTransitionCurlUp
            // 4 UIViewAnimationTransitionCurlUp
            [UIView beginAnimations:@"Images transition" context:nil];
            [UIView setAnimationDuration:intAnimationTime];
            
            if(intAnimationType==1)
            {
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:playImgsVw cache:YES];
            }else if(intAnimationType==2)
            {
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:playImgsVw cache:YES];
            }else if(intAnimationType==3)
            {
                [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:playImgsVw cache:YES];
            }else {
                
                NSInteger randNo=  arc4random()%3;
                NSLog(@"%ld",(long)randNo);
                if(randNo==1)
                {
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:playImgsVw cache:YES];
                }else if(randNo==2){
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:playImgsVw cache:YES];
                }else {
                    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:playImgsVw cache:YES];
                }
                
            }
            
            if([strReturnedShuffle isEqualToString:@"true"])
            {
                NSInteger randShuffle=   arc4random()% playImagesArr.count ;
                slideImage.image= [UIImage imageWithContentsOfFile:playImagesArr[randShuffle]];
            }
            else {
                slideImage.image= [UIImage imageWithContentsOfFile:playImagesArr[imgnum]];
            }
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            [UIView commitAnimations];
            
            imgnum++;
            NSLog(@"img num== %d",imgnum);
            
            [self performSelector:@selector(btnPlayPressed) withObject:nil afterDelay:intAnimationTime];
        }
        
    }
}

-(IBAction)dispNextImage:(id)sender{
    
    
}

#pragma mark - GADDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    if(self == self.navigationController.topViewController)
        [self.interstitial presentFromRootViewController:self];
}

@end
