//
//  AudioRecorder.h
//  ShortSaleScore
//
//  Created by Bhargavi on 1/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "GADHelper.h"

@class AudioRecorder;

@interface AudioRecorder : GADBannerViewController <AVAudioPlayerDelegate,MFMailComposeViewControllerDelegate>
{
    
    UILabel *lblTitle;
    NSMutableArray *allAudioArr; 
    NSString *databasepath;
    NSString *audiopath;
    sqlite3 *dbSecret;
    UIToolbar *toolbar;
    UITableView *audioTbl;
    NSString *audioID,*audioFilePath,*audioTitle,*audiotime,*audioDate;
    AVAudioPlayer *audioPlayer;
    NSTimer *updateTimer;
    bool flagPlay,flaghide;
    UILabel *TimeLbl,*DurationLbl;
    UIButton *playpauseBtn;
    UIView *transViewBG,*transView;
    UISlider *progressBar;
    NSString *selaudioId,*audioToEmail,*audioNmToEmail;
    UIButton *btnBack,*btnBackward,*btnFast,*btnForward;
    
    AppDelegate *app;
    UILabel *lbl;
    UIButton *btn;
    UIBarButtonItem *editdoneButton;
    NSInteger count;
}

@property (nonatomic, retain) IBOutlet	UISlider *progressBar;
@property(nonatomic,retain) IBOutlet UIView *transViewBG,*transView;
@property(nonatomic,retain) IBOutlet  UILabel *TimeLbl,*DurationLbl;
@property(nonatomic,retain) IBOutlet UIButton *playpauseBtn;
@property (nonatomic, retain) NSTimer *updateTimer;
@property(nonatomic,retain) NSString  *audioID,*audioFilePath,*audioTitle,*audiotime,*audioDate;
@property(nonatomic,retain) NSMutableArray *allAudioArr;
@property(nonatomic,retain) IBOutlet UITableView *audioTbl;
@property(nonatomic,retain) IBOutlet UIToolbar *toolbar;
@property(nonatomic,retain) NSString *audiopath;

@property(nonatomic,retain) IBOutlet   UIButton *btnBack,*btnBackward,*btnFast,*btnForward;

@property(nonatomic,retain) IBOutlet   UILabel *lblTitle;
@end
