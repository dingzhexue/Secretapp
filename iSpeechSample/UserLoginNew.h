//
//  UserLoginNew.h
//  SecretApp
//
//  Created by c27 on 14/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserLoginNew : UIViewController
{
    UIButton *btnCheck;
    UITextField *txtCode;
}
@property (nonatomic,retain)IBOutlet     UIButton *btnCheck;
@property (nonatomic,retain)IBOutlet      UITextField *txtCode;
-(IBAction)btnCheckClicked:(id)sender;
@end
