//
//  AudioRecorder.m
//  ShortSaleScore
//
//  Created by Bhargavi on 1/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AudioRecorder.h"
#import "AudioCustomCell.h"
#import "AddAudioView.h"
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"
#import "GADInterstitial.h"

@interface AudioRecorder () <GADInterstitialDelegate, GADBannerViewDelegate>

@property (nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation AudioRecorder
@synthesize lblTitle;
@synthesize audiopath,allAudioArr,progressBar;
@synthesize btnBack,btnFast,btnForward,btnBackward;
@synthesize toolbar,audioTbl,transView,transViewBG,DurationLbl,TimeLbl,playpauseBtn;

@synthesize audioID,audioFilePath,audioTitle,audiotime,audioDate,updateTimer;
int cnt =0 ;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [audioFilePath release];
    [progressBar release];
    [allAudioArr release];
    [lblTitle release];
    [btnBackward release];
    [btnFast release];
    [audioID release];
    [btnForward release];
    [playpauseBtn release];
    [DurationLbl release];
    [TimeLbl release];
    [transView release];
    [transViewBG release];
    [audiotime release];
    [audioDate release];
    [audioTitle release];
    [audioTbl release];
    [toolbar release];
    [audiopath release];
    [btnBack release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        toolbar.barTintColor = [UIColor blackColor];
    }

    app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    allAudioArr=[[NSMutableArray alloc] init];
    flagPlay=NO;
    self.title=@"Audio";
    [self.navigationController setNavigationBarHidden:NO];
  /*  editdoneButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                      style:UIBarButtonSystemItemDone target:self action:@selector(EditTableVideos:)];
    self.navigationItem.rightBarButtonItem = editdoneButton;
    [editdoneButton release];
    editdoneButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                      style:UIBarButtonSystemItemDone target:self action:@selector(EditTableVideos:)];
    self.navigationItem.rightBarButtonItem = editdoneButton;
    [editdoneButton release];
   */
    
    UIImage *stretchLeftTrack = [[UIImage imageNamed:@"iphone-p-line.png"]
                                 stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
    UIImage *stretchRightTrack = [[UIImage imageNamed:@"iphone-p-line2.png"]
                                  stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
    [progressBar setThumbImage: [UIImage imageNamed:@"iphone-p-point.png"] forState:UIControlStateNormal];
    [progressBar setMinimumTrackImage:stretchLeftTrack forState:UIControlStateNormal];
    [progressBar setMaximumTrackImage:stretchRightTrack forState:UIControlStateNormal];
    progressBar.continuous = YES;
    progressBar.userInteractionEnabled = NO;

    
    
    // Tap For Tap Adview Starts Here
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
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
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(btnAddAudioPressed)];
    addButton.style = UIBarButtonItemStyleBordered;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        addButton.tintColor = [UIColor whiteColor];
    }
    [buttons addObject:addButton];
    [addButton release];
    toolbar.items = buttons;
    [buttons release];
    
    [self AllAudioToDisplay];
}

