//
//  tblPinCodeLockTap.m
//  SecretApp
//
//  Created by c78 on 06/02/13.
//
//

#import "tblPinCodeLockTap.h"
#import "AppDelegate.h"
#import "viewVoiceAuthentication.h"
#import "ABPadLockScreenController.h"

@interface tblPinCodeLockTap ()

// ABP PinCode Screen For The User
@property (nonatomic, strong) ABPadLockScreenController *pinScreen;

// PinCode Entered By The User
@property (nonatomic,retain) NSString *code;

// flag is for checking the password confirmation
@property (nonatomic) int flag;

// flag is for asking the current password confirmation
@property (nonatomic) bool askForPassword,askToSetPassword;

@end

@implementation tblPinCodeLockTap

@synthesize delegate=_delegate;
@synthesize listOfItems;

@synthesize code;

AppDelegate *app;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    listOfItems = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"main-bg.png"]]];
    
    NSArray *itemsArray1 =[NSArray arrayWithObjects:@"Change PinCode ",@"Set as a Lock",nil];
    NSDictionary *itemsDict1 = [NSDictionary dictionaryWithObject:itemsArray1 forKey:@"0"];
    
    [listOfItems addObject:itemsDict1];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [listOfItems count];;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *objdict = [listOfItems objectAtIndex:section];
    NSString *str = [NSString stringWithFormat:@"%i",section];
    NSArray *objarray = [objdict objectForKey:str];
    return [objarray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SettingsCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSDictionary *objdict = [listOfItems objectAtIndex:indexPath.section];
        NSString *str = [NSString stringWithFormat:@"%i",indexPath.section];
        NSArray *objarray = [objdict objectForKey:str];
        //        if(indexPath.section == 0 && indexPath.row == 0)
        //        {
        //            cell.textLabel.textColor = [UIColor  blackColor];
        //            cell.textLabel.text = [objarray objectAtIndex:indexPath.row];
        //            UISwitch* aswitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        //            aswitch.on = YES; // or NO
        //            cell.accessoryView = aswitch;
        //            [aswitch release];
        //        } else      {
        cell.textLabel.textColor = [UIColor  blackColor];
        cell.textLabel.text = [objarray objectAtIndex:indexPath.row];
        
        //        }
        
    }

    return  cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
    if(section == 0)
    {
        return @"PinCode Authentication settings";
    }
    else
    {
        return @"";
    }
    
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate != nil) {

        if(indexPath.section == 0 && indexPath.row == 0)
        {
            
            NSString *strAuth= [self Authentication];
            if([strAuth isEqualToString:@"false"])
            {
                NSLog(@"First set as a lock");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PinCode Lock Settings" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
                alert.message=@"First set as a lock.";
                [alert show];
            }else
            {
                //Check Current Pass Then Ask For Changing The Pass If Current Pass Match
                NSLog(@"Changing Pin");
                self.askForPassword = NO;
                self.flag = 0;
                [self changePinCode:self.code];
                
            }

        } else if(indexPath.section == 0 && indexPath.row == 1)
        {
            
            NSString *strAuth= [self Authentication];
        
            NSLog(@"Check From Here To Set As A Lock...");
            
            if([strAuth isEqualToString:@"false"])
            {
                
                NSLog(@"PinCode Not Set");
                
                bool userwantstochangepincode = YES;
                
                if (userwantstochangepincode) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PinCode Authentication Settings" message:@"" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Continue",nil];
                    alert.message=@"Do you want to set PinCode Lock?";
                    [alert show];
                    [alert release];
                }
                
            }else
            {
                NSLog(@"Pin Code Set");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PinCode Authentication Settings" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
                alert.message=@"PinCode lock is alredy set as a lock!";
                [alert show];
                [alert release];
            }

        }
    }
}



#pragma mark - ABLockScreenDelegate Methods
//Check code
- (void)unlockWasSuccessful
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
//    UISwitch *swch=(UISwitch *)[self.view viewWithTag:120];
//    swch.on=YES;
    NSLog(@"Pin entry successfull");
}


- (void)unlockWasCancelled
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    UISwitch *swch=(UISwitch *)[self.view viewWithTag:120];
    swch.on=NO;
    self.flag = 0;
    self.pinScreen.title = @"Enter Password";
    self.pinScreen.subtitle = @"Please enter your Password";
    NSLog(@"Pin entry cancelled");
}

- (void)unlockWasUnsuccessful:(NSString *)falseEntryCode afterAttemptNumber:(NSInteger)attemptNumber
{
    
    NSLog(@"Flag Id :: %d",self.flag);
    
    if (self.askToSetPassword) {
        
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
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Change Password" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
                    alert.cancelButtonIndex = 1;
                    alert.message = @"Are you sure want to change PinCode?...";
                    [alert show];
                    [alert release];
                    NSLog(@"The Saved Password Will Be :: %@",falseEntryCode);
                    self.flag = 0;
                }
                
            }
        
        }
    }
}

