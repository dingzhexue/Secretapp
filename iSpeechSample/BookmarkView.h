//
//  BookmarkView.h
//  SecretApp
//
//  Created by c62 on 23/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADHelper.h"

@interface BookmarkView : GADBannerViewController
{
    UIWebView *webVw;
    UIToolbar *toolbar;
    NSMutableArray *bookmarkArr;
    UITableView *bookmarkTbl;
    sqlite3 *dbSecret;
    NSString *databasepath;
    UIBarButtonItem *editdoneButton;
    BOOL editBookmarkflag;
    NSString *bookmarkID,*bookmarkTitle,*bookmarkURL,*selBookID;
    AppDelegate *app;

}
@property(nonatomic,retain) NSString *bookmarkID,*bookmarkTitle,*bookmarkURL; 
@property(nonatomic,retain) IBOutlet NSMutableArray *bookmarkArr; 
@property(nonatomic,retain) IBOutlet UITableView *bookmarkTbl;
@property(nonatomic,retain) IBOutlet UIWebView *webVw;
@property(nonatomic,retain) IBOutlet UIToolbar *toolbar;

@end
