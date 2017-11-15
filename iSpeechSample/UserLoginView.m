//
//  UserLoginView.m
//  SecretApp
//
//  Created by c62 on 13/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserLoginView.h"

@interface UserLoginView ()

@end

@implementation UserLoginView

@synthesize btnRecognize,txtUserNm,lblPassword;


NSString  *loggedinPass,*loggedinNm;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    [loggedinNm release];
    [loggedinPass release];
    [lblPassword release];
    [txtUserNm release];
    [btnRecognize release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    (self.view).backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-background"]];
    app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self.navigationController setNavigationBarHidden:YES];
    
    loggedinNm=[[NSString alloc] init];
   // loggedinPass=[[NSString alloc] init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    
    isUserRegistered=false;
    app.LoginUserID=@"";
    txtUserNm.text=@"";
    lblPassword.text=@"";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)recognize:(id)sender
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
    
    [lblPassword setText:result.text];
    
    loggedinPass = [[NSString alloc]initWithFormat:@"%@",result.text];
    
    [speechRecognition release];
    [txtUserNm resignFirstResponder];
    
    //[self searchUser];
if([txtUserNm.text isEqualToString:@""])
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Name Field is Blank! Please enter user name ! " message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil,nil];
    alert.message=loggedinPass;
    [alert show];
    [alert release];

}else {
    if([loggedinPass isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Alert Message" message:@"Your Password is null. Do you want to set it again??" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES" ,nil];
        [alert show];
        [alert release];
    }
    else
    {
        if([self getUserName])
        {
           
            if([self checkPattern:loggedinPass])
            {
            
                NSString  *isLoginPhoto=[self getProperties:@"LoginPhoto"];
                if([isLoginPhoto isEqualToString:@"true"])
                {
                //Sucessful login photo
                    
                    @try
                {
                    [self getUSerID];
                    //  [self takePhoto];
                    
                    AVCaptureDevice *frontalCamera;
                    NSArray *allCameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
                    
                    // Find the frontal camera.
                    for ( int i = 0; i < allCameras.count; i++ ) {
                        AVCaptureDevice *camera = [allCameras objectAtIndex:i];
                        
                        if ( camera.position == AVCaptureDevicePositionFront ) {
                            frontalCamera = camera;
                        }
                    }
                    
                    // If we did not find the camera then do not take picture.
                    if ( frontalCamera != nil ) {
                        // Start the process of getting a picture.
                        session = [[AVCaptureSession alloc] init];
                        
                        // Setup instance of input with frontal camera and add to session.
                        NSError *error;
                        AVCaptureDeviceInput *input =
                        [AVCaptureDeviceInput deviceInputWithDevice:frontalCamera error:&error];
                        
                        if ( !error && [session canAddInput:input] ) {
                            // Add frontal camera to this session.
                            [session addInput:input];
                            
                            // We need to capture still image.
                            output = [[AVCaptureStillImageOutput alloc] init];
                            
                            // Captured image. settings.
                            [output setOutputSettings:
                             [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil]];
                            
                            if ( [session canAddOutput:output] ) {
                                [session addOutput:output];
                                
                                videoConnection = nil;
                                for (AVCaptureConnection *connection in output.connections) {
                                    for (AVCaptureInputPort *port in [connection inputPorts]) {
                                        if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                                            videoConnection = connection;
                                            break;
                                        }
                                    }
                                    if (videoConnection) { break; }
                                }
                                
                                // Finally take the picture
                                if ( videoConnection ) {
                                    [session startRunning];
                                    
                                       [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(captureImage) userInfo:nil repeats:NO];                             }
                            }
                        }
                    }
                }
                @catch (NSException *exception)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Camera" message:@"Camera is not available  " delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                    [alert show];
                    // [alert release];
                }
                    
                    //
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:@"Message" message:@"You are logged into System Successfully.." delegate:self cancelButtonTitle:@"Logout" otherButtonTitles:@"Continue" ,nil];
                    [alert show];
                }else {
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:@"Message" message:@"You are logged into System Successfully.." delegate:self cancelButtonTitle:@"Logout" otherButtonTitles:@"Continue" ,nil];
                    [alert show];
                    
                }
                    //
                
                
            }else {
                
                //Code for Login attempts Photo
                NSString  *isBreakIn=[self getProperties:@"BrekIn"];
                if([isBreakIn isEqualToString:@"true"])
                {
                    
                    @try
                    {
                        
                        [self getUSerID];
                        //  [self takePhoto];
                        
                        AVCaptureDevice *frontalCamera;
                        NSArray *allCameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
                        
                        // Find the frontal camera.
                        for ( int i = 0; i < allCameras.count; i++ ) {
                            AVCaptureDevice *camera = [allCameras objectAtIndex:i];
                            
                            if ( camera.position == AVCaptureDevicePositionFront ) {
                                frontalCamera = camera;
                            }
                        }
                        
                        // If we did not find the camera then do not take picture.
                        if ( frontalCamera != nil ) {
                            // Start the process of getting a picture.
                            session = [[AVCaptureSession alloc] init];
                            
                            // Setup instance of input with frontal camera and add to session.
                            NSError *error;
                            AVCaptureDeviceInput *input =
                            [AVCaptureDeviceInput deviceInputWithDevice:frontalCamera error:&error];
                            
                            if ( !error && [session canAddInput:input] ) {
                                // Add frontal camera to this session.
                                [session addInput:input];
                                
                                // We need to capture still image.
                               output = [[AVCaptureStillImageOutput alloc] init];
                                
                                // Captured image. settings.
                                [output setOutputSettings:
                                 [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil]];
                                
                                if ( [session canAddOutput:output] ) {
                                    [session addOutput:output];
                                    
                                    videoConnection = nil;
                                    for (AVCaptureConnection *connection in output.connections) {
                                        for (AVCaptureInputPort *port in [connection inputPorts]) {
                                            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                                                videoConnection = connection;
                                                break;
                                            }
                                        }
                                        if (videoConnection) { break; }
                                    }
                                    
                                    // Finally take the picture
                                    if ( videoConnection ) {
                                        [session startRunning];
                                        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(captureImage1) userInfo:nil repeats:NO];
                                                                            }
                                }
                            }
                        }
                    }
                    @catch (NSException *exception)
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Camera" message:@"Camera is not available  " delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                        [alert show];
                        // [alert release];
                    }
                  
                    //
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:@"Log in Fail" message:@"You entered wrong password !!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil ,nil];
                    [alert show];
                }else {
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:@"Log in Fail" message:@"You entered wrong password !!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil ,nil];
                    [alert show];
                    
                }
                    //
                
                }
            
            
            
            }else {
            NSLog(@"This User is Not registered yet..!!");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to be registered using password: " message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Register",nil];
            alert.message=loggedinPass;
            [alert show];
            [alert release];
        }
    }
}
}

