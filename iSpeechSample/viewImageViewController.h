//
//  viewImageViewController.h
//  SecretApp
//
//  Created by c35 on 26/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <AddressBook/AddressBook.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
@interface viewImageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    
    NSMutableArray *wantedname;
    NSMutableArray *wantednumber;
    NSMutableArray *arrSelectedNumber; 
    UITableView *contactsTable;
    sqlite3 *dbSecret;
    NSString *databasepath;

//    UILabel *lblTime,*lblDate,*lblTitle;
//    UIImageView *imgPhoto;
    UITableView *tblContact;
    AppDelegate *app;

}
-(IBAction)btnSendClick:(id)sender;
//@property (nonatomic,retain)IBOutlet     UILabel *lblTime,*lblDate,*lblTitle;
//@property (nonatomic,retain)IBOutlet       UIImageView *imgPhoto;
@property (nonatomic,retain)IBOutlet    UITableView *contactsTable;
@end
