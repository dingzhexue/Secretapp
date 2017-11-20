//
//  ViewController.m
//  AndroidLock
//
//  Created by Purnama Santo on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DrawPatternLockViewController.h"
#import "DrawPatternLockView.h"
#import "PinCodeLoginViewController.h"
#import "PinCodeViewController.h"
#include <AudioToolbox/AudioToolbox.h>

#define MATRIX_SIZE 3

@implementation DrawPatternLockViewController
@synthesize nav,loggedinNm,loggedinPass;



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];
    //        UIImage *img=[UIImage imageNamed:@"main-bg.png"];
    //    //    self.view.backgroundColor = [UIColor darkGrayColor];
    //      UIImageView *imgView=[[UIImageView alloc]initWithImage:img];
    //        imgView.frame=CGRectMake(0, 0,480, 700);
    //    [self.view addSubview:imgView];
    self.view = [[DrawPatternLockView alloc] init];
    
    
}
-(IBAction)BtnSettingsClicked:(id)sender
{
    
    app.isReEnterPattern=NO;
    app.isNewPattern=NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    isUserRegistered=false;
    
    
    /*Check Which Lock Is Current Lock Then Apply The Screen Which Is Required....*/
    
    
//    app.userDefaults = [NSUserDefaults standardUserDefaults];

    NSString *myString = [GlobalFunctions getStringValueFromUserDefaults_ForKey:@"LockMethod2"];
    NSLog(@"Lock Code Method :: %@",myString);
        if(app.chngePWD)
    {
        

    }
    else if([myString isEqualToString:@"PinCode"])
    {
        PinCodeViewController *pinView;
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            pinView = [[PinCodeViewController alloc] initWithNibName:@"PinCodeViewController_iPad" bundle:nil];
        }
        else
        {
            pinView = [[PinCodeViewController alloc] initWithNibName:@"PinCodeViewController" bundle:nil];
        }
        
        NSLog(@"Navigation Controller :: %@",self.navigationController);
        
        [self.navigationController pushViewController:pinView animated:YES];
        
        NSLog(@"Modal View Control Presented");
    }
    else
    {
        NSLog(@"Load Other Login View");
    }
    
}