-(void)captureImage1
{
    [output captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        if (imageDataSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput
                                 jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *photo = [[UIImage alloc] initWithData:imageData];
            NSLog(@"Captured img====> %@",photo);
            app.capImg=photo;
            
            
            NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            // If you go to the folder below, you will find those pictures
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init] ;
            dateFormat.dateFormat = @"yyyy-MM-dd";
            
            NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
            timeFormat.dateFormat = @"HH.mm.SS";
            
            NSDate *now = [[NSDate alloc] init] ;
            
            NSString *theDate = [dateFormat stringFromDate:now];
            NSString *theTime = [timeFormat stringFromDate:now];
            
            NSString *filename =[NSString stringWithFormat:@"|%@|%@|",theDate,theTime];
            theDate=[[NSString alloc]initWithString:filename];
            
            
            NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",docDir,theDate];
            
            
            NSData *data1 = [NSData dataWithData:UIImageJPEGRepresentation(photo, 1.0f)];
            [data1 writeToFile:pngFilePath atomically:YES];
            // [self insertImageBreakIn:pngFilePath :theTime: theDate];
            [self insertImage:pngFilePath :theTime :theDate];
            //
            //                                         [data1 release];
            //                                         [pngFilePath release];
            //                                         [filename release];
            //                                         [theDate release];
            //                                         [theTime release];
            //                                         [now release];
            //                                         [timeFormat release];
            //                                         [dateFormat release];
            //                                         [photo release];
            //                                         [imageData release];
            
            
            //                                         [output release];
            //                                         [input release];
            //                                         [session release];
            // [addnewpropertydelegate setSelectedImager:photo];
            //NSLog(@"selected image::: %@",addnewpropertydelegate);
        }
    }];

}
-(void)captureImage
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"blank" ofType:@"wav"];
    SystemSoundID soundID;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    AudioServicesPlaySystemSound(soundID);

    [output captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        if (imageDataSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput
                                 jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *photo = [[UIImage alloc] initWithData:imageData];
            NSLog(@"Captured img====> %@",photo);
            app.capImg=photo;
            
            
            NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            // If you go to the folder below, you will find those pictures
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init] ;
            dateFormat.dateFormat = @"yyyy-MM-dd";
            
            NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
            timeFormat.dateFormat = @"HH.mm.SS";
            
            NSDate *now = [[NSDate alloc] init] ;
            
            NSString *theDate = [dateFormat stringFromDate:now];
            NSString *theTime = [timeFormat stringFromDate:now];
            
            NSString *filename =[NSString stringWithFormat:@"|%@|%@|",theDate,theTime];
            theDate=[[NSString alloc]initWithString:filename];
            
            
            NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",docDir,theDate];
            
            
            NSData *data1 = [NSData dataWithData:UIImageJPEGRepresentation(photo, 1.0f)];
            [data1 writeToFile:pngFilePath atomically:YES];
            
            [self insertImageBreakIn:pngFilePath :theTime: theDate];
            
            // [addnewpropertydelegate setSelectedImager:photo];
            // NSLog(@"selected image::: %@",addnewpropertydelegate);
        }
    }];

}
-(void)insertImageBreakIn:(NSString *)imagePath :(NSString *)imgTime :(NSString *)imgDate {
    
    sqlite3_stmt *stmt;
    databasepath=[app getDBPathNew];
    const char *dbpath=databasepath.UTF8String;
    
    if(sqlite3_open(dbpath, &dbSecret) == SQLITE_OK)
    {
        // NSString *insertquery=[NSString stringWithFormat:@"Insert into ViewImageLogtbl(UserID,ImagePath,isBreakIn) VALUES(\"%@\",\"%@\",\"true\")",app.LoginUserID ,imagePath];
        NSString *insertquery=[NSString stringWithFormat:@"Insert into ViewImageLogtbl(UserID,ImagePath,isBreakIn,logInTime,loginDate) VALUES(\"%@\",\"%@\",\"true\",\"%@\",\"%@\")",app.LoginUserID ,imagePath,imgTime,imgDate];
        
        NSLog(@"insert query== %@",insertquery);
        
        const char *insert_query=insertquery.UTF8String;
        sqlite3_prepare(dbSecret, insert_query, -1, &stmt, NULL);
        
        if(sqlite3_step(stmt)== SQLITE_DONE)
        {
            NSLog(@"img/video Inserted..");
            
        }
        else
        {
            NSLog(@"Failed to capture image");
            
        }
        sqlite3_finalize(stmt);
        sqlite3_close(dbSecret);
    }
    
}

