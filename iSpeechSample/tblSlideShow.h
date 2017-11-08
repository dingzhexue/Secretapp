//
//  tblSlideShow.h
//  SecretApp
//
//  Created by c27 on 15/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>


@protocol tblSlideShowDelegate
//- (void)colorSelected:(NSString *)color;
@end

@interface tblSlideShow : UITableViewController
{
    sqlite3 *dbSecret;
    NSMutableArray *listOfItems;
    id<tblSlideShowDelegate> _delegate;
}

@property (nonatomic, retain) NSMutableArray *listOfItems;
@property (nonatomic, assign) id<tblSlideShowDelegate> delegate;

@end



 