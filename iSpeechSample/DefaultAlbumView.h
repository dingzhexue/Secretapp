//
//  DefaultAlbumView.h
//  SecretApp
//
//  Created by c62 on 21/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CustomUIScrollView.h"
#import "GADHelper.h"

@interface DefaultAlbumView : GADBannerViewController<UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVAudioRecorderDelegate,UIPopoverControllerDelegate>
{
    UIScrollView *scrollVw;
    NSMutableArray *imgArray,*UIImagetypeArr,*playImagesArr;
    UIToolbar *toolbar;
    UIView *view;
    
    NSString *databasepath,*docImgPath,*theDate,*tempPath;
    sqlite3 *dbSecret;
    NSString *imgId,*imgPath,*videopath,*selVideoPath,*videopathAll;
    UIView *playImgsVw,*uiDemo;
    UIImageView *slideImage;
    
    UIImage *thumbImage;
    NSURL *videoURL;
    bool isImgFlag;
    UIButton *img1;
    bool insertVideoFlag;
    IBOutlet CustomUIScrollView *scrollView;
    MPMoviePlayerController *moviePlayer;
    
    UIImageView *backgroundImg;
    AppDelegate *app;
}

//--------------TapForTap View--------------//

@property (nonatomic,retain) IBOutlet UIImageView *backgroundImg;

@property(nonatomic,retain) IBOutlet MPMoviePlayerController *moviePlayer;
@property(nonatomic, retain) IBOutlet CustomUIScrollView *scrollView;
@property(nonatomic,readwrite) bool insertVideoFlag;
@property(nonatomic,retain) UIImage *thumbImage;
@property(nonatomic,retain) IBOutlet UIImageView *slideImage;
@property(nonatomic,retain) IBOutlet UIView *playImgsVw,*uiDemo;
@property(nonatomic,retain) NSString *imgId,*imgPath,*selVideoPath;
@property(nonatomic,retain) NSString *docImgPath,*videopath,*videopathAll;
@property(nonatomic,retain) IBOutlet UIToolbar *toolbar; 
@property(nonatomic,retain) NSMutableArray *imgArray,*UIImagetypeArr,*playImagesArr;
@property(nonatomic,retain) IBOutlet UIScrollView *scrollVw;



//Nevil
-(IBAction)BookmarkClicked:(id)sender;
-(IBAction)NotesClicked:(id)sender;
-(IBAction)AudioRecordClicked:(id)sender;
-(IBAction)ContactsClicked:(id)sender;
-(IBAction)VideoClicked:(id)sender;
-(IBAction)MusicClicked:(id)sender;
-(IBAction) closeImgView:(id)sender;

//Nevil
//@property(nonatomic,retain) IBOutlet CustomUIScrollView *scrollView;
@end