-(void)insertImage:(NSString *)imagePath :(NSString *)imgTime :(NSString *)imgDate {
    
    sqlite3_stmt *stmt;
    databasepath=[app getDBPathNew];
    const char *dbpath=databasepath.UTF8String;
    
    if(sqlite3_open(dbpath, &dbSecret) == SQLITE_OK)
    {
        // NSString *insertquery=[NSString stringWithFormat:@"Insert into ViewImageLogtbl(UserID,ImagePath,isLogin) VALUES(\"%@\",\"%@\",\"true\")",app.LoginUserID ,imagePath];
        NSString *insertquery=[NSString stringWithFormat:@"Insert into ViewImageLogtbl(UserID,ImagePath,isLogin,logInTime,loginDate) VALUES(\"%@\",\"%@\",\"true\",\"%@\",\"%@\")",app.LoginUserID ,imagePath,imgTime,imgDate];
        
        NSLog(@"insert query== %@",insertquery);
        
        const char *insert_query=insertquery.UTF8String;
        sqlite3_prepare(dbSecret, insert_query, -1, &stmt, NULL);
        
        if(sqlite3_step(stmt)== SQLITE_DONE)
        {
            NSLog(@"img/video Inserted..");
            
        }
        else
        { 
            NSLog(@"Failed to capture image");
            
        }
        sqlite3_finalize(stmt);
        sqlite3_close(dbSecret);
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)goAway:(id)sender{
    
    [sender resignFirstResponder];
}

-(IBAction) searchUser
{
    if([txtUserNm.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Message" message:@"Please Enter Your Name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        loggedinNm=txtUserNm.text;
        databasepath=[app getDBPathNew];
        if (sqlite3_open(databasepath.UTF8String, &dbSecret) == SQLITE_OK) 
        {
            NSLog(@"unm==%@ ",loggedinNm);
            NSLog(@"pass=== %@",loggedinPass);
            
            NSString *selectSql = [NSString stringWithFormat:@"select * from VerifyUserTbl Where UserName=\"%@\" AND UserPasswordTxt=\"%@\" ",loggedinNm,loggedinPass];
            
            NSLog(@"Query : %@",selectSql);
            const char *sqlStatement = selectSql.UTF8String;
            sqlite3_stmt *query_stmt;
            
            if(sqlite3_prepare_v2(dbSecret, sqlStatement, -1, &query_stmt, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(query_stmt) == SQLITE_ROW) 
                {
                    loggedinUserID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(query_stmt, 0)];
                    
                    NSLog(@"User id=== %@",loggedinUserID);
                    
                    app.LoginUserID=loggedinUserID;
                    
                    if(!isUserRegistered)
                    {
                        UIAlertView *alert = [[UIAlertView alloc]
                                              initWithTitle:@"Message" message:@"You are logged into System Successfully.." delegate:self cancelButtonTitle:@"Logout" otherButtonTitles:@"Continue" ,nil];
                        [alert show];
                        [alert release];
                    }
                    else
                    {
                        RootViewController *root;
                        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
                        {
                            root = [[RootViewController alloc] initWithNibName:@"RootViewcontroller_Ipad" bundle:nil];
                        }
                        else {
                            root = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
                        }
                        
                        [self.navigationController pushViewController:root animated:YES];
                        [root release];
                    }
                }     
                else
                {
                    NSLog(@"This User is Not registered yet..!!");
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to be registered using password: " message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Register",nil];
                    alert.message=loggedinPass;
                    [alert show];
                    [alert release];
                    
                }
                sqlite3_finalize(query_stmt);
            }
        }
        sqlite3_close(dbSecret);  
    }
}




