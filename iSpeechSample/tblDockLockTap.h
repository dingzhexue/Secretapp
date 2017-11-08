//
//  tblDockLockTap.h
//  SecretApp
//
//  Created by c27 on 15/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "ABPadLockScreenController.h"


@protocol tblDockLockTapDelegate
//- (void)keyPadSelected:(NSString *)color;
@end

@interface tblDockLockTap : UITableViewController <UIAlertViewDelegate, ABLockScreenDelegate>
{
    sqlite3 *dbSecret;
    NSMutableArray *listOfItems;
    id<tblDockLockTapDelegate> _delegate;
}

@property (nonatomic, retain) NSMutableArray *listOfItems;
@property (nonatomic, assign) id<tblDockLockTapDelegate> delegate;


@end
