//  AlbumProcessView.m
//  SecretApp
//
//  Created by c62 on 23/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlbumProcessView.h"
#import "AppDelegate.h"
#import <QuartzCore/Quartzcore.h>
#import "viewImageViewController.h"

@interface AlbumProcessView ()
{
    DDSocialDialog *dialog;
}
@end

@implementation AlbumProcessView
@synthesize facebook;

@synthesize imgArray,scrollVw,toolbar,ChekUncheckFlag,checkImgbtn,checkedImgPathArr,videopathAll,checkedVideoArr,selVideoPath,totalVideoLbl;

@synthesize imgId,imgPath,checkedImgArr,lastImg,totalImgLbl,CustomLibraryVw,actIndicator,videoIcon;

static NSString* kAppId = @"145792598897737";
int videos;

AppDelegate *app;
UIButton *pasteBtn;
UIBarButtonItem *selectAllBtn ;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    [videoIcon release];
    [totalVideoLbl release];
    [selVideoPath release];
    [videopathAll release];
    [actIndicator release];
    [CustomLibraryVw release];
    [lastImg release];
    [totalImgLbl release];
    [checkedVideoArr release];
    [checkImgbtn release];
    [checkedImgPathArr release];
    [checkedImgArr release];
    [imgId release];
    [imgPath release];
    [imgArray release];
    [scrollVw release];
    [toolbar release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [toolbar setBarTintColor:[UIColor blackColor]];
    }
    // Do any additional setup after loading the view from its nib.
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //self.library = [[ALAssetsLibrary alloc] init];
    
    //   initialize array  //
    
    imgArray=[[NSMutableArray alloc] init];
    checkedImgArr=[[NSMutableArray alloc] init];
    checkedImgPathArr=[[NSMutableArray alloc] init];
    checkedVideoArr=[[NSMutableArray alloc] init];
    
    // set scrollview properties //
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        
        scrollVw.scrollEnabled = YES;
        scrollVw.delegate = self;
        // scrollVw.frame=CGRectMake(scrollVw.frame.origin.x, scrollVw.frame.origin.y, scrollVw.frame.size.width,2000);
        scrollVw.contentSize=CGSizeMake(768, 5000);
        [self.view addSubview:scrollVw];
        
        //set Right button in navigation bar //
        
        selectAllBtn = [[UIBarButtonItem alloc] initWithTitle:@"Select All"
                                                        style:UIBarButtonSystemItemDone target:self action:@selector(btnSelectAllClicked:)];
        self.navigationItem.rightBarButtonItem = selectAllBtn;
        selectAllBtn.style=UIBarButtonItemStyleBordered;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            selectAllBtn.tintColor=[UIColor whiteColor];
        }
        [selectAllBtn release];
        NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:4];
        UIBarButtonItem *flexibaleSpaceBarButton0 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [flexibaleSpaceBarButton0 setWidth:200];
        [buttons addObject:flexibaleSpaceBarButton0];
        [flexibaleSpaceBarButton0 release];
        //Set Buttons in Toolbar //
        
        
        
        UIButton *contBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [contBtn addTarget:self action:@selector(shareImagesClicked) forControlEvents:UIControlEventTouchUpInside];
        contBtn.frame = CGRectMake(0.00, 300.0,65.0, 30.0);
        [contBtn setTitle:@"Share"  forState:UIControlStateNormal];
        contBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16.0];
        [contBtn setBackgroundImage:[UIImage imageNamed:@"menubar.png"] forState:UIControlStateNormal];
        [self.view addSubview:contBtn];
        
        UIBarButtonItem *contlayerbtn =[[UIBarButtonItem alloc]initWithCustomView:contBtn];
        contlayerbtn.style = UIBarButtonItemStyleBordered;
        [buttons addObject:contlayerbtn];
        [contlayerbtn release];
        
        UIBarButtonItem *flexibaleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [flexibaleSpaceBarButton setWidth:10 ];
        [buttons addObject:flexibaleSpaceBarButton];
        [flexibaleSpaceBarButton release];
        
        /* UIButton *addvideoButton = [UIButton buttonWithType: UIButtonTypeCustom];
         [addvideoButton addTarget:self action:@selector(btnMoveImage:) forControlEvents:UIControlEventTouchUpInside];
         addvideoButton.frame = CGRectMake(300.00, 300.0, 45.0, 30.0);
         [addvideoButton setTitle:@"Move" forState:UIControlStateNormal];
         addvideoButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:11.0];
         [addvideoButton setBackgroundImage:[UIImage imageNamed:@"navbarbtn.png"] forState:UIControlStateNormal];
         [self.view addSubview:addvideoButton];
         
         UIBarButtonItem *doneButton =[[UIBarButtonItem alloc]initWithCustomView:addvideoButton];
         doneButton.style = UIBarButtonItemStyleBordered;
         
         [buttons addObject:doneButton];
         [doneButton release];
         
         UIBarButtonItem *flexibaleSpaceBarButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
         [flexibaleSpaceBarButton1 setWidth:5];
         [buttons addObject:flexibaleSpaceBarButton1];
         [flexibaleSpaceBarButton1 release];*/
        
        UIButton *cameraAddBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [cameraAddBtn addTarget:self action:@selector(btnCopyImagePressed) forControlEvents:UIControlEventTouchUpInside];
        cameraAddBtn.frame = CGRectMake(330.00, 300.0, 65.0, 30.0);
        [cameraAddBtn setTitle:@"Copy" forState:UIControlStateNormal];
        cameraAddBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16.0];
        [cameraAddBtn setBackgroundImage:[UIImage imageNamed:@"menubar.png"] forState:UIControlStateNormal];
        [self.view addSubview:cameraAddBtn];
        
        UIBarButtonItem *wwwlayerbtn =[[UIBarButtonItem alloc]initWithCustomView:cameraAddBtn];
        wwwlayerbtn.style = UIBarButtonItemStyleBordered;
        [buttons addObject:wwwlayerbtn];
        [wwwlayerbtn release];
        
        UIBarButtonItem *flexibaleSpaceBarButton2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [flexibaleSpaceBarButton2 setWidth:10];
        [buttons addObject:flexibaleSpaceBarButton2];
        [flexibaleSpaceBarButton2 release];
        
        pasteBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [pasteBtn addTarget:self action:@selector(btnPastePressed) forControlEvents:UIControlEventTouchUpInside];
        pasteBtn.frame = CGRectMake(330.00, 300.0, 65.0, 30.0);
        [pasteBtn setTitle:@"Paste" forState:UIControlStateNormal];
        pasteBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16.0];
        [pasteBtn setBackgroundImage:[UIImage imageNamed:@"menubar.png"] forState:UIControlStateNormal];
        [self.view addSubview:pasteBtn];
        
        UIBarButtonItem *sslayerbtn =[[UIBarButtonItem alloc]initWithCustomView:pasteBtn];
        sslayerbtn.style = UIBarButtonItemStyleBordered;
        [buttons addObject:sslayerbtn];
        [sslayerbtn release];
        
        UIBarButtonItem *flexibaleSpaceBarButton3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [flexibaleSpaceBarButton3 setWidth:10];
        [buttons addObject:flexibaleSpaceBarButton3];
        [flexibaleSpaceBarButton3 release];
        
        UIButton *openCameraBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [openCameraBtn addTarget:self action:@selector(confirmDeleteImg) forControlEvents:UIControlEventTouchUpInside];
        openCameraBtn.frame = CGRectMake(330.00, 300.0, 65.0, 30.0);
        openCameraBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16.0];
        [openCameraBtn setTitle:@"Delete" forState:UIControlStateNormal];
        [openCameraBtn setBackgroundImage:[UIImage imageNamed:@"menubar.png"] forState:UIControlStateNormal];
        
        [self.view addSubview:openCameraBtn];
        
        UIBarButtonItem *cmlayerbtn =[[UIBarButtonItem alloc]initWithCustomView:openCameraBtn];
        cmlayerbtn.style = UIBarButtonItemStyleBordered;
        [buttons addObject:cmlayerbtn];
        [cmlayerbtn release];
        
        [toolbar setItems:buttons];
        
        [buttons release];
        
    }else {
        
        
        scrollVw.scrollEnabled = YES;
        scrollVw.delegate = self;
        scrollVw.contentSize=CGSizeMake(320, 1000);
        [self.view addSubview:scrollVw];
        
        //set Right button in navigation bar //
        
        selectAllBtn = [[UIBarButtonItem alloc] initWithTitle:@"Select All"
                                                        style:UIBarButtonSystemItemDone target:self action:@selector(btnSelectAllClicked:)];
        self.navigationItem.rightBarButtonItem = selectAllBtn;
        selectAllBtn.style=UIBarButtonItemStyleBordered;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            selectAllBtn.tintColor=[UIColor whiteColor];
        }
        [selectAllBtn release];
        
        //Set Buttons in Toolbar //
        
        NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:4];
        
        UIButton *contBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [contBtn addTarget:self action:@selector(shareImagesClicked) forControlEvents:UIControlEventTouchUpInside];
        contBtn.frame = CGRectMake(330.00, 300.0, 60.0, 30.0);
        [contBtn setTitle:@"Share"  forState:UIControlStateNormal];
        contBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
        [contBtn setBackgroundImage:[UIImage imageNamed:@"menubar.png"] forState:UIControlStateNormal];
        [self.view addSubview:contBtn];
        
        UIBarButtonItem *contlayerbtn =[[UIBarButtonItem alloc]initWithCustomView:contBtn];
        contlayerbtn.style = UIBarButtonItemStyleBordered;
        [buttons addObject:contlayerbtn];
        [contlayerbtn release];
        
        UIBarButtonItem *flexibaleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [flexibaleSpaceBarButton setWidth:10];
        [buttons addObject:flexibaleSpaceBarButton];
        [flexibaleSpaceBarButton release];
        
        /* UIButton *addvideoButton = [UIButton buttonWithType: UIButtonTypeCustom];
         [addvideoButton addTarget:self action:@selector(btnMoveImage:) forControlEvents:UIControlEventTouchUpInside];
         addvideoButton.frame = CGRectMake(300.00, 300.0, 45.0, 30.0);
         [addvideoButton setTitle:@"Move" forState:UIControlStateNormal];
         addvideoButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:11.0];
         [addvideoButton setBackgroundImage:[UIImage imageNamed:@"navbarbtn.png"] forState:UIControlStateNormal];
         [self.view addSubview:addvideoButton];
         
         UIBarButtonItem *doneButton =[[UIBarButtonItem alloc]initWithCustomView:addvideoButton];
         doneButton.style = UIBarButtonItemStyleBordered;
         
         [buttons addObject:doneButton];
         [doneButton release];
         
         UIBarButtonItem *flexibaleSpaceBarButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
         [flexibaleSpaceBarButton1 setWidth:5];
         [buttons addObject:flexibaleSpaceBarButton1];
         [flexibaleSpaceBarButton1 release];*/
        
        UIButton *cameraAddBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [cameraAddBtn addTarget:self action:@selector(btnCopyImagePressed) forControlEvents:UIControlEventTouchUpInside];
        cameraAddBtn.frame = CGRectMake(330.00, 300.0, 60.0, 30.0);
        [cameraAddBtn setTitle:@"Copy" forState:UIControlStateNormal];
        cameraAddBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
        [cameraAddBtn setBackgroundImage:[UIImage imageNamed:@"menubar.png"] forState:UIControlStateNormal];
        [self.view addSubview:cameraAddBtn];
        
        UIBarButtonItem *wwwlayerbtn =[[UIBarButtonItem alloc]initWithCustomView:cameraAddBtn];
        wwwlayerbtn.style = UIBarButtonItemStyleBordered;
        [buttons addObject:wwwlayerbtn];
        [wwwlayerbtn release];
        
        UIBarButtonItem *flexibaleSpaceBarButton2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [flexibaleSpaceBarButton2 setWidth:10];
        [buttons addObject:flexibaleSpaceBarButton2];
        [flexibaleSpaceBarButton2 release];
        
        pasteBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [pasteBtn addTarget:self action:@selector(btnPastePressed) forControlEvents:UIControlEventTouchUpInside];
        pasteBtn.frame = CGRectMake(330.00, 300.0, 60.0, 30.0);
        [pasteBtn setTitle:@"Paste" forState:UIControlStateNormal];
        pasteBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
        [pasteBtn setBackgroundImage:[UIImage imageNamed:@"menubar.png"] forState:UIControlStateNormal];
        [self.view addSubview:pasteBtn];
        
        UIBarButtonItem *sslayerbtn =[[UIBarButtonItem alloc]initWithCustomView:pasteBtn];
        sslayerbtn.style = UIBarButtonItemStyleBordered;
        [buttons addObject:sslayerbtn];
        [sslayerbtn release];
        
        UIBarButtonItem *flexibaleSpaceBarButton3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [flexibaleSpaceBarButton3 setWidth:10];
        [buttons addObject:flexibaleSpaceBarButton3];
        [flexibaleSpaceBarButton3 release];
        
        UIButton *openCameraBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [openCameraBtn addTarget:self action:@selector(confirmDeleteImg) forControlEvents:UIControlEventTouchUpInside];
        openCameraBtn.frame = CGRectMake(330.00, 300.0, 60.0, 30.0);
        openCameraBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
        [openCameraBtn setTitle:@"Delete" forState:UIControlStateNormal];
        [openCameraBtn setBackgroundImage:[UIImage imageNamed:@"menubar.png"] forState:UIControlStateNormal];
        
        [self.view addSubview:openCameraBtn];
        
        UIBarButtonItem *cmlayerbtn =[[UIBarButtonItem alloc]initWithCustomView:openCameraBtn];
        cmlayerbtn.style = UIBarButtonItemStyleBordered;
        [buttons addObject:cmlayerbtn];
        [cmlayerbtn release];
        
        [toolbar setItems:buttons];
        
        [buttons release];
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{    
    [self.navigationController setNavigationBarHidden:NO];
    self.title=@"Select Photos";
    
    
    
    [self.actIndicator startAnimating ];
    imgArray=[[NSMutableArray alloc] init];
    checkedImgArr=[[NSMutableArray alloc] init];
    checkedImgPathArr =[[NSMutableArray alloc] init];
    checkedVideoArr=[[NSMutableArray alloc] init];
    self.CustomLibraryVw.hidden=true;
    newSize = CGSizeMake(480.0,480.0);
    pasteBtn.enabled=false;
    videos=0;
    
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

-(void) getImages
{
    [imgArray removeAllObjects];
    databasepath = [app getDBPathNew];
    
    if (sqlite3_open([databasepath UTF8String], &dbSecret) == SQLITE_OK) {
        
        NSString *sql = [NSString stringWithFormat:@"select * from AlbumTbl where UserID=%d ORDER BY ImageID ASC",[app.LoginUserID intValue]];
        
        sqlite3_stmt *selectstmt;
        const char *sel_query=[sql UTF8String];
        
        if(sqlite3_prepare(dbSecret, sel_query, -1, &selectstmt, NULL) == SQLITE_OK) {
            
            while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {
                AlbumProcessView *albumObj = [[AlbumProcessView alloc] init];
                
                albumObj.imgId =[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
                
                albumObj.imgPath = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
                
                albumObj.videopathAll=[NSString stringWithFormat:@"%s",sqlite3_column_text(selectstmt, 3)];
                
                [imgArray addObject:albumObj];
                //[contObj release];
            }
        }
        sqlite3_finalize(selectstmt);
    }
    else
        sqlite3_close(dbSecret);
    
    NSLog(@"img count::: %d",[imgArray count]);
    [self dispImages];
}

-(void)dispImages
{    
    for(UIView * view in scrollVw.subviews)
    {
        if([view isKindOfClass:[UIButton class]] || [view isKindOfClass:[UIControl class]])
        {
            [view removeFromSuperview];
            view = nil;
        }
    }
    NSLog(@"num of Images :::: %d",[imgArray count]);
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
        
        int width=100;
        int height=100;
        int x=5;
        int y=5;
        videos=0;
        
        for (int i = 1 ; i<=[imgArray count] ; i++)
        {
            AlbumProcessView *alObj=[imgArray objectAtIndex:i-1];
            
            if([alObj.videopathAll isEqualToString:@""] || [alObj.videopathAll isEqualToString:@"(null)"])
            {
                
                //set View for Images Only //
                img1=[[UIButton alloc] init];
                // img1.contentMode = UIViewContentModeScaleAspectFit;
                img1.frame=CGRectMake(x,y,width,height);
                [img1 setImage:[UIImage imageWithContentsOfFile:alObj.imgPath ]forState:UIControlStateNormal];
                [img1 addTarget:self action:@selector(checkImgAction:) forControlEvents:(UIControlEventTouchUpInside)];
                [img1 setTag:i-1];
                //  app.ZoomImage=defAlObj.imgPath;
                isImgFlag=true;
            }
            else
            {
                //set View for Videos //
                
                videos++;
                img1=[[UIButton alloc] init];
                img1.frame=CGRectMake(x,y,width,height);
                [img1 setImage:[UIImage imageWithContentsOfFile:alObj.imgPath ]forState:UIControlStateNormal];
                [img1 addTarget:self action:@selector(checkImgAction:) forControlEvents:(UIControlEventTouchUpInside)];
                [img1 setTag:i-1];
                
                UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"movie.png"]];
                img.frame = CGRectMake(0,70,40,40);
                [img1 addSubview:img];
            }
            
            (i%3)==0 ? (y=y+105) : (y=y);
            (i%3)==0 ? (x=5) : (x=x+105);   
            NSLog(@"total video=== %d",videos);
            
            [scrollVw addSubview:img1];
            [self.view addSubview:scrollVw];
        }
        
    }else{
        int width=240;
        int height=240;
        int x=15;
        int y=10;
        videos=0;
        
        for (int i = 1 ; i<=[imgArray count] ; i++)
        {
            AlbumProcessView *alObj=[imgArray objectAtIndex:i-1];
            
            if([alObj.videopathAll isEqualToString:@""] || [alObj.videopathAll isEqualToString:@"(null)"])
            {
                
                //set View for Images Only //
                img1=[[UIButton alloc] init];
                // img1.contentMode = UIViewContentModeScaleAspectFit;
                img1.frame=CGRectMake(x,y,width,height);
                [img1 setImage:[UIImage imageWithContentsOfFile:alObj.imgPath ]forState:UIControlStateNormal];
                [img1 addTarget:self action:@selector(checkImgAction:) forControlEvents:(UIControlEventTouchUpInside)];
                [img1 setTag:i-1];
                //  app.ZoomImage=defAlObj.imgPath;
                isImgFlag=true;
            }
            else
            {
                //set View for Videos //
                
                videos++;
                img1=[[UIButton alloc] init];
                img1.frame=CGRectMake(x,y,width,height);
                [img1 setImage:[UIImage imageWithContentsOfFile:alObj.imgPath ]forState:UIControlStateNormal];
                [img1 addTarget:self action:@selector(checkImgAction:) forControlEvents:(UIControlEventTouchUpInside)];
                [img1 setTag:i-1];
                
                UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"movie.png"]];
                img.frame = CGRectMake(0,200,40,40);
                [img1 addSubview:img];
            }
            
            (i%3)==0 ? (y=y+250) : (y=y);
            (i%3)==0 ? (x=15) : (x=x+250);   
            NSLog(@"total video=== %d",videos);
            
            [scrollVw addSubview:img1];
            [self.view addSubview:scrollVw];
        }
        
    }
    
    [actIndicator stopAnimating];
    actIndicator.hidden =true;
}