-(IBAction) AuthenticateUser
{
    loggedinNm=txtUserNm.text;
    databasepath=[app getDBPathNew];
    if (sqlite3_open(databasepath.UTF8String, &dbSecret) == SQLITE_OK) 
    {
        NSLog(@"unm==%@ ",loggedinNm);
        NSLog(@"pass=== %@",loggedinPass);
        
        NSString *selectSql = [NSString stringWithFormat:@"select * from VerifyUserTbl Where UserName=\"%@\" AND UserPasswordTxt=\"%@\" ",loggedinNm,loggedinPass];
        
        NSLog(@"Query : %@",selectSql);
        const char *sqlStatement = selectSql.UTF8String;
        sqlite3_stmt *query_stmt;
        
        if(sqlite3_prepare_v2(dbSecret, sqlStatement, -1, &query_stmt, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(query_stmt) == SQLITE_ROW) 
            {
                loggedinUserID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(query_stmt, 0)];
                
                NSLog(@"User id=== %@",loggedinUserID);
                
                app.LoginUserID=loggedinUserID;
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Message" message:@"You are logged into System Successfully.." delegate:self cancelButtonTitle:@"Logout" otherButtonTitles:@"Continue" ,nil];
                   [alert show];
                   [alert release];
              
            }     
            sqlite3_finalize(query_stmt);
        }
    }
    sqlite3_close(dbSecret);  

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Register"])
    {
        if([self registerUser])
        {  
            [self getUSerID];
            [self addProperty];
            [self addAuthenticaStyle];
                        UIAlertView *alert = [[UIAlertView alloc]
                                              initWithTitle:@"Message" message:@"You are logged into System Successfully.." delegate:self cancelButtonTitle:@"Logout" otherButtonTitles:@"Continue" ,nil];
                        [alert show];
                        [alert release];
        }
        
    }
    else if ([title isEqualToString:@"Cancel"]) {
        loggedinUserID=@"";
        app.LoginUserID=@"";
        txtUserNm.text=@"";
        lblPassword.text=@"";
        loggedinPass=@"";
    }
    else if([title isEqualToString:@"Continue"])
    {
        RootViewController *root;
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            root = [[RootViewController alloc] initWithNibName:@"RootViewcontroller_Ipad" bundle:nil];
        }
        else {
            root = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
        }
        
        [self.navigationController pushViewController:root animated:YES];
        [root release];
    }
    else if([title isEqualToString:@"OK"])
    {
//        isUserRegistered=true;
//        [self searchUser];
    }  
    else if([title isEqualToString:@"YES"])
    {
        [self recognize:nil];
    }
    else if([title isEqualToString:@"Logout"])
    {
        loggedinUserID=@"";
        app.LoginUserID=@"";
        txtUserNm.text=@"";
        loggedinPass=@"";
    }
}

