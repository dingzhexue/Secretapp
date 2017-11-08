//
//  tblKepPadTap.h
//  SecretApp
//
//  Created by c27 on 15/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
@protocol tblKeypadTapDelegate
//- (void)keyPadSelected:(NSString *)color;
@end
@interface tblKepPadTap : UITableViewController<UIAlertViewDelegate>
{
    sqlite3 *dbSecret;
    NSMutableArray *listOfItems;
    id<tblKeypadTapDelegate> _delegate;
}

@property (nonatomic, retain) NSMutableArray *listOfItems;
@property (nonatomic, assign) id<tblKeypadTapDelegate> delegate;

@end
