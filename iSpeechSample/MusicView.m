//
//  MusicView.m
//  SecretApp
//
//  Created by c62 on 22/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MusicView.h"
#import "iTunesDataList.h"
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"
#import "GADInterstitial.h"

@interface MusicView () <GADInterstitialDelegate, GADBannerViewDelegate>

@property (nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation MusicView

@synthesize musicArr,musicPath,musicID,musicTbl,toolbar,musicTitle,playView,updateTimer,playViewBG;

@synthesize playTimeLbl,totaltimeLbl,playpauseBtn,audioPlayer,progressBar,selSongID,selSongPath;
@synthesize btnBack,btnBackward,btnFast,btnForward;
@synthesize lblTitle;
int count=0;


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
    [btnBack release];
    [btnBackward release];
    [btnFast release];
    [btnForward release];
    [lblTitle release];
    [selSongID release];
    [selSongPath release];
    [playViewBG release];
    [updateTimer release];
    [playView release];
    [progressBar release];
    [totaltimeLbl release];
    [playpauseBtn release];
    [playTimeLbl release];
    [audioPlayer release];
    [toolbar release];
    [musicID release];
    [musicPath release];
    [musicArr release];
    [musicTbl release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        toolbar.barTintColor = [UIColor blackColor];
    }

    app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    musicArr=[[NSMutableArray alloc] init];
    [self.navigationController setNavigationBarHidden:NO];
  /*  
    editdoneButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                      style:UIBarButtonSystemItemDone target:self action:@selector(EditMusic:)];
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
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(btnAddSongPressed)];
    addButton.style = UIBarButtonItemStyleBordered;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        addButton.tintColor=[UIColor whiteColor];
    }
    [buttons addObject:addButton];
    [addButton release];
    toolbar.items = buttons;
    [buttons release];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    self.playViewBG.hidden=TRUE;
    self.playViewBG.backgroundColor = [UIColor grayColor];
    self.playViewBG.alpha = 0.5;
    playView.hidden=YES;
    
    flagPlay=NO;
    [self dispSongs];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
   

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
   if(audioPlayer.playing)
   {
       [audioPlayer stop];
   }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction)btnFastClick:(id)sender
{
    
    NSLog(@"btnFastClick");
    NSTimeInterval time = audioPlayer.currentTime;
    time += 8.0; // forward 5 secs
    if (time > audioPlayer.duration)
    {
        
    }
    else{
        audioPlayer.currentTime = time;
    }
    
}
-(IBAction)btnForwardClick:(id)sender
{
    
    
    intCount++;
    int i= musicArr.count ;
    NSLog(@" count %d and i is %d",count,i);
    
    if(intCount <i )
    {
        MusicView *musicVwObj=musicArr[intCount];
        selSongID=musicVwObj.musicID;
        
        selSongPath=musicVwObj.musicPath;
            lblTitle.text=musicVwObj.musicTitle;
        NSData *data=[NSData dataWithContentsOfFile:selSongPath];
        NSLog(@"data length from music tbl ====> %lu",(unsigned long)data.length);
        
        flagPlay=NO;
        audioPlayer.currentTime=0.00;
        progressBar.value = 0.00;
        playTimeLbl.text=@"0.00";
        
        
        count=0;
        [audioPlayer stop];
        [playpauseBtn setImage:[UIImage imageNamed:@"ipad-p-play.png"] forState:UIControlStateNormal];
        [updateTimer invalidate];
        updateTimer=nil;
        
        //  NSData *data11=[NSData dataWithContentsOfFile:app.iTuneSongPath];
        // NSLog(@"data length from music ====> %d",[data11 length]);
        
        //  NSURL *newURL = [[NSURL alloc]initFileURLWithPath:selSongPath];   
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        NSLog(@"Current filepath=== %@",selSongPath);
        
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error]; 
        NSLog(@"Total time::: %.2f",(audioPlayer.duration/100));
        float total=(audioPlayer.duration/100)+2;
        totaltimeLbl.text=[NSString stringWithFormat:@"%.2f",total];
        
        NSLog(@"Total time + 2::: %.2f",total);

        
       
    }else {
        intCount--;
        
    }
    NSLog(@"btnForwardClick");
}
-(IBAction)btnbackwardClick:(id)sender
{
    intCount--;
    int i= musicArr.count ;
    NSLog(@" count %ld and i is %d",(long)intCount,i);
    
    if( intCount>=0 )
    {
        
        MusicView *musicVwObj=musicArr[intCount];
        selSongID=musicVwObj.musicID;
            lblTitle.text=musicVwObj.musicTitle;
        selSongPath=musicVwObj.musicPath;
        
        NSData *data=[NSData dataWithContentsOfFile:selSongPath];
        NSLog(@"data length from music tbl ====> %lu",(unsigned long)data.length);
        
        flagPlay=NO;
        audioPlayer.currentTime=0.00;
        progressBar.value = 0.00;
        playTimeLbl.text=@"0.00";
        
        
        count=0;
        [audioPlayer stop];
        [playpauseBtn setImage:[UIImage imageNamed:@"ipad-p-play.png"] forState:UIControlStateNormal];
        [updateTimer invalidate];
        updateTimer=nil;
        
        //  NSData *data11=[NSData dataWithContentsOfFile:app.iTuneSongPath];
        // NSLog(@"data length from music ====> %d",[data11 length]);
        
        //  NSURL *newURL = [[NSURL alloc]initFileURLWithPath:selSongPath];   
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        NSLog(@"Current filepath=== %@",selSongPath);
        
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error]; 
        NSLog(@"Total time::: %.2f",(audioPlayer.duration/100));
        float total=(audioPlayer.duration/100)+2;
        totaltimeLbl.text=[NSString stringWithFormat:@"%.2f",total];
        
        NSLog(@"Total time + 2::: %.2f",total);
       
    }else {
        
        intCount++;
    }
    
    NSLog(@"btnForwardClick");
}
-(IBAction)btnBackClick:(id)sender
{
    
    NSLog(@"btnFastClick");
    NSTimeInterval time = audioPlayer.currentTime;
    time -= .0; // forward 5 secs
    //    if (time < audioPlayer.duration)
    //    {
    //        
    //    }
    //    else{
    audioPlayer.currentTime = time;
    // }
    NSLog(@"btnbackwardClick");
    
    NSLog(@"btnBackClick");
}


#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSLog(@"Arr Count : %lu",(unsigned long)musicArr.count);
    return musicArr.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
  /*  UIView *selectedBackgroundViewForCell = [UIView new];
    [selectedBackgroundViewForCell setBackgroundColor:[UIColor blackColor]];
    cell.selectedBackgroundView = selectedBackgroundViewForCell;*/
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        cell.textLabel.textColor=[UIColor blackColor];
    }
    else
    {
        cell.textLabel.textColor=[UIColor whiteColor];
    }
    cell.textLabel.font= [UIFont fontWithName:@"Arial Rounded MT Bold" size:15.0];

    MusicView *musicVwObj=musicArr[indexPath.row];
    cell.textLabel.text=musicVwObj.musicTitle;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MusicView *musicVwObj=musicArr[indexPath.row];
    selSongID=musicVwObj.musicID;
    lblTitle.text=musicVwObj.musicTitle;
    selSongPath=musicVwObj.musicPath;
    
    NSData *data=[NSData dataWithContentsOfFile:selSongPath];
    NSLog(@"data length from music tbl ====> %lu",(unsigned long)data.length);
    
    flagPlay=NO;
    audioPlayer.currentTime=0.00;
    progressBar.value = 0.00;
    playTimeLbl.text=@"0.00";
    
    CATransition *transUp=[CATransition animation];
    transUp.duration=.3;
    transUp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transUp.delegate=self;
    transUp.type=kCATransitionMoveIn;
    transUp.subtype=kCATransitionFade;
    [playViewBG.layer addAnimation:transUp forKey:nil];
    playViewBG.hidden=NO;
    
    transUp=[CATransition animation];
    transUp.duration=.4;
    transUp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transUp.delegate=self;
    transUp.type=kCATransitionMoveIn;
    transUp.subtype=kCATransitionFromTop;
    [playView.layer addAnimation:transUp forKey:nil];
    playView.hidden=NO;

    count=0;
    [audioPlayer stop];
    [playpauseBtn setImage:[UIImage imageNamed:@"ipad-p-play.png"] forState:UIControlStateNormal];
    [updateTimer invalidate];
    updateTimer=nil;
    intCount =indexPath.row;
  //  NSData *data11=[NSData dataWithContentsOfFile:app.iTuneSongPath];
   // NSLog(@"data length from music ====> %d",[data11 length]);
    
  //  NSURL *newURL = [[NSURL alloc]initFileURLWithPath:selSongPath];   
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSLog(@"Current filepath=== %@",selSongPath);
    
    NSError *error;
    
    audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
    [audioPlayer prepareToPlay];
    NSLog(@"Total time::: %.2f",(audioPlayer.duration/100));
    float total=(audioPlayer.duration/100)+2;
    totaltimeLbl.text=[NSString stringWithFormat:@"%.2f",total];
    
    NSLog(@"Total time + 2::: %.2f",total);
}

