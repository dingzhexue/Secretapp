//
//  WelcomeScreen.m
//  SecretApp
//
//  Created by c44 on 19/03/14.
//
//

#import "WelcomeScreen.h"
#import "DrawPatternLockViewController.h"
#import "UserLoginView.h"
#import "AppDelegate.h"

@interface WelcomeScreen ()

@end
AppDelegate *app;
@implementation WelcomeScreen
@synthesize btnNext;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        btnNext.tintColor=[UIColor whiteColor];
        btnNext.layer.borderWidth=1.0f;
        btnNext.layer.borderColor=[[UIColor whiteColor] CGColor];
    }
    else
    {
        [btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnNext setBackgroundColor:[UIColor clearColor]];
        btnNext.layer.borderWidth=1.0f;
        btnNext.layer.borderColor=[[UIColor whiteColor] CGColor];
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.navigationController.navigationBarHidden=YES;
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//    if (app.isFirstRun)
//    {
//        [self performSelector:@selector(splashOver) withObject:self afterDelay:3];
//    }
//    else
//    {
//        [self performSelector:@selector(splashOver) withObject:self afterDelay:0];
//    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)splashOver
{
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

-(IBAction)btnNextClicked:(id)sender
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
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
