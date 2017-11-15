//
//  tblViewAttempts.h
//  SecretApp
//
//  Created by c27 on 15/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol tblViewAttemptsDelegate
//- (void)keyPadSelected:(NSString *)color;
@end


@class AppDelegate;

@interface tblViewAttempts : UITableViewController
{
    NSMutableArray *listOfItems;
    NSString *databasepath;
    sqlite3 *dbSecret;
    id<tblViewAttemptsDelegate> _delegate;
    
    AppDelegate *app;


}

@property (nonatomic, retain) NSMutableArray *listOfItems;
@property (nonatomic, assign) id<tblViewAttemptsDelegate> delegate;


@end



