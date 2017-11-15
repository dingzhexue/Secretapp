//
//  tblViewLogins.h
//  SecretApp
//
//  Created by c27 on 17/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol tblViewLoginsDelegate
 
@end

@class AppDelegate;

@interface tblViewLogins : UITableViewController
{
    id<tblViewLoginsDelegate> _delegate;
    NSMutableArray *listOfItems;
    NSString *databasepath;
    sqlite3 *dbSecret;
    NSString *strIMgPath,*strTime,*strDate,*imgId;
    AppDelegate *app;

}

@property (nonatomic, retain)     NSString *strIMgPath,*strTime,*strDate,*imgId;  
@property (nonatomic, retain) NSMutableArray *listOfItems;
@property (nonatomic, assign) id<tblViewLoginsDelegate> delegate;

@end