-(Boolean)registerUser
{
    Boolean returnValue = '\0';
    sqlite3_stmt *stmt;
    databasepath=[app getDBPathNew];
    const char *dbpath=databasepath.UTF8String;
    if(sqlite3_open(dbpath, &dbSecret) == SQLITE_OK)
    {
        NSString *insertquery=[NSString stringWithFormat:@"Insert into VerifyUserTbl(UserName,UserPasswordTxt,UserVoiceTxt) VALUES(\"%@\",\"%@\",\"%@\")",loggedinNm,loggedinPass,@""];
        
        NSLog(@"insert query== %@",insertquery);
        
        const char *insert_query=insertquery.UTF8String;
        sqlite3_prepare(dbSecret, insert_query, -1, &stmt, NULL);
        
        if(sqlite3_step(stmt)== SQLITE_DONE)
        {
            NSLog(@"user Inserted..");

            returnValue=true;

        }
        else
        { 
            returnValue=false;
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry" message:@"Failed To Register.." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        sqlite3_finalize(stmt);
        sqlite3_close(dbSecret);
    }
    return returnValue;
}
-(Boolean) getUserName
{
    Boolean returnValue;
    loggedinNm=txtUserNm.text;
    
    
    databasepath=[app getDBPathNew];
    if (sqlite3_open(databasepath.UTF8String, &dbSecret) == SQLITE_OK) 
    {
        NSLog(@"unm==%@ ",loggedinNm);
        NSString *selectSql = [NSString stringWithFormat:@"select * from VerifyUserTbl Where UserName=\"%@\" ",loggedinNm];
        
        NSLog(@"Query : %@",selectSql);
        const char *sqlStatement = selectSql.UTF8String;
        sqlite3_stmt *query_stmt;
        if(sqlite3_prepare_v2(dbSecret, sqlStatement, -1, &query_stmt, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(query_stmt) == SQLITE_ROW) 
            {
              
                
                app.LoginUserID=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(query_stmt, 0)];
                loggedinNm = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(query_stmt, 1)];
                
                NSLog(@"User Name is === %@",loggedinNm);
                
                NSLog(@"User ID  is === %@",app.LoginUserID);

                returnValue = true;
                
                //                app.LoginUserID=loggedinUserID;
            } else {
                
                returnValue =false;
                
            }    
            sqlite3_finalize(query_stmt);
        }else 
        {
            returnValue = false;
        }
    }else {
        returnValue =false;  
    }
    sqlite3_close(dbSecret);  
    return  returnValue ;
    
}
-(NSString *) getProperties :(NSString *)strProperty
{
    NSString *strReturn=@"false";
    databasepath=[app getDBPathNew];
    NSString *selectSql = nil;
    if (sqlite3_open(databasepath.UTF8String, &dbSecret) == SQLITE_OK) 
    {
        
        if([strProperty isEqualToString:@"BrekIn"]){
            selectSql = [NSString stringWithFormat:@"select BrekinPhoto from AutoLogOffTbl where UserID=%@",app.LoginUserID];
        }else if([strProperty isEqualToString:@"LoginPhoto"]){
            selectSql = [NSString stringWithFormat:@"select LoginPhoto from AutoLogOffTbl where UserID=%@",app.LoginUserID];
        }
        NSLog(@"Query : %@",selectSql);
        const char *sqlStatement = selectSql.UTF8String;
        sqlite3_stmt *query_stmt;
        
        if(sqlite3_prepare_v2(dbSecret, sqlStatement, -1, &query_stmt, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(query_stmt) == SQLITE_ROW) 
            {
                NSString *checkValue = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(query_stmt, 0)];
                
                NSLog(@"Value == %@",checkValue);
                
                strReturn=checkValue;
            }     
            
            sqlite3_finalize(query_stmt);
        }else {
            strReturn =@"false";
        }
    }
    sqlite3_close(dbSecret);  
    return strReturn;
}