- (void)viewDidUnload
{
   // [allAudioArr release];
   
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated
{
    flagPlay=NO;
    [self.navigationController setNavigationBarHidden:NO];
    self.transViewBG.hidden=TRUE;
    self.transView.hidden=true;
    self.transViewBG.backgroundColor = [UIColor grayColor];
    self.transViewBG.alpha = 0.5;
    [self AllAudioToDisplay];
}

-(void) AllAudioToDisplay
{
    [allAudioArr removeAllObjects];
    databasepath = [app getDBPathNew];
    
    if (sqlite3_open(databasepath.UTF8String, &dbSecret) == SQLITE_OK) {
        
        NSString *sql =[NSString stringWithFormat:@"select * from AudioTbl where UserID=%d",(app.LoginUserID).intValue];
        
        sqlite3_stmt *selectstmt;
        const char *sel_query=sql.UTF8String;
        if(sqlite3_prepare(dbSecret, sel_query, -1, &selectstmt, NULL) == SQLITE_OK) {
            
            while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {
                AudioRecorder *audioObj = [[AudioRecorder alloc] init];
                
                audioObj.audioID =@((char *)sqlite3_column_text(selectstmt, 0));
                
                audioObj.audioTitle=@((char *)sqlite3_column_text(selectstmt, 2));
                
                audioObj.audioFilePath = @((char *)sqlite3_column_text(selectstmt, 3));
                
                audioObj.audiotime=@((char *)sqlite3_column_text(selectstmt, 4));
                
                audioObj.audioDate= @((char *)sqlite3_column_text(selectstmt, 5));
                
                [allAudioArr addObject:audioObj];
                //[contObj release];
            }
        }
        sqlite3_finalize(selectstmt);
    }
    else
        sqlite3_close(dbSecret);
    
    NSLog(@"audios count::: %lu",(unsigned long)allAudioArr.count);
    //  NSLog(@"Note Array:::: %@",);
    [audioTbl reloadData];
}


-(IBAction)btnFastClick:(id)sender
{

    NSLog(@"btnFastClick");
    NSTimeInterval time = audioPlayer.currentTime;
    time += 5.0; // forward 5 secs
    if (time > audioPlayer.duration)
    {
        
    }
    else{
        audioPlayer.currentTime = time;
    }
        
}
-(IBAction)btnForwardClick:(id)sender
{
    
   
    count++;
    int i= allAudioArr.count ;
    NSLog(@" count %ld and i is %d",(long)count, i);

    if(count <i )
    {
        
        
        [audioPlayer stop];
        
        audioPlayer.currentTime=0.00;
        progressBar.value = 0.00;
        TimeLbl.text=@"0.00";
 flagPlay=NO;
        [playpauseBtn setImage:[UIImage imageNamed:@"iphone-p-play.png"] forState:UIControlStateNormal];
        [updateTimer invalidate];
        updateTimer=nil;
        
        // Set audio path and time 
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        AudioRecorder *obj = allAudioArr[count];
        DurationLbl.text=obj.audiotime;
        lblTitle.text=obj.audioTitle;
        //  currTime=[NSString stringWithFormat:@"%@",TimeLbl.text];
        
        NSLog(@"Current filepath=== %@",obj.audioFilePath);
        NSURL *url = [NSURL fileURLWithPath:obj.audioFilePath];
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    }else {
        count--;
      
    }
    NSLog(@"btnForwardClick");
}
-(IBAction)btnbackwardClick:(id)sender
{
    count--;
    int i= allAudioArr.count ;
    NSLog(@" count %ld and i is %d",(long)count,i);
    
    if( count>=0 )
    {
        [audioPlayer stop];
        audioPlayer.currentTime=0.00;
        progressBar.value = 0.00;
        TimeLbl.text=@"0.00";
         flagPlay=NO;
        [playpauseBtn setImage:[UIImage imageNamed:@"iphone-p-play.png"] forState:UIControlStateNormal];
        [updateTimer invalidate];
        updateTimer=nil;
        
        // Set audio path and time 
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        AudioRecorder *obj = allAudioArr[count];
        DurationLbl.text=obj.audiotime;
        lblTitle.text=obj.audioTitle;
        //  currTime=[NSString stringWithFormat:@"%@",TimeLbl.text];
        
        NSLog(@"Current filepath=== %@",obj.audioFilePath);
        NSURL *url = [NSURL fileURLWithPath:obj.audioFilePath];
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    }else {
        
        count++;
    }

    NSLog(@"btnForwardClick");
    }
-(IBAction)btnBackClick:(id)sender
{
  
    NSLog(@"btnFastClick");
    NSTimeInterval time = audioPlayer.currentTime;
    time -= 5.0; // forward 5 secs
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


-(IBAction)btnAddAudioPressed {
    AddAudioView *addaudio;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        addaudio = [[AddAudioView alloc] initWithNibName:@"AddAudioView_ipad" bundle:nil];
    }
    else {
        addaudio = [[AddAudioView alloc] initWithNibName:@"AddAudioView" bundle:nil];
    }

  //  AddAudioView *addaudio=[[AddAudioView alloc] initWithNibName:@"AddAudioView" bundle:nil];
    [self.navigationController pushViewController:addaudio animated:YES];
    [addaudio release];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"audio data count:::: %lu",(unsigned long)allAudioArr.count);
    return allAudioArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CustomCellIdentifier = @"AudioCustomCell";
    
        AudioCustomCell *cell = (AudioCustomCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        if (cell == nil) {
        NSArray *nib;
     
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"AudioCustomCell_Ipad" owner:self options:nil];
        }
        else {
            nib = [[NSBundle mainBundle] loadNibNamed:@"AudioCustomCell" owner:self options:nil];

        }
        

        
        
        
        for(id oneObject in nib)
            if([oneObject isKindOfClass:[AudioCustomCell class]])
                cell = (AudioCustomCell *)oneObject;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.textLabel.font= [UIFont fontWithName:@"Arial Rounded MT Bold" size:15.0];
        
    AudioRecorder *obj = allAudioArr[indexPath.row];
    cell.titleLbl.text= obj.audioTitle;
    cell.DateLbl.text=obj.audioDate; 
    cell.timeLbl.text=obj.audiotime;
    
    [cell.mailBtn addTarget:self action:@selector(getAudioToEmail:) forControlEvents:UIControlEventTouchUpInside];
    (cell.mailBtn).tag = indexPath.row + 500;
    
    return cell;
}

