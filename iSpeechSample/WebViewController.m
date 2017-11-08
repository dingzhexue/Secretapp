//
//  WebViewController.m
//  SecretApp
//
//  Created by c62 on 31/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"
#import "BookmarkView.h"
#import <QuartzCore/Quartzcore.h>
#import "AppDelegate.h"
#import "GlobalFunctions.h"
#import "DefaultAlbumView.h"
#import "CustomDownloadView.h"
//#import "AFHTTPRequestOperation.h"

@interface WebViewController ()

@end

@implementation WebViewController

@synthesize toolbar,webVw,actVw,webUrlTxt,giveTitleToBookmarkView,bookmarkTitleTxt,progTag,progressView,totalsizeTag,transViewBG;

@synthesize imgPath,imgfilename,myWebData,pagesArr,downlodDetailVw,downlodingFileTbl,progress;

@synthesize fileURL;

@synthesize bookmarkTitle,bookmarkURL;

int pageIndex,files; 
UILabel *titleLbl;
UIImageView *imgVw;

AppDelegate *app;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

//Hiding the status bar
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
-(void)dealloc{
    
    [fileURL release];
    [progressView release];
    [myWebData release];
    [imgPath release];
    [downlodDetailVw release];
   // [imgfilename release];
    [bookmarkTitleTxt release];
    [transViewBG release];
    [giveTitleToBookmarkView release];
    [webUrlTxt release];
    [actVw release];
    [toolbar release];
    [webVw release];
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

    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    webVw.delegate=self;
   
    pageIndex=0;
    files=0;
    insertArrFlag=true;
    
    pagesArr=[[NSMutableArray alloc] init];
    array2 = [[NSMutableArray alloc] init];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    self.giveTitleToBookmarkView.hidden=true;
    self.transViewBG.hidden=true;
    self.downlodDetailVw.hidden=true;
    
    webVw.delegate=self;
    progress = 0;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration=0.1;
    longPress.delegate = self;
    [webVw addGestureRecognizer:longPress];
    [longPress release];
   
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        
        // //******************** array to add buttons in toolbar //******************** //
        
        NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:5];
        
        //******************** Back button ********************//
        
        UIButton *contBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [contBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        contBtn.frame = CGRectMake(330.00, 300.0, 30.0, 30.0);
        [contBtn setBackgroundImage:[UIImage imageNamed:@"go-back.png"] forState:UIControlStateNormal];
        [self.view addSubview:contBtn];
        
        UIBarButtonItem *contlayerbtn =[[UIBarButtonItem alloc]initWithCustomView:contBtn];
        contlayerbtn.style = UIBarButtonItemStyleBordered;
        [buttons addObject:contlayerbtn];
        [contlayerbtn release];
        
        // ********************** Space between back and add btn ******************************//
        
        UIBarButtonItem *flexibaleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [flexibaleSpaceBarButton setWidth:192];
        [buttons addObject:flexibaleSpaceBarButton];
        [flexibaleSpaceBarButton release];
        
        //****************************** Add back url button ******************************// 
        
        backURLButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [backURLButton addTarget:self action:@selector(backURL:) forControlEvents:UIControlEventTouchUpInside];
        backURLButton.frame = CGRectMake(330.00, 300.0, 30.0, 30.0);
        [backURLButton setBackgroundImage:[UIImage imageNamed:@"backbtn1.png"] forState:UIControlStateNormal];
        [self.view addSubview:backURLButton];
        
        UIBarButtonItem *backBtn =[[UIBarButtonItem alloc]initWithCustomView:backURLButton];
        backBtn.style = UIBarButtonItemStyleBordered;
        [buttons addObject:backBtn];
        [backBtn release];    
        
        // ********************** Space between backurl and next url btn ******************************///
        
        UIBarButtonItem *flexibaleSpaceBarButton11 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [flexibaleSpaceBarButton11 setWidth:192];
        [buttons addObject:flexibaleSpaceBarButton11];
        [flexibaleSpaceBarButton11 release];
        
        
        //****************************** Add next url button ******************************// 
        
        nexturlButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [nexturlButton addTarget:self action:@selector(nextURL:) forControlEvents:UIControlEventTouchUpInside];
        nexturlButton.frame = CGRectMake(330.00, 300.0, 30.0, 30.0);
        [nexturlButton setBackgroundImage:[UIImage imageNamed:@"nextbtn1.png"] forState:UIControlStateNormal];
        [self.view addSubview:nexturlButton];
        
        UIBarButtonItem *nextBtn =[[UIBarButtonItem alloc]initWithCustomView:nexturlButton];
        nextBtn.style = UIBarButtonItemStyleBordered;
        [buttons addObject:nextBtn];
        [nextBtn release];
        
        
        // ********************** Space between next url and add bookmark btn **********************//
        UIBarButtonItem *flexibaleSpaceBarButton12 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [flexibaleSpaceBarButton12 setWidth:192];
        [buttons addObject:flexibaleSpaceBarButton12];
        [flexibaleSpaceBarButton12 release];
        
        //****************************** Add bookmark button ******************************// 
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBookmarkClicked)];
        addButton.style = UIBarButtonItemStyleBordered;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            addButton.tintColor=[UIColor whiteColor];
        }
        [buttons addObject:addButton];
        [addButton release];
        /*   
        // **************************Space between add bookmark and download **********************/
        /*
        UIBarButtonItem *flexibaleSpaceBarButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [flexibaleSpaceBarButton1 setWidth:185];
        [buttons addObject:flexibaleSpaceBarButton1];
        [flexibaleSpaceBarButton1 release];
         */  
        //****************************** download btn ****************************** //
      /*  
        UIButton *cameraAddBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [cameraAddBtn addTarget:self action:@selector(downloadBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        cameraAddBtn.frame = CGRectMake(330.0, 300.0, 30.0, 30.0);
        [cameraAddBtn setBackgroundImage:[UIImage imageNamed:@"download_icon.png"] forState:UIControlStateNormal];
        
        imgVw=[[UIImageView alloc] initWithFrame:CGRectMake(-10,-9, 25, 25)];
        imgVw.image=[UIImage imageNamed:@"Circle_Red.png"];
        [cameraAddBtn addSubview:imgVw];
        imgVw.hidden=true;
        
        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(-8,-8, 20, 20)];
        [titleLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        [titleLbl setBackgroundColor:[UIColor clearColor]];
        titleLbl.textColor=[UIColor whiteColor];
        [titleLbl setText:@""];
        [titleLbl setTextAlignment:UITextAlignmentCenter];
        [cameraAddBtn addSubview:titleLbl];
        
        [self.view addSubview:cameraAddBtn];
        
        UIBarButtonItem *wwwlayerbtn =[[UIBarButtonItem alloc]initWithCustomView:cameraAddBtn];
        wwwlayerbtn.style = UIBarButtonItemStyleBordered;
        [buttons addObject:wwwlayerbtn];
        [wwwlayerbtn release];
        */
        [toolbar setItems:buttons];
        [buttons release];
        

    }else {
        
    
    
    // //******************** array to add buttons in toolbar //******************** //
    
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:5];
    
    //******************** Back button ********************//
    
    UIButton *contBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [contBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    contBtn.frame = CGRectMake(330.00, 300.0, 30.0, 30.0);
    [contBtn setBackgroundImage:[UIImage imageNamed:@"go-back.png"] forState:UIControlStateNormal];
    [self.view addSubview:contBtn];
    
    UIBarButtonItem *contlayerbtn =[[UIBarButtonItem alloc]initWithCustomView:contBtn];
    contlayerbtn.style = UIBarButtonItemStyleBordered;
    [buttons addObject:contlayerbtn];
    [contlayerbtn release];
    
    // ********************** Space between back and add btn ******************************//
    
    UIBarButtonItem *flexibaleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [flexibaleSpaceBarButton setWidth:55];
    [buttons addObject:flexibaleSpaceBarButton];
    [flexibaleSpaceBarButton release];
    
    //****************************** Add back url button ******************************// 
    
    backURLButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [backURLButton addTarget:self action:@selector(backURL:) forControlEvents:UIControlEventTouchUpInside];
    backURLButton.frame = CGRectMake(330.00, 300.0, 30.0, 30.0);
    [backURLButton setBackgroundImage:[UIImage imageNamed:@"backbtn1.png"] forState:UIControlStateNormal];
    [self.view addSubview:backURLButton];
    
    UIBarButtonItem *backBtn =[[UIBarButtonItem alloc]initWithCustomView:backURLButton];
    backBtn.style = UIBarButtonItemStyleBordered;
    [buttons addObject:backBtn];
    [backBtn release];    
    
    // ********************** Space between backurl and next url btn ******************************///
    
    UIBarButtonItem *flexibaleSpaceBarButton11 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [flexibaleSpaceBarButton11 setWidth:55];
    [buttons addObject:flexibaleSpaceBarButton11];
    [flexibaleSpaceBarButton11 release];
    
    
    //****************************** Add next url button ******************************// 
    
     nexturlButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [nexturlButton addTarget:self action:@selector(nextURL:) forControlEvents:UIControlEventTouchUpInside];
    nexturlButton.frame = CGRectMake(330.00, 300.0, 30.0, 30.0);
    [nexturlButton setBackgroundImage:[UIImage imageNamed:@"nextbtn1.png"] forState:UIControlStateNormal];
    [self.view addSubview:nexturlButton];
    
    UIBarButtonItem *nextBtn =[[UIBarButtonItem alloc]initWithCustomView:nexturlButton];
    nextBtn.style = UIBarButtonItemStyleBordered;
    [buttons addObject:nextBtn];
    [nextBtn release];

    
    // ********************** Space between next url and add bookmark btn **********************//
    UIBarButtonItem *flexibaleSpaceBarButton12 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [flexibaleSpaceBarButton12 setWidth:45];
    [buttons addObject:flexibaleSpaceBarButton12];
    [flexibaleSpaceBarButton12 release];
    
    //****************************** Add bookmark button ******************************// 
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBookmarkClicked)];
    addButton.style = UIBarButtonItemStyleBordered;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        addButton.tintColor=[UIColor whiteColor];
    }
    [buttons addObject:addButton];
    [addButton release];
    
    // **************************Space between add bookmark and download **********************//
    /*
    UIBarButtonItem *flexibaleSpaceBarButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [flexibaleSpaceBarButton1 setWidth:60];
    [buttons addObject:flexibaleSpaceBarButton1];
    [flexibaleSpaceBarButton1 release];
     
    ****************************** download btn ****************************** 
  
    UIButton *cameraAddBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [cameraAddBtn addTarget:self action:@selector(downloadBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    cameraAddBtn.frame = CGRectMake(330.0, 300.0, 30.0, 30.0);
    [cameraAddBtn setBackgroundImage:[UIImage imageNamed:@"download_icon.png"] forState:UIControlStateNormal];
    
    imgVw=[[UIImageView alloc] initWithFrame:CGRectMake(-10,-9, 25, 25)];
    imgVw.image=[UIImage imageNamed:@"Circle_Red.png"];
    [cameraAddBtn addSubview:imgVw];
    imgVw.hidden=true;
    
    titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(-8,-8, 20, 20)];
    [titleLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
    [titleLbl setBackgroundColor:[UIColor clearColor]];
    titleLbl.textColor=[UIColor whiteColor];
    [titleLbl setText:@""];
    [titleLbl setTextAlignment:UITextAlignmentCenter];
    [cameraAddBtn addSubview:titleLbl];
    
    [self.view addSubview:cameraAddBtn];
    
    UIBarButtonItem *wwwlayerbtn =[[UIBarButtonItem alloc]initWithCustomView:cameraAddBtn];
    wwwlayerbtn.style = UIBarButtonItemStyleBordered;
    [buttons addObject:wwwlayerbtn];
    [wwwlayerbtn release];
    */
     [toolbar setItems:buttons];
    [buttons release];
    }
    
    //
    backURLButton.enabled =false;
    nexturlButton.enabled=false;
    
    if([[GlobalFunctions urlRetrieveFromUserDefaults] isEqualToString:@""] || [[GlobalFunctions urlRetrieveFromUserDefaults] isEqualToString:@"(null)"] || [GlobalFunctions urlRetrieveFromUserDefaults] == NULL)
    {
        webUrlTxt.text=@"http://www.";
    }
    else
    {
        webUrlTxt.text= [GlobalFunctions urlRetrieveFromUserDefaults];
        NSLog(@"text=== %@",webUrlTxt.text);
    }
    NSURL *url = [NSURL URLWithString:webUrlTxt.text];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webVw loadRequest:requestObj];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField { 
    // Go clicked...
    
    [webUrlTxt resignFirstResponder];
    [actVw startAnimating];
    insertArrFlag=true; 
    
    NSString *urlAddress = [NSString stringWithFormat:@"%@",webUrlTxt.text];
    NSLog(@"web url=== %@",urlAddress);
    
    BOOL validurl = [self validateURL:urlAddress];
    
    NSLog(@" Url validation ===> %@",validurl ? @"Valid":@"Not valid");
    int strlen=[urlAddress length];
    NSString *subString, *subString2;
  
    if(validurl)
    {
        if(strlen >= 10)
        {
            subString= [urlAddress substringToIndex:10];
            
            subString2=[urlAddress substringToIndex:3];
       
        
            if([subString isEqualToString:@"http://www"])        
            {
                NSLog(@"url is alredy proper.. ");
            }
            else if ([subString2 isEqualToString:@"www"]) {
                urlAddress=[NSString stringWithFormat:@"%@%@",@"http://",urlAddress];
                NSLog(@"proper url=== %@",urlAddress);
            }
            else {
                urlAddress=[NSString stringWithFormat:@"%@%@",@"http://www.",urlAddress];
                NSLog(@"proper url=== %@",urlAddress);
            }
        }
        else
        {
            subString=urlAddress;
            if([subString isEqualToString:@"http://www"])        
            {
                NSLog(@"url is alredy proper.. ");
            }
            else if ([subString2 isEqualToString:@"www"]) {
                urlAddress=[NSString stringWithFormat:@"%@%@",@"http://",urlAddress];
                NSLog(@"proper url=== %@",urlAddress);
            }
            else {
                urlAddress=[NSString stringWithFormat:@"%@%@",@"http://www.",urlAddress];
                NSLog(@"proper url=== %@",urlAddress);
            }
        }
        
        NSLog(@"urlAddres to be saved ::: %@",urlAddress);
        
        [GlobalFunctions urlSaveToUserDefaults:urlAddress];
        
        self.webVw.scalesPageToFit = YES;
        
        NSURL *url = [NSURL URLWithString:urlAddress];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [webVw loadRequest:requestObj];
    }
    else 
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Message" message:@"Please Enter Valid Url ." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [actVw stopAnimating];
    }
    
    return YES;
}

