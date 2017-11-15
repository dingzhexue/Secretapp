//
//  PinCodeViewController.m
//  SecretApp
//
//  Created by c78 on 08/02/13.
//
//

#import "PinCodeViewController.h"

@interface PinCodeViewController ()

@property (nonatomic,retain) NSString *code;

@end

@implementation PinCodeViewController


@synthesize userName,pinDigit1,pinDigit2,pinDigit3,pinDigit4;

-(void)dealloc
{
    
    [userName release];
    [pinDigit1 release];
    [pinDigit2 release];
    [pinDigit3 release];
    [pinDigit4 release];
    [super dealloc];
    
}

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
    self.navigationController.navigationBarHidden = YES;
    app= (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    userName.tag = 0;
    [userName becomeFirstResponder];
    userName.delegate = self;
    pinDigit1.delegate = self;
    pinDigit2.delegate = self;
    pinDigit3.delegate = self;
    pinDigit4.delegate = self;
    
    pinDigit1.tag = 1;
    pinDigit2.tag = 2;
    pinDigit3.tag = 3;
    pinDigit4.tag = 4;
    
    pinDigit1.keyboardType = UIKeyboardTypeNumberPad;
    pinDigit2.keyboardType = UIKeyboardTypeNumberPad;
    pinDigit3.keyboardType = UIKeyboardTypeNumberPad;
    pinDigit4.keyboardType = UIKeyboardTypeNumberPad;
    
    pinDigit1.selected = NO;
    pinDigit2.selected = NO;
    pinDigit3.selected = NO;
    pinDigit4.selected = NO;
    
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        //self.edgesForExtendedLayout = UIRectEdgeNone;
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+20, self.view.frame.size.width, self.view.frame.size.height);
    }

        // Do any additional setup after loading the view from its nib.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //[textField resignFirstResponder];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag>0) {
        NSInteger nextTag = textField.tag + 1;
        // Try to find next responder
        UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
        
        if(!self.code)
        {
            self.code = [[NSString alloc]init];
        }
        if (self.code.length < textField.tag) {
            self.code = [self.code stringByAppendingString:string];
            
            UIImageView *view = (UIImageView *)[self.view viewWithTag:(3+nextTag)];
            UIImage *image = [[UIImage alloc]init];
            image = [UIImage imageNamed:@"EntryBox_entry.png"];
            
            NSLog(@"View :: %@ Image :: %@",view,image);
            
            view.image = image;
        }else if(self.code.length>=textField.tag)
        {
            NSRange range = NSMakeRange(textField.tag-1, 1);
            self.code = [self.code stringByReplacingCharactersInRange:range withString:string];
        }
        
        NSLog(@"Code :: %@",self.code);
        
        if (self.code.length == 4) {
            if ([self checkLogin])
            {
                NSString  *isLoginPhoto=[self getProperties:@"LoginPhoto"];
                if([isLoginPhoto isEqualToString:@"true"])
                {
                    @try
                    {
                        
                        //  [self takePhoto];
                        
                        AVCaptureDevice *frontalCamera;
                        NSArray *allCameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
                        
                        // Find the frontal camera.
                        for ( int i = 0; i < allCameras.count; i++ ) {
                            AVCaptureDevice *camera = allCameras[i];
                            
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
                                output.outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
                                
                                if ( [session canAddOutput:output] ) {
                                    [session addOutput:output];
                                    
                                    
                                    
                                    videoConnection = nil;
                                    for (AVCaptureConnection *connection in output.connections) {
                                        for (AVCaptureInputPort *port in connection.inputPorts) {
                                            if ([port.mediaType isEqual:AVMediaTypeVideo] ) {
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
                    
                    //                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Fail!" message:@"You enterd a wrong pattern!! " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    //                    [alert show];
                    
                }

                
                
                
                
            
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Congratulations!!!" message:@"You are logged into system successfully..." delegate:nil cancelButtonTitle:@"Logout" otherButtonTitles:@"Continue",nil];
                alert.delegate = self;
                [alert show];
                [alert release];
                
            }
            else
            {
                
                NSString  *isBreakIn=[self getProperties:@"BrekIn"];
                if([isBreakIn isEqualToString:@"true"])
                {
                    @try
                    {
                        //  [self takePhoto];
                        AVCaptureDevice *frontalCamera;
                        NSArray *allCameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
                        
                        // Find the frontal camera.
                        for ( int i = 0; i < allCameras.count; i++ )
                        {
                            AVCaptureDevice *camera = allCameras[i];
                            if ( camera.position == AVCaptureDevicePositionFront )
                            {
                                frontalCamera = camera;
                            }
                        }
                        
                        // If we did not find the camera then do not take picture.
                        if ( frontalCamera != nil )
                        {
                            // Start the process of getting a picture.
                            session = [[AVCaptureSession alloc] init];
                            
                            // Setup instance of input with frontal camera and add to session.
                            NSError *error;
                            AVCaptureDeviceInput *input =
                            [AVCaptureDeviceInput deviceInputWithDevice:frontalCamera error:&error];
                            
                            
                            if ( !error && [session canAddInput:input] )
                            {
                                // Add frontal camera to this session.
                                [session addInput:input];
                                
                                
                                // We need to capture still image.
                                output = [[AVCaptureStillImageOutput alloc] init];
                                
                                // Captured image. settings.
                                output.outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
                                
                                if ( [session canAddOutput:output] )
                                {
                                    [session addOutput:output];
                                    
                                    videoConnection = nil;
                                    //                                    NSString *path = [[NSBundle mainBundle] pathForResource:@"blank" ofType:@"wav"];
                                    //                                    SystemSoundID soundID;
                                    //                                    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
                                    //                                    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
                                    //                                    AudioServicesPlaySystemSound(soundID);
                                    
                                    for (AVCaptureConnection *connection in output.connections)
                                    {
                                        for (AVCaptureInputPort *port in connection.inputPorts)
                                        {
                                            if ([port.mediaType isEqual:AVMediaTypeVideo] )
                                            {
                                                videoConnection = connection;
                                                break;
                                            }
                                        }
                                        if (videoConnection) { break; }
                                    }
                                    
                                    // Finally take the picture
                                    if ( videoConnection )
                                    {
                                        
                                        [session startRunning];
                                        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(captureImage) userInfo:nil repeats:NO];
                                        
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
                    
                    
                }

                
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Login Failed!!!" message:@"Please enter the correct UserName and PinCode..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alert.delegate = self;
                [alert show];
                [alert release];
                
                NSLog(@"Login Failed!!!");
                self.code = @"";
            }
        }
        
        if (nextResponder) {
            // Found next responder, so set it.
            textField.text = string;
            [nextResponder becomeFirstResponder];
        } else {
            // Not found, so remove keyboard.
            if (![self.code isEqualToString:@""]) {
                textField.text = string;
            }
            [textField resignFirstResponder];
        }
        return NO;
    }
    
    return YES;

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
            [self insertImage:pngFilePath :theTime :theDate];
            // [addnewpropertydelegate setSelectedImager:photo];
            // NSLog(@"selected image::: %@",addnewpropertydelegate);
        }
    }];
    
}

-(void)captureImage
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
            [self insertImageBreakIn:pngFilePath :theTime: theDate];
            
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

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    NSLog(@"TextField Tag :: %ld Next Responder :: %@ Text Fileld :: %@",(long)nextTag,nextResponder,textField);
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

/*
#pragma mark - CHECK PIN CODE LOCK

 -(NSString *) checkPinCodeLock
 {
     NSString *strReturn=@"false";
     NSString *databasepath=[app getDBPath];
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
         }
         else
         {
         sqlite3_finalize(query_stmt);
         }
     }
 sqlite3_close(dbSecret);
 return strReturn;
 }*/

#pragma mark - Check Login

-(BOOL)checkLogin
{
    Boolean valueReturn = '\0';
if([userName.text isEqualToString:@""])
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Message" message:@"Please Enter Your Name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}
else
{
    
    NSString *loggedinNm = [[NSString alloc]init];
    NSString *loggedinPass = [[NSString alloc]init];
    NSString *loggedinUserID = [[NSString alloc]init];
    
    loggedinNm = userName.text;
    databasepath=[app getDBPathNew];
    if (sqlite3_open(databasepath.UTF8String, &dbSecret) == SQLITE_OK)
    {
        loggedinPass = self.code;
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
                loggedinUserID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(query_stmt, 0)];
                
                NSLog(@"User id=== %@",loggedinUserID);
                
                app.LoginUserID=loggedinUserID;
                
                
                valueReturn= true;
            }
            else
            {
                
                
                valueReturn= false;
            }
        }
        else
        {
            
            
            valueReturn= false;
        }
        sqlite3_finalize(query_stmt);
    }else {
        
        
        valueReturn =false;
    }
    
    
}

sqlite3_close(dbSecret);
return valueReturn;
}

#pragma mark - ALERTVIEW DELEGATE METHOD

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Logout"])
    {
        userName.text = @"";
        self.code = @"";
        
        for (int i = 1; i<=4; i++) {
            UIImageView *view = (UIImageView *)[self.view viewWithTag:(4+i)];
            UIImage *image = [[UIImage alloc]init];
            image = [UIImage imageNamed:@"EntryBox.png"];
            
            NSLog(@"View :: %@ Image :: %@",view,image);
            
            view.image = image;
        }
        self.code = @"";
        [userName becomeFirstResponder];
        
    }
    
    if([title isEqualToString:@"Continue"])
    {
        NSLog(@"Logged In Successfully...");
        
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
    
    if([title isEqualToString:@"OK"])
    {
        for (int i = 1; i<=4; i++) {
            UIImageView *view = (UIImageView *)[self.view viewWithTag:(4+i)];
            UIImage *image = [[UIImage alloc]init];
            image = [UIImage imageNamed:@"EntryBox.png"];
            
            NSLog(@"View :: %@ Image :: %@",view,image);
            
            view.image = image;
        }
        self.code = @"";
        [userName becomeFirstResponder];
    }



}


@end
