//
//  Add_ImportContactView.m
//  SecretApp
//
//  Created by c62 on 17/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Add_ImportContactView.h"
#import "AppDelegate.h"
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"
#import "GADInterstitial.h"

@interface Add_ImportContactView () <GADInterstitialDelegate, GADBannerViewDelegate>

@property (nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation Add_ImportContactView
@synthesize rateView,scrlVw,contImage,imgpath;
@synthesize dialBtn,mailBtn;
@synthesize txtConNum,txtConNote,txtconEmail,txtContName,textClick,clickImageBtn;
@synthesize vwControl;
@synthesize subAdView;
@synthesize interstitial;
@synthesize imgHeader;
@synthesize contactEmail,contactName,contactNote,contactPhone,contactPic,contactRating;

float rate;

AppDelegate *app;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    [subAdView release];
    [vwControl release];
    [dialBtn release];
    [mailBtn release];
    [imgpath release];
    [clickImageBtn release];
    [textClick release];
    [contImage release];
    [txtconEmail release];
    [txtContName release];
    [txtConNum release];
    [txtConNote release];
    [scrlVw release];
    [imgHeader release];
    [super dealloc];
}
-(Boolean)CheckValidation
{
    Boolean returnVal=true;
    
   
    
    if([txtContName.text isEqualToString:@""])
    {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        alert.message = @"Contact name is blank, Please Enter Contact name";
        [alert show];
        [alert release];
        returnVal =false;
    }else if([txtConNum.text isEqualToString:@""]){
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.message = @"Contact number is blank, Please Enter Contact number";
        [alert show];
        [alert release];
        returnVal=false;
    }
    
   
    
    return returnVal;
}

-(void)resignKeyboard {
    [txtConNote resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.navigationController setNavigationBarHidden:NO];
    [subAdView setBackgroundColor:[UIColor clearColor]];
    
     if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
     {
         if (app.EditContactFlag)
         {
             [imgHeader setImage:[UIImage imageNamed:@"edit-contact.png"]];
         }
         else
         {
             [imgHeader setImage:[UIImage imageNamed:@"ipad-contact.png"]];
         }

         txtConNote.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-combg.png"]];
        
         
         UIView *emailpaddingView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 20, 30)];
         txtconEmail.leftView = emailpaddingView;
         txtconEmail.leftViewMode = UITextFieldViewModeAlways;
         UIView *emailrightpaddingView = [[UIView alloc] initWithFrame:CGRectMake(30, 10, 65, 61)];
         txtconEmail.rightView = emailrightpaddingView;
         txtconEmail.rightViewMode =  UITextFieldViewModeAlways;
         
         UIView *conpaddingView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 20, 30)];
         txtConNum.leftView = conpaddingView;
         txtConNum.leftViewMode = UITextFieldViewModeAlways;
         UIView *conrightpaddingView = [[UIView alloc] initWithFrame:CGRectMake(30, 10, 65, 61)];
         txtConNum.rightView = conrightpaddingView;
         txtConNum.rightViewMode =  UITextFieldViewModeAlways;
         
         UIView *namepaddingView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 20, 30)];
         txtContName.leftView = namepaddingView;
         txtContName.leftViewMode = UITextFieldViewModeAlways;
         UIView *namerightpaddingView = [[UIView alloc] initWithFrame:CGRectMake(30, 10, 65, 61)];
         txtContName.rightView = namerightpaddingView;
         txtContName.rightViewMode =  UITextFieldViewModeAlways;
#ifdef LITEVERSION
         // Tap For Tap Adview Starts Here
         if(![[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"BreakInPackagePurchased"] isEqualToString:@"YES"])
         {
             if(![[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"AdPackagePurchased"] isEqualToString:@"YES"])
             {
                /* self.interstitial = [TFTInterstitial interstitialWithDelegate:self];
                 [self.interstitial load];
                 [self.interstitial showWithViewController: self];*/
                 self.interstitial = [GADHelper createAndLoadInterstitial:self];
             }
             
         }
         // Tap For Tap Adview Ends Here
