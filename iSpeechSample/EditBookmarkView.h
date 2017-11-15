//
//  EditBookmarkView.h
//  SecretApp
//
//  Created by c62 on 31/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditBookmarkView : UIViewController
{
    UITextField *bmTitleTxt,*bmURLTxt;
    NSString *selBmID;
    sqlite3 *dbSecret;
    NSString *databasepath;
    
    AppDelegate *app;

}

@property(nonatomic,retain) IBOutlet UITextField *bmTitleTxt,*bmURLTxt;

@end
