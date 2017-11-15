//
//  ContactListView.h
//  SecretApp
//
//  Created by c62 on 17/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "GADHelper.h"

@interface ContactListView : GADBannerViewController<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIToolbar *toolbar;
    UITableView *contactTbl;
    NSMutableArray *contactsArr;
    sqlite3 *dbSecret;
    NSString *databasepath;
    NSString *contID,*contName,*contPic,*contNum,*uid,*conRating,*conNote,*conEmail;
    int conid;
    NSMutableArray *wantedname;
    NSMutableArray *wantednumber;
    
    UIImageView *backgroundImg;
    AppDelegate *app;
    UIView *popView;
}

@property(nonatomic,readwrite)  int conid;
@property(nonatomic,retain) NSString *contID,*contName,*contPic,*contNum,*uid,*conRating,*conNote,*conEmail;
@property(nonatomic,retain) IBOutlet UITableView *contactTbl;
@property(nonatomic,retain) IBOutlet UIToolbar *toolbar; 
@property(nonatomic,retain) NSMutableArray *contactsArr;

@property(nonatomic,retain) IBOutlet UIImageView *backgroundImg;

-(void)dispAllContacts;

@end
