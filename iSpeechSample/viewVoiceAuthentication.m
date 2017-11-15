//
//  viewVoiceAuthentication.m
//  SecretApp
//
//  Created by c27 on 21/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "viewVoiceAuthentication.h"

@interface viewVoiceAuthentication ()

@end

@implementation viewVoiceAuthentication
@synthesize lblTextChange,isNewPassword,isReEnterPassword,strMail;
@synthesize btnSpeak;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [strConfirmPass release];
    [strNewPass release];
    [btnSpeak release];
 //   [loggedinPass release];
    [super dealloc];
}
-(void)viewWillAppear:(BOOL)animated
{
    if(![strMail isEqualToString:@"Mail"])
    {
      self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);

    if(app.chngePWD)

    {
        isNewPassword = YES;
        self.navigationController.title=@"Enter New Password";
        lblTextChange.text=@"Enter New Password";   
     }
    ISSpeechRecognition *recognition = [[ISSpeechRecognition alloc] init];
    NSError *err;
    [recognition setDelegate:self];
    if(![recognition listen:&err])
    {
        NSLog(@"ERROR: %@", err);
    }
   }
}
    
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    app=(AppDelegate *)[UIApplication sharedApplication].delegate;

    strMail=@"";
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    self.navigationController.title=@"Enter Current Password";    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setBtnSpeak:nil];
    [self setLblTextChange:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)btnSpeakClicked:(id)sender 
{
    ISSpeechRecognition *recognition = [[ISSpeechRecognition alloc] init];

    NSError *err;

    [recognition setDelegate:self];

    if(![recognition listen:&err])
    {
        NSLog(@"ERROR: %@", err);
    }

}


- (void)recognition:(ISSpeechRecognition *)speechRecognition didGetRecognitionResult:(ISSpeechRecognitionResult *)result {
    //NSLog(@"Method: %@", NSStringFromSelector(_cmd));
    NSLog(@"Result: %@", result.text);

    //[lblPassword setText:result.text];

    loggedinPass = [[NSString alloc]initWithFormat:@"%@",result.text];

    [speechRecognition release];


    //[self searchUser];
    if(isReEnterPassword)
    {
        if([loggedinPass isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Alert Message" message:@"Your Password is null. Do you want to set it again??" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Try Again" ,nil];

            [alert show];
            [alert release];
        }
        else
        {
            strConfirmPass=loggedinPass;
            if([strConfirmPass isEqualToString:strNewPass ] )
            {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Alert Message" message:@"Your Password is matched. Do you want to set New Pasword??" delegate:self cancelButtonTitle:@"Clsoe" otherButtonTitles:@"Confirm" ,nil];
                [alert show];
                [alert release];
            }else {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Alert Message" message:@"Your Password is not matched. Do you want to try it again??" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Try Again" ,nil];
                [alert show];
                [alert release];

            }

        }

    }else if(isNewPassword)
    {

        if([loggedinPass isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Alert Message" message:@"Your Password is null. Do you want to set it again??" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Try Again" ,nil];
            [alert show];
            [alert release];
        }
        else
       {

         strNewPass =loggedinPass;
        UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Alert Message" message:@"" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Try Again",@"Re Enter",nil];
             alert.message=[NSString stringWithFormat: @"You Enter this Password. \" %@\" ",loggedinPass];
           [alert show];
            [alert release];
            //  [self searchUser];
        }

    }else
    {
        if([loggedinPass isEqualToString:@""])
            {
                UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Alert Message" message:@"Your Password is null. Do you want to set it again??" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Try Again" ,nil];
                [alert show];
                [alert release];
        }
        else
        {
            if([self checkPattern:loggedinPass])
            {
                UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Alert Message" message:@"" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes" ,nil];
                alert.message= alert.message=[NSString stringWithFormat: @"Your Password is matched. Do you want to set New Pasword?? \" %@\" ",loggedinPass];
                [alert show];
            [alert release];
            }else {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Alert Message" message:@"Your this password did not match." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Try Again" ,nil];
                alert.message= alert.message=[NSString stringWithFormat: @"Your this password did not match! \" %@\"",loggedinPass];
                [alert show];
            }
       }
    }
}

- (void)recognition:(ISSpeechRecognition *)speechRecognition didFailWithError:(NSError *)error {
    //    NSLog(@"Method: %@", NSStringFromSelector(_cmd));
    NSLog(@"Error: %@", error);

    [speechRecognition release];
}

- (void)recognitionCancelledByUser:(ISSpeechRecognition *)speechRecognition {
    //NSLog(@"Method: %@", NSStringFromSelector(_cmd));

    [speechRecognition release];
}

- (void)recognitionDidBeginRecording:(ISSpeechRecognition *)speechRecognition {
    //NSLog(@"Method: %@", NSStringFromSelector(_cmd));

}

- (void)recognitionDidFinishRecording:(ISSpeechRecognition *)speechRecognition {
    //NSLog(@"Method: %@", NSStringFromSelector(_cmd));
}



