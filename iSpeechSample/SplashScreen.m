//
//  SplashScreen.m
//  SecretApp
//
//  Created by c58 on 01/03/13.
//
//

#import "SplashScreen.h"
#import "DrawPatternLockViewController.h"
#import "UserLoginView.h"
#import "AppDelegate.h"


@interface SplashScreen ()

@end
AppDelegate *app;
@implementation SplashScreen
@synthesize img;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.img.frame=CGRectMake(0,20, self.view.frame.size.width, self.view.frame.size.height-20);
    }

    self.navigationController.navigationBarHidden=YES;
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (app.isFirstRun)
    {
        [self performSelector:@selector(splashOver) withObject:self afterDelay:3];
    }
    else
    {
        [self performSelector:@selector(splashOver) withObject:self afterDelay:0];
    }
    
}
-(void)splashOver
{
    NSString *strValue=[self Authentication];
    
    if([strValue isEqualToString:@"true"])
    {
        UIViewController *viewController1;
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            viewController1 = [[UserLoginView alloc] initWithNibName:@"UserLoginView_Ipad" bundle:nil];
        }
        else {
            viewController1 = [[UserLoginView alloc] initWithNibName:@"UserLoginView" bundle:nil];
        }
        [self.navigationController pushViewController:viewController1 animated:NO];
    }
    else
    {
        if (app.iSBuyCLick==YES)
        {
            
        }
        else
        {
            DrawPatternLockViewController *drw=[[DrawPatternLockViewController alloc]init];
            [self.navigationController pushViewController:drw animated:NO];
            drw = nil;
        }
    }
}
-(NSString *) Authentication
{
    NSString *strReturn=@"false";
    NSString *databasepath=[app getDBPathNew];
    if (sqlite3_open([databasepath UTF8String], &dbSecret) == SQLITE_OK)
    {
        NSString *selectSql = [NSString stringWithFormat:@"select VoiceAuth from AuthentictionCheckTbl where UserID = %@",app.LoginUserID];
        NSLog(@"Query : %@",selectSql);
        const char *sqlStatement = [selectSql UTF8String];
        sqlite3_stmt *query_stmt;
        if(sqlite3_prepare_v2(dbSecret, sqlStatement, -1, &query_stmt, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(query_stmt) == SQLITE_ROW)
            {
                NSString *checkValue = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(query_stmt, 0)];
                NSLog(@"User id=== %@",checkValue);
                if([ checkValue isEqualToString: @"true"])
                {
                    //sqlite3_close(dbSecret);
                    strReturn= @"true";
                }
                else
                {
                    //sqlite3_close(dbSecret);
                    strReturn= @"false";
                }
            }
            sqlite3_finalize(query_stmt);
        }
        else
        {
            
        }
    }
    sqlite3_close(dbSecret);
    return strReturn;
}

@end