- (void)viewWillLayoutSubviews {
    
    //SetDefaultView
    int w ;
    int h ;
    
    NSLog(@"viewWillLayoutSubviews");
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        
        
        if(app.chngePWD)
        {
            self.contentSizeForViewInPopover = CGSizeMake(490.0, 490.0);
            
            w = 320/MATRIX_SIZE;
            h = 450/MATRIX_SIZE;
            
        }else {
            
            w = 600/MATRIX_SIZE;
            h = 900/MATRIX_SIZE;
            
            //        w = self.view.frame.size.width/MATRIX_SIZE;
            //        h = self.view.frame.size.height/MATRIX_SIZE;
        }
        
        //  int w = self.view.frame.size.width/MATRIX_SIZE;
        //  int h = self.view.frame.size.height/MATRIX_SIZE;
        //    int w = 320/MATRIX_SIZE;
        //    int h = 500/MATRIX_SIZE;
        
    }else {
        
        
        if(app.chngePWD)
        {
            w = 320/MATRIX_SIZE;
            h = 450/MATRIX_SIZE;
            
            
        }else {
            w = 220/MATRIX_SIZE;
            h = 330/MATRIX_SIZE;
            
        }
        
        
    }
    int i=0;
    int x = 0;
    int y=0;
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        if (!app.chngePWD)
        {
            h = (h/1.5);
        }
    }
    
    //setLock
    for (UIView *view in self.view.subviews)
        if ([view isKindOfClass:[UIImageView class]]) {
            
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
            {
                if (app.chngePWD)
                {
                    x = w*(i/MATRIX_SIZE) + (i/MATRIX_SIZE)*30 + 100;
                    y = h*(i%MATRIX_SIZE) + 100;
                }
                else
                {
                    x = w*(i/MATRIX_SIZE) + w/2 + 25;
                    y = h*(i%MATRIX_SIZE) + h/2 + 175;
                }
            }
            else
            {
                CGSize result = [UIScreen mainScreen].bounds.size;
                
                if (result.height < 568){
                    
                x = w*(i/MATRIX_SIZE) + 40;
                y = h*(i%MATRIX_SIZE) + 60;
                    NSLog(@"First");
                    
                }else{
                
                x = w*(i/MATRIX_SIZE) + 40;
                y = h*(i%MATRIX_SIZE) + 108;
                    NSLog(@"Second");
                
                }
            }
            
            if(app.chngePWD)
            {
                
            }else {
                if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
                {
                    x= x+50;
                    y=y+100;
                    
                    
                }else {
                    x= x+50;
                    y=y+100;
                }
                
            }
            
            NSLog(@"X :: %d Y :: %d",x,y);
            
            view.center = CGPointMake(x, y);
            
            i++;
        }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([textField.text isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
    }
    else if ([string isEqualToString:@" "])
    {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    // Return YES for supported orientations
    //  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    //      return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    //  } else {
    //      return YES;
    //  }
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _paths = [[NSMutableArray alloc] init];
}

-(void)onTick:(NSTimer *)timer {
    //   intTickCount ++;
    NSLog(@"Tick Count %ld...",(long)intTickCount);
    
    //if(intTickCount >=15)
    //  {
    timerFlag=false;
    passwordCounter =0;
    [tmrLock invalidate];
    tmrLock=nil;
    //  }
    
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(passwordCounter>=5){
        if(!timerFlag){
            timerFlag =true;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You are fail to draw a correct pattern, You are lock For 15 sec. !!" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
            
            [alert show];
            tmrLock = [NSTimer scheduledTimerWithTimeInterval: 15.0
                                                       target: self
                                                     selector:@selector(onTick:)
                                                     userInfo: nil repeats:NO];
        }
    }else {
        NSLog(@"counter Value %ld",(long)passwordCounter);
        
        CGPoint pt = [[touches anyObject] locationInView:self.view];
        UIView *touched = [self.view hitTest:pt withEvent:event];
        [txtName resignFirstResponder];
        DrawPatternLockView *v = (DrawPatternLockView*)self.view;
     //   [v drawLineFromLastDotTo:pt];
        
        if (touched!=self.view) {
            NSLog(@"touched view tag: %ld ", (long)touched.tag);
            
            BOOL found = NO;
            for (NSNumber *tag in _paths) {
                found = tag.integerValue==touched.tag;
                if (found)
                    break;
            }
            
            if (found)
                return;
            
            [_paths addObject:[NSNumber numberWithInt:touched.tag]];
            [v addDotView:touched];
            
            UIImageView* iv = (UIImageView*)touched;
            iv.highlighted = YES;
        }
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // clear up hilite
    
    if(passwordCounter>=5){
    }else {
//        DrawPatternLockView *v = (DrawPatternLockView*)self.view;
//        [v clearDotViews];
        image=[self captureView:self.view];
        
        for (UIView *view in self.view.subviews)
            if ([view isKindOfClass:[UIImageView class]])
                [(UIImageView*)view setHighlighted:NO];
        
        [self.view setNeedsDisplay];
        
        // pass the output to target action...
        //if (_target && _action)
        //   [_target performSelector:_action withObject:[self getKey]];
        [_target performSelector:_action withObject: [self getKey]];
        
    }
}
- (UIImage *)captureView:(UIView *)view
{
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    UIGraphicsBeginImageContext(screenRect.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, screenRect);
    
    [view.layer renderInContext:ctx];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

// get key from the pattern drawn
// replace this method with your own key-generation algorithm
- (NSString *) getKey {
    
    NSMutableString *key;
    key = [NSMutableString string];
    
    // simple way to generate a key
    
    for (NSNumber *tag in _paths)
    {
        [key appendFormat:@"%02ld", (long)tag.integerValue];
    }
    loggedinPass=key;
    
    NSLog(@"key value== %@",key);
    
    
    if(app.chngePWD)
    {
        
        
        if(app.isReEnterPattern)
        {
            
            if([app.newLogInPattern isEqualToString:key])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Change Password " message:@"" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Confirm",nil];
                alert.message=loggedinPass;
                [alert show];
                app.blNVFromReEnter=YES;
            }else
            {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Re Enter PAttern " message:@"" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Re Try",nil];
                alert.message=@"Your Re enter Patter is not Same";
                [alert show];
                app.blNVFromReEnter=YES;
            }
            
            
        }
        else if(app.isNewPattern)
        {
            
            app.newLogInPattern=loggedinPass;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Draw New Pattern" message:@"" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Try New",@"Re Enter",nil];
            alert.message=@"D";
            [alert show];
            app.blNVFromNewPattern=YES;
            
        }else {
            NSLog(@"Key is %@",key);
            
            
            Boolean valdiPattern=[self checkPattern:key];
            
            if (valdiPattern) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Change Pattern " message:@"" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Change Pattern",nil];
                alert.message=@"Your pattern is match. Do you wish to change pattern?";
                [alert show];
            }else {
                
                NSLog(@"pattern %@",loggedinPass);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Change Pattern " message: @"" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Re Try",nil];
                alert.message=@"Your Pattern is incorrect";
                [alert show];
                
            }
            
            
        }
    }else {
        
        
        NSString *strName=txtName.text;
        NSLog(@"Name is  %@",strName);
        if(strName.length==0)
        {
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Message" message:@"Please Enter Your Name." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            
        }else
        {
            Boolean  nameExixts= [self getUserName];
            if(nameExixts)
            {
                Boolean ValidKey =[self MatchPattern];
                if(ValidKey)
                {
                    [self getUSerID];
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
                                    output.outputSettings = @{AVVideoCodecKey: AVVideoCodecJPEG};
                                    
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
                                            //                                            NSString *path = [[NSBundle mainBundle] pathForResource:@"blank" ofType:@"wav"];
                                            //                                            SystemSoundID soundID;
                                            //                                            NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
                                            //                                            AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
                                            //                                            AudioServicesPlaySystemSound(soundID);
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
                        
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Fail!" message:@"You enterd a wrong pattern!! " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//                        [alert show];
                        
                    }
                    
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:@"Message" message:@"You are logged into System Successfully.." delegate:self cancelButtonTitle:@"Logout" otherButtonTitles:@"Continue" ,nil];
                    [alert show];
                }else {
                    passwordCounter ++;
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
                                    output.outputSettings = @{AVVideoCodecKey: AVVideoCodecJPEG};
                                    
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

                    
                   // else
                    //{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Fail!" message:@"You enterd a wrong pattern!! " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                        [alert show];
                   // }
                }
            }else {
                NSLog(@"This User is Not registered yet..!!");
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to be registered using password: " message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Register",nil];
                alert.message=loggedinPass;
                [alert show];
            }
        }
        
    }
    
    return key;
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