-(IBAction)getAudioToEmail:(id)sender
{
    int index=[sender tag]-500;
    AudioRecorder *obj = allAudioArr[index];
    NSLog(@"audio === %@",obj.audioFilePath);
    
    audioToEmail=obj.audioFilePath;
    audioNmToEmail=obj.audioTitle;
    
    [self EmailAudio];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [audioTbl reloadData];
    
    audioPlayer.currentTime=0.00;
    progressBar.value = 0.00;
    TimeLbl.text=@"0.00";
    
    flagPlay=NO;
    CATransition *transUp=[CATransition animation];
    transUp.duration=.3;
    transUp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transUp.delegate=self;
    transUp.type=kCATransitionMoveIn;
    transUp.subtype=kCATransitionFade;
    [transViewBG.layer addAnimation:transUp forKey:nil];
    transViewBG.hidden=NO;
    
    transUp=[CATransition animation];
    transUp.duration=.4;
    transUp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transUp.delegate=self;
    transUp.type=kCATransitionMoveIn;
    transUp.subtype=kCATransitionFromTop;
    [transView.layer addAnimation:transUp forKey:nil];
    transView.hidden=NO;
    
    cnt=0;
    [audioPlayer stop];
    
    [playpauseBtn setImage:[UIImage imageNamed:@"iphone-p-play.png"] forState:UIControlStateNormal];
    [updateTimer invalidate];
    updateTimer=nil;
    
    // Set audio path and time 
    count=indexPath.row;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    int i=indexPath.row;
    AudioRecorder *obj = allAudioArr[i];
    DurationLbl.text=obj.audiotime;
  
    lblTitle.text=obj.audioTitle;
    //  currTime=[NSString stringWithFormat:@"%@",TimeLbl.text];
    
    NSLog(@"Current filepath=== %@",obj.audioFilePath);
    NSURL *url = [NSURL fileURLWithPath:obj.audioFilePath];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
            return 60;
    }
    else {
        return 45;
    }
    


}

#pragma mark Row Rearrange

- (IBAction) EditTableVideos:(id)sender{
    if(self.editing)
    {
        [super setEditing:NO animated:NO]; 
        [audioTbl setEditing:NO animated:NO];
        [audioTbl reloadData];
        (self.navigationItem.rightBarButtonItem).title = @"Edit";
        (self.navigationItem.rightBarButtonItem).style = UIBarButtonItemStylePlain;
    }
    else
    {
        [super setEditing:YES animated:YES]; 
        [audioTbl setEditing:YES animated:YES];
        [audioTbl reloadData];
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
    NSString *item = [allAudioArr[fromIndexPath.row] retain];
    [allAudioArr removeObject:item];
    [allAudioArr insertObject:item atIndex:toIndexPath.row];
    [item release];
}

#pragma mark - Delete audio

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        AudioRecorder *adObj=allAudioArr[indexPath.row];
        selaudioId=adObj.audioID ;
        NSLog(@"Audio id=== %d",selaudioId.intValue);
        
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Alert!!" message:@"Are you sure you want to delete the Audio?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:nil];
        
        [alert addButtonWithTitle:@"Delete"];
        [alert show];
        [alert release]; 
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    /********* On Confirmation to delete contact  ***********/
    if([title isEqualToString:@"Delete"])
    {
        [self deleteAudio];
    }
}

-(void)deleteAudio{
    
    NSLog(@"audioID TO Delete==== %d",selaudioId.intValue);
    databasepath=[app getDBPathNew];
    if (sqlite3_open(databasepath.UTF8String, &dbSecret) == SQLITE_OK) 
    {
        NSString *DeleteQuery = [NSString stringWithFormat:@"Delete from AudioTbl Where AudioID=%d",selaudioId.intValue];
        
        NSLog(@"Query : %@",DeleteQuery);
        const char *deleteStmt = DeleteQuery.UTF8String;
        sqlite3_stmt *query_stmt;
        
        if(sqlite3_prepare_v2(dbSecret, deleteStmt, -1, &query_stmt, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(query_stmt)== SQLITE_DONE)
            {
                // NSLog(@"Error: %s",sqlite3_errmsg(dbphonebook));
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Delete Result" message:@"Audio Deleted Successfully...." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Deleted Result" message:@"Audio Not Deleted...." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                
            }
            sqlite3_finalize(query_stmt);
        }
    }
    sqlite3_close(dbSecret);  
    [self AllAudioToDisplay];
}