-(void)checkImgAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int k=[sender tag];
    
    AlbumProcessView *alObj=[imgArray objectAtIndex:k];
    selImgID=alObj.imgId;
    selVideoPath=alObj.videopathAll;
    
    if([btn isMemberOfClass:[UIControl class]])
    {
        [checkedImgArr removeObject:selImgID];
        [checkedImgPathArr removeObject:alObj.imgPath];
        [checkedVideoArr removeObject:alObj.videopathAll];
        [btn removeFromSuperview];
    }
    else
    {
        UIControl *view  =[[UIControl alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        [view addTarget:self action:@selector(checkImgAction:) forControlEvents:UIControlEventTouchUpInside];
        // view.backgroundColor  = [UIColor colorWithWhite:1.0 alpha:0.5];
        [view setTag:[btn tag]];
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checked_new.png"]];
        img.frame = CGRectMake(5,5, 20, 20);
        [view addSubview:img];
        [btn addSubview:view];
        
        [checkedImgArr addObject:selImgID];
        [checkedImgPathArr addObject:alObj.imgPath];
        [checkedVideoArr addObject:selVideoPath];
        
        
    }
}

-(IBAction)btnSelectAllClicked:(id)sender
{
    [checkedImgArr removeAllObjects];
    [checkedImgPathArr removeAllObjects];
    [checkedVideoArr removeAllObjects];
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        
        if([selectAllBtn.title isEqualToString:@"Select All"])
        {
            selectAllBtn.title=@"Deselect All";
            
            int width=240 ;
            int height=240;
            int x=15;
            int y=10;            
            for (int i = 1 ; i<=[imgArray count] ; i++)
            {
                AlbumProcessView *albmObj=[imgArray objectAtIndex:i-1];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setImage:[UIImage imageWithContentsOfFile:albmObj.imgPath] forState:UIControlStateNormal];
                [btn setFrame:CGRectMake(x,y, width, height)];
                [btn addTarget:self action:@selector(checkImgAction:) forControlEvents:(UIControlEventTouchUpInside)];
                [btn setTag:i-1];
                [scrollVw addSubview:btn];
                
                (i%3)==0 ? (y=y+250) : (y=y);
                (i%3)==0 ? (x=15) : (x=x+250);
                
                UIControl *view  =[[UIControl alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
                [view addTarget:self action:@selector(checkImgAction:) forControlEvents:UIControlEventTouchUpInside];
                [view setTag:i-1];
                
                UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checked_new.png"]];
                img.frame = CGRectMake(5,5, 20, 20);
                [view addSubview:img];
                [btn addSubview:view];
                
                [checkedImgArr addObject:albmObj.imgId];
                [checkedImgPathArr addObject:albmObj.imgPath];
                [checkedVideoArr addObject:albmObj.videopathAll];
            }
            
            [self.view addSubview:scrollVw];
            
        }
        else
        {
            selectAllBtn.title=@"Select All";
            [self dispImages];
            
            [checkedImgArr removeAllObjects];
            [checkedImgPathArr removeAllObjects];
            [checkedVideoArr removeAllObjects];
        }
        
    }else {
        
        
        if([selectAllBtn.title isEqualToString:@"Select All"])
        {
            selectAllBtn.title=@"Deselect All";
            
            int width=100;
            int height=100;
            int x=5;
            int y=5;
            
            for (int i = 1 ; i<=[imgArray count] ; i++)
            {
                AlbumProcessView *albmObj=[imgArray objectAtIndex:i-1];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setImage:[UIImage imageWithContentsOfFile:albmObj.imgPath] forState:UIControlStateNormal];
                [btn setFrame:CGRectMake(x,y, width, height)];
                [btn addTarget:self action:@selector(checkImgAction:) forControlEvents:(UIControlEventTouchUpInside)];
                [btn setTag:i-1];
                [scrollVw addSubview:btn];
                
                (i%3)==0 ? (y=y+105) : (y=y);
                (i%3)==0 ? (x=5) : (x=x+105);
                
                UIControl *view  =[[UIControl alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
                [view addTarget:self action:@selector(checkImgAction:) forControlEvents:UIControlEventTouchUpInside];
                [view setTag:i-1];
                
                UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checked_new.png"]];
                img.frame = CGRectMake(5,5, 20, 20);
                [view addSubview:img];
                [btn addSubview:view];
                
                [checkedImgArr addObject:albmObj.imgId];
                [checkedImgPathArr addObject:albmObj.imgPath];
                [checkedVideoArr addObject:albmObj.videopathAll];
            }
            
            [self.view addSubview:scrollVw];
            
        }
        else
        {
            selectAllBtn.title=@"Select All";
            [self dispImages];
            
            [checkedImgArr removeAllObjects];
            [checkedImgPathArr removeAllObjects];
            [checkedVideoArr removeAllObjects];
        }
    }
}

-(void)btnCopyImagePressed
{
    if([checkedImgArr count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Message" message:@"Please Select Image To Be Copied." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        NSLog(@"image to be copied === %@",checkedImgPathArr);
        
        [pasteBtn setTitle:[NSString stringWithFormat:@"Paste (%d)",[checkedImgArr count]] forState:UIControlStateNormal];
        pasteBtn.enabled=true;
    }
}

-(void)btnPastePressed
{
    [actIndicator startAnimating];
    
    sqlite3_stmt *stmt;
    databasepath=[app getDBPathNew];
    
    for(int p=0;p<[checkedImgArr count];p++)
    {
        const char *dbpath=[databasepath UTF8String];
        if(sqlite3_open(dbpath, &dbSecret) == SQLITE_OK)
        {
            NSString *insertquery=[NSString stringWithFormat:@"Insert into AlbumTbl(UserID,ImagePath,VideoPath) VALUES(%d,\"%@\",\"%@\")",[app.LoginUserID intValue],[checkedImgPathArr objectAtIndex:p],[checkedVideoArr objectAtIndex:p]];
            
            NSLog(@"insert query== %@",insertquery);
            
            const char *insert_query=[insertquery UTF8String];
            sqlite3_prepare(dbSecret, insert_query, -1, &stmt, NULL);
            
            if(sqlite3_step(stmt)== SQLITE_DONE)
            {
                NSLog(@"img path=== %@ pasted..",[checkedImgPathArr objectAtIndex:p]);
                [pasteBtn setTitle:@"Paste" forState:UIControlStateNormal];
                
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
    }
    
    [checkedImgArr removeAllObjects];
    [checkedImgPathArr removeAllObjects];
    [checkedVideoArr removeAllObjects];
    
    pasteBtn.enabled=false;
    [self getImages];
}

#pragma mark - Delete Image Actionsheet Methods

-(void)confirmDeleteImg{
    if([checkedImgArr count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Message" message:@"Please Select Image To Be Deleted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            dialog = [[DDSocialDialog alloc]initWithFrame:CGRectMake(250, 600, 320, 200) theme:DDSocialDialogThemeTwitter];
            //dialog.titleLabel.text = @"Sure to delete?";
            //dialog.titleLabel.textAlignment = UITextAlignmentCenter;
            
            UIButton *btnDelete = [[UIButton alloc]initWithFrame:CGRectMake(35,60,220,40)];
            //[btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
            btnDelete.titleLabel.textColor = [UIColor whiteColor];
            [btnDelete.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:25.0]];
            [btnDelete setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
            
            //[btnDelete setBackgroundColor:[UIColor redColor]];
            [btnDelete addTarget:self action:@selector(selectEvent:) forControlEvents:UIControlEventTouchUpInside];
            [btnDelete setTag:0];
            
            UIButton *btnCancel = [[UIButton alloc]initWithFrame:CGRectMake(35,120,220,40)];
            //[btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
            btnCancel.titleLabel.textColor = [UIColor whiteColor];
            [btnCancel.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:25.0]];
            [btnCancel setBackgroundImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
            //[btnCancel setBackgroundColor:[UIColor redColor]];
            [btnCancel addTarget:self action:@selector(selectEvent:) forControlEvents:UIControlEventTouchUpInside];
            [btnCancel setTag:1];
            
            [dialog addSubview:btnDelete];
            [dialog addSubview:btnCancel];
            [dialog show];
            [dialog release];
        }
        else if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Sure To Delete?" delegate:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Delete", nil];
            popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            popupQuery.delegate=self;
            [popupQuery showInView:self.view];
            [popupQuery release];
        }
    }
}

-(IBAction)selectEvent:(id)sender
{
    if ([sender tag] == 0)
    {
        [self delImage];
        [dialog dismiss:YES];
    }
    else
    {
        NSLog(@"Cancel..");
        [dialog dismiss:YES];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0)
    {
            [self delImage];
    }
    else
    {
        NSLog(@"Cancel..");
    }
}

-(void)delImage{
    
    databasepath=[app getDBPathNew];
    for(int p=0;p<[checkedImgArr count];p++)
    {
        NSString *imgid=[checkedImgArr objectAtIndex:p];
        
        if (sqlite3_open([databasepath UTF8String], &dbSecret) == SQLITE_OK) 
        {
            NSString *selectSql = [NSString stringWithFormat:@"Delete from AlbumTbl Where ImageID=%d",[imgid intValue]];
            
            NSLog(@"Query : %@",selectSql);
            
            const char *deleteStmt = [selectSql UTF8String];
            sqlite3_stmt *query_stmt;
            
            if(sqlite3_prepare_v2(dbSecret, deleteStmt, -1, &query_stmt, NULL) == SQLITE_OK)
            {
                if(sqlite3_step(query_stmt)== SQLITE_DONE)
                {
                    NSLog(@"img id === [ %d ] Deleted...",[imgid intValue]);
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:@"Deleted Result" message:@"Image Not Deleted...." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    
                }
                sqlite3_finalize(query_stmt);
            }
        }
    }
    sqlite3_close(dbSecret);
    [checkedImgArr removeAllObjects];
    [checkedImgPathArr removeAllObjects];
    [checkedVideoArr removeAllObjects];
    
    [self getImages];
}

-(IBAction)btnMoveImage:(id)sender{
    
    if([checkedImgArr count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Message" message:@"Please Select Image To Be Moved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        AlbumProcessView *alObj=[imgArray objectAtIndex:0];
        
        self.title=@"";
        self.navigationItem.rightBarButtonItem=nil;
        
        UIBarButtonItem *canseleBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                       style:UIBarButtonSystemItemDone target:self action:@selector(TransDown)];
        self.navigationItem.leftBarButtonItem = canseleBtn;
        canseleBtn.style=UIBarButtonItemStyleBordered;
        [canseleBtn release];
        
        CATransition *transUp=[CATransition animation];
        transUp.duration=0.5;
        transUp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transUp.delegate=self;
        transUp.type=kCATransitionMoveIn;
        transUp.subtype=kCATransitionFromTop;
        [CustomLibraryVw.layer addAnimation:transUp forKey:nil];
        CustomLibraryVw.hidden=NO;
        
        [self.view addSubview:CustomLibraryVw];
        
        totalImgLbl.text=[NSString stringWithFormat:@"%d",[imgArray count]-videos];
        if(videos>0)
        {
            totalVideoLbl.hidden=false;
            totalVideoLbl.text=[NSString stringWithFormat:@"%d",videos];
            videoIcon.hidden=false;
        }
        else
        {
            videoIcon.hidden=true;
            totalVideoLbl.hidden=true;
        }
        
        lastImg.image=[UIImage imageWithContentsOfFile:alObj.imgPath];        
    }
}

-(IBAction)TransDown
{    
    CATransition *transDown=[CATransition animation];
    transDown.duration=0.6;
    transDown.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transDown.delegate=self;
    transDown.type=kCATransitionReveal;
    transDown.subtype=kCATransitionFromBottom;
    [CustomLibraryVw.layer addAnimation:transDown forKey:nil];
    CustomLibraryVw.hidden=YES;
    
    self.navigationItem.leftBarButtonItem=nil;
    self.title=@"Select Photos";
    
    selectAllBtn = [[UIBarButtonItem alloc] initWithTitle:@"Select All"
                                                    style:UIBarButtonSystemItemDone target:self action:@selector(btnSelectAllClicked:)];
    self.navigationItem.rightBarButtonItem = selectAllBtn;
    selectAllBtn.style=UIBarButtonItemStyleBordered;
    [selectAllBtn release];
    
    [checkedImgArr removeAllObjects];
    [checkedImgPathArr removeAllObjects];
    [checkedVideoArr removeAllObjects];
    [CustomLibraryVw removeFromSuperview];
    [self dispImages];
}

-(void)shareImagesClicked
{
    // [self EmailImagesClicked];
    //[self facebookShareButtonPressed:self];
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Sharing" message:@"" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Facebook",@"Twitter",@"Email",@"SMS" ,nil];
    [alert show];
    [alert release];
    
    
    
}
-(void)postToWall
{
#ifdef LITEVERSION
    NSString *desc = [NSString stringWithFormat:@"'this is Secret Vault.Its a nice."];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"http://www.facebook.com/pages/Secret-App-Private-Albums-Manger/ 419463658136588/",@"link",
                                   @"http://www.SecretAppLinkDemo.com/myssscoreicon.png",@"picture",
                                   @" ",@"name",
                                   @" ",@"caption",
                                   desc,@"description",
                                   @"Great App!",@"message",
                                   nil];
    
#else
    NSString *desc = [NSString stringWithFormat:@"'this is Secret Vault Pro.Its a nice."];
    //GoProLink
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"http://www.facebook.com/pages/Secret-App-Private-Albums-Manger/ 419463658136588/",@"link",
                                   @"http://www.SecretAppProLinkDemo.com/myssscoreicon.png",@"picture",
                                   @" ",@"name",
                                   @" ",@"caption",
                                   desc,@"description",
                                   @"Great App!",@"message",
                                   nil];
    
#endif
    [ [self facebook ]dialog:@"feed" andParams:params andDelegate:self];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    /********* On Confirmation to share image  ***********/
    
    if([title isEqualToString:@"Facebook"])
    {
        if([checkedImgArr count]==0)
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Message" message:@"Please Select Image To Be Shared." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }else{
        [self performSelector:@selector(fBClick) withObject:self afterDelay:2.0];    
        }
        
        
    }
    else if([title isEqualToString:@"SMS"])
    {
        if([checkedImgArr count] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Message" message:@"Please Select Image To Be Shared." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            [actIndicator startAnimating];
            newSize = CGSizeMake(100.0f, 100.0f);
            
            UIGraphicsBeginImageContext(newSize);
#ifdef LITEVERSION
            NSString *emailBody = @"Check out this pic from my Secret Vault app, that I got for free from the AppStore <br/><a href=\"https://itunes.apple.com/us/app/secret-app/id569771443?ls=1&mt=8\">Secret Vault on itunes</a>";
#else
            //GoProLink
            NSString *emailBody = @"Check out this pic from my Secret Vault Pro app, that I got for free from the AppStore <br/><a href=\"https://itunes.apple.com/us/app/secret-vault-pro-plus/id873504069?ls=1&mt=8\">Secret Vault Pro on itunes</a>";
#endif

            MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
            if([MFMessageComposeViewController canSendText])
            {
                picker.body = emailBody;
                picker.recipients= nil;
                picker.messageComposeDelegate = self;
            }
            
//#ifdef LITEVERSION
//            [picker setSubject:@"Pictures from Secret Vault"];
//#else
//            [picker setSubject:@"Pictures from Secret Vault Pro"];
//#endif
            
            
            NSLog(@"checkedImgPathArr count== %d",[checkedImgPathArr count]);
            
            for(int i=0;i<[checkedImgPathArr count];i++)
            {
                UIImage *attachimage = [UIImage imageWithContentsOfFile:[checkedImgPathArr objectAtIndex:i]];
                NSData *data = UIImagePNGRepresentation(attachimage);
                if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
                {
                    [picker addAttachmentData:data typeIdentifier:@"public.data" filename:[NSString stringWithFormat:@"SecretImage-%d.png",i+1]];
                }
                else
                {
                    [picker addAttachmentData:data mimeType:@"image/png" fileName:[NSString stringWithFormat:@"SecretImage-%d.png",i+1]];
                }
            }
            [self presentViewController:picker animated:YES completion:nil];
            
            [picker release];
            
            [checkedImgArr removeAllObjects];
            [checkedImgPathArr removeAllObjects];
        }

    }
    else if([title isEqualToString:@"Email"])
    {
        [self EmailImagesClicked];
        
    }else if([title isEqualToString:@"Twitter"]) {
        TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
#ifdef LITEVERSION
        NSString *comment12=[NSString stringWithFormat:@"#Secret Vault"];
#else
        NSString *comment12=[NSString stringWithFormat:@"#Secret Vault Pro"];
#endif
        
//        NSString *link = [[NSString alloc]initWithFormat:@"%simages/%@",ServerPath,[images objectAtIndex:imageNO]];
//        NSURL *url = [NSURL URLWithString:link];//
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        
        // ****************************image compression for twitter upload **********************************
//        
//        CGFloat compression = 1.0f;
//        CGFloat maxCompression = 0.0f;
//        int maxFileSize = 150*224;
 
        @try {
            if([checkedImgArr count]==0)
            {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Message" message:@"Please Select Image To Be Shared." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }else if([checkedImgArr count]>1)
            {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Message" message:@"You can share only one image on Twitter." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }else{
              



            [actIndicator startAnimating];
            actIndicator.hidden=false;
            NSLog(@"Count>>>>>%d",[checkedImgArr count]);
            NSString *strImgPath=[checkedImgPathArr objectAtIndex:0];
            NSLog(@"image path %@",strImgPath);
           // UIImage *img2=[UIImage imageNamed:@"audio-recording.png"];
            UIImage *img=[UIImage imageWithContentsOfFile:strImgPath];
            
            [tweetViewController setInitialText:comment12];
           // [tweetViewController addImage:img2];
            [tweetViewController addImage:img];

            [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
                NSString *output;
                
                switch (result) {
                    case TWTweetComposeViewControllerResultCancelled:
                        output = @"Tweet cancelled.";
                        [actIndicator stopAnimating];
                        actIndicator.hidden=true;
                      
                        UIAlertView *alertCancel = [[UIAlertView alloc]
                                                    initWithTitle:@"Message" message:@"Tweeter Sharing is cancelled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alertCancel show];
                        [alertCancel release];

                        break;
                    case TWTweetComposeViewControllerResultDone:
                        // The tweet was sent.
                        output = @"Tweet done.";

                        [actIndicator stopAnimating];
                        actIndicator.hidden=true;
                        UIAlertView *alert = [[UIAlertView alloc]
                                              initWithTitle:@"Message" message:@"Image is Shared." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                        break;
                    default:
                        break;
                }
                
               // [self performSelectorOnMainThread:@selector(displayText:) withObject:output waitUntilDone:NO];
                
            [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
                [self presentViewController:tweetViewController animated:YES completion:nil];
            
            
            }
                
          
        }
        @catch (NSException *exception) {
            
        
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Twitter Sharing" message:@"Problem Occured while Sharing images." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];        }
        

      
    }
       
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    
    switch (result) {
        case MessageComposeResultCancelled:
            alert.message = @"Cancelled";
            break;
        case MessageComposeResultFailed:
            alert.message = @"Failed";
            break;
        case MessageComposeResultSent:
            alert.message = @"Send";
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [alert show];
    [alert release];
}

//-(void) displayText :(NSString *)strOutput
//{
//    UIAlertView *alert = [[UIAlertView alloc]
//                          initWithTitle:@"Message" message:@"Please Select Image To Be Shared." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
//    [alert release];
//}
-(void)fBClick
{
#ifdef LITEVERSION
    facebook = [[Facebook alloc]initWithAppId:@"145792598897737" andDelegate:self];
#else
    facebook = [[Facebook alloc]initWithAppId:@"418421318294440" andDelegate:self];
#endif
    [facebook extendAccessTokenIfNeeded];
     [self facebookShareButtonPressed:self];
}
- (void)EmailImagesClicked
{
    if([checkedImgArr count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Message" message:@"Please Select Image To Be Shared." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        [actIndicator startAnimating];
        newSize = CGSizeMake(100.0f, 100.0f); 
        
        UIGraphicsBeginImageContext(newSize);
        
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        // Set the subject of email
#ifdef LITEVERSION
        [picker setSubject:@"Pictures from Secret Vault"];
#else
        [picker setSubject:@"Pictures from Secret Vault Pro"];
#endif
        
        // Add email addresses
        // Notice three sections: "to" "cc" and "bcc"	
        [picker setToRecipients:[NSArray arrayWithObjects:@"", nil]];
        [picker setCcRecipients:[NSArray arrayWithObject:@""]];	
        [picker setBccRecipients:[NSArray arrayWithObject:@""]];
        
        // Fill out the email body text
        NSString *emailBody = @"I have shared the picture,just check it out.";
        
        // This is not an HTML formatted email
        [picker setMessageBody:emailBody isHTML:NO];
        
        NSLog(@"checkedImgPathArr count== %d",[checkedImgPathArr count]);
        
        for(int i=0;i<[checkedImgPathArr count];i++)
        {
            UIImage *attachimage = [UIImage imageWithContentsOfFile:[checkedImgPathArr objectAtIndex:i]];
            
            //  UIImage *small = [UIImage imageWithCGImage:attachimage.CGImage scale:0.25 orientation:attachimage.imageOrientation];
            
            /* [attachimage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
             UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
             UIGraphicsEndImageContext();*/
            
            NSData *data = UIImagePNGRepresentation(attachimage);
            
            [picker addAttachmentData:data mimeType:@"image/png" fileName:[NSString stringWithFormat:@"SecretImage-%d",i+1]];
        }
        
        // Show email view
        [self presentViewController:picker animated:YES completion:nil];
        
        // Release picker
        [picker release];
        
        [checkedImgArr removeAllObjects];
        [checkedImgPathArr removeAllObjects];
    }
}

//- (NSString*)fileMIMEType:(NSString*) file {
//    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (CFStringRef)[file pathExtension], NULL);
//    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
//    CFRelease(UTI);
//    return [(NSString *)MIMEType autorelease];
//}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{    
    [actIndicator stopAnimating];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    switch (result) 
    {
        case MFMailComposeResultCancelled:
            alert.message = @"Message Canceled";
            break;
        case MFMailComposeResultSaved:
            alert.message = @"Message Saved";
            break;
        case MFMailComposeResultSent:
            alert.message = @"Message Sent";
            break;
        case MFMailComposeResultFailed:
            alert.message = @"Message Failed";
            break;
        default:
            alert.message = @"Message Not Sent";
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [alert show];
    [alert release];
    
    [self dispImages];
}

#pragma mark - FBFeedPostDelegate

/*
 -(void)PostOnFB
 {
 [self.navigationItem setHidesBackButton:YES animated:YES];
 selectAllBtn.enabled=false;
 [self.scrollVw setUserInteractionEnabled:false];
 
 UIImage *attachimage = [UIImage imageWithContentsOfFile:[checkedImgPathArr objectAtIndex:0]];
 UIGraphicsBeginImageContext(newSize);
 [attachimage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];  
 UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();  
 UIGraphicsEndImageContext();    
 
 FBFeedPost *post = [[FBFeedPost alloc] initWithPhoto:newImage name:@"Image"];
 [post publishPostWithDelegate:self];
 
 IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
 display.type = NotificationDisplayTypeLoading;
 display.tag = NOTIFICATION_DISPLAY_TAG;
 [display setNotificationText:@"Posting Photo..."];
 [display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:0.0];
 [display release];		
 }
 
 - (void) failedToPublishPost:(FBFeedPost*) _post {
 
 UIView *dv = [self.view viewWithTag:NOTIFICATION_DISPLAY_TAG];
 [dv removeFromSuperview];
 
 IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
 display.type = NotificationDisplayTypeText;
 [display setNotificationText:@"Failed To Post"];
 [display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:1.5];
 [display release];
 NSLog(@"Failed to post... ");
 //release the alloc'd post
 [_post release];
 [self.navigationItem setHidesBackButton:NO animated:YES];
 selectAllBtn.enabled=true;
 [self.scrollVw setUserInteractionEnabled:true];
 }
 
 - (void) finishedPublishingPost:(FBFeedPost*) _post {
 
 UIView *dv = [self.view viewWithTag:NOTIFICATION_DISPLAY_TAG];
 [dv removeFromSuperview];
 
 IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
 display.type = NotificationDisplayTypeText;
 [display setNotificationText:@"Finished Posting"];
 [display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:1.5];
 [display release];
 
 //release the alloc'd post
 [_post release];
 
 [self.navigationItem setHidesBackButton:NO animated:YES];
 selectAllBtn.enabled=true;
 [self.scrollVw setUserInteractionEnabled:true];
 }
 */
//- (IBAction)facebookShareButtonPressed:(id)sender {
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if ([defaults objectForKey:@"FBAccessTokenKey"] 
//        && [defaults objectForKey:@"FBExpirationDateKey"]) {
//        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
//        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
//    }
//    if (![facebook isSessionValid]) {
//        NSArray *permissions = [[NSArray alloc]initWithObjects:@"publish_stream", nil];
//        [facebook authorize:permissions];
//    }else{
//        [self postToWall];
//    }
//}

#pragma mark - FBRequestDelegate Methods
/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response 
{
 
    [actIndicator stopAnimating];
    actIndicator.hidden =true;
    NSLog(@"received response");
}


- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSArray class]] && ([result count] > 0)) {
        result = [result objectAtIndex:0];
    }
    switch (currentAPICall) {
        case kAPIGraphUserPermissionsDelete:
        {
            [self showMessage:@"User uninstalled app"];
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            // Nil out the session variables to prevent
            // the app from thinking there is a valid session
            [delegate facebook].accessToken = nil;
            [delegate facebook].expirationDate = nil;
            
            // Notify the root view about the logout.
            
            break;
        }
        case kAPIFriendsForDialogFeed:
        {
            NSArray *resultData = [result objectForKey: @"data"];
            // Check that the user has friends
            if ([resultData count] > 0) {
                // Pick a random friend to post the feed to
                //   int randomNumber = arc4random() % [resultData count];
                //                [self apiDialogFeedFriend: 
                //                 [[resultData objectAtIndex: randomNumber] objectForKey: @"id"]];
            } else {
                [self showMessage:@"You do not have any friends to post to."];
            }
            break;
        }
        case kAPIGetAppUsersFriendsUsing:
        {
            NSMutableArray *friendsWithApp = [[NSMutableArray alloc] initWithCapacity:1];
            // Many results
            if ([result isKindOfClass:[NSArray class]]) {
                [friendsWithApp addObjectsFromArray:result];
            } else if ([result isKindOfClass:[NSDecimalNumber class]]) {
                [friendsWithApp addObject: [result stringValue]];
            }
            
            //            if ([friendsWithApp count] > 0) {
            //                [self apiDialogRequestsSendToUsers:friendsWithApp];
            //            } else {
            //                [self showMessage:@"None of your friends are using the app."];
            //            }
            
            [friendsWithApp release];
            break;
        }
            
        case kAPIFriendsForTargetDialogRequests:
        {
            NSArray *resultData = [result objectForKey: @"data"];
            // got friends?
            if ([resultData count] > 0) { 
                // pick a random one to send a request to
                //    int randomIndex = arc4random() % [resultData count];	
                //                NSString* randomFriend = 
                //                [[resultData objectAtIndex: randomIndex] objectForKey: @"id"];
                //                [self apiDialogRequestsSendTarget:randomFriend];
            } else {
                [self showMessage: @"You have no friends to select."];
            }
            break;
        }
        case kAPIGraphMe:
        {
            NSString *nameID = [[NSString alloc] initWithFormat: @"%@ (%@)", 
                                [result objectForKey:@"name"], 
                                [result objectForKey:@"id"]];
            NSMutableArray *userData = [[NSMutableArray alloc] initWithObjects:
                                        [NSDictionary dictionaryWithObjectsAndKeys:
                                         [result objectForKey:@"id"], @"id",
                                         nameID, @"name",
                                         [result objectForKey:@"picture"], @"details",
                                         nil], nil];
            // Show the basic user information in a new view controller
            //            APIResultsViewController *controller = [[APIResultsViewController alloc]
            //                                                    initWithTitle:@"Your Information"
            //                                                    data:userData
            //                                                    action:@""];
            //            [self.navigationController pushViewController:controller animated:YES];
            //            [controller release];
            [userData release];
            [nameID release];
            break;
        }
        case kAPIGraphUserFriends:
        {
            
            //            NSArray *resultData = [result objectForKey:@"data"];
            //            NSLog(@"result data cvount>>>%d",[resultData count]);
            //            if ([resultData count] > 0) {
            //                for (NSUInteger i=0; i<[resultData count] && i < [resultData count]; i++) {
            //                    [friends addObject:[resultData objectAtIndex:i]];
            //                }
            //                NSLog(@"FriendsArray Count>>>%@",friends);
            //                
            //                // main_Scroll_View.contentOffset=CGPointMake(0, 125);
            //                
            //                [friends_tblvw reloadData]; 
            //                
            //            } else {
            //                [self showMessage:@"You have no friends."];
            //}
            // [friends release];
            break;
        }
        case kAPIGraphUserCheckins:
        {
            NSMutableArray *places = [[NSMutableArray alloc] initWithCapacity:1];
            NSArray *resultData = [result objectForKey:@"data"];
            for (NSUInteger i=0; i<[resultData count] && i < 5; i++) {
                NSString *placeID = [[[resultData objectAtIndex:i] objectForKey:@"place"] objectForKey:@"id"];
                NSString *placeName = [[[resultData objectAtIndex:i] objectForKey:@"place"] objectForKey:@"name"];
                NSString *checkinMessage = [[resultData objectAtIndex:i] objectForKey:@"message"] ?
                [[resultData objectAtIndex:i] objectForKey:@"message"] : @"";
                [places addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   placeID,@"id",
                                   placeName,@"name",
                                   checkinMessage,@"details",
                                   nil]];
            }
            // Show the user's recent check-ins a new view controller
            //            APIResultsViewController *controller = [[APIResultsViewController alloc]
            //                                                    initWithTitle:@"Recent Check-ins"
            //                                                    data:places
            //                                                    action:@"recentcheckins"];
            //            [self.navigationController pushViewController:controller animated:YES];
            //            [controller release];
            [places release];
            break;
        }
        case kAPIGraphSearchPlace:
        {
            NSMutableArray *places = [[NSMutableArray alloc] initWithCapacity:1];
            NSArray *resultData = [result objectForKey:@"data"];
            for (NSUInteger i=0; i<[resultData count] && i < 5; i++) {
                [places addObject:[resultData objectAtIndex:i]];
            }
            // Show the places nearby in a new view controller
            //            APIResultsViewController *controller = [[APIResultsViewController alloc]
            //                                                    initWithTitle:@"Nearby"
            //                                                    data:places
            //                                                    action:@"places"];
            //            [self.navigationController pushViewController:controller animated:YES];
            //            [controller release];
            [places release];
            break;
        }
        case kAPIGraphUserPhotosPost:
        {
            [self showMessage:@"Photo uploaded successfully."];
            break;
        }
        case kAPIGraphUserVideosPost:
        {
            [self showMessage:@"Video uploaded successfully."];
            break;
        }
        default:
            break;
    }
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    //  [self apiGraphUserPhotosPost];
    [self facebookShareButtonPressed:nil];
    //  NSLog(@"Error message: %@", [error description]);
    [self showMessage:@"Oops, something went haywire."];
}

#pragma mark - FBDialogDelegate Methods

/**
 * Called when a UIServer Dialog successfully return. Using this callback
 * instead of dialogDidComplete: to properly handle successful shares/sends
 * that return ID data back.
 */
- (void)dialogCompleteWithUrl:(NSURL *)url {
    if (![url query]) {
        NSLog(@"User canceled dialog or there was an error");
        return;
    }
    
    NSDictionary *params = [self parseURLParams:[url query]];
    switch (currentAPICall) {
        case kDialogFeedUser:
        case kDialogFeedFriend:
        {
            // Successful posts return a post_id
            if ([params valueForKey:@"post_id"]) {
                [self showMessage:@"Published feed successfully."];
                NSLog(@"Feed post ID: %@", [params valueForKey:@"post_id"]);
            }
            break;
        }
        case kDialogRequestsSendToMany:
        case kDialogRequestsSendToSelect:
        case kDialogRequestsSendToTarget:
        {
            // Successful requests return one or more request_ids.
            // Get any request IDs, will be in the URL in the form
            // request_ids[0]=1001316103543&request_ids[1]=10100303657380180
            NSMutableArray *requestIDs = [[[NSMutableArray alloc] init] autorelease];
            for (NSString *paramKey in params) {
                if ([paramKey hasPrefix:@"request_ids"]) {
                    [requestIDs addObject:[params objectForKey:paramKey]];
                }
            }
            if ([requestIDs count] > 0) {
                [self showMessage:@"Sent request successfully."];
                NSLog(@"Request ID(s): %@", requestIDs);
            }
            break;
        }
        default:
            break;
    }
}

- (void)dialogDidNotComplete:(FBDialog *)dialog {
    NSLog(@"Dialog dismissed.");
}

- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error {
    // [self apiGraphUserPhotosPost];
    // NSLog(@"Error message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    [self showMessage:@"Oops, something went haywire."];
}

/**
 * Called when the user granted additional permissions.
 */
- (void)userDidGrantPermission {
    // After permissions granted follow up with next API call
    switch (currentAPICall) {
        case kDialogPermissionsCheckinForRecent:
        {
            // After the check-in permissions have been
            // granted, save them in app session then
            // retrieve recent check-ins
            //            [self updateCheckinPermissions];
            //            [self apiGraphUserCheckins];
            break;
        }
        case kDialogPermissionsCheckinForPlaces:
        {
            // After the check-in permissions have been
            // granted, save them in app session then
            // get nearby locations
            //            [self updateCheckinPermissions];
            //            [self getNearby];
            break;
        }
        case kDialogPermissionsExtended:
        {
            // In the sample test for getting user_likes
            // permssions, echo that success.
            [self showMessage:@"Permissions granted."];
            break;
        }
        default:
            break;
    }
}

/**
 * Called when the user canceled the authorization dialog.
 */
- (void)userDidNotGrantPermission {
    [self showMessage:@"Extended permissions not granted."];
}
- (NSDictionary *)parseURLParams:(NSString *)query {
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
	for (NSString *pair in pairs) {
		NSArray *kv = [pair componentsSeparatedByString:@"="];
		NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
		[params setObject:val forKey:[kv objectAtIndex:0]];
	}
    return params;
}

- (void)showMessage:(NSString *)message {
    
    
    
}
#pragma mark - facebook


- (IBAction)facebookShareButtonPressed:(id)sender {
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    if (![facebook isSessionValid]) 
    {
        NSArray *permissions = [[NSArray alloc]initWithObjects:@"publish_stream", nil];
        [facebook authorize:permissions];
    }else{
        if([checkedImgArr count]==0)
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Message" message:@"Please Select Image To Be Share." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }else
        {
            
             for(int i =0;i< checkedImgArr.count ;i++)
            {
                [actIndicator startAnimating];
                actIndicator.hidden=false;
                NSLog(@"Count>>>>>%d",[checkedImgArr count]);
                            NSString *strImgPath=[checkedImgPathArr objectAtIndex:i];
                          NSLog(@"image path %@",strImgPath);
            
            UIImage *img=[UIImage imageWithContentsOfFile:strImgPath];
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           img, @"picture",
                                           nil];
            
            
            
            
            //   NSString *id_string=[NSString stringWithFormat:@"me/photos" objectForKey:@"id"];
            
            
            [facebook requestWithGraphPath:@"me/photos"
                                 andParams:params
                             andHttpMethod:@"POST"
                               andDelegate:self];
            
            
            
            }
        }
        
    }
    
    
}
// For iOS 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [facebook handleOpenURL:url]; 
}





-(void)fbDidNotLogin:(BOOL)cancelled{
    if (cancelled) {
        [actIndicator stopAnimating];
        actIndicator.hidden=true;
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Could not Login" message:@"Facebook Cannot login for your application." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
}

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt
{
    NSLog(@"token extended");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [facebook extendAccessTokenIfNeeded];
}

- (void)fbSessionInvalidated {}

- (void)fbDidLogin 
{
    if ([facebook isSessionValid]) { 
        [self facebookShareButtonPressed:nil];
    }
    
}

- (void)fbDidLogout {
}



@end