-(BOOL) validateURL: (NSString *) url
{
    NSError *error = NULL;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"(?i)(?:(?:https?):\\/\\/)?(?:\\S+(?::\\S*)?@)?(?:(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|(?:(?:[a-z\\u00a1-\\uffff0-9]+-?)*[a-z\\u00a1-\\uffff0-9]+)(?:\\.(?:[a-z\\u00a1-\\uffff0-9]+-?)*[a-z\\u00a1-\\uffff0-9]+)*(?:\\.(?:[a-z\\u00a1-\\uffff]{2,})))(?::\\d{2,5})?(?:\\/[^\\s]*)?" options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (error)
        NSLog(@"error");
    
    NSRange range = [expression rangeOfFirstMatchInString:url options:NSMatchingCompleted range:NSMakeRange(0, [url length])];
    if (!NSEqualRanges(range, NSMakeRange(NSNotFound, 0))){
        NSString *match = [url substringWithRange:range];
        NSLog(@"%@", match);
        return true;
    }   
    else {
        NSLog(@"no match");
    }
    return false;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"finish loding..");
    
    NSString *currentURL = webVw.request.URL.absoluteString;
    webUrlTxt.text=currentURL;
    
    [GlobalFunctions urlSaveToUserDefaults:currentURL];
   
    if(insertArrFlag)
    {
        if ([pagesArr count]>0)
        {   
            if ([[pagesArr objectAtIndex:[pagesArr count]-1] isEqualToString:currentURL]) {
                NSLog(@"already there..");
            }
            else
            {
                [pagesArr addObject:[GlobalFunctions urlRetrieveFromUserDefaults]];
                pageIndex++;
                nexturlButton.enabled=false;
            }
        }   
        else
        {
            [pagesArr addObject:[GlobalFunctions urlRetrieveFromUserDefaults]];
            pageIndex++;
        }
    }
    else
    {
        if(cnt >= 1)
        {
            insertArrFlag=true;
        }
        else
        {
            cnt++;
        }
    }
    
    NSLog(@"pages arr count=== %d",pagesArr.count);
    NSLog(@"pages arr== %@",pagesArr);
    NSLog(@"page index=== %d",pageIndex);
    
    if(pageIndex == 1 || pageIndex == 0 )
    {
        backURLButton.enabled=false;
    }
    else{
        backURLButton.enabled=true;
    }
    
    [actVw stopAnimating];
}