-(IBAction)goAway:(id)sender{
    
    [sender resignFirstResponder];
}

-(Boolean) checkPattern : (NSString *)strPattern
{
    Boolean returnValue;
    databasepath=[app getDBPathNew];
    if (sqlite3_open(databasepath.UTF8String, &dbSecret) == SQLITE_OK) 
    {
     //   NSLog(@"unm==%@ ",loggedinNm);
        NSLog(@"pass=== %@",loggedinPass);
        NSString *selectSql = [NSString stringWithFormat:@"select UserPasswordTxt from VerifyUserTbl Where UserID = %@ ",app.LoginUserID];
        
        NSLog(@"Query : %@",selectSql);
        const char *sqlStatement = selectSql.UTF8String;
        sqlite3_stmt *query_stmt;
        @try {
            
            if(sqlite3_prepare_v2(dbSecret, sqlStatement, -1, &query_stmt, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(query_stmt) == SQLITE_ROW) 
                {
                    NSString *strPatternCode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(query_stmt, 0)];
                    
                    NSLog(@"Pattertn code is === %@",strPatternCode);
                    
                    if([strPattern isEqualToString:strPatternCode])
                    {
                        returnValue = true;
                    }else {
                        returnValue = false;
                    }
                } else {
                    returnValue =false;
                }    
                sqlite3_finalize(query_stmt);
            }else 
            {
                returnValue = false;
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception is %@",exception);
            sqlite3_finalize(query_stmt);  
            sqlite3_close(dbSecret);
        }
        sqlite3_finalize(query_stmt);     
    }else {
        returnValue =false;  
    }
    
    sqlite3_close(dbSecret);  
    return  returnValue ;
    
}