#pragma mark Row Rearrange

- (IBAction) EditMusic:(id)sender{
    
    if(self.editing)
    {
        [super setEditing:NO animated:NO]; 
        [musicTbl setEditing:NO animated:NO];
        [musicTbl reloadData];
        (self.navigationItem.rightBarButtonItem).title = @"Edit";
        (self.navigationItem.rightBarButtonItem).style = UIBarButtonItemStylePlain;
    }
    else
    {
        [super setEditing:YES animated:YES]; 
        [musicTbl setEditing:YES animated:YES];
        [musicTbl reloadData];
        (self.navigationItem.rightBarButtonItem).title = @"Done";
        (self.navigationItem.rightBarButtonItem).style = UIBarButtonItemStyleDone;
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Move row
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
      toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString *item = [musicArr[fromIndexPath.row] retain];
    [musicArr removeObject:item];
    [musicArr insertObject:item atIndex:toIndexPath.row];
    [item release];
}

#pragma mark - Delete Video

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        MusicView *vdObj=musicArr[indexPath.row];
        selSongID=vdObj.musicID ;
        NSLog(@"song id=== %d",selSongID.intValue);
        
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Alert!!" message:@"Are you sure you want to delete the Song?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:nil];
        
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
        [self deleteSelectedSong];
    }
}