#else
#endif
         
     }
    else
    {
        if (app.EditContactFlag)
        {
            [imgHeader setImage:[UIImage imageNamed:@"iphone-n-edit-contact.png"]];
        }
        else
        {
            [imgHeader setImage:[UIImage imageNamed:@"ipad-contact.png"]];
        }
        
        UIToolbar *toolbar = [[[UIToolbar alloc] init] autorelease];
        [toolbar setBarStyle:UIBarStyleBlackTranslucent];
        [toolbar sizeToFit];
        
        UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard)];
        
#ifdef LITEVERSION
        // Tap For Tap Adview Starts Here
        if(![[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"BreakInPackagePurchased"] isEqualToString:@"YES"])
        {
            if(![[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"AdPackagePurchased"] isEqualToString:@"YES"])
            {
                NSLog(@"Content Printing Started At :: %f",scrlVw.bounds.size.height-50);
                /*self.interstitial = [TFTInterstitial interstitialWithDelegate:self];
                [self.interstitial load];
                [self.interstitial showWithViewController: self];*/
                self.interstitial = [GADHelper createAndLoadInterstitial:self];
            }
            
        }
        // Tap For Tap Adview Ends Here
#else
#endif
        NSArray *itemsArray = [NSArray arrayWithObjects:flexButton, doneButton, nil];
        
        [flexButton release];
        [doneButton release];
        [toolbar setItems:itemsArray];
        
        [txtConNote setInputAccessoryView:toolbar];
    }
   
    
    //delegate
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if(app.EditContactFlag){
        
        self.title=@"Edit Contact";
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                        style:UIBarButtonSystemItemDone target:self action:@selector(InsertContact)];
        self.navigationItem.rightBarButtonItem = rightButton;
        [rightButton release];

    }else {
        
    
        self.title=@"Add Contact";
//        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
//                                                                        style:UIBarButtonSystemItemDone target:self action:@selector(InsertContact)];
//        self.navigationItem.rightBarButtonItem = rightButton;
//        [rightButton release];    
    }
    //Top buttons//
    
    
    //Scrollview
    if(UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)
    {
        scrlVw.scrollEnabled = YES;
        scrlVw.delegate = self;
        scrlVw.contentSize=CGSizeMake(768, 1500);
        [self.view addSubview:scrlVw]; 
    }
    else 
    {
        scrlVw.scrollEnabled = YES;
        scrlVw.delegate = self;
        
        NSLog(@"View Size :: %f",self.view.bounds.size.height);
        
        scrlVw.contentSize=CGSizeMake(300, 400);
        [self.view addSubview:scrlVw];   
    }
    if(app.EditContactFlag) // Set controls with fileds to edit
    {
        txtContName.text=app.conNm;
        txtConNum.text=app.conPhone;
        txtconEmail.text=app.conEmail;
        txtConNote.text=app.ConNote;
        NSLog(@" Length %d", app.conImg.length);
         if(app.conImg.length <=7)
         {
             contImage.image=[UIImage imageNamed:@"ipad-addimage.png"];
         }else 
         {
                         contImage.image=[UIImage imageWithContentsOfFile:app.conImg];
                         NSLog(@"Image path from delegate::: %@",app.conImg);
         }
        
        //Rating code//
        self.rateView.notSelectedImage = [UIImage imageNamed:@"star1.png"];
        self.rateView.halfSelectedImage = [UIImage imageNamed:@"half_star.png"];
        self.rateView.fullSelectedImage = [UIImage imageNamed:@"star2.png"];
        self.rateView.rating = [app.conRate intValue];
        self.rateView.editable = YES;
        self.rateView.maxRating = 5;
        self.rateView.delegate = self;
        
        [dialBtn setUserInteractionEnabled:true];
        [mailBtn setUserInteractionEnabled:true];
        
    }
    else // Set controls with empty filed to insert
    {
        [dialBtn setUserInteractionEnabled:false];
        [mailBtn setUserInteractionEnabled:false];
        txtContName.text=@"";
        txtConNum.text=@"";
        txtconEmail.text=@"";
        txtConNote.text=@"";
        contImage.image=[UIImage imageNamed:@"ipad-addimage.png"];
        //Rating code//
        
        CGFloat result = self.view.bounds.size.height;
        
        self.rateView.notSelectedImage = [UIImage imageNamed:@"star1.png"];
        self.rateView.halfSelectedImage = [UIImage imageNamed:@"half_star.png"];
        self.rateView.fullSelectedImage = [UIImage imageNamed:@"star2.png"];
        self.rateView.rating = 0;
        self.rateView.editable = YES;
        self.rateView.maxRating = 5;
        self.rateView.delegate = self;
    }
}