-(void)addProperty
{
    sqlite3_close(dbSecret);
    NSLog(@"Log in id is %@ ",app.LoginUserID);
    sqlite3_stmt *stmt;
    databasepath=[app getDBPathNew];
    const char *dbpath=databasepath.UTF8String;
    if(sqlite3_open(dbpath, &dbSecret) == SQLITE_OK)
    {
        //(UserID integer,"Time" text,BrekinPhoto boolean,LoginPhoto boolean,HighQuality boolean,Duration text,Transition text,Repeat boolean,Shuffle boolean,UseDeskAgent boolean, Facebook boolean)
        
        NSString *insertquery=[NSString stringWithFormat:@"Insert into AutoLogOffTbl(UserID,Time,BrekinPhoto,LoginPhoto,HighQuality,Duration,Transition,Repeat,Shuffle,UseDeskAgent,Facebook) VALUES( %@ ,\"1 minute\",\"false\",\"false\",\"false\",\"2\",\"4\",\"false\",\"false\",\"false\",\"false\")",app.LoginUserID];
        
        NSLog(@"insert query== %@",insertquery);
        
        const char *insert_query=insertquery.UTF8String;
        sqlite3_prepare(dbSecret, insert_query, -1, &stmt, NULL);
        
        if(sqlite3_step(stmt)== SQLITE_DONE)
        {
            NSLog(@"user property added..");
            
        }
        else
        {  NSLog(@"failed to add property .");
            
        }
        sqlite3_finalize(stmt);
        sqlite3_close(dbSecret);
    }
}

-(void)addAuthenticaStyle
{
    sqlite3_close(dbSecret);
    NSLog(@"Log in id is %@ ",app.LoginUserID);
    sqlite3_stmt *stmt;
    databasepath=[app getDBPathNew];
    const char *dbpath=databasepath.UTF8String;
    if(sqlite3_open(dbpath, &dbSecret) == SQLITE_OK)
    {
        //(UserID integer,"Time" text,BrekinPhoto boolean,LoginPhoto boolean,HighQuality boolean,Duration text,Transition text,Repeat boolean,Shuffle boolean,UseDeskAgent boolean, Facebook boolean)
        
        NSString *insertquery=[NSString stringWithFormat:@"Insert into AuthentictionCheckTbl(VoiceAuth,PatternAuth,UserID,PinCodeAuth) VALUES (\"true\",\"false\",%@,\"false\")",app.LoginUserID];
        
        NSLog(@"insert query== %@",insertquery);
        
        const char *insert_query=insertquery.UTF8String;
        sqlite3_prepare(dbSecret, insert_query, -1, &stmt, NULL);
        
        if(sqlite3_step(stmt)== SQLITE_DONE)
        {
            NSLog(@"user property added..");
        }
        else
        {  NSLog(@"failed to add property .");
            
        }
        sqlite3_finalize(stmt);
        sqlite3_close(dbSecret);
    }
}


-(NSString *) getUSerID
{
    loggedinNm=txtUserNm.text;
    databasepath=[app getDBPathNew];
    if (sqlite3_open(databasepath.UTF8String, &dbSecret) == SQLITE_OK) 
    {
        NSLog(@"unm==%@ ",loggedinNm);
        NSLog(@"pass=== %@",loggedinPass);
        NSString *selectSql = [NSString stringWithFormat:@"select * from VerifyUserTbl Where UserName=\"%@\" ",loggedinNm];
        
        NSLog(@"Query : %@",selectSql);
        const char *sqlStatement = selectSql.UTF8String;
        sqlite3_stmt *query_stmt;
        if(sqlite3_prepare_v2(dbSecret, sqlStatement, -1, &query_stmt, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(query_stmt) == SQLITE_ROW) 
            {
                loggedinUserID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(query_stmt, 0)];
                
                NSLog(@"User id=== %@",loggedinUserID);
                
                app.LoginUserID=loggedinUserID;
                
            }     
            sqlite3_finalize(query_stmt);
        }else 
        {
            //      [self searchUser];
            
        }
    }
    sqlite3_close(dbSecret);  
    return @"false";  
}
-(Boolean) checkPattern : (NSString *)strLoggedInPass
{
    Boolean returnValue;
    databasepath=[app getDBPathNew];
    if (sqlite3_open(databasepath.UTF8String, &dbSecret) == SQLITE_OK) 
    {
        NSLog(@"unm==%@ ",loggedinNm);
        NSLog(@"pass=== %@",strLoggedInPass);
        NSString *selectSql = [NSString stringWithFormat:@"select UserPasswordTxt from VerifyUserTbl Where UserID = %@ ",app.LoginUserID];
        
        NSLog(@"Query : %@",selectSql);
        const char *sqlStatement = selectSql.UTF8String;
        sqlite3_stmt *query_stmt;
        @try {
            
            if(sqlite3_prepare_v2(dbSecret, sqlStatement, -1, &query_stmt, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(query_stmt) == SQLITE_ROW) 
                {
                    NSString *strLogginCode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(query_stmt, 0)];
                    
                    NSLog(@"Pattertn code is === %@",strLogginCode);
                    
                    if([strLoggedInPass isEqualToString:strLogginCode])
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



@end
