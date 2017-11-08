//
//  VideoView.m
//  SecretApp
//
//  Created by c62 on 20/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VideoView.h"
#import "AppDelegate.h"
#import "VideoCustomView.h"
#import "RootViewController.h"
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"
#import "GADInterstitial.h"

@interface VideoView () <GADInterstitialDelegate, GADBannerViewDelegate>

@property (nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation VideoView

@synthesize recorder,titleView,titletxt,tempPath,toolbar,videosTbl,videoArr,moviePlayer,videoRecorder,interstitial;

@synthesize videoID,videoPath,videoDate,videoTitle;
@synthesize selvideoID,selvideoTitle,selvideoPath,selvideoDate;

UIBarButtonItem *editdoneButton;
AppDelegate *app;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    [moviePlayer release];
    [selvideoDate release];
    [selvideoID release];
    [selvideoPath release];
    [selvideoTitle release];
    [videoID release];
    [videoDate release];
    [videoTitle release];
    [videoPath release];
    [videoArr release];
    [videosTbl release];
    [toolbar release];
    [tempPath release];
    [titletxt release];
    [titleView release];
    [recorder release];
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
    videoArr=[[NSMutableArray alloc] init];
    self.titleView.hidden=true;
    self.title=@"Video";
    [self currentdate];
    titletxt.delegate=self;
    [self.navigationController setNavigationBarHidden:NO];
    /*
    editdoneButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                    style:UIBarButtonSystemItemDone target:self action:@selector(EditTableVideos:)];
    self.navigationItem.rightBarButtonItem = editdoneButton;
    [editdoneButton release];

    */
    
    
    // Tap For Tap Adview Starts Here
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
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
    // Tap For Tap Adview Ends Here
    
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:2];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(btnAddVideoPressed)];
    addButton.style = UIBarButtonItemStyleBordered;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        addButton.tintColor=[UIColor whiteColor];
    }
    [buttons addObject:addButton];
    [addButton release];
    [toolbar setItems:buttons];
    [buttons release];
    
    [self dispVideo];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    self.title=@"Video";
    [self currentdate];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Fetch Videos From Database

-(void)dispVideo{
    [videoArr removeAllObjects];
    databasepath = [app getDBPathNew];
    
    if (sqlite3_open([databasepath UTF8String], &dbSecret) == SQLITE_OK) {
        
        NSString *sql =[NSString stringWithFormat:@"select * from VideoTbl where UserID=%d",[app.LoginUserID intValue]];
        
        sqlite3_stmt *selectstmt;
        const char *sel_query=[sql UTF8String];
        if(sqlite3_prepare(dbSecret, sel_query, -1, &selectstmt, NULL) == SQLITE_OK) {
            
            while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {
                VideoView *videoObj = [[VideoView alloc] init];
                
                videoObj.videoID =[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
                
                videoObj.videoPath=[NSString stringWithFormat:@"%s",sqlite3_column_text(selectstmt, 2)]; 
                
                videoObj.videoTitle=[NSString stringWithFormat:@"%s",sqlite3_column_text(selectstmt, 3)];
                
                videoObj.videoDate=[NSString stringWithFormat:@"%s",sqlite3_column_text(selectstmt, 4)];
                
                [videoArr addObject:videoObj];
            }
        }
        sqlite3_finalize(selectstmt);
    }
    else
        sqlite3_close(dbSecret);
    
    NSLog(@"Videos count::: %d",[videoArr count]);
    [videosTbl reloadData];
}

#pragma mark - TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"video data count:::: %d",[videoArr count]);
    return [videoArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CustomCellIdentifier = @"videoCustomCell";
    
    VideoCustomView *cell = (VideoCustomView *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if (cell == nil) {
        NSArray *nib;
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        nib = [[NSBundle mainBundle] loadNibNamed:@"VideoCustomView_Ipad" owner:self options:nil];        
        }else {
        nib = [[NSBundle mainBundle] loadNibNamed:@"VideoCustomView" owner:self options:nil];
        }

        
        for(id oneObject in nib)
            if([oneObject isKindOfClass:[VideoCustomView class]])
                cell = (VideoCustomView *)oneObject;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    VideoView *videoObj=[videoArr objectAtIndex:indexPath.row];
    cell.vtitleLbl.text=videoObj.videoTitle;
    cell.vDateLbl.text=videoObj.videoDate;
   
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
   UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Video"
                                                                    style:UIBarButtonSystemItemDone target:self action:@selector(videobtn)];
    self.navigationItem.leftBarButtonItem = rightButton;
    [rightButton release];
   // editdoneButton.enabled=FALSE;
    [self.navigationItem setRightBarButtonItem:nil animated:NO];
    
    VideoView *videoObj=[videoArr objectAtIndex:indexPath.row];
    selvideoPath=videoObj.videoPath;
    selvideoID=videoObj.videoID;
    selvideoDate=videoObj.videoDate;
    selvideoTitle=videoObj.videoTitle;
    
    self.title=selvideoTitle;
    
    NSLog(@"Video Path=== %@",selvideoPath);
    [self playVideo];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
    return 60;
    }else {
    return 45;
    }


}