#pragma mark - ALERT VIEW

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Yes"])
    {
        app.chngePWD = YES;
        
        Boolean isUpdated=[self updatePassword:self.code :app.LoginUserID];
        [self updateLockStyle:app.LoginUserID];
        [app.userDefaults setObject:@"PinCode" forKey:@"LockMethod"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"It is highly recommended that you back up this passcode to your email, If you forget this passcode you will not be able to access your account, would you like this passcode sent to your mail box?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Send" ,nil];
        [alert show];
        
        if(isUpdated)
        {
            NSLog(@"Password Changed Successfully...");
        }
        else
        {
            NSLog(@"Password Did Not Changed Successfully...");
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else if ([title isEqualToString:@"Continue"])
    {
        NSLog(@"Finally You Reached To Pin Code...");
        
        /*If Password Set Then Dont Change Just Change Lock Pattern Only*/
        
        NSString *currentPass;
        
        NSLog(@"User Id :: %@",app.LoginUserID);
        
        currentPass = [self currentPassword:app.LoginUserID];
        
        NSLog(@"Current Password :: %@",currentPass);
        
        if([currentPass isEqualToString:@""])
        {
            self.askForPassword = NO;
            self.askToSetPassword = NO;
            [self changePinCode:self.code];
            //[self updateLockStyle:app.LoginUserID];
        }
        else
        {
            self.askToSetPassword = YES;
            self.askForPassword = NO;
            [self changePinCode:self.code];
            [self updateLockStyle:app.LoginUserID];
            
        }
        
    }
    else if([title isEqualToString:@"Send"])
    {
        [self sendMail:@"SetPassCode"];
    }
}

-(NSString *) Authentication
{
    NSString *strReturn=@"false";
    NSString *databasepath=[app getDBPathNew];
    if (sqlite3_open([databasepath UTF8String], &dbSecret) == SQLITE_OK)
    {
        
        
        NSString *selectSql = [NSString stringWithFormat:@"select PinCodeAuth from AuthentictionCheckTbl where UserID = %@",app.LoginUserID];
        
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
        }else {
            sqlite3_finalize(query_stmt);
        }
    }
    sqlite3_close(dbSecret);
    return strReturn;
}

#pragma mark - CHANGE PIN-CODE

-(void)changePinCode:(NSString *)strAuth
{
    strAuth = [self Authentication];
    
    if([strAuth isEqualToString:@"false"])
    {
        /* PinCode Authentication Screen Will Start From Here*/
        
        if (!self.pinScreen)
        {
            self.flag = 0;
            self.pinScreen = [[ABPadLockScreenController alloc] initWithDelegate:self];
            self.pinScreen.pin = @"";
            self.pinScreen.attemptLimit = 0;
            self.pinScreen.title = @"Enter Password";
            self.pinScreen.subtitle = @"Please enter your Password";
        }
        app.lockcheck=NO;
        
        UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:self.pinScreen];
        navCon.modalPresentationStyle = UIModalPresentationFormSheet;
        [navCon.navigationBar setTintColor:[UIColor blackColor]];
        
        //[self.navigationController pushViewController:self.pinScreen animated:YES];
        [self presentViewController:navCon animated:YES completion:nil];
    }
    else
    {
        self.askForPassword = TRUE;
        [self getPasswordChangeScreen];
    }
    
}

-(void)getPasswordChangeScreen
{

    if (!self.pinScreen)
    {
        self.flag = 0;
        self.pinScreen = [[ABPadLockScreenController alloc] initWithDelegate:self];
        self.pinScreen.pin = @"";
        self.pinScreen.attemptLimit = 0;
        self.pinScreen.title = @"Enter Password";
        self.pinScreen.subtitle = @"Please enter your Password";
    }
    app.lockcheck=NO;
    
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:self.pinScreen];
    navCon.modalPresentationStyle = UIModalPresentationFormSheet;
    [navCon.navigationBar setTintColor:[UIColor blackColor]];
    
    //[self.navigationController pushViewController:self.pinScreen animated:YES];
    [self presentViewController:navCon animated:YES completion:nil];
}

