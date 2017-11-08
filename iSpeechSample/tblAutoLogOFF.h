//
//  tblAutoLogOFF.h
//  SecretApp
//
//  Created by c27 on 15/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol tblAutoLogOFFDelegate
//- (void)tblAutoLogOFFPro:(NSString *)color;
@end

@interface tblAutoLogOFF : UITableViewController
{
NSMutableArray *listOfItems;
id<tblAutoLogOFFDelegate> _delegate;
}

@property (nonatomic, retain) NSMutableArray *listOfItems;
@property (nonatomic, assign) id<tblAutoLogOFFDelegate> delegate;


@end