#pragma mark Play Video

-(IBAction)playVideo
{
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:selvideoPath]];
   if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
   {
    moviePlayer.view.frame = CGRectMake(0, 0, 768  , 1004);
   }else {
    moviePlayer.view.frame = CGRectMake(0, 0, 320, 420);
   }
       [self.view addSubview:moviePlayer.view];
    [moviePlayer play];  
}

#pragma mark Row Rearrange

- (IBAction) EditTableVideos:(id)sender{
	if(self.editing)
	{
		[super setEditing:NO animated:NO]; 
		[videosTbl setEditing:NO animated:NO];
		[videosTbl reloadData];
		[self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
	}
	else
	{
		[super setEditing:YES animated:YES]; 
		[videosTbl setEditing:YES animated:YES];
		[videosTbl reloadData];
		[self.navigationItem.rightBarButtonItem setTitle:@"Done"];
		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
	}
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Move row
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
      toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString *item = [[videoArr objectAtIndex:fromIndexPath.row] retain];
    [videoArr removeObject:item];
    [videoArr insertObject:item atIndex:toIndexPath.row];
    [item release];
}

#pragma mark - Delete Video

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        VideoView *vdObj=[videoArr objectAtIndex:indexPath.row];
        selvideoID=vdObj.videoID ;
        NSLog(@"Cont id=== %d",[selvideoID intValue]);
        
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Alert!!" message:@"Are you sure you want to delete the video?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:nil];
        
        [alert addButtonWithTitle:@"YES"];
        [alert show];
        [alert release]; 
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    /********* On Confirmation to delete contact  ***********/
    if([title isEqualToString:@"YES"])
    {
        [self deleteVideo];
    }
}

-(void)deleteVideo{
    NSLog(@"ID==== %d",[selvideoID intValue]);
    
    databasepath=[app getDBPathNew];
    if (sqlite3_open([databasepath UTF8String], &dbSecret) == SQLITE_OK) 
    {
        NSString *DeleteQuery = [NSString stringWithFormat:@"Delete from VideoTbl Where VideoID=%d",[selvideoID intValue]];
        
        NSLog(@"Query : %@",DeleteQuery);
        const char *deleteStmt = [DeleteQuery UTF8String];
        sqlite3_stmt *query_stmt;
        
        if(sqlite3_prepare_v2(dbSecret, deleteStmt, -1, &query_stmt, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(query_stmt)== SQLITE_DONE)
            {
                // NSLog(@"Error: %s",sqlite3_errmsg(dbphonebook));
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Delete Result" message:@"Video Deleted Successfully...." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Deleted Result" message:@"Video Not Deleted...." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                
            }
            sqlite3_finalize(query_stmt);
        }
    }
    sqlite3_close(dbSecret);  
    [self dispVideo];
}

#pragma mark -  Display VideoList and remove play view

-(void)videobtn
{    
    self.title=@"Video";
    //Priyank Change
    if(moviePlayer.playbackState == MPMoviePlaybackStatePlaying)
        [moviePlayer stop];
    //Change Over
    [moviePlayer.view removeFromSuperview];
    //editdoneButton.enabled=true;
    editdoneButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                      style:UIBarButtonSystemItemDone target:self action:@selector(EditTableVideos:)];
    self.navigationItem.rightBarButtonItem = editdoneButton;
    [editdoneButton release];
    
    [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    
}

#pragma mark - Video Capture Methods