-(Boolean) checkPassword : (NSString *)strPassword
{
    Boolean returnValue;
    databasepath=[app getDBPathNew];
    if (sqlite3_open(databasepath.UTF8String, &dbSecret) == SQLITE_OK) 
    {
     //   NSLog(@"unm==%@ ",loggedinNm);
        NSLog(@"pass=== %@",loggedinPass);
        NSString *selectSql = [NSString stringWithFormat:@"select PatternCode from VerifyUserTbl Where UserID = %@ ",app.LoginUserID];
        
        NSLog(@"Query : %@",selectSql);
        const char *sqlStatement = selectSql.UTF8String;
        sqlite3_stmt *query_stmt;
        @try {
            
            if(sqlite3_prepare_v2(dbSecret, sqlStatement, -1, &query_stmt, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(query_stmt) == SQLITE_ROW) 
                {
                    NSString *strOldPassword = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(query_stmt, 0)];
                    
                    NSLog(@"Pattertn code is === %@",strOldPassword);
                    
                    if([strPassword isEqualToString:strOldPassword])
                    {
                        returnValue = true;
                    }else {
                        returnValue = false;
                    }
                } else {
                    returnValue =false;
                }    
                sqlite3_finalize(query_stmt);
            }else 
            {
                returnValue = false;
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception is %@",exception);
            sqlite3_finalize(query_stmt);  
            sqlite3_close(dbSecret);
        }
        sqlite3_finalize(query_stmt);     
    }else {
        returnValue =false;  
    }
    
    sqlite3_close(dbSecret);  
    return  returnValue ;
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Yes"])
    {
        isNewPassword = YES;
        self.navigationController.title=@"Enter New Password";
        lblTextChange.text=@"Enter New Password";
        ISSpeechRecognition *recognition = [[ISSpeechRecognition alloc] init];

        NSError *err;

        [recognition setDelegate:self];

        if(![recognition listen:&err])
        {
            NSLog(@"ERROR: %@", err);
        }
        [self recognize:nil];
    }
    else if([title isEqualToString:@"Re Enter"])
    {

        isReEnterPassword=YES;
        
        self.navigationController.title=@"Re Enter New Password";
        lblTextChange.text=@"Re Enter New Password";
        ISSpeechRecognition *recognition = [[ISSpeechRecognition alloc] init];

        NSError *err;

        [recognition setDelegate:self];

        if(![recognition listen:&err])
        {
            NSLog(@"ERROR: %@", err);
        }
        
    } else if([title isEqualToString:@"Close"])
    {
        isNewPassword=NO;
        isReEnterPassword=NO;
        
        [self.navigationController popViewControllerAnimated:YES];  
    }else if([title isEqualToString:@"Try Again"]) {
        ISSpeechRecognition *recognition = [[ISSpeechRecognition alloc] init];
        
        NSError *err;
        
        [recognition setDelegate:self];
        
        if(![recognition listen:&err])
        {
            NSLog(@"ERROR: %@", err);
        }
        [recognition release];
        
    }
    else if([title isEqualToString:@"Confirm"])
    {
        isNewPassword=NO;
        isReEnterPassword=NO;
        app.chngePWD=NO;
       Boolean isUpdated=[self updatePassword:strConfirmPass :app.LoginUserID];
        if(isUpdated)
        {
            
            Boolean isChangedStyle=[self updateLockStyle:app.LoginUserID];
            if(isChangedStyle)
            {
                
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Alert Message" message:@"Do you want to set New Pasword??"  delegate:self cancelButtonTitle:@"Finish" otherButtonTitles:nil ,nil];
                alert.message=[NSString stringWithFormat: @"Password = %@",loggedinPass];
            [alert show];
            
               
            }
        }
       
        //[self.navigationController popViewControllerAnimated:YES];  
    }else if([title isEqualToString:@"Finish"])
    {
              
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"It is highly recommended that you back up this passcode to your email, If you forget this passcode you will not be able to access your account, would you like this passcode sent to your mail box?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Send" ,nil];
        [alert show];
        
        
    }
    else if([title isEqualToString:@"Send"])
    {
        [self sendMail];
    }
    else if([title isEqualToString:@"No"])
    {
        NSLog(@"NO");
    }


}
-(Boolean) updatePassword :(NSString *)strValue :(NSString * )UserID 
{  
    sqlite3_stmt *statement = NULL;
    
    if(sqlite3_open([app getDBPathNew].UTF8String,&dbSecret)== SQLITE_OK)
    {
        NSString *insertquery;
        insertquery=[NSString stringWithFormat:@"UPDATE VerifyUserTbl SET UserPasswordTxt =\"%@\" where UserID=%@",strValue,UserID];
        NSLog(@"Query::::%@",insertquery);
        const char *insert_query=insertquery.UTF8String;
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
    sqlite3_stmt *statement = NULL;
    
    if(sqlite3_open([app getDBPathNew].UTF8String,&dbSecret)== SQLITE_OK)
    {
        NSString *insertquery;
        insertquery=[NSString stringWithFormat:@"UPDATE AuthentictionCheckTbl SET VoiceAuth =\"%@\" ,PatternAuth =\"%@\", PinCodeAuth =\"%@\" where UserID=%@",@"true",@"false",@"false",UserID];
        NSLog(@"Query::::%@",insertquery);
        const char *insert_query=insertquery.UTF8String;
        sqlite3_prepare(dbSecret,insert_query,-1,&statement,NULL);
        if(sqlite3_step(statement) == SQLITE_DONE){
            NSLog(@"record updated");
            sqlite3_finalize(statement);
            sqlite3_close(dbSecret);
            
            app.userDefaults = [NSUserDefaults standardUserDefaults];
            // saving an NSString
            [app.userDefaults setObject:@"Voice" forKey:@"LockMethod"];
            [GlobalFunctions setStringValueToUserDefaults:@"Voice" ForKey:@"LockMethod2"];
            app.loginMethod = @"Pattern";
            
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

- (IBAction)sendMail
{
#ifdef LITEVERSION
    if ([MFMailComposeViewController canSendMail])
    {
        NSString *someString;
        MFMailComposeViewController *mfViewController = [[MFMailComposeViewController alloc] init];
        mfViewController.mailComposeDelegate = self;
        [mfViewController setSubject:@"Secret Vault Passcode"];
        [mfViewController setMessageBody:@"Your Secret Vault Passcode" isHTML:YES];
        
            someString = [NSString stringWithFormat:@"This is a your Secret Vault passcode. Don't share with anyone, It's confidencial...<br/><a href=\"https://itunes.apple.com/us/app/secret-app/id569771443?ls=1&mt=8\">Secret Vault on itunes</a><br/>Your Username is: %@.<br/>Your passcode is : %@.",[self currentUserName:app.LoginUserID],strConfirmPass];
        
        [mfViewController setMessageBody:someString isHTML:YES];
        strMail=@"Mail";
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
        
        someString = [NSString stringWithFormat:@"This is a your Secret Vault Pro passcode. Don't share with anyone, It's confidencial...<br/><a href=\"https://itunes.apple.com/us/app/secret-vault-pro-plus/id873504069?ls=1&mt=8\">Secret Vault Pro on itunes</a><br/>Your Username is: %@.<br/>Your passcode is : %@.",[self currentUserName:app.LoginUserID],strConfirmPass];
        
        [mfViewController setMessageBody:someString isHTML:YES];
        strMail=@"Mail";
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
    [self.navigationController popViewControllerAnimated:YES];
    [alert show];
}

#pragma mark - SQL Methods
-(NSString *)currentUserName:(NSString *)UserID
{
    
    NSString *pass = [[NSString alloc]init];
    
    if (sqlite3_open([app getDBPathNew].UTF8String,&dbSecret)== SQLITE_OK)
    {
        NSString *selectSql = [NSString stringWithFormat:@"select UserName from VerifyUserTbl where UserID=%@",UserID];
        
        NSLog(@"Query : %@",selectSql);
        const char *sqlStatement = selectSql.UTF8String;
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
                        pass = @((char *)sqlite3_column_text(query_stmt, 0));
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
@end