-(void)deleteSelectedSong{
    NSLog(@"ID==== %d",selSongID.intValue);
    
    databasepath=[app getDBPathNew];
    if (sqlite3_open(databasepath.UTF8String, &dbSecret) == SQLITE_OK) 
    {
        NSString *DeleteQuery = [NSString stringWithFormat:@"Delete from MusicTbl Where MusicID=%d",selSongID.intValue];
        
        NSLog(@"Query : %@",DeleteQuery);
        const char *deleteStmt = DeleteQuery.UTF8String;
        sqlite3_stmt *query_stmt;
        
        if(sqlite3_prepare_v2(dbSecret, deleteStmt, -1, &query_stmt, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(query_stmt)== SQLITE_DONE)
            {
                // NSLog(@"Error: %s",sqlite3_errmsg(dbphonebook));
                
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Delete Result" message:@"Song Deleted Successfully...." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
    [self dispSongs];
}

#pragma  mark MY Methods

-(IBAction)playPause:(id)sender{    
    if(flagPlay)
    {
        NSLog(@"Player paused...");
        
        [playpauseBtn setImage:[UIImage imageNamed:@"ipad-p-play.png"] forState:UIControlStateNormal];
        [audioPlayer pause];
        flagPlay=NO;
    }
    else
    {
        flagPlay=YES;
        count =0;
        
        [playpauseBtn setImage:[UIImage imageNamed:@"ipad-p-pause.png"] forState:UIControlStateNormal];
        audioPlayer.delegate=self;
        [audioPlayer play];
        
        NSLog(@" time duration ::: %f",audioPlayer.duration);
        NSLog(@"Player playing...");
        updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateCurrentTime) userInfo:audioPlayer repeats:YES];
        [self updateCurrentTimeForPlayer:audioPlayer];
    }
}

- (IBAction)progressSliderMoved:(UISlider *)sender
{
    [self updateCurrentTimeForPlayer:audioPlayer];
}

-(void)updateCurrentTimeForPlayer:(AVAudioPlayer *)p
{
    playTimeLbl.text=[NSString stringWithFormat:@"%d:%02d", (int)p.currentTime / 60, (int)p.currentTime % 60, nil];
    progressBar.value = p.currentTime;
    progressBar.maximumValue = p.duration;
    
//    if(audioPlayer.currentTime == 0.00)
//    {
//        NSLog(@"Cnt::: %d",count);
//        
//        if(count>0)
//        {
//            count=0;
//            [audioPlayer stop];
//            [playpauseBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
//            [updateTimer invalidate];
//            updateTimer=nil;
//            
//            flagPlay=NO;
//        }
//        else
//        {
//            count++;
//        }
//    }
    if(!audioPlayer.isPlaying)
    {
        [audioPlayer stop];
        //cnt++;
        
        [playpauseBtn setImage:[UIImage imageNamed:@"ipad-p-play.png"] forState:UIControlStateNormal];
        [updateTimer invalidate];
        updateTimer=nil;
        flagPlay=NO;
    }
}

- (void)updateCurrentTime
{
    [self updateCurrentTimeForPlayer:audioPlayer];
}

-(IBAction)closePlayView:(id)sender{
    
    [audioPlayer stop];
    flagPlay=NO;
    [updateTimer invalidate];
    updateTimer=nil;
    audioPlayer.currentTime=0.00;
    
    CATransition *transDown=[CATransition animation];
    transDown.duration=.4;
    transDown.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transDown.delegate=self;
    transDown.type=kCATransitionReveal;
    transDown.subtype=kCATransitionFromBottom;
    [playView.layer addAnimation:transDown forKey:nil];
    playView.hidden=YES;
    
    transDown=[CATransition animation];
    transDown.duration=.4;
    transDown.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transDown.delegate=self;
    transDown.type=kCATransitionReveal;
    transDown.subtype=kCATransitionFade;
    [playViewBG.layer addAnimation:transDown forKey:nil];
    playViewBG.hidden=YES;
}

-(void)btnAddSongPressed
{
    
    iTunesDataList *musicVW;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        musicVW = [[iTunesDataList alloc] initWithNibName:@"iTUnesDataList_Ipad" bundle:nil];
    }
    else {
        musicVW = [[iTunesDataList alloc] initWithNibName:@"iTUnesDataList" bundle:nil];
    }

   // iTunesDataList *musicVW=[[iTunesDataList alloc]initWithNibName:@"iTUnesDataList" bundle:nil];
    [self.navigationController pushViewController:musicVW animated:YES];
    [musicVW release];
}