-(IBAction)backURL:(id)sender
{
    pageIndex--;
    NSLog(@"page index=== %d",pageIndex);
    nexturlButton.enabled=true;
    insertArrFlag =false;
    cnt=0;
    
    if(pageIndex == 1)
    {
        backURLButton.enabled=false;
        
        NSURL *url = [NSURL URLWithString:[pagesArr objectAtIndex:pageIndex-1]];
        NSLog(@"url=== %@",url);
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [webVw loadRequest:requestObj];
        [actVw startAnimating];
    }
    else 
    {
        NSURL *url = [NSURL URLWithString:[pagesArr objectAtIndex:pageIndex-1]];
        NSLog(@"url=== %@",url);
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [webVw loadRequest:requestObj];
        [actVw startAnimating];
    }
}

-(IBAction)nextURL:(id)sender{
    
    backURLButton.enabled=true;
    pageIndex++;
    NSLog(@"page index=== %d",pageIndex);
    
    insertArrFlag =false;
    cnt=0;
    if(pageIndex == [pagesArr count])
    {
        nexturlButton.enabled=false;
        
        NSURL *url = [NSURL URLWithString:[pagesArr objectAtIndex:pageIndex-1]];
        NSLog(@"url=== %@",url);
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [webVw loadRequest:requestObj];
        [actVw startAnimating];
    }
    else 
    {
        nexturlButton.enabled=true;
        NSURL *url = [NSURL URLWithString:[pagesArr objectAtIndex:pageIndex-1]];
        NSLog(@"url=== %@",url);
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [webVw loadRequest:requestObj];
        [actVw startAnimating];
    }
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
   
    NSLog(@"load start...");
    
    if([webUrlTxt.text isEqualToString:@"" ] || [webUrlTxt.text isEqualToString:@"http://www." ])
    {
         [actVw stopAnimating];
    }
    else {
        [actVw startAnimating];
    }
}