#pragma mark - Transition down

-(IBAction)btnCloseTransClicked:(id)sender{
    
    [audioPlayer stop];
    flagPlay=NO;
    [updateTimer invalidate];
    updateTimer=nil;
    audioPlayer.currentTime=0.00;
   
    if(UI_USER_INTERFACE_IDIOM() ==UIUserInterfaceIdiomPad)
    {
        
    
    CATransition *transDown=[CATransition animation];
    transDown.duration=.4;
    transDown.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transDown.delegate=self;
    transDown.type=kCATransitionReveal;
    transDown.subtype=kCATransitionFromBottom;
    [transView.layer addAnimation:transDown forKey:nil];
    transView.hidden=YES;
    
    transDown=[CATransition animation];
    transDown.duration=.4;
    transDown.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transDown.delegate=self;
    transDown.type=kCATransitionReveal;
    transDown.subtype=kCATransitionFade;
    [transViewBG.layer addAnimation:transDown forKey:nil];
    transViewBG.hidden=YES;
    
    }else {
        CATransition *transDown=[CATransition animation];
        transDown.duration=.4;
        transDown.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transDown.delegate=self;
        transDown.type=kCATransitionReveal;
        transDown.subtype=kCATransitionFromBottom;
        [transView.layer addAnimation:transDown forKey:nil];
        transView.hidden=YES;
        
        transDown=[CATransition animation];
        transDown.duration=.4;
        transDown.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transDown.delegate=self;
        transDown.type=kCATransitionReveal;
        transDown.subtype=kCATransitionFade;
        [transViewBG.layer addAnimation:transDown forKey:nil];
        transViewBG.hidden=YES;
  
    }
    
    
}

#pragma mark - My Methods

-(IBAction)btnPlayPause:(id)sender{
    
    if(flagPlay)
    {
        NSLog(@"Player paused...");
        
        [playpauseBtn setImage:[UIImage imageNamed:@"iphone-p-play.png"] forState:UIControlStateNormal];
        [audioPlayer pause];
        flagPlay=NO;
    }
    else
    {
        flagPlay=YES;
        cnt =0;
        
        [playpauseBtn setImage:[UIImage imageNamed:@"iphone-p-pause.png"] forState:UIControlStateNormal];
       // [audioPlayer prepareToPlay];
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
    //audioPlayer.currentTime = sender.value;
    [self updateCurrentTimeForPlayer:audioPlayer];
}

-(void)updateCurrentTimeForPlayer:(AVAudioPlayer *)p
{
    TimeLbl.text=[NSString stringWithFormat:@"%d:%02d", (int)p.currentTime / 60, (int)p.currentTime % 60, nil];
    progressBar.value = p.currentTime;
    progressBar.maximumValue = p.duration;
    
   // if(audioPlayer.currentTime == 0.00)
   // {
    //  if(cnt > 0)
      //  {
            
          //  cnt=0;
            
            
            if(!audioPlayer.isPlaying)
            {
                [audioPlayer stop];
                //cnt++;
                
                [playpauseBtn setImage:[UIImage imageNamed:@"iphone-p-play"] forState:UIControlStateNormal];
                [updateTimer invalidate];
                updateTimer=nil;
                flagPlay=NO;
            }
       // }
//        else 
//        {
//             NSLog(@"Cnt::: %d",cnt);
//             cnt++;
//        }
    //}
}

- (void)updateCurrentTime
{
    [self updateCurrentTimeForPlayer:audioPlayer];
}

#pragma  mark - send audio via email

- (void)EmailAudio
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
#ifdef LITEVERSION
    [picker setSubject:@"Audio from Secret Vault"];
#else
    [picker setSubject:@"Audio from Secret Vault Pro"];
#endif
    
    [picker setToRecipients:@[@""]];
    [picker setCcRecipients:@[@""]];    
    [picker setBccRecipients:@[@""]];
    
    NSString *emailBody = @"I have shared the media,just check it out.";
    
    [picker setMessageBody:emailBody isHTML:NO];
    
    NSLog(@"audio file=== %@",audioToEmail);
    
    NSData *data = [NSData dataWithContentsOfFile:audioToEmail ];
        
    [picker addAttachmentData:data mimeType:@"audio/caf" fileName:[NSString stringWithFormat:@"%@.caf",audioNmToEmail]];
        
    [self presentViewController:picker animated:YES completion:nil];
    
    [picker release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
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
}

#pragma mark - GADDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    if(self == self.navigationController.topViewController)
        [self.interstitial presentFromRootViewController:self];
}

@end
