//
//  AddAudioView.h
//  SecretApp
//
//  Created by c62 on 13/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <sqlite3.h>
#import "GADHelper.h"

@class AddAudioView;

@protocol RecorderDelegate
@required
- (void) viewpic1:(AddAudioView *)viewpic didSelectValue:(NSString*)value didSelectEvent:(NSString*)event;
@end

@interface AddAudioView : GADBannerViewController
{
    IBOutlet UIButton *btnRecord;
    IBOutlet UIButton *btnPlay;
    IBOutlet UIButton *btnStop;
    IBOutlet UIButton *btnDelete;
    
    bool flagPause;
    AVAudioPlayer *audioPlayer;
    AVAudioRecorder *audioRecorder;
    int recordEncoding;
    enum
    {
        ENC_AAC1 = 1,
        ENC_ALAC1 = 2,
        ENC_IMA41 = 3,
        ENC_ILBC1 = 4,
        ENC_ULAW1 = 5,
        ENC_PCM1 = 6,
    } 
    encodingTypes;
    NSString *theDate,*theTime;
    
    NSString *databasepath;
    NSString *audiopath;
    NSString *DateStr,*timeStr;
    sqlite3 *dbSecret;
    id<RecorderDelegate> recdelegate;

    UIView *transViewBG,*transView; 
    UIView *addTitleView;
    UITextField *titletxt;
    UILabel *timeLbl;
    NSTimer	*updateTimer;
}

@property(nonatomic,retain) NSString *timeStr,*DateStr;
@property (nonatomic, retain) NSTimer	*updateTimer;
@property(nonatomic,retain) IBOutlet UILabel *timeLbl;
@property(nonatomic,retain) IBOutlet UITextField *titletxt;
@property(nonatomic,retain)id<RecorderDelegate> recdelegate;
@property(nonatomic,retain) IBOutlet UIView *addTitleView;
@property(nonatomic,retain) IBOutlet UIButton *btnRecord;
@property(nonatomic,retain) IBOutlet UIButton *btnDelete;
@property(nonatomic,retain) IBOutlet UIButton *btnPlay;
@property(nonatomic,retain) IBOutlet UIButton *btnStop;
@property(nonatomic,retain) IBOutlet UIView *transViewBG,*transView;
@property(nonatomic,retain) NSString *audioTitle;
@property(nonatomic,retain) NSString *audiopath;

-(IBAction)goAway:(id)sender;
-(IBAction)btnRefreshaudioClicked:(id)sender;
-(IBAction)saveAudioClicked:(id)sender;

@end
