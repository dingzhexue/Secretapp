//
//  SplashScreen.h
//  SecretApp
//
//  Created by c58 on 01/03/13.
//
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>


@interface SplashScreen : UIViewController
{
    sqlite3 *dbSecret;
}
@property (nonatomic,retain) IBOutlet UIImageView *img;
@end