-(IBAction)btnAddVideoPressed{
    @try 
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {      
            
            videoRecorder = [[UIImagePickerController alloc]init];         
            NSArray *sourceTypes = [UIImagePickerController availableMediaTypesForSourceType:videoRecorder.sourceType];
            //  NSLog(@"Available types for source as camera = %@", sourceTypes);
            if (![sourceTypes containsObject:(NSString*)kUTTypeMovie] ) 
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                                message:@"Device Not Supported for video Recording."                                                                       delegate:self 
                                                      cancelButtonTitle:@"Yes" 
                                                      otherButtonTitles:@"No",nil];
                [alert show];
                [alert release];
                return;
            }
            videoRecorder.sourceType = UIImagePickerControllerSourceTypeCamera;
            videoRecorder.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeMovie];           
            videoRecorder.videoQuality = UIImagePickerControllerQualityTypeLow;
            videoRecorder.videoMaximumDuration=120;
            videoRecorder.delegate = self;
            
            [self presentViewController:videoRecorder animated:YES completion:nil];
            [videoRecorder release];
        }
    }
    @catch (NSException *exception) 
    {
        
    }
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {

    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:(NSString *)kUTTypeVideo] || 
        [type isEqualToString:(NSString *)kUTTypeMovie]) 
    {
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        // Code To give Name to video and store to DocumentDirectory //
        
        NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormat setDateFormat:@"dd-MM-yyyy||HH:mm:SS"];
        NSDate *now = [[[NSDate alloc] init] autorelease];
        theDate = [dateFormat stringFromDate:now];
        
        tempPath = [[NSString alloc ] initWithString:[NSString stringWithFormat:@"%@/%@.mp4",documentsDirectory,theDate]];
        
        BOOL success = [videoData writeToFile:tempPath atomically:NO];
        
        NSLog(@"Successs:::: %@",success ? @"YES" : @"NO");
        NSLog(@"video path-->%@",tempPath);
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        //Display View to add title//
        
        CATransition *transUp=[CATransition animation];
        transUp.duration=0.5;
        transUp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transUp.delegate=self;
        transUp.type=kCATransitionMoveIn;
        transUp.subtype=kCATransitionFromTop;
        [titleView.layer addAnimation:transUp forKey:nil];
        titleView.hidden=NO;
        
        [self.view addSubview:titleView];
    }
}

-(IBAction)currentdate
{
    NSDate* date = [NSDate date];    
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM:SS"];
    DateStr = [[NSString alloc]initWithFormat:@"%@",[formatter stringFromDate:date]];
    NSLog(@"Date::: %@",DateStr);
}

#pragma mark - Video Save Method

-(IBAction)SaveVideo{
    NSLog(@"video path from save method:: %@",tempPath);
    sqlite3_stmt *stmt;
    databasepath=[app getDBPathNew];
    const char *dbpath=[databasepath UTF8String];
    if(sqlite3_open(dbpath, &dbSecret) == SQLITE_OK)
    {
        NSString *insertquery=[NSString stringWithFormat:@"Insert into VideoTbl(UserID,VideoPath,VideoTitle,VideoDate) VALUES(%d,\"%@\",\"%@\",\"%@\");",[app.LoginUserID intValue],tempPath,titletxt.text,DateStr];
        
        NSLog(@"Query:: %@",insertquery);
        
        const char *insert_query=[insertquery UTF8String];
        
        sqlite3_prepare_v2(dbSecret, insert_query, -1, &stmt, NULL);
        
        if(sqlite3_step(stmt)== SQLITE_DONE)
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Message" message:@"Video Added Successfully...!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
        }
        else
        { 
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry" message:@"Failed To Insert Video.." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        sqlite3_finalize(stmt);
        sqlite3_close(dbSecret);
    }
    [self TransDown];
}

#pragma mark - Hide Add Title View

-(IBAction)TransDown
{    
    [titletxt resignFirstResponder];
    titletxt.text=@"";
    self.navigationItem.hidesBackButton=NO;
    self.title=@"Record Video";
    titletxt.text=@"";
    CATransition *transDown=[CATransition animation];
    transDown.duration=0.6;
    transDown.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transDown.delegate=self;
    transDown.type=kCATransitionReveal;
    transDown.subtype=kCATransitionFromBottom;
    [titleView.layer addAnimation:transDown forKey:nil];
    titleView.hidden=YES;
    
    [self dispVideo];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [titletxt resignFirstResponder];
    return YES;
}

#pragma mark - GADDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    if(self == self.navigationController.topViewController)
        [self.interstitial presentFromRootViewController:self];
}

@end