#pragma mark Fetch Videos From Database

-(void)dispSongs{
    
    [musicArr removeAllObjects];
    databasepath = [app getDBPathNew];
    
    if (sqlite3_open(databasepath.UTF8String, &dbSecret) == SQLITE_OK) {
        
        NSString *sql =[NSString stringWithFormat:@"select * from MusicTbl where UserID=%d",(app.LoginUserID).intValue];
        
        sqlite3_stmt *selectstmt;
        const char *sel_query=sql.UTF8String;
        if(sqlite3_prepare(dbSecret, sel_query, -1, &selectstmt, NULL) == SQLITE_OK) {
            
            while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {
                MusicView *musicObj = [[MusicView alloc] init];
                
                musicObj.musicID =@((char *)sqlite3_column_text(selectstmt, 0));
                
                musicObj.musicTitle=[NSString stringWithFormat:@"%s",sqlite3_column_text(selectstmt, 2)];
                
                musicObj.musicPath =[NSString stringWithFormat:@"%s",sqlite3_column_text(selectstmt, 3)];
                
                [musicArr addObject:musicObj];
                
                NSData *data1=[NSData dataWithContentsOfFile:musicObj.musicPath];
                NSLog(@"data len from sel data-------> %lu",(unsigned long)data1.length);
            }
        }
        sqlite3_finalize(selectstmt);
    }
    else
        sqlite3_close(dbSecret);
    
    NSLog(@" count::: %lu",(unsigned long)musicArr.count);
    if(musicArr.count == 0)
    {
#ifdef LITEVERSION
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"iTunes Syncing" message:@"To Sync your device:\n1.Connect your iPhone to your computer.\n2.In iTunes, select your iPhone, and then click the apps tab.\n3. Below file sharing, select 'Secret Vault' from the list.\n4. Select Add, then select songs and add from your music folder and then sync device.\n5. You can add song from iTunes library by pressing '+' button below." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
#else
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"iTunes Syncing" message:@"To Sync your device:\n1.Connect your iPhone to your computer.\n2.In iTunes, select your iPhone, and then click the apps tab.\n3. Below file sharing, select 'Secret Vault Pro' from the list.\n4. Select Add, then select songs and add from your music folder and then sync device.\n5. You can add song from iTunes library by pressing '+' button below." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
#endif
        [alert show];
        [alert release];
    }
    [musicTbl reloadData];
}

#pragma mark - GADDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    if(self == self.navigationController.topViewController)
        [self.interstitial presentFromRootViewController:self];
}

@end
