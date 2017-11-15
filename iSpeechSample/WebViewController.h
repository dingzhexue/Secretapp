//
//  WebViewController.h
//  SecretApp
//
//  Created by c62 on 31/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController<UIWebViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UIWebView *webVw;
    UIToolbar *toolbar;
    UIActivityIndicatorView *actVw;
    UITextField *webUrlTxt,*bookmarkTitleTxt;
    UIView *giveTitleToBookmarkView,*downlodDetailVw,*transViewBG;
    sqlite3 *dbSecret;
    
   
    
    
    NSString *databasepath;
    NSString *imgPath;
    NSString *imgfilename;
    NSMutableData *myWebData;
    NSMutableArray *pagesArr;
    UIButton *backURLButton,*nexturlButton;
    bool insertArrFlag;
    NSURL *downlodURL;
    NSFileHandle *handle;
    int receivedLength; 
    int cnt,progTag,totalsizeTag;
    UIProgressView *progressView;
    UITableView *downlodingFileTbl;
    UILabel *sizelbl;
    float progress,floatFileSize;
    
    //For array
    NSString *fileURL;
    NSMutableArray *array1,*array2;
    
    //AFHTTPRequestOperation *operation;
    
    int pageIndex,files;
    UILabel *titleLbl;
    UIImageView *imgVw;
    
    AppDelegate *app;
    
}
@property(nonatomic,retain) NSString *bookmarkTitle, *bookmarkURL;
@property(nonatomic,readwrite) int progTag,totalsizeTag;
@property(nonatomic,retain) NSString *fileURL;
@property(nonatomic,readwrite) float progress;
@property(nonatomic,retain) IBOutlet UITableView *downlodingFileTbl;
@property(nonatomic,retain) NSMutableArray *pagesArr;
@property(nonatomic,retain) NSMutableData *myWebData;
@property(nonatomic,retain) NSString *imgfilename,*imgPath;
@property(nonatomic,retain) IBOutlet UIView *giveTitleToBookmarkView,*downlodDetailVw,*transViewBG;
@property(nonatomic,retain) IBOutlet UITextField *webUrlTxt,*bookmarkTitleTxt;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *actVw;
@property(nonatomic,retain) IBOutlet UIWebView *webVw;
@property(nonatomic,retain) IBOutlet UIToolbar *toolbar;
@property(nonatomic,retain) UIProgressView *progressView;


@end
