//
//  VideoView.h
//  SecretApp
//
//  Created by c62 on 20/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <sqlite3.h>
#import <MediaPlayer/MediaPlayer.h>
#import "GADHelper.h"

@interface VideoView : GADBannerViewController<AVAudioRecorderDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    UIImagePickerController *videoRecorder;
    NSString *videoStoragePath;
    NSString *theDate,*theTime;
    NSMutableArray *videoArr;
    NSString *databasepath;
    NSString *audiopath;
    NSString *DateStr,*timeStr;
    sqlite3 *dbSecret;
    UIToolbar *toolbar;
    
    UIView *titleView;
    UITextField *titletxt;
    NSString *tempPath;
    UITableView *videosTbl;
    
    NSString *videoID,*videoPath,*videoTitle,*videoDate;

    NSString *selvideoID,*selvideoPath,*selvideoTitle,*selvideoDate;
    
    MPMoviePlayerController *moviePlayer;
}
@property(nonatomic,retain) IBOutlet  MPMoviePlayerController *moviePlayer;
@property(nonatomic,retain) NSString *selvideoID,*selvideoPath,*selvideoTitle,*selvideoDate;
@property(nonatomic,retain) NSString *videoID,*videoPath,*videoTitle,*videoDate;
@property(nonatomic,retain) NSMutableArray *videoArr;
@property (nonatomic, retain) UIImagePickerController *videoRecorder;
@property(nonatomic,retain) IBOutlet UITableView *videosTbl;
@property(nonatomic,retain) IBOutlet UIToolbar *toolbar; 
@property(nonatomic,retain) NSString *tempPath;
@property(nonatomic,retain) IBOutlet UITextField *titletxt;
@property(nonatomic,retain)IBOutlet  UIView *titleView;
@property(nonatomic,retain)UIImagePickerController *recorder;

@end
