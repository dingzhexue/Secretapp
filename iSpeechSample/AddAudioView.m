//
//  AddAudioView.m
//  SecretApp
//
//  Created by c62 on 13/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddAudioView.h"
#import <QuartzCore/Quartzcore.h>

#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"
#import "GADInterstitial.h"

@interface AddAudioView () <GADInterstitialDelegate, GADBannerViewDelegate>

@property (nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation AddAudioView

@synthesize btnRecord,btnDelete,btnPlay,btnStop,recdelegate,audiopath;

@synthesize addTitleView,titletxt,timeLbl,updateTimer,timeStr,DateStr,transViewBG,transView,audioTitle;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    [timeStr release];
    [DateStr release];
    [timeLbl release];
    [addTitleView release];
    [titletxt release];
    [audiopath release];
    [btnRecord release];
    [btnDelete release];
    [btnPlay release];
    [btnStop release];
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated
{

     app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        self.transViewBG.hidden=YES;
        self.transView.hidden=YES;
//        self.transViewBG.backgroundColor = [UIColor grayColor];
//        self.transViewBG.alpha = 0.9;    
        
    }else {
        self.addTitleView.hidden=YES;
    }
    [self currentdate:nil];
    self.title=@"Record Audio";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
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

-(IBAction)startRecording
{
    if(!audioRecorder.isRecording)
    {
      //**** Code to start audio Recording**** // 
    [btnRecord setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    btnRecord.showsTouchWhenHighlighted = YES;
    
    if(!flagPause)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"dd:MM:yy";
        
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        timeFormat.dateFormat = @"HH:mm:SS";
        
        NSDate *now = [[NSDate alloc] init];
        
        theDate = [dateFormat stringFromDate:now];
        theTime = [timeFormat stringFromDate:now];
        
        NSString *filename =[NSString stringWithFormat:@"%@-%@",theDate,theTime];
        theDate=[[NSString alloc]initWithString:filename];
        
        [dateFormat release];
        [timeFormat release];
        [now release];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
        
        NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
        if(recordEncoding == ENC_PCM1)
        {
            recordSettings[AVFormatIDKey] = [NSNumber numberWithInt: kAudioFormatLinearPCM];
            recordSettings[AVSampleRateKey] = @44100.0f;
            recordSettings[AVNumberOfChannelsKey] = @2;
            recordSettings[AVLinearPCMBitDepthKey] = @16;
            recordSettings[AVLinearPCMIsBigEndianKey] = @NO;
            recordSettings[AVLinearPCMIsFloatKey] = @NO;   
        }
        else
        {
            NSNumber *formatObject;
            switch (recordEncoding) 
            {
                case (ENC_AAC1): 
                    formatObject = [NSNumber numberWithInt: kAudioFormatMPEG4AAC];
                    break;
                case (ENC_ALAC1):
                    formatObject = [NSNumber numberWithInt: kAudioFormatAppleLossless];
                    break;
                case (ENC_IMA41):
                    formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
                    break;
                case (ENC_ILBC1):
                    formatObject = [NSNumber numberWithInt: kAudioFormatiLBC];
                    break;
                case (ENC_ULAW1):
                    formatObject = [NSNumber numberWithInt: kAudioFormatULaw];
                    break;
                default:
                    formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
            }
            recordSettings[AVFormatIDKey] = formatObject;
            recordSettings[AVSampleRateKey] = @44100.0f;
            recordSettings[AVNumberOfChannelsKey] = @2;
            recordSettings[AVEncoderBitRateKey] = @12800;
            recordSettings[AVLinearPCMBitDepthKey] = @16;
            recordSettings[AVEncoderAudioQualityKey] = [NSNumber numberWithInt: AVAudioQualityHigh];
        }
        
        NSURL *url;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
        NSString *documentsDirectory = paths[0]; // Get documents folder
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"Recording"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
            [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; 
        NSString *filePath =[NSString stringWithFormat:@"%@/%@.caf",dataPath,theDate];
        // appiPhone.strATitle = theDate;
        url = [NSURL fileURLWithPath:filePath];
        audiopath=[[NSString alloc] initWithFormat:@"%@",filePath];
        
        NSLog(@"File path::: %@",filePath);
        NSLog(@"file name::: %@",audiopath );
        NSError *error = nil;
        
        audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
        
        if ([audioRecorder prepareToRecord] == YES)
        {
            [audioRecorder record];
            
            if (audioRecorder.recording)
            {
                updateTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(updateCurrentTime) userInfo:audioRecorder repeats:YES];
                [self updateCurrentTimeForRecorder:audioRecorder];
            }
        }
        else 
        {
            //int errorCode = CFSwapInt32HostToBig ([error code]); 
            // NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode); 
            
        }
    }
    else 
    {
        [audioRecorder record];
        flagPause = NO;
    }
  }
  else
  {      
        flagPause = YES;
        btnRecord.showsTouchWhenHighlighted = YES;
        [audioRecorder pause];
        [btnRecord setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
  }
}
-(void)updateCurrentTimeForRecorder:(AVAudioRecorder *)p
{
    timeLbl.text = [NSString stringWithFormat:@"%d:%02d", (int)p.currentTime / 60, (int)p.currentTime % 60, nil];

    //progressBar.value = p.currentTime;
}
- (void)updateCurrentTime
{
    [self updateCurrentTimeForRecorder:audioRecorder];
}

-(IBAction)btnRefreshaudioClicked:(id)sender{
    
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Alert!!" message:@"Are you sure you want to restart this recording?The current recording will be lost." delegate:self cancelButtonTitle:@"NO" otherButtonTitles:nil];
    [alert addButtonWithTitle:@"YES"];
    [alert show];
    [alert release]; 
    
    //appiPhone.intBtnAnsTag = 3;    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    /********* On Confirmation to stop recording  ***********/
    if([title isEqualToString:@"YES"])
    {
        audiopath=@"";
        timeLbl.text=@"0:00";
        [btnRecord setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        flagPause = NO;
        [audioRecorder stop];
        recordEncoding=0;
        [recdelegate viewpic1:self didSelectValue:theDate didSelectEvent:@"STOP"]; 
    }
}

-(IBAction)saveAudioClicked:(id)sender{
  
    NSLog(@"AudioPath=== %@",audiopath);
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        if([audiopath isEqualToString:@""])
        {
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please Record Audio First.." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {   
            if(updateTimer.valid||audioRecorder.recording)
            {
                [updateTimer invalidate];
                [audioRecorder stop];
            }
            
            btnRecord.showsTouchWhenHighlighted=true;
            flagPause = NO;
            recordEncoding=0;
            
            timeStr=[[NSString alloc]initWithFormat:@"%@", timeLbl.text];
            NSLog(@"Time:::: %@",timeStr);
            self.navigationItem.hidesBackButton=YES;
            self.title=@"Audio Title";
            [recdelegate viewpic1:self didSelectValue:theDate didSelectEvent:@"STOP"];
            
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
            [transView.layer addAnimation:transUp1 forKey:nil];
            transView.hidden=NO;
           
            [self.view addSubview:transViewBG];  
            [self.view addSubview:transView];
        }

    }else {
        if([audiopath isEqualToString:@""])
        {
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please Record Audio First.." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {   
            if(updateTimer.valid||audioRecorder.recording)
            {
                [updateTimer invalidate];
                [audioRecorder stop];
            }
            
            btnRecord.showsTouchWhenHighlighted=true;
            flagPause = NO;
            recordEncoding=0;
            
            timeStr=[[NSString alloc]initWithFormat:@"%@", timeLbl.text];
            NSLog(@"Time:::: %@",timeStr);
            self.navigationItem.hidesBackButton=YES;
            self.title=@"Audio Title";
            [recdelegate viewpic1:self didSelectValue:theDate didSelectEvent:@"STOP"];
            
            
            
            
            CATransition *transUp=[CATransition animation];
            transUp.duration=0.5;
            transUp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transUp.delegate=self;
            transUp.type=kCATransitionMoveIn;
            transUp.subtype=kCATransitionFromTop;
            [addTitleView.layer addAnimation:transUp forKey:nil];
            addTitleView.hidden=NO;
            
            [self.view addSubview:addTitleView];
        }
    
    }
    }

-(IBAction)currentdate:(id)sender
{
    NSDate* date = [NSDate date];    
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    formatter.dateFormat = @"yyyy-MM-dd HH:MM:SS";
    DateStr = [[NSString alloc]initWithFormat:@"%@",[formatter stringFromDate:date]];
    NSLog(@"Date::: %@",DateStr);
    //[dateLabel setText:str];
}

-(IBAction)SaveAudioWithTitle:(id)sender{
    timeLbl.text=@"0:00";
    if([titletxt.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Message" message:@"Please Enter Audio Title.." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        NSLog(@"Time:::: %@",timeStr);
        NSLog(@" Date::::== %@", DateStr);
        sqlite3_stmt *stmt;
        databasepath=[app getDBPathNew];
        const char *dbpath=databasepath.UTF8String;
        if(sqlite3_open(dbpath, &dbSecret) == SQLITE_OK)
        {
            NSString *insertquery=[NSString stringWithFormat:@"Insert into AudioTbl(UserID,AudioTitle,AudioPath,AudioTime,AudioDate) VALUES(%d,\"%@\",\"%@\",\"%@\",\"%@\");",(app.LoginUserID).intValue,titletxt.text,audiopath,timeStr,DateStr];
            
            NSLog(@"Query:: %@",insertquery);
        
            const char *insert_query=insertquery.UTF8String;
            
            sqlite3_prepare_v2(dbSecret, insert_query, -1, &stmt, NULL);
            
            if(sqlite3_step(stmt)== SQLITE_DONE)
            {
                // NSLog(@"Audio inserted...");
                UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Message" message:@"Recording Added Successfully...!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                
                [self TransDown];
                audiopath=[[NSString alloc] init];
            }
            else
            { 
                UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry" message:@"Failed To Insert Recording.." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            sqlite3_finalize(stmt);
            sqlite3_close(dbSecret);
            
        }
        
    }
}

-(IBAction)TransDown
{    
     [titletxt resignFirstResponder];
     self.navigationItem.hidesBackButton=NO;
     self.title=@"Record Audio";
     titletxt.text=@"";
     
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        CATransition *transDown=[CATransition animation];
        transDown.duration=0.6;
        transDown.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
     transDown.delegate=self;
     transDown.type=kCATransitionReveal;
     transDown.subtype=kCATransitionFromBottom;
     [transView.layer addAnimation:transDown forKey:nil];
     transView.hidden=YES;

    //CATransition *transDown2=[CATransition animation];
    transDown.duration=0.6;
    transDown.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transDown.delegate=self;
    transDown.type=kCATransitionReveal;
    transDown.subtype=kCATransitionFromBottom;
    [transViewBG.layer addAnimation:transDown forKey:nil];
    transViewBG.hidden=YES;
    }else{
        
        CATransition *transDown=[CATransition animation];
        transDown.duration=0.6;
        transDown.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transDown.delegate=self;
        transDown.type=kCATransitionReveal;
        transDown.subtype=kCATransitionFromBottom;
        [addTitleView.layer addAnimation:transDown forKey:nil];
        addTitleView.hidden=YES;

        
    }
            
}

-(IBAction)goAway:(id)sender
{
    [sender resignFirstResponder];
}

#pragma mark - GADDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    if(self == self.navigationController.topViewController)
        [self.interstitial presentFromRootViewController:self];
}

@end


