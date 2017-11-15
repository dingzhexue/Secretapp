//
//  ImportContactView.h
//  SecretApp
//
//  Created by c62 on 18/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "GADHelper.h"

@interface ImportContactView : GADBannerViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *wantedname;
    NSMutableArray *wantednumber;
    UITableView *contactsTable;
    sqlite3 *dbSecret;
    NSString *databasepath;
    AppDelegate *app;

}
@property(nonatomic,retain) IBOutlet UITableView *contactsTable;

@end