#pragma mark - SQL Methods
-(NSString *)currentUserName:(NSString *)UserID
{
    
    NSString *pass = [[NSString alloc]init];
    
    if (sqlite3_open([[app getDBPathNew] UTF8String],&dbSecret)== SQLITE_OK)
    {
        NSString *selectSql = [NSString stringWithFormat:@"select UserName from VerifyUserTbl where UserID=%@",UserID];
        
        NSLog(@"Query : %@",selectSql);
        const char *sqlStatement = [selectSql UTF8String];
        sqlite3_stmt *query_stmt;
        @try {
            
            if(sqlite3_prepare_v2(dbSecret, sqlStatement, -1, &query_stmt, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(query_stmt) == SQLITE_ROW)
                {
                    
                    if(((const char *) sqlite3_column_text(query_stmt, 0) == NULL))
                    {
                        pass = @"";
                    }
                    else
                    {
                        pass = [NSString stringWithUTF8String:(char *)sqlite3_column_text(query_stmt, 0)];
                        NSLog(@"Password is === %@",pass);
                    }
                    
                } else {
                    pass = @"";
                    NSLog(@"Password is Null");
                }
                sqlite3_finalize(query_stmt);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception is %@",exception);
            sqlite3_finalize(query_stmt);
            sqlite3_close(dbSecret);
        }
        sqlite3_finalize(query_stmt);
    }else {
        pass = @"";
    }
    
    sqlite3_close(dbSecret);
    return  pass;
}
-(NSString *)currentPassword:(NSString *)UserID
{
    
    NSString *pass = [[NSString alloc]init];

    if (sqlite3_open([[app getDBPathNew] UTF8String],&dbSecret)== SQLITE_OK)
    {
        NSString *selectSql = [NSString stringWithFormat:@"select UserPinCodeText from VerifyUserTbl where UserID=%@",UserID];
        
        NSLog(@"Query : %@",selectSql);
        const char *sqlStatement = [selectSql UTF8String];
        sqlite3_stmt *query_stmt;
        @try {
            
            if(sqlite3_prepare_v2(dbSecret, sqlStatement, -1, &query_stmt, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(query_stmt) == SQLITE_ROW)
                {
                    
                    if(((const char *) sqlite3_column_text(query_stmt, 0) == NULL))
                    {
                        pass = @"";
                    }
                    else
                    {
                        pass = [NSString stringWithUTF8String:(char *)sqlite3_column_text(query_stmt, 0)];
                       NSLog(@"Password is === %@",pass); 
                    }
                    
                } else {
                    pass = @"";
                    NSLog(@"Password is Null");
                }
                sqlite3_finalize(query_stmt);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception is %@",exception);
            sqlite3_finalize(query_stmt);
            sqlite3_close(dbSecret);
        }
        sqlite3_finalize(query_stmt);
    }else {
        pass = @"";
    }
    
    sqlite3_close(dbSecret);
    return  pass;
    
//    
//
//    NSString *pass = @"";
//    
//    sqlite3_stmt *statement;
//    
//    if(sqlite3_open([[app getDBPath] UTF8String],&dbSecret)== SQLITE_OK)
//    {
//        
//        NSString *insertquery;
//        insertquery=[NSString stringWithFormat:@"select UserPinCodeText from VerifyUserTbl where UserID=%@",UserID];
//        NSLog(@"Query::::%@",insertquery);
//        const char *insert_query=[insertquery UTF8String];
//        sqlite3_prepare(dbSecret,insert_query,-1,&statement,NULL);
//        
//        while(sqlite3_step(statement) == SQLITE_ROW)
//        {
//            pass = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//        }
//        sqlite3_finalize(statement);
//    }
//    else
//    {
//        NSLog(@"failed 2 connect");
//        sqlite3_finalize(statement);
//        sqlite3_close(dbSecret);
//        pass = @"Fail To Connect";
//    }
//    
//    return pass;
}

-(Boolean) updatePassword :(NSString *)PinCode :(NSString * )UserID
{
    sqlite3_stmt *statement;
    
    if(sqlite3_open([[app getDBPathNew] UTF8String],&dbSecret)== SQLITE_OK)
    {
        NSString *insertquery;
        insertquery=[NSString stringWithFormat:@"UPDATE VerifyUserTbl SET UserPinCodeText =\"%@\" where UserID=%@",PinCode,UserID];
        NSLog(@"Query::::%@",insertquery);
        const char *insert_query=[insertquery UTF8String];
        sqlite3_prepare(dbSecret,insert_query,-1,&statement,NULL);
        if(sqlite3_step(statement) == SQLITE_DONE){
            NSLog(@"record updated");
            sqlite3_finalize(statement);
            sqlite3_close(dbSecret);
            return true;
        }
        else{
            NSLog(@"failed 2 connect");
            sqlite3_finalize(statement);
            sqlite3_close(dbSecret);
            return false;
        }
    }
    else
    {
        sqlite3_finalize(statement);
        sqlite3_close(dbSecret);
        return false;
    }
}

-(Boolean) updateLockStyle :(NSString * )UserID
{
    sqlite3_stmt *statement;
    
    if(sqlite3_open([[app getDBPathNew] UTF8String],&dbSecret)== SQLITE_OK)
    {
        
        NSString *insertquery;
        insertquery=[NSString stringWithFormat:@"UPDATE AuthentictionCheckTbl SET VoiceAuth =\"%@\" ,PatternAuth =\"%@\",PinCodeAuth =\"%@\"  where UserID=%@",@"false",@"false",@"true",UserID];
        NSLog(@"Query::::%@",insertquery);
        const char *insert_query=[insertquery UTF8String];
        sqlite3_prepare(dbSecret,insert_query,-1,&statement,NULL);
        if(sqlite3_step(statement) == SQLITE_DONE){
            NSLog(@"record updated");
            sqlite3_finalize(statement);
            sqlite3_close(dbSecret);
            
            app.userDefaults = [NSUserDefaults standardUserDefaults];
            // saving an NSString
            [app.userDefaults setObject:@"PinCode" forKey:@"LockMethod"];
            app.loginMethod = @"PinCode";
            [GlobalFunctions setStringValueToUserDefaults:@"PinCode" ForKey:@"LockMethod2"];
            
            return true;
        }
        else{
            NSLog(@"failed 2 connect");
            sqlite3_finalize(statement);
            sqlite3_close(dbSecret);
            return false;
        }
    }
    else
    {
        sqlite3_finalize(statement);
        sqlite3_close(dbSecret);
        return false;
    }
}
#pragma mark - Send Mail

- (IBAction)sendMail:(NSString *)str
{
#ifdef LITEVERSION
    if ([MFMailComposeViewController canSendMail])
    {
        NSString *someString;
        MFMailComposeViewController *mfViewController = [[MFMailComposeViewController alloc] init];
        mfViewController.mailComposeDelegate = self;
        [mfViewController setSubject:@"Secret Vault Passcode"];
        [mfViewController setMessageBody:@"Your Secret Vault Passcode" isHTML:YES];
        if([str isEqualToString:@"SetPassCode"])
        {
            someString = [NSString stringWithFormat:@"This is a your Secret Vault passcode. Don't share with anyone, It's confidencial...<br/><a href=\"https://itunes.apple.com/us/app/secret-app/id569771443?ls=1&mt=8\">Secret Vault on itunes</a><br/>Your Username is: %@.<br/>Your passcode is : %@.",[self currentUserName:app.LoginUserID],self.code];
        }
        else
        {
            
        }
        [mfViewController setMessageBody:someString isHTML:YES];
        
        //        NSString *path;
        //        path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"ScreenShot"];
        //        NSString *screenShotFilePath = [path stringByAppendingPathComponent:@"screenshot.jpg"];
        
        //        UIImage *image=[UIImage imageWithContentsOfFile:screenShotFilePath];
        //
        //        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        //        [mfViewController addAttachmentData:data  mimeType:@"image/jpeg" fileName:@"screenshot.jpg"];
        
        [self presentViewController:mfViewController animated:YES completion:nil];
	}
#else
    //GoProLink
    if ([MFMailComposeViewController canSendMail])
    {
        NSString *someString;
        MFMailComposeViewController *mfViewController = [[MFMailComposeViewController alloc] init];
        mfViewController.mailComposeDelegate = self;
        [mfViewController setSubject:@"Secret Vault Pro Passcode"];
        [mfViewController setMessageBody:@"Your Secret Vault Pro Passcode" isHTML:YES];
        if([str isEqualToString:@"SetPassCode"])
        {
            someString = [NSString stringWithFormat:@"This is a your Secret Vault Pro passcode. Don't share with anyone, It's confidencial...<br/><a href=\"https://itunes.apple.com/us/app/secret-vault-pro-plus/id873504069?ls=1&mt=8\">Secret Vault Pro on itunes</a><br/>Your Username is: %@.<br/>Your passcode is : %@.",[self currentUserName:app.LoginUserID],self.code];
        }
        else
        {
            
        }
        [mfViewController setMessageBody:someString isHTML:YES];
        
        //        NSString *path;
        //        path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"ScreenShot"];
        //        NSString *screenShotFilePath = [path stringByAppendingPathComponent:@"screenshot.jpg"];
        
        //        UIImage *image=[UIImage imageWithContentsOfFile:screenShotFilePath];
        //
        //        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        //        [mfViewController addAttachmentData:data  mimeType:@"image/jpeg" fileName:@"screenshot.jpg"];
        
        [self presentModalViewController:mfViewController animated:YES];
	}

#endif
    else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"Email is not configured." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
		[alert show];
	}
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            alert.message = @"Message Canceled";
            break;
        case MFMailComposeResultSaved:
            alert.message = @"Message Saved";
            break;
        case MFMailComposeResultSent:
            alert.message = @"Message Sent";
            break;
        case MFMailComposeResultFailed:
            alert.message = @"Message Failed";
            break;
        default:
            alert.message = @"Message Not Sent";
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [alert show];
}

@end
