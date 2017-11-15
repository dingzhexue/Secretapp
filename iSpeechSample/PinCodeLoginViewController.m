//
//  PinCodeLoginViewController.m
//  SecretApp
//
//  Created by c78 on 08/02/13.
//
//

#import "PinCodeLoginViewController.h"
#import "ABPadLockScreenView_iPhone.h"


@interface PinCodeLoginViewController ()

// ABP PinCode Screen For The User
@property (nonatomic, strong) ABPadLockScreenController *pinScreen;

// PinCode Entered By The User
@property (nonatomic,retain) NSString *code;

// flag is for checking the password confirmation
@property (nonatomic) int flag;

// flag is for asking the current password confirmation
@property (nonatomic) bool askForPassword,askToSetPassword;

@property (nonatomic,retain) UITextField *txtName;

@end


@implementation PinCodeLoginViewController

@synthesize txtName;


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    
    NSLog(@"PinCode View Loaded");
  
    if (!self.pinScreen)
    {
        self.flag = 0;
        self.pinScreen = [[ABPadLockScreenController alloc] initWithDelegate:self];
        self.pinScreen.pin = @"";
        self.pinScreen.attemptLimit = 0;
        self.pinScreen.title = @"Enter Password";
        self.pinScreen.subtitle = @"Please enter your Password";
        
        txtName = [[UITextField alloc]initWithFrame:CGRectMake(20, 15, 280, 35)];
        txtName.borderStyle = UITextBorderStyleRoundedRect;
        txtName.textAlignment = NSTextAlignmentCenter;
        txtName.backgroundColor = [UIColor whiteColor];
        txtName.placeholder = @" Enter User Name";
        [txtName addTarget:self
                        action:@selector(methodToFire)
              forControlEvents:UIControlEventEditingDidEndOnExit];
        txtName.tag = 10;

        [self.pinScreen.view addSubview:txtName];
        
    }
    app.lockcheck=NO;
    self.navigationController.navigationBarHidden=YES;
    /*
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:self.pinScreen];
    navCon.modalPresentationStyle = UIModalPresentationFormSheet;
    [navCon.navigationBar setTintColor:[UIColor blackColor]];
    navCon.navigationBar.hidden = TRUE;
    */

    [self.navigationController pushViewController:self.pinScreen animated:NO];
    //[self presentViewController:navCon animated:YES completion:nil];

}
-(void)methodToFire{
    
    [txtName resignFirstResponder];
    [self.pinScreen becomeFirstResponder];
//    
//    
//    ABPadLockScreenView_iPhone *pad = [[ABPadLockScreenView_iPhone alloc]init];
//    [pad layoutSubviews];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ABLockScreenDelegate Methods
//Check code
- (void)unlockWasSuccessful
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Pin entry successfull");
}


- (void)unlockWasCancelled
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    UISwitch *swch=(UISwitch *)[self.view viewWithTag:120];
    swch.on=NO;
    self.pinScreen.title = @"Enter Password";
    self.pinScreen.subtitle = @"Please enter your Password";
    NSLog(@"Pin entry cancelled");
}