-(IBAction)tapBackground:(id)sender
{
    [txtConNum resignFirstResponder];
    [txtConNote resignFirstResponder];
}
- (void)viewDidUnload
{
    [self setRateView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma  mark - Call button Actionsheet

-(IBAction)btnCallContactPressed
{
    if([txtConNum.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please enter The Number First.." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contact" message:@"Choose" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Call",@"SMS",nil]; 
        [alert show];
        [alert release];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    /********* On Confirmation to dial contact  ***********/
    if([title isEqualToString:@"Call"])
    {
        [self dialNum];
    }
    else if([title isEqualToString:@"Continue"])
    {
        NSLog(@"Phone num::: %@",app.conPhone);
        NSString *phoneNumber = txtConNum.text;
        NSString *telString = [NSString stringWithFormat:@"tel:%@", phoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
        app.conPhone=txtConNum.text;
    }
    else if([title isEqualToString:@"SMS"])
    {
        [self sendSMS:@"SMS Body" recipientList:[NSArray arrayWithObjects:app.conPhone, nil]];
    }   
}

#pragma mark - Dial number method

-(IBAction)dialNum
{
    bool callflag;
    callflag=[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
    NSLog(@"The value of the bool is %@\n", (callflag ? @"YES" : @"NO"));
    
    if(callflag)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Calling this contact will close the application.Do you want to continue?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert addButtonWithTitle:@"Continue"];
        [alert show];
        [alert release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Your Device Doesn't Support Dial Facility.." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

#pragma mark Send SMS method

- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;    
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    switch (result) {
            
        case MessageComposeResultCancelled:
            alert.message = @"Message Canceled";
            break;
        case MessageComposeResultSent:
            alert.message = @"Message Sent";
            break;
        default:
            alert.message = @"Message Sending Failed.";
        break;	}
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [alert show];
    [alert release];
    
}

#pragma  mark - Send Mail

-(IBAction)sendMail
{
    if ([MFMailComposeViewController canSendMail]) 
    {
        MFMailComposeViewController *mfViewController = [[MFMailComposeViewController alloc] init];
        mfViewController.mailComposeDelegate = self;
        [mfViewController setSubject:@"Subject"];
        
        [mfViewController setMessageBody:@"Message Body" isHTML:YES];
        
        NSArray *toRecipients = [NSArray arrayWithObject:app.conNm]; 
        [mfViewController setToRecipients:toRecipients];
        
        [self presentViewController:mfViewController animated:YES completion:nil];
        [mfViewController release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"Your phone is not currently configured to send mail." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }   
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    switch (result) {
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
        break;	}
   [self dismissViewControllerAnimated:YES completion:nil];
    
    [alert show];
    [alert release];
}

#pragma mark - Rating Method

- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    
    rate = rating;
    NSLog(@"\n Rate ===> %f", rate);
}

#pragma mark - AddContact Actionsheet Methods

-(IBAction)btnClickImagePressed{
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Choose" delegate:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open Camera",@"Open Gallery", nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleDefault;
    popupQuery.delegate=self;
    [popupQuery showInView:self.view];
    [popupQuery release];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0)
    {
        @try
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;        
            imagePicker.delegate = self;
            imagePicker.showsCameraControls = YES;
            imagePicker.navigationBarHidden = YES;
            imagePicker.wantsFullScreenLayout = YES;
            
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        @catch (NSException *exception) 
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Camera" message:@"Camera is not available  " delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
    else if (buttonIndex == 1)
    {
        [self dismissViewControllerAnimated:NO completion:nil];
        
        if ([UIImagePickerController isSourceTypeAvailable :UIImagePickerControllerSourceTypePhotoLibrary])
        {
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
            {
                UIImagePickerController *UserPhotoPicker = [[UIImagePickerController alloc]init];
                UserPhotoPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                [UserPhotoPicker setDelegate:self];
                UserPhotoPicker.navigationBar.tintColor = [UIColor blackColor];
                
                app.objPopOverController = [[UIPopoverController alloc] initWithContentViewController:UserPhotoPicker];
                [app.objPopOverController setDelegate:self];    
                [app.objPopOverController presentPopoverFromRect:CGRectMake(250,400, 1,1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            }
            else
            {
                UIImagePickerController *picker =[[UIImagePickerController alloc]init];
                picker.delegate  = self   ;
                picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:picker animated:YES completion:nil];
                [picker release];
            }
        }
    }
    else
    {
        NSLog(@"Cancel..");
    }
}

#pragma mark - set Image from gallery & camera 

-(void)imagePickerController:(UIImagePickerController *)picker
       didFinishPickingImage:(UIImage *)image
                 editingInfo:(NSDictionary *)editingInfo
{
    NSString *nameofimg=[NSString stringWithFormat:@"%@",image];
    
 	NSString *substring=[nameofimg substringFromIndex:12];
    NSString *new=[substring substringToIndex:7];
    
    NSData * imageData = UIImageJPEGRepresentation(image, 1.0);
    
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentdirectory=[path objectAtIndex:0];
    
    NSString *newFilePath = [NSString stringWithFormat:[documentdirectory stringByAppendingPathComponent: @"/%@.png"],new];
    self.imgpath=[NSString stringWithFormat:@"%@",newFilePath];
    
    if (imageData != nil)
    {
        [imageData writeToFile:newFilePath atomically:YES];
        contImage.image=[UIImage imageWithContentsOfFile:imgpath];
        app.conImg=self.imgpath;
    }
    
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *) picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)go:(id)sender
{    
    [sender resignFirstResponder];
}

-(IBAction)btnResetClicked:(id)sender
{
    txtconEmail.text = @"";
    txtConNote.text = @"";
    txtConNum.text = @"";
    txtContName.text = @"";
}

-(IBAction)btnSaveClicked:(id)sender
{
    if(app.EditContactFlag)
    {
        app.EditContactFlag=NO;
        NSString *streditRate=[NSString stringWithFormat:@"%f",rate];
        NSLog(@"edited Rate:::: %@",streditRate);
        
        databasepath=[app getDBPathNew];
        if (sqlite3_open([databasepath UTF8String], &dbSecret) == SQLITE_OK)
        {
            NSString *selectSql = [NSString stringWithFormat:@"Update ContactTbl set ContName=\"%@\",ContPhone=\"%@\",ContactEmail=\"%@\",ContactRating=\"%@\",ContNote=\"%@\",ContPic=\"%@\" Where ContactID=%d ;",txtContName.text,txtConNum.text,txtconEmail.text,streditRate,txtConNote.text,app.conImg,[app.conid intValue]];
            
            NSLog(@"Query : %@",selectSql);
            const char *sqlStatement = [selectSql UTF8String];
            sqlite3_stmt *query_stmt;
            sqlite3_prepare(dbSecret, sqlStatement, -1, &query_stmt, NULL);
            
            if(sqlite3_step(query_stmt)== SQLITE_DONE)
            {
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Sorry" message:@"Failed To Update Data..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                
            }
            sqlite3_finalize(query_stmt);
        }
        sqlite3_close(dbSecret);
    }
    else
    {
        if([self CheckValidation])
        {
            NSString *strRate=[NSString stringWithFormat:@"%f",rate];
            NSLog(@"Rate:::: %@",strRate);
            NSLog(@"Path from save method==> %@",imgpath);
            sqlite3_stmt *stmt;
            databasepath=[app getDBPathNew];
            const char *dbpath=[databasepath UTF8String];
            if(sqlite3_open(dbpath, &dbSecret) == SQLITE_OK)
            {
                
                
                NSString *insertquery=[NSString stringWithFormat:@"Insert into ContactTbl (UserID,ContName,ContPhone,ContactEmail,ContactRating,ContNote,ContPic) VALUES(%d,\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",[app.LoginUserID intValue],txtContName.text,txtConNum.text,txtconEmail.text,strRate,txtConNote.text,imgpath];
                
                NSLog(@"insert Query::::> %@",insertquery);
                
                const char *insert_query=[insertquery UTF8String];
                sqlite3_prepare(dbSecret, insert_query, -1, &stmt, NULL);
                
                if(sqlite3_step(stmt)== SQLITE_DONE)
                {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:@"Sorry" message:@"Failed To Insert Data.." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                }
                sqlite3_finalize(stmt);
                sqlite3_close(dbSecret);
            }
        }
    }

}

#pragma mark - Save & EditContact

-(void)InsertContact{
    if(app.EditContactFlag)
    {
        app.EditContactFlag=NO;
        NSString *streditRate=[NSString stringWithFormat:@"%f",rate];
        NSLog(@"edited Rate:::: %@",streditRate);
        
        databasepath=[app getDBPathNew];
        if (sqlite3_open([databasepath UTF8String], &dbSecret) == SQLITE_OK) 
        {
            NSString *selectSql = [NSString stringWithFormat:@"Update ContactTbl set ContName=\"%@\",ContPhone=\"%@\",ContactEmail=\"%@\",ContactRating=\"%@\",ContNote=\"%@\",ContPic=\"%@\" Where ContactID=%d ;",txtContName.text,txtConNum.text,txtconEmail.text,streditRate,txtConNote.text,app.conImg,[app.conid intValue]];
            
            NSLog(@"Query : %@",selectSql);
            const char *sqlStatement = [selectSql UTF8String];
            sqlite3_stmt *query_stmt;
            sqlite3_prepare(dbSecret, sqlStatement, -1, &query_stmt, NULL);
            
            if(sqlite3_step(query_stmt)== SQLITE_DONE)
            {
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Sorry" message:@"Failed To Update Data..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                
            }
            sqlite3_finalize(query_stmt);
        }
        sqlite3_close(dbSecret);
    }    
    else
    {
        if([self CheckValidation])
        {
            NSString *strRate=[NSString stringWithFormat:@"%f",rate];
            NSLog(@"Rate:::: %@",strRate);
            NSLog(@"Path from save method==> %@",imgpath);
            sqlite3_stmt *stmt;
            databasepath=[app getDBPathNew];
            const char *dbpath=[databasepath UTF8String];
            if(sqlite3_open(dbpath, &dbSecret) == SQLITE_OK)
            {
                
                
                NSString *insertquery=[NSString stringWithFormat:@"Insert into ContactTbl (UserID,ContName,ContPhone,ContactEmail,ContactRating,ContNote,ContPic) VALUES(%d,\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",[app.LoginUserID intValue],txtContName.text,txtConNum.text,txtconEmail.text,strRate,txtConNote.text,imgpath];
                
                NSLog(@"insert Query::::> %@",insertquery);
                
                const char *insert_query=[insertquery UTF8String];
                sqlite3_prepare(dbSecret, insert_query, -1, &stmt, NULL);
                
                if(sqlite3_step(stmt)== SQLITE_DONE)
                {          
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                { 
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:@"Sorry" message:@"Failed To Insert Data.." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                }
                sqlite3_finalize(stmt);
                sqlite3_close(dbSecret);
            }
        }
    }
}

#pragma mark - GADDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    if(self == self.navigationController.topViewController)
        [self.interstitial presentFromRootViewController:self];
}

@end