-(NSString *) getProperties :(NSString *)strProperty
{
    NSString *strReturn=@"false";
    databasepath=[app getDBPathNew];
    NSString *selectSql;
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
                NSString *checkValue = @((const char *) sqlite3_column_text(query_stmt, 0));
                
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



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

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
        loggedinNm=txtName.text;
        databasepath=[app getDBPathNew];
        if (sqlite3_open(databasepath.UTF8String, &dbSecret) == SQLITE_OK)
        {
            NSLog(@"unm==%@ ",loggedinNm);
            NSLog(@"pass=== %@",loggedinPass);
            
            NSString *selectSql = [NSString stringWithFormat:@"select * from VerifyUserTbl Where UserName=\"%@\" AND PatternCode=\"%@\" ",loggedinNm,loggedinPass];
            
            NSLog(@"Query : %@",selectSql);
            const char *sqlStatement = selectSql.UTF8String;
            sqlite3_stmt *query_stmt;
            
            if(sqlite3_prepare_v2(dbSecret, sqlStatement, -1, &query_stmt, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(query_stmt) == SQLITE_ROW)
                {
                    loggedinUserID = @((const char *) sqlite3_column_text(query_stmt, 0));
                    
                    NSLog(@"User id=== %@",loggedinUserID);
                    
                    app.LoginUserID=loggedinUserID;
                    
                    if(!isUserRegistered)
                    {
                        UIAlertView *alert = [[UIAlertView alloc]
                                              initWithTitle:@"Message" message:@"You are logged into System Successfully.." delegate:self cancelButtonTitle:@"Logout" otherButtonTitles:@"Continue" ,nil];
                        [alert show];
                        
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
                        
                    }
                }
                else
                {
                    NSLog(@"This User is Not registered yet..!!");
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to be registered using password: " message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Register",nil];
                    alert.message=loggedinPass;
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

-(void)viewWillAppear:(BOOL)animated
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        if(app.chngePWD)
        {
            
            [self.navigationController setNavigationBarHidden:NO];
            UIBarButtonItem *lefttButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                            style:UIBarButtonSystemItemDone target:self action:@selector(BtnSettingsClicked:)];
            self.navigationItem.leftBarButtonItem = lefttButton;
            
            self.title=@"Enter Current Pattern";
            
            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"ip-main-bg.png"]]];
            
            
            if(app.isReEnterPattern)//New Pattenr
            {
                [self.navigationController setNavigationBarHidden:NO];
                self.title=@"Re-Enter New Pattern";
                
            }else if(app.isNewPattern)//Re-Enter Pattern
            {
                
                [self.navigationController setNavigationBarHidden:NO];
                self.title=@"Enter New Pattern";
                
            }
            
        }else {
            
            [self.navigationController setNavigationBarHidden:YES];
            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"ipad-background.png"]]];
            
            UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(0, -15, 768,1024)];
            UIImage *subImage = [UIImage imageNamed:@"ipad-steel-bg.png"];
            subView.backgroundColor = [UIColor colorWithPatternImage:subImage];
            subView.userInteractionEnabled = NO;
            [self.view addSubview:subView];
            
            UIView *subViewBox = [[UIView alloc]initWithFrame:CGRectMake(100, 275, 564,643)];
            UIImage *subImageBox = [UIImage imageNamed:@"ipad-l-bg.png"];
            subViewBox.backgroundColor = [UIColor colorWithPatternImage:subImageBox];
            subViewBox.userInteractionEnabled = NO;
            
            UIView *openLock = [[UIView alloc]initWithFrame:CGRectMake(155, 67, 464, 59)];
            UIImage *openLockImg = [UIImage imageNamed:@"ipad-open-lock.png"];
            openLock.backgroundColor = [UIColor colorWithPatternImage:openLockImg];
            openLock.userInteractionEnabled = NO;
            
            UITextField *name = [[UITextField alloc]initWithFrame:CGRectMake(100, 200, 100, 25)];
            name.text = @"Name";
            name.userInteractionEnabled = NO;
            
            [self.view addSubview:openLock];
            [subView addSubview:subViewBox];
            [subView addSubview:openLock];
            [subView addSubview:name];
                
            txtName = [[UITextField alloc]init];
            txtName.frame = CGRectMake(212, 160, 453, 63);
            txtName.textColor = [UIColor whiteColor];
            txtName.font = [UIFont fontWithName:@"Helvitica" size:26.0];
            
            txtName.placeholder=@" Enter User Name";
            txtName.delegate=self;
            txtName.background = [UIImage imageNamed:@"l-namebg.png"];
                
            UIView *emailpaddingView = [[UIView alloc] initWithFrame:CGRectMake(10, 15, 20, 63)];
            txtName.leftView = emailpaddingView;
            txtName.leftViewMode = UITextFieldViewModeAlways;
            UIView *emailrightpaddingView = [[UIView alloc] initWithFrame:CGRectMake(30, 15, 20, 63)];
            txtName.rightView = emailrightpaddingView;
            txtName.rightViewMode =  UITextFieldViewModeAlways;
                
                
            // txtName.text =@"Name";
            [self.view addSubview:txtName];
            
            [self.view addSubview:openLock];
            
            [self.view addSubview:subViewBox];

            //self.view.backgroundColor = subView.backgroundColor;
            
            //[self.view addSubview:subView];
            
            
            
            //
            //       lbl=[[UILabel alloc]init];
            //       lbl.frame=CGRectMake(100, 10,100.0,50.0);
            //       lbl.text =@"Name";
            //       [self.view addSubview:lbl];
            
            
            
        }
    }else {
        
        if(app.chngePWD)
        {
            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"main-bg.png"]]];
            
            
            
            [self.navigationController setNavigationBarHidden:NO];
            UIBarButtonItem *lefttButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                            style:UIBarButtonSystemItemDone target:self action:@selector(BtnSettingsClicked:)];
            self.navigationItem.leftBarButtonItem = lefttButton;
            
            self.title = @"Enter Current Pattern";
            
            if(app.isReEnterPattern)
            {
                [self.navigationController setNavigationBarHidden:NO];
                self.title = @"Re-Enter New Pattern";
                
            }else if(app.isNewPattern)
            {
                [self.navigationController setNavigationBarHidden:NO];
                self.title = @"Enter New Pattern";
            }
            
        }else {
            
            CGSize result = [UIScreen mainScreen].bounds.size;
            
            if (result.height < 568){
                
                NSLog(@"Load iPhone 4");
                
                self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"iphone-n-back.png"]]];
                
                UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(0, -15, 320,480)];
                UIImage *subImage = [UIImage imageNamed:@"iphone-n-steel-bg.png"];
                subView.backgroundColor = [UIColor colorWithPatternImage:subImage];
                subView.userInteractionEnabled = NO;
                [self.view addSubview:subView];
                
                UIView *subViewBox = [[UIView alloc]initWithFrame:CGRectMake(40, 125, 244,314)];
                UIImage *subImageBox = [UIImage imageNamed:@"iphone-n-subview.png"];
                subViewBox.backgroundColor = [UIColor colorWithPatternImage:subImageBox];
                subViewBox.userInteractionEnabled = NO;
                
                UIView *openLock = [[UIView alloc]initWithFrame:CGRectMake(60, 30, 200, 26)];
                UIImage *openLockImg = [UIImage imageNamed:@"iphone-n-open-lock.png"];
                openLock.backgroundColor = [UIColor colorWithPatternImage:openLockImg];
                openLock.userInteractionEnabled = NO;
                
                UITextField *name = [[UITextField alloc]initWithFrame:CGRectMake(40, 90, 100, 25)];
                name.text = @"Name";
                name.userInteractionEnabled = NO;
                
                [self.view addSubview:openLock];
                [subView addSubview:subViewBox];
                [subView addSubview:openLock];
                [subView addSubview:name];
                
                self.navigationController.navigationBar.hidden =YES;
                txtName=[[UITextField alloc]init];
                txtName.font = [UIFont fontWithName:@"Helvitica" size:50.0];
                txtName.textColor = [UIColor whiteColor];
                txtName.frame=CGRectMake(90, 70,190,27);
                txtName.placeholder=@" Enter User Name";
                txtName.delegate=self;
                txtName.background = [UIImage imageNamed:@"l-namebg.png"];
                [self.view addSubview:txtName];

            }
            else{
                
                NSLog(@"Load iPhone 5");
                                
                self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"iphone-b-back-iPhone5.png"]]];
                
                UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,560)];
                UIImage *subImage = [UIImage imageNamed:@"iphone-n-steelbg-iphone5.png"];
                subView.backgroundColor = [UIColor colorWithPatternImage:subImage];
                subView.userInteractionEnabled = NO;
                [self.view addSubview:subView];
                
                UIView *subViewBox = [[UIView alloc]initWithFrame:CGRectMake(40, 160, 244,314)];
                UIImage *subImageBox = [UIImage imageNamed:@"iphone-n-subview.png"];
                subViewBox.backgroundColor = [UIColor colorWithPatternImage:subImageBox];
                subViewBox.userInteractionEnabled = NO;
                
                UIView *openLock = [[UIView alloc]initWithFrame:CGRectMake(60, 30, 200, 26)];
                UIImage *openLockImg = [UIImage imageNamed:@"iphone-n-open-lock.png"];
                openLock.backgroundColor = [UIColor colorWithPatternImage:openLockImg];
                openLock.userInteractionEnabled = NO;
                
                UITextField *name = [[UITextField alloc]initWithFrame:CGRectMake(40, 113, 100, 25)];
                name.text = @"Name";
                name.userInteractionEnabled = NO;
                
                [self.view addSubview:openLock];
                [subView addSubview:subViewBox];
                [subView addSubview:openLock];
                [subView addSubview:name];
                
                self.navigationController.navigationBar.hidden =YES;
                txtName=[[UITextField alloc]init];
                txtName.font = [UIFont fontWithName:@"Helvitica" size:50.0];
                txtName.textColor = [UIColor whiteColor];
                txtName.frame=CGRectMake(90, 110,190,27);
                txtName.placeholder=@" Enter User Name";
                txtName.delegate=self;
                txtName.background = [UIImage imageNamed:@"l-namebg.png"];
                [self.view addSubview:txtName];
            }

            
        }
        
    }
    for (UIView *view in self.view.subviews)
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    

    for (int i=0; i<MATRIX_SIZE; i++) {
        for (int j=0; j<MATRIX_SIZE; j++) {
            
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
            {
                UIImage *dotImage = [UIImage imageNamed:@"ipad-lock1.png"];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:dotImage
                                                           highlightedImage:[UIImage imageNamed:@"ipad-lock2.png"]];
                imageView.frame = CGRectMake(0, 0, dotImage.size.width, dotImage.size.height);
                imageView.userInteractionEnabled = YES;
                imageView.tag = j*MATRIX_SIZE + i + 1;
                [self.view addSubview:imageView];
                
            }else{
                UIImage *dotImage = [UIImage imageNamed:@"iphone-n-lock1.png"];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:dotImage
                                                           highlightedImage:[UIImage imageNamed:@"iphone-n-lock2.png"]];
                imageView.frame = CGRectMake(0, 0, dotImage.size.width, dotImage.size.height);
                imageView.userInteractionEnabled = YES;
                imageView.tag = j*MATRIX_SIZE + i + 1;
                [self.view addSubview:imageView];
            }
            
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver: self  selector: @selector(handleEnterForeground:) name: @"UIApplicationDidBecomeActiveNotification" object: nil];
}

