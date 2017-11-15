//
//  tblKepPadTap.h
//  SecretApp
//
//  Created by c27 on 15/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol tblKeypadTapDelegate
//- (void)keyPadSelected:(NSString *)color;
@end
@class AppDelegate;

@interface tblKepPadTap : UITableViewController<UIAlertViewDelegate>
{
    sqlite3 *dbSecret;
    NSMutableArray *listOfItems;
    id<tblKeypadTapDelegate> _delegate;
    AppDelegate *app;

}

@property (nonatomic, retain) NSMutableArray *listOfItems;
@property (nonatomic, assign) id<tblKeypadTapDelegate> delegate;

@end
