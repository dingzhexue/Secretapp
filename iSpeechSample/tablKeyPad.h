//
//  tablKeyPad.h
//  SecretApp
//
//  Created by c27 on 15/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tblKepPadTap.h"
#import "tblDockLockTap.h"
#import "tblPinCodeLockTap.h"

#import <sqlite3.h>
@protocol keyPadSelectedDelegte
//- (void)keyPadSelected:(NSString *)color;
@end
@interface tablKeyPad : UITableViewController<tblKeypadTapDelegate,tblDockLockTapDelegate,tblPinCodeLockTapDelegate>
{
    NSMutableArray *listOfItems;
    id<keyPadSelectedDelegte> _delegate;
    sqlite3 *dbTest;
    sqlite3 *dbSecret;
}

@property (nonatomic, retain) NSMutableArray *listOfItems;
@property (nonatomic, assign) id<keyPadSelectedDelegte> delegate;

@end