- (void) handleEnterForeground: (NSNotification*) sender
{
    app.flagTapForTap = true;
}

-(void)viewWillDisappear:(BOOL)animated
{
    //if(app.blNVFromNewPattern)
    //{
    //    app.isNewPattern=NO;
    //    app.isReEnterPattern=NO;
    //}
    //    if(app.blNVFromReEnter)
    //    {
    //        app.isNewPattern=NO;
    //        //app.isReEnterPattern=NO;
    //    }
    
}
-(Boolean) MatchPattern
{
    Boolean valueReturn = '\0';
    if([txtName.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Message" message:@"Please Enter Your Name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    else
    {
        loggedinNm=txtName.text;
        databasepath=[app getDBPathNew];
        if (sqlite3_open(databasepath.UTF8String, &dbSecret) == SQLITE_OK)
        {
            NSLog(@"unm==%@ ",loggedinNm);
            NSLog(@"pass=== %@",loggedinPass);
            
            NSString *selectSql = [NSString stringWithFormat:@"select * from VerifyUserTbl Where UserName=\"%@\" AND PatternCode=\"%@\" ",loggedinNm,loggedinPass];
            
            NSLog(@"Query : %@",selectSql);
            const char *sqlStatement = selectSql.UTF8String;
            sqlite3_stmt *query_stmt;
            
            if(sqlite3_prepare_v2(dbSecret, sqlStatement, -1, &query_stmt, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(query_stmt) == SQLITE_ROW)
                {
                    loggedinUserID = @((const char *) sqlite3_column_text(query_stmt, 0));
                    
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
        }
        else {
            valueReturn =false;
        }
    }
    
    sqlite3_close(dbSecret);
    return valueReturn;
    
}
- (void)setTarget:(id)target withAction:(SEL)action {
    _target = target;
    _action = action;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Register"])
    {
        [self registerUser];
        [self getUSerID];
        [self addProperty];
        [self addAuthenticaStyle];
        //[self sendMail];
    }
    else if ([title isEqualToString:@"Cancel"]) {
        loggedinUserID=@"";
        app.LoginUserID=@"";
        txtName.text=@"";
        //lblPassword.text=@"";
        loggedinPass=@"";
    }
    else if([title isEqualToString:@"Continue"])
    {
        app.flagTapForTap = true;
        
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
    else if([title isEqualToString:@"Send"])
    {
        [self sendMail];
        NSLog(@"Send Mail");
        //        isUserRegistered=true;
        //        [self searchUser];
    }
    else if([title isEqualToString:@"YES"])
    {
        //        [self recognize:nil];
    }
    else if([title isEqualToString:@"Logout"])
    {
        UserName=@"";
        loggedinUserID=@"";
        app.LoginUserID=@"";
        txtName.text=@"";
        loggedinPass=@"";
    } else if([title isEqualToString:@"Change Pattern"])
    {
        app.isNewPattern=true;
        DrawPatternLockViewController *drwNew=[[DrawPatternLockViewController alloc]init];
        [self.navigationController pushViewController:drwNew animated:YES];
    }else if([title isEqualToString:@"Re Enter"])
    {
        app.isReEnterPattern=true;
        DrawPatternLockViewController *drwNew=[[DrawPatternLockViewController alloc]init];
        [self.navigationController pushViewController:drwNew animated:YES];
    }else if([title isEqualToString:@"Confirm"])
    {
        Boolean isUpadated=[self updatePassword:app.newLogInPattern :app.LoginUserID];
        [self updateLockStyle:app.LoginUserID];
        //[app.userDefaults setObject:@"Pattern" forKey:@"LockMethod"];
        //  NSLog(@" IS Changed %@",isChanged);
        if(isUpadated)
        {
            app.chngePWD=NO;
            app.isNewPattern=NO;
            app.isReEnterPattern=NO;
            app.isnAvigateFromPattern=YES;
            ColorPickerController *_colorPicker;
            _colorPicker = [[ColorPickerController alloc] initWithStyle:UITableViewStyleGrouped];
            //   _colorPicker.delegate = self;
            // DrawPatternLockViewController *drwNew=[[DrawPatternLockViewController alloc]init];
            
            app.userDefaults = [NSUserDefaults standardUserDefaults];
            // saving an NSString
            [app.userDefaults setObject:@"Pattern" forKey:@"LockMethod"];
            app.loginMethod = @"Pattern";
            
            [self.navigationController pushViewController:_colorPicker animated:YES];
        }
    }
    else if([title isEqualToString:@"Close"])
    {
        // app.chngePWD=NO;
        app.isNewPattern=NO;
        app.isReEnterPattern=NO;
        app.isnAvigateFromPattern=YES;
        
        
        ColorPickerController *_colorPicker;
        _colorPicker = [[ColorPickerController alloc] initWithStyle:UITableViewStyleGrouped] ;
        //   _colorPicker.delegate = self;
        [self.navigationController pushViewController:_colorPicker animated:YES];
        
        
    }
}

-(NSString *) getUSerID
{
    loggedinNm=txtName.text;
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
                loggedinUserID = @((const char *) sqlite3_column_text(query_stmt, 0));
                
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
-(Boolean) getUserName
{
    Boolean returnValue;
    loggedinNm=txtName.text;
    
    
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
                UserName = @((const char *) sqlite3_column_text(query_stmt, 1));
                
                NSLog(@"User Name is === %@",UserName);
                
                
                returnValue = true;
                
                //                app.LoginUserID=loggedinUserID;
            }
            else
            {
                
                returnValue =false;
                
            }
            sqlite3_finalize(query_stmt);
        }
        else
        {
            returnValue = false;
        }
    }
    else
    {
        returnValue =false;
    }
    sqlite3_close(dbSecret);
    return  returnValue ;
}

-(Boolean) checkPattern : (NSString *)strPattern
{
    Boolean returnValue;
    databasepath=[app getDBPathNew];
    if (sqlite3_open(databasepath.UTF8String, &dbSecret) == SQLITE_OK)
    {
        NSLog(@"unm==%@ ",loggedinNm);
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
                    NSString *strPatternCode = @((const char *) sqlite3_column_text(query_stmt, 0));
                    
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


-(void)registerUser
{
    sqlite3_close(dbSecret);
    
    sqlite3_stmt *stmt;
    databasepath=[app getDBPathNew];
    const char *dbpath=databasepath.UTF8String;
    if(sqlite3_open(dbpath, &dbSecret) == SQLITE_OK)
    {
        NSString *insertquery=[NSString stringWithFormat:@"Insert into VerifyUserTbl(UserName,PatternCode) VALUES(\"%@\",\"%@\")",loggedinNm,loggedinPass];
        
        NSLog(@"insert query== %@",insertquery);
        
        const char *insert_query=insertquery.UTF8String;
        sqlite3_prepare(dbSecret, insert_query, -1, &stmt, NULL);
        
        if(sqlite3_step(stmt)== SQLITE_DONE)
        {
            NSLog(@"user Inserted..");
            
            app.flagTapForTap = true;
            
            RootViewController *root;
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
            {
                root = [[RootViewController alloc] initWithNibName:@"RootViewcontroller_Ipad" bundle:nil];
            }
            else {
                root = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
            }
            
            [self.navigationController pushViewController:root animated:YES];
            
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Message" message:@"It is highly recommended that you back up this passcode to your email, If you forget this passcode you will not be able to access your account, would you like this passcode sent to your mail box?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Send" ,nil];
            [alert show];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry" message:@"Failed To Register.." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
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
        
        NSString *insertquery=[NSString stringWithFormat:@"Insert into AuthentictionCheckTbl(VoiceAuth,PatternAuth,UserID,PinCodeAuth) VALUES (\"false\",\"true\",%@,\"false\")",app.LoginUserID];
        
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


-(Boolean) updatePassword :(NSString *)strValue :(NSString * )UserID
{
    sqlite3_stmt *statement = NULL;
    
    if(sqlite3_open([app getDBPathNew].UTF8String,&dbSecret)== SQLITE_OK)
    {
        NSString *insertquery;
        insertquery=[NSString stringWithFormat:@"UPDATE VerifyUserTbl SET PatternCode =\"%@\" where UserID=%@",strValue,UserID];
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
        insertquery=[NSString stringWithFormat:@"UPDATE AuthentictionCheckTbl SET VoiceAuth =\"%@\" ,PatternAuth =\"%@\",PinCodeAuth =\"%@\"  where UserID=%@",@"false",@"true",@"false",UserID];
        NSLog(@"Query::::%@",insertquery);
        const char *insert_query=insertquery.UTF8String;
        sqlite3_prepare(dbSecret,insert_query,-1,&statement,NULL);
        if(sqlite3_step(statement) == SQLITE_DONE){
            NSLog(@"record updated");
            sqlite3_finalize(statement);
            sqlite3_close(dbSecret);
            
            app.userDefaults = [NSUserDefaults standardUserDefaults];
            // saving an NSString
            //[app.userDefaults setValue:@"PinCode" forKey:@"LockMethod"];
            //[app.userDefaults synchronize];
            [GlobalFunctions setStringValueToUserDefaults:@"Pattern" ForKey:@"LockMethod2"];
            NSLog(@"%@",[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"LockMethod2"]);
            app.loginMethod = @"Pattern";
            
//            NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
//            [us setValue:@"PinCode" forKey:@"LockMethod2"];
//            [us synchronize];
            
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

//-(void)registerUser
//{
//    sqlite3_stmt *stmt;
//    databasepath=[app getDBPath];
//    const char *dbpath=[databasepath UTF8String];
//    if(sqlite3_open(dbpath, &dbSecret) == SQLITE_OK)
//    {
//        NSString *insertquery=[NSString stringWithFormat:@"Insert into VerifyUserTbl(UserName,UserPasswordTxt,UserVoiceTxt) VALUES(\"%@\",\"%@\",\"%@\")",loggedinNm,loggedinPass,@""];
//
//        NSLog(@"insert query== %@",insertquery);
//
//        const char *insert_query=[insertquery UTF8String];
//        sqlite3_prepare(dbSecret, insert_query, -1, &stmt, NULL);
//
//        if(sqlite3_step(stmt)== SQLITE_DONE)
//        {
//            NSLog(@"user Inserted..");
//
//            UIAlertView *alert = [[UIAlertView alloc]
//                                  initWithTitle:@"Message" message:@"You are logged into System Successfully.." delegate:self cancelButtonTitle:@"Logout" otherButtonTitles:@"OK" ,nil];
//            [alert show];
//        //   [alert release];
//        }
//        else
//        {
//            UIAlertView *alert = [[UIAlertView alloc]
//                                  initWithTitle:@"Sorry" message:@"Failed To Register.." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//         //   [alert release];
//        }
//        sqlite3_finalize(stmt);
//        sqlite3_close(dbSecret);
//    }
//}


#pragma mark - Send Mail

- (IBAction)sendMail
{
#ifdef LITEVERSION
   
    if ([MFMailComposeViewController canSendMail])
    {
        [self dismissViewControllerAnimated:NO completion:nil];
        
        MFMailComposeViewController *mfViewController = [[MFMailComposeViewController alloc] init];
        mfViewController.mailComposeDelegate = self;
        [mfViewController setSubject:@"Secret Vault Passcode"];
        [mfViewController setMessageBody:@"Your Secret Vault Passcode" isHTML:YES];
        NSString *someString = [NSString stringWithFormat:@"This is a your Secret Vault passcode. Don't share with anyone, It's confidencial...<br/><a href=\"https://itunes.apple.com/us/app/secret-app/id569771443?ls=1&mt=8\">Secret Vault on itunes</a><br/>Your Username is: %@.<br/> Your passcode is : %@",[self currentUserName:app.LoginUserID],loggedinPass ];
        [mfViewController setMessageBody:someString isHTML:YES];
        
//        NSString *path;
//        path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"ScreenShot"];
//        NSString *screenShotFilePath = [path stringByAppendingPathComponent:@"screenshot.jpg"];
//        
//        UIImage *image=[UIImage imageWithContentsOfFile:screenShotFilePath];
        
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        [mfViewController addAttachmentData:data  mimeType:@"image/jpeg" fileName:@"screenshot.jpg"];
         app.flagTapForTap = false;
        [self presentViewController:mfViewController animated:YES completion:nil];
    }
#else
    if ([MFMailComposeViewController canSendMail])
    {
        [self dismissViewControllerAnimated:NO completion:nil];
        
        MFMailComposeViewController *mfViewController = [[MFMailComposeViewController alloc] init];
        mfViewController.mailComposeDelegate = self;
        [mfViewController setSubject:@"Secret Vault Pro Passcode"];
        [mfViewController setMessageBody:@"Your Secret Vault Pro Passcode" isHTML:YES];
        //GoProLink
        NSString *someString = [NSString stringWithFormat:@"This is a your Secret Vault Pro passcode. Don't share with anyone, It's confidencial...<br/><a href=\"https://itunes.apple.com/us/app/secret-vault-pro-plus/id873504069?ls=1&mt=8\">Secret Vault Pro on itunes</a><br/>Your Username is: %@.<br/> Your passcode is : %@",[self currentUserName:app.LoginUserID],loggedinPass ];
        [mfViewController setMessageBody:someString isHTML:YES];
        
        //        NSString *path;
        //        path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"ScreenShot"];
        //        NSString *screenShotFilePath = [path stringByAppendingPathComponent:@"screenshot.jpg"];
        //
        //        UIImage *image=[UIImage imageWithContentsOfFile:screenShotFilePath];
        
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        [mfViewController addAttachmentData:data  mimeType:@"image/jpeg" fileName:@"screenshot.jpg"];
        
        [self presentViewController:mfViewController animated:YES completion:nil];
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
     app.flagTapForTap = false;
    [alert show];
}

#pragma mark - CHECK PIN CODE LOCK
/*
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
 }else {
 sqlite3_finalize(query_stmt);
 }
 }
 sqlite3_close(dbSecret);
 return strReturn;
 }
 
 
 }
 */

#pragma mark - IN APP PURCHASE

//- (void)timeout:(id)arg {
//
//    _hud.labelText = @"Timeout!";
//    _hud.detailsLabelText = @"Please try again later.";
//    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
//    _hud.mode = MBProgressHUDModeCustomView;
//    [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:3.0];
////    if (isFree==NO) {
////        [self FreeCard:@"Birthday"];
////    }
//
//
//}
//- (void)dismissHUD:(id)arg
//{
//
//    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
//    _hud = nil;
//
//}
//- (void)productsLoaded:(NSNotification *)notification {
//
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
//    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
////    if (isFree==NO)
////    {
////        [self FreeCard:@"Birthday"];
////    }
//
//}
//- (void)productPurchased:(NSNotification *)notification {
//
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
//    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
//
//    NSString *productIdentifier = (NSString *)notification.object;
//    NSLog(@"Purchased: %@", productIdentifier);
//
////    if (isCosume==YES) {
////        app.Image_select=YES;
////    }
////
////    [app.Purchase_array removeAllObjects];
////    [[InAppRageIAPHelper alloc]init];
////    isCosume=NO;
////    CATransition *transition = [CATransition animation];
////    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
////    NSString *types[4] = {kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};
////    NSString *subtypes[4] = {kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
////
////    transition.type = types[1];
////
////    transition.subtype = subtypes[3];
////    [transition setDuration:1.0];
////    transition.delegate = self;
////    [Buy_vw.layer addAnimation:transition forKey:nil];
////    Buy_vw.hidden=YES;
////    Info_view.hidden=YES;
////    [self ReplaceBuyimage];
//}
//- (void)productPurchaseFailed:(NSNotification *)notification {
//
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
//    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
//
////    isCosume=NO;
////
////    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notification.object;
////    if (transaction.error.code != SKErrorPaymentCancelled) {
////        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error!"
////                                                         message:transaction.error.localizedDescription
////                                                        delegate:nil
////                                               cancelButtonTitle:nil
////                                               otherButtonTitles:@"OK", nil] autorelease];
////
////        [alert show];
////    }
//
//}

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
//        sqlite3_finalize(query_stmt);
    }else {
        pass = @"";
    }
    
    sqlite3_close(dbSecret);
    return  pass;
}


- (void)messageComposeViewController:(nonnull MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result { 
    return;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder { 
    return;
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection { 
    return;
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container { 
    return;
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container { 
    return;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator { 
    return;
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator { 
    return;
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator { 
    return;
}

- (void)setNeedsFocusUpdate { 
    return;
}

- (void)updateFocusIfNeeded { 
    return;
}

@end
