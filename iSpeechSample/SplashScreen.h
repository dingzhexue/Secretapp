//
//  SplashScreen.h
//  SecretApp
//
//  Created by c58 on 01/03/13.
//
//

#import <UIKit/UIKit.h>
#import "UserLoginView.h"


@interface SplashScreen : UIViewController
{
    sqlite3 *dbSecret;
    AppDelegate *app;
}
@property (nonatomic,retain) IBOutlet UIImageView *img;
@end
