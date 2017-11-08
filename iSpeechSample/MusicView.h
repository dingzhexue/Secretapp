//
//  MusicView.h
//  SecretApp
//
//  Created by c62 on 22/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import <AVFoundation/AVFoundation.h>
#import "GADHelper.h"

@interface MusicView : GADBannerViewController<AVAudioPlayerDelegate>
{
    UIToolbar *toolbar;
    UITableView *musicTbl;
    NSMutableArray *musicArr;
    NSString *musicID,*musicPath,*musicTitle;
    sqlite3 *dbSecret;
    NSString *databasepath;
    NSString *selSongID,*selSongPath;
    AVAudioPlayer *audioPlayer;
    UIButton *playpauseBtn;
    UILabel *totaltimeLbl,*playTimeLbl;
    UILabel *lblTitle;
    UISlider *progressBar;
    UIView *playView,*playViewBG;
    bool flagPlay;
    NSTimer	*updateTimer;
    UIBarButtonItem *editdoneButton;
    UIButton *btnBack,*btnBackward,*btnFast,*btnForward;
}

@property(nonatomic,retain) NSString *selSongID,*selSongPath;
@property (nonatomic, retain) NSTimer *updateTimer;
@property(nonatomic,retain) IBOutlet  UIView *playView,*playViewBG;
@property(nonatomic,retain) IBOutlet UISlider *progressBar;
@property(nonatomic,retain)  IBOutlet UIButton *playpauseBtn;
@property(nonatomic,retain) IBOutlet UILabel *totaltimeLbl,*playTimeLbl;
@property(nonatomic,retain) AVAudioPlayer *audioPlayer;
@property(nonatomic,retain) IBOutlet UITableView *musicTbl;
@property(nonatomic,retain) NSMutableArray *musicArr;
@property(nonatomic,retain) NSString *musicID,*musicPath,*musicTitle;
@property(nonatomic,retain) IBOutlet UIToolbar *toolbar;

@property(nonatomic,retain) IBOutlet   UIButton *btnBack,*btnBackward,*btnFast,*btnForward;
 @property(nonatomic,retain) IBOutlet UILabel *lblTitle;

@end
