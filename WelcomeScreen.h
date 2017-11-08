//
//  WelcomeScreen.h
//  SecretApp
//
//  Created by c44 on 19/03/14.
//
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface WelcomeScreen : UIViewController
{
    sqlite3 *dbSecret;
}
@property(nonatomic,retain) IBOutlet UIButton *btnNext;
-(IBAction)btnNextClicked:(id)sender;
@end