-(void)backBtnClicked
{    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)longPress:(UILongPressGestureRecognizer*)gesture {
  //  [gesture.view becomeFirstResponder];
    
     if ( gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Long Presse done.");
        
        // ************** Get file extension *************** //
        NSString *url = webUrlTxt.text;
        NSArray *parts = [url componentsSeparatedByString:@"/"];
       imgfilename = [parts objectAtIndex:[parts count]-1];
       // NSLog(@"file name=== %@",imgfilename);
       
        NSArray *urlComponents = [imgfilename componentsSeparatedByString:@"."];
        NSString *extension = [urlComponents lastObject];
        NSLog(@"ext== %@",extension);
        
        if([extension isEqualToString:@"gif"] ||[extension isEqualToString:@"jpg"]||[extension isEqualToString:@"jpeg"]||[extension isEqualToString:@"png"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to save image in Default Album?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save",nil]; 
            [alert show];
            [alert release];
        }
         
        else if([extension isEqualToString:@"mp3"] )
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to save this Audio  file?" message:nil delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil]; 
            [alert show];
            [alert release];
            
        }
         
        else if([extension isEqualToString:@"html"]||[extension isEqualToString:@"pdf"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to save this html/pdf file?" message:nil delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Yes",nil]; 
            [alert show];
            [alert release];
            
        }

    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    /********* On Confirmation to dial contact  ***********/
    if([title isEqualToString:@"Save"]) //Save image
    {
        [actVw startAnimating];
        NSLog(@"url== %@",webUrlTxt.text);
        
        NSArray *parts = [webUrlTxt.text componentsSeparatedByString:@"/"];
        imgfilename = [parts objectAtIndex:[parts count]-1];
        NSLog(@"file name again=== %@",imgfilename);
        
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:webUrlTxt.text]]];
        
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *newFilePath = [NSString stringWithFormat:[docDir stringByAppendingPathComponent: @"/%@"],imgfilename];
        self.imgPath=[NSString stringWithFormat:@"%@",newFilePath];
        NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0)];
        
        if (data != nil)
        {
            [data writeToFile:newFilePath atomically:YES];
            [image release];
            
            [self insertImage];
        }         
    }
    else if ([title isEqualToString:@"YES"]) 
    {
        [actVw startAnimating];
        
        //AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        NSURLRequest *req=[NSURLRequest requestWithURL:[NSURL URLWithString:webUrlTxt.text] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:120];
        
        NSURLConnection *con=[[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
        
        NSString *fileName = [[webUrlTxt.text lastPathComponent]stringByReplacingOccurrencesOfString:@"%20" withString:@""];
        
      //  NSString *newString = [fileName stringByReplacingOccurrencesOfString:@"%20" withString:@""];
        fileURL=webUrlTxt.text;
        
        NSLog(@"Filename: %@", fileName);
        
        if(con)
        {
            myWebData=[[NSMutableData data] retain];
            
            array1 = [[NSMutableArray alloc] init];
            
            [array1 addObject:fileName];
            [array1 addObject:fileURL];
            
            files++;
            
            NSLog(@" arr count== %d",array1.count);
            
            titleLbl.text=[NSString stringWithFormat:@"%d",files];
            imgVw.hidden=false;
            
            [self performSelectorInBackground:@selector(startConn:) withObject:con];
            
        }
        else{
             [con release];
        }
    }
    else if ([title isEqualToString:@"Yes"]) 
    {
        [self saveFile:webUrlTxt.text];
    }
}

-(IBAction)startConn: (NSURLConnection *)connection
{
    [connection start];
}

- (IBAction)saveFile :(NSString *) filepath {
        [actVw startAnimating];
    
        NSString *filenm = [[filepath lastPathComponent] stringByReplacingOccurrencesOfString:@"%20" withString:@""];
        NSLog(@"Filename: %@", filenm);
       
      // NSString *newString = [filenm stringByReplacingOccurrencesOfString:@"%20" withString:@""];
        
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *pathToDownloadTo = [NSString stringWithFormat:@"%@/%@", docPath, filenm];
        
        NSData *tmp = [NSData dataWithContentsOfURL:[NSURL URLWithString:filepath ]];
       
        if (tmp != nil) {
            NSError *error = nil;
           
            [tmp writeToFile:pathToDownloadTo options:NSDataWritingAtomic error:&error];
            if (error != nil) {
                NSLog(@"Failed to save the file: %@", [error description]);
            } else {
                
                [actVw stopAnimating];
                
                UIAlertView *filenameAlert = [[UIAlertView alloc] initWithTitle:@"File saved" message:[NSString stringWithFormat:@"The file %@ has been saved.", filenm] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [filenameAlert show];
                [filenameAlert release];
                titleLbl.text=@"";
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" 
                                                            message:@"File could not be loaded" 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"Okay" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            
        }
}

/*
-(BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([[[request URL] scheme] isEqual:@""] )
    { 
        return NO;  //-- no need to follow the link
    }
    else {
       // [self saveFile];
        return YES; //-- otherwise, follow the link
    }
}
*/

-(void)insertImage
{
    sqlite3_stmt *stmt;
    databasepath=[app getDBPathNew];
    const char *dbpath=[databasepath UTF8String];
    if(sqlite3_open(dbpath, &dbSecret) == SQLITE_OK)
    {
        NSLog(@"user id=== %d",[app.LoginUserID intValue]);
        NSString *insertquery=[NSString stringWithFormat:@"Insert into AlbumTbl(UserID,ImagePath,VideoPath) VALUES(%d,\"%@\",\"%@\")",[app.LoginUserID intValue],imgPath,@""];
        
        NSLog(@"insert query== %@",insertquery);
        
        const char *insert_query=[insertquery UTF8String];
        sqlite3_prepare(dbSecret, insert_query, -1, &stmt, NULL);
        
        if(sqlite3_step(stmt)== SQLITE_DONE)
        {
            [actVw stopAnimating];
            DefaultAlbumView *defVw=[[DefaultAlbumView alloc] initWithNibName:@"DefaultAlbumView" bundle:nil];
            [self.navigationController pushViewController:defVw animated:YES];
            [defVw release];
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
        [actVw stopAnimating];
    }
}

-(void)addBookmarkClicked{
    
    self.navigationItem.hidesBackButton=YES;
    self.title=@"Bookmark Title";
   //    CATransition *transUp=[CATransition animation];
//    transUp.duration=0.5;
//    transUp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transUp.delegate=self;
//    transUp.type=kCATransitionMoveIn;
//    transUp.subtype=kCATransitionFromTop;
  
    CATransition *transUp=[CATransition animation];
    transUp.duration=0.7;
    transUp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transUp.delegate=self;
    transUp.type=kCATransitionMoveIn;
    transUp.subtype=kCATransitionFromTop;
    [transViewBG.layer addAnimation:transUp forKey:nil];
    transViewBG.hidden=NO;
    
    CATransition *transUp1=[CATransition animation];
    transUp1.duration=0.7;
    transUp1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transUp1.delegate=self;
    transUp1.type=kCATransitionMoveIn;
    transUp1.subtype=kCATransitionFromTop;
    [giveTitleToBookmarkView.layer addAnimation:transUp forKey:nil];
    giveTitleToBookmarkView.hidden=NO;
    
//    [transView.layer addAnimation:transUp1 forKey:nil];
//    transView.hidden=NO;
    
    [self.view addSubview:transViewBG];  
 //   [self.view addSubview:transView];
     self.giveTitleToBookmarkView.frame = CGRectMake(0, -10, 320, 540);
    [self.view addSubview:giveTitleToBookmarkView];
}

-(IBAction)InsertData{
    // int uid=1;
    sqlite3_stmt *stmt;
    databasepath=[app getDBPathNew];
    const char *dbpath=[databasepath UTF8String];
    
    if(sqlite3_open(dbpath, &dbSecret) == SQLITE_OK)
    {
        NSString *insertquery=[NSString stringWithFormat:@"Insert into BookmarkTbl(UserID,BookmarkTitle,BookmarkURL) VALUES(%d,\"%@\",\"%@\");",[app.LoginUserID intValue],bookmarkTitleTxt.text,webUrlTxt.text];
        
        NSLog(@"insert bookmark query== %@",insertquery);
        
        const char *insert_query=[insertquery UTF8String];
        sqlite3_prepare(dbSecret, insert_query, -1, &stmt, NULL);
        
        if(sqlite3_step(stmt)== SQLITE_DONE)
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Message" message:@"Bookmark Added Successfully...!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        { 
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry" message:@"Failed To Insert bookmark.." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        sqlite3_finalize(stmt);
        sqlite3_close(dbSecret);
    }
    [self TransDown];
}

-(IBAction)TransDown
{    
    [bookmarkTitleTxt resignFirstResponder];
    self.navigationItem.hidesBackButton=NO;
    [self.navigationController setNavigationBarHidden:YES];
    bookmarkTitleTxt.text=@"";
    
    CATransition *transDown=[CATransition animation];
    transDown.duration=0.6;
    transDown.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transDown.delegate=self;
    transDown.type=kCATransitionReveal;
    transDown.subtype=kCATransitionFromBottom;
    [giveTitleToBookmarkView.layer addAnimation:transDown forKey:nil];
    giveTitleToBookmarkView.hidden=YES;
   
    transDown.duration=0.6;
    transDown.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transDown.delegate=self;
    transDown.type=kCATransitionReveal;
    transDown.subtype=kCATransitionFromBottom;
    [transViewBG.layer addAnimation:transDown forKey:nil];
    transViewBG.hidden=YES;

}

#pragma mark - TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"downlod data count:::: %d",[array2 count]);
    return [array2 count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CustomCellIdentifier = @"CustomDownload";
    
    CustomDownloadView *cell = (CustomDownloadView *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    
    if (cell == nil) {
        NSArray *nib;
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
         nib = [[NSBundle mainBundle] loadNibNamed:@"CustomDownloadView_ipad2" owner:self options:nil];
        }
        else {
        nib = [[NSBundle mainBundle] loadNibNamed:@"CustomDownloadView" owner:self options:nil];            
        }

        for(id oneObject in nib)
            if([oneObject isKindOfClass:[CustomDownloadView class]])
                cell = (CustomDownloadView *)oneObject;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    cell.filenameLbl.text=[[array2 objectAtIndex:indexPath.row] objectAtIndex:0];
    
   // cell.totalSizeLbl.text=[NSString stringWithFormat:@"%.2f mb",floatFileSize];
    
    totalsizeTag=indexPath.row+500;
    
    cell.totalSizeLbl.tag=totalsizeTag;
    
    NSLog(@"Progress frm tbl=== %f",progress);
    
   // cell.progressview.progress=progress;
    progTag=indexPath.row+5;
    
    [cell.progressview setTag:progTag];
    
    [cell.cancelDLodBtn addTarget:self action:@selector(btnCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.cancelDLodBtn setTag:indexPath.row+1000];

    return cell;
}

-(IBAction)btnCancelPressed:(id)sender
{
    int tag=[sender tag]-1000;
    
    NSLog(@"cancel tag=== %d",tag);
    
    NSLog(@"file name to cancel== %@",[[array2 objectAtIndex:tag] objectAtIndex:0]);
    
    [array2 removeObjectAtIndex:tag];
    
    NSLog(@"arr count=== %d",array2.count);
    
    files--;
    
    if(files == 0)
    {
        titleLbl.text=@"";
        imgVw.hidden=true;
    }
    else 
    {
        titleLbl.text=[NSString stringWithFormat:@"%d",files];
    }
   
    [downlodingFileTbl reloadData];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
}

-(void)downloadBtnClicked{
    
    NSLog(@"Downloads..");
    
    self.downlodDetailVw.hidden=false;
    
    [self.navigationController setNavigationBarHidden:NO];
    
    self.navigationItem.leftBarButtonItem=nil;
    UIBarButtonItem *canseleBtn = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                   style:UIBarButtonSystemItemDone target:self action:@selector(CloseDownloadDetailView)];
    self.navigationItem.leftBarButtonItem = canseleBtn;
    canseleBtn.style=UIBarButtonItemStyleBordered;
    [canseleBtn release];
    
}

-(void)CloseDownloadDetailView{
    
    self.downlodDetailVw.hidden=true;
    self.navigationItem.leftBarButtonItem=nil;
    [self.navigationItem setHidesBackButton:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    NSLog(@"%@",@"connection established");
    [actVw startAnimating];
    receivedLength = 0;
    
    [myWebData setLength: 0];
    
    NSNumber *filesize = [[NSNumber numberWithLong: [response expectedContentLength]] retain];

    NSLog(@"file Size num : %@ ",filesize);
    
    floatFileSize = [filesize floatValue]/1000000;
    
    NSLog(@"file Size : %.2f",floatFileSize);
    
    [array1 addObject:[NSNumber numberWithFloat:floatFileSize]];
    [array2 addObject:array1];
    
    NSLog(@"file size from arr=== %@",[[array2 objectAtIndex:files-1] objectAtIndex:2]);
    [array1 release];

    sizelbl.text=[NSString stringWithFormat:@"%@",filesize];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    NSLog(@"********** receiving data **********");
    
    if(files > 1)
    {
        [myWebData appendData:data];
    }
    else
    {
        myWebData=[NSMutableData data];
    }
    receivedLength = receivedLength + [data length];
    
    NSLog(@"received lenght======>> %d",receivedLength);
    
    progress = ((float)receivedLength / (floatFileSize*1000000));
    
    NSLog(@"Progress=== %f",progress);

    [self progressSet:downlodingFileTbl];
    
    [downlodingFileTbl reloadData];
    
    if( myWebData.length > 25000000 && handle!=nil )
    {          
        [handle writeData:myWebData];
        
        [myWebData release];
        
        myWebData =[[NSMutableData alloc] initWithLength:0];
    }
}

-(void)progressSet:(UIView *) View1{
    
    for (id View in [View1 subviews]) {
        if ([View isKindOfClass:[UIProgressView class]] || [View isKindOfClass:[UILabel class]])
        {
            progressView=(UIProgressView *)[View viewWithTag:progTag];
            progressView.progress=progress;
            UILabel *lbl=(UILabel *)[View viewWithTag:totalsizeTag];
            
            NSLog(@"file size from arr **=== %@",[[array2 objectAtIndex:files-1] objectAtIndex:2]);
            
            NSString *tsize=[[array2 objectAtIndex:files-1] objectAtIndex:2];
            
            float previousTotal = [tsize floatValue];
            
            lbl.text=[NSString stringWithFormat:@"%.2fmb",previousTotal];
        }
        
        if ([View isKindOfClass:[UIView class]]) {
            [self progressSet:View];
        }
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"%@",@"connection failed");
    [connection release];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSLog(@"\n******************* Data received ***********************");
    
    [actVw stopAnimating];
        
    NSLog(@"arr2 count=== %d",[array2 count]);
    
    if(array2.count > 0)
    {
        for(int i=0;i<array2.count;i++)
        {
            for(int j=0;j<[[array2 objectAtIndex:i] count];j++)
            {
                NSLog(@"%d %@",i,[[array2 objectAtIndex:i] objectAtIndex:j]);
            }
            
            self.downlodDetailVw.hidden =true;
            self.webVw.hidden=false;
            
            [self performSelector:@selector(saveFile:) withObject:[[array2 objectAtIndex:i] objectAtIndex:1]];
            files--;
            
            titleLbl.text=[NSString stringWithFormat:@"%d", files]; //[array2 count] - (i+1)];
            
            if(files == 0)
            {
                titleLbl.text=@"";
                imgVw.hidden=true;
            }
        }
    }
    else
    {
        titleLbl.text=@"";
        imgVw.hidden=true;
    }
    [connection release];
}


@end