- (void)unlockWasUnsuccessful:(NSString *)falseEntryCode afterAttemptNumber:(NSInteger)attemptNumber
{
    NSLog(@"Entered Pin Code :: %@",falseEntryCode);
    
    /*if (self.askToSetPassword) {
        
        NSString *currentPass = [self currentPassword:app.LoginUserID];
        
        if ([currentPass isEqual:falseEntryCode]) {
            self.askToSetPassword = FALSE;
            [self changePinCode:self.code];
            [self updateLockStyle:app.LoginUserID];
            
            [self dismissViewControllerAnimated:YES completion:^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PinCode Authentication Settings" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
                alert.message=@"PinCode lock is set as a lock!";
                [alert show];
                [alert release];
            }];
            
        }
        else
        {
            
            self.askToSetPassword = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PinCode Authentication Settings" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok",nil];
            alert.message=@"You enered the wrong password. Please enter the correct password...";
            [alert show];
            [alert release];
            
        }
        
    }
    else
    {
        if (self.askForPassword) {
            NSLog(@"Password In Unlock :: %@",falseEntryCode);
            
            //CHECK CURRENT PASSWORD
            NSString *currentPass = [self currentPassword:app.LoginUserID];
            
            NSLog(@"Current Pass :: %@",currentPass);
            
            if ([currentPass isEqualToString:falseEntryCode]) {
                self.askForPassword = NO;
                self.flag = 0;
                
                [self dismissViewControllerAnimated:YES
                                         completion:^{
                                             [self changePinCode:self.code];
                                             self.askForPassword = NO;
                                         }];
                
            }
            else
            {
                self.askForPassword = YES;
                
                self.flag = 0;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Try Again!!!" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
                alert.message=@"The Entered PinCode Does Not Match! Please Try Again...";
                [alert show];
                [alert release];
            }
            
        }
        else
        {
            NSLog(@"In Else");
            if (self.flag < 1) {
                self.code = falseEntryCode;
                NSLog(@"The Entered Code Is :: %@",self.code);
                self.flag++;
                NSLog(@"Flag = %d",self.flag);
                self.pinScreen.subtitle = @"Please re-enter your Password";
                self.pinScreen.title = @"Re-Enter Password";
                UISwitch *swch=(UISwitch *)[self.view viewWithTag:120];
                swch.on=NO;
            }else if (self.flag >= 1) {
                
                NSLog(@"Comparision Of Code :: Old Code :: %@ New Code :: %@",self.code,falseEntryCode);
                
                if (![self.code isEqual:falseEntryCode]) {
                    self.flag = 0;
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Try Again!!!" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
                    alert.message=@"The Entered PinCode Does Not Match! Please Try Again...";
                    [alert show];
                    [alert release];
                    self.pinScreen.title = @"Enter Password";
                    self.pinScreen.subtitle = @"Please enter your Password";
                }
                else
                {
                    self.pinScreen.subtitle = @"Please enter your Password";
                    self.pinScreen.title = @"Enter Password";
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Change Password" message:@"" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"Cancel", nil];
                    alert.cancelButtonIndex = 1;
                    alert.message = @"Are you sure want to change PinCode?...";
                    [alert show];
                    [alert release];
                    NSLog(@"The Saved Password Will Be :: %@",falseEntryCode);
                    self.flag = 0;
                }
                
            }
            
        }
    }*/
}

/* Get UserId From User Name */

-(NSString *) searchUser
{
    if([txtName.text isEqualToString:@""])
    {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Message" message:@"Please Enter Your Name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    else
    {
        NSString *loggedinNm=txtName.text;
        NSString *loggedinPass = self.code;
        databasepath=[app getDBPathNew];
        if (sqlite3_open(databasepath.UTF8String, &dbSecret) == SQLITE_OK)
        {
            NSLog(@"unm==%@ ",loggedinNm);
            NSLog(@"pass=== %@",loggedinPass);
            
            NSString *selectSql = [NSString stringWithFormat:@"select * from VerifyUserTbl Where UserName=\"%@\" AND UserPinCodeText=\"%@\" ",loggedinNm,loggedinPass];
            
            NSLog(@"Query : %@",selectSql);
            const char *sqlStatement = selectSql.UTF8String;
            sqlite3_stmt *query_stmt;
            
            if(sqlite3_prepare_v2(dbSecret, sqlStatement, -1, &query_stmt, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(query_stmt) == SQLITE_ROW)
                {
                    NSString *loggedinUserID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(query_stmt, 0)];
                    
                    NSLog(@"User id=== %@",loggedinUserID);
                    
                    app.LoginUserID=loggedinUserID;
                    
            
                        RootViewController *root;
                        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
                        {
                            root = [[RootViewController alloc] initWithNibName:@"RootViewcontroller_Ipad" bundle:nil];
                        }
                        else {
                            root = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
                        }
                        
                        [self.navigationController pushViewController:root animated:YES];

                }
                else
                {
                    NSLog(@"This User is Not registered yet..!!");
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please enter the correct UserId." message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok",nil];
                    //alert.message=loggedinPass;
                    [alert show];
                }
                sqlite3_finalize(query_stmt);
            }else {
                //      [self searchUser];
            }
        }
        
    }
    sqlite3_close(dbSecret);
    return @"false";
}


/* Check The Password With The Current Password */


#pragma mark - TEXT FIELD DELEGATE METHODS

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    if([textField.text isEqualToString:@"\n"])
//    {
//        [textField resignFirstResponder];
//
//    }
//    
//    return YES;
//}
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    
//   
//    return YES;
//}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if ([textField tag]==10) {
//        if([string isEqualToString:@"\n"])
//        {
//            [txtName resignFirstResponder];
//       
//        }
//    }
//    return YES;
//}


@end
