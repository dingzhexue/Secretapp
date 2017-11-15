//
//  ContactListView.m
//  SecretApp
//
//  Created by c62 on 17/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactListView.h"
#import "ContactCustomCell.h"
#import "Add_ImportContactView.h"
#import "ImportContactView.h"
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"
#import "GADInterstitial.h"


@interface ContactListView () <GADInterstitialDelegate, GADBannerViewDelegate>

@property (nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation ContactListView
@synthesize toolbar,contactTbl;
@synthesize contactsArr;
@synthesize contName,contID,contNum,contPic,conid,conEmail,conNote,conRating,uid;
@synthesize interstitial;
@synthesize backgroundImg;



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
    [backgroundImg release];
    [uid release];
    [conNote release];
    [conRating release];
    [uid release];
    [contID release];
    [contName release];
    [contPic release];
    [contNum release];
    [toolbar release];
    [contactTbl release];
    [contactsArr release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        toolbar.barTintColor = [UIColor blackColor];
        //[self moveAllSubviewsDown];
    }

    [self.navigationController setNavigationBarHidden:NO];
    app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.title=@"Contacts";
    contactsArr=[[NSMutableArray alloc] init];
    
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
#ifdef LITEVERSION
        // Tap For Tap Adview Starts Here
        if(![[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"BreakInPackagePurchased"] isEqualToString:@"YES"])
        {
            if(![[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"AdPackagePurchased"] isEqualToString:@"YES"])
            {
                /*self.interstitial = [TFTInterstitial interstitialWithDelegate:self];
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
#ifdef LITEVERSION
        // Tap For Tap Adview Starts Here
       if(![[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"BreakInPackagePurchased"] isEqualToString:@"YES"])
        {
            if(![[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"AdPackagePurchased"] isEqualToString:@"YES"])
            {
                /*self.interstitial = [TFTInterstitial interstitialWithDelegate:self];
                 [self.interstitial load];
                 [self.interstitial showWithViewController: self];*/
                self.interstitial = [GADHelper createAndLoadInterstitial:self];
            }
            
        }
        // Tap For Tap Adview Ends Here
#else
#endif
        CGSize result = [UIScreen mainScreen].bounds.size;
        if (result.height < 568){
            NSLog(@"Login From iphone 4");
            self.backgroundImg.image = [UIImage imageNamed:@"iphone-n-back.png"];
        }
        else
        {
            NSLog(@"Login From iphone 5");
            self.backgroundImg.image = [UIImage imageNamed:@"iphone-n-back@2x.png"];
//            self.backgroundImg.frame = CGRectMake(0, -10, 320, 540);
        }
        
        
    }
    
    
 /*   UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                    style:UIBarButtonSystemItemDone target:self action:@selector(EditTable:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
    */
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:2];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(btnAddContactPressed)];
    addButton.style = UIBarButtonItemStyleBordered;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        addButton.tintColor = [UIColor whiteColor];
    }
    [buttons addObject:addButton];
    [addButton release];
    toolbar.items = buttons;
    [buttons release];
    
    [self dispAllContacts];
}

- (void)viewWillAppear:(BOOL)animated
{
   [self.navigationController setNavigationBarHidden:NO];
    app.EditContactFlag=NO;
    [self dispAllContacts];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - addContact Actionsheet Methods

-(void)btnAddContactPressed{
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
        popView.backgroundColor = [[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.7];
        
        UIView *chooseView = [[UIView alloc]initWithFrame:CGRectMake(21, 108, 726, 707)];
        chooseView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-choose-bg.png"]];
        [popView addSubview:chooseView];
        
        UIView *chooseName = [[UIView alloc]initWithFrame:CGRectMake(230, 177, 320, 80)];
        chooseName.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chooseText.png"]];
        [popView addSubview:chooseName];
        
        UIButton *btnAddContact = [[UIButton alloc]initWithFrame:CGRectMake(31, 331, 712, 133)];
        btnAddContact.backgroundColor = [UIColor clearColor];
        btnAddContact.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-add-button.png"]];
        [btnAddContact addTarget:self action:@selector(btnAddContactPressed:) forControlEvents:UIControlEventTouchUpInside];
        [popView addSubview:btnAddContact];
        
        UIButton *btnImportContact = [[UIButton alloc]initWithFrame:CGRectMake(32, 463, 712, 133)];
        btnImportContact.backgroundColor = [UIColor clearColor];
        btnImportContact.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-import-button.png"]];
        [btnImportContact addTarget:self action:@selector(btnImportContactPressed:) forControlEvents:UIControlEventTouchUpInside];
        [popView addSubview:btnImportContact];
        
        UIButton *btnCancel = [[UIButton alloc]initWithFrame:CGRectMake(215, 630, 342, 74)];
        btnCancel.backgroundColor = [UIColor clearColor];
        btnCancel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-cancel.png"]];
        [btnCancel addTarget:self action:@selector(btnCancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [popView addSubview:btnCancel];
        
        [self.view addSubview:popView];

    }
    else
    {
        CGSize result = [UIScreen mainScreen].bounds.size;
        if (result.height < 568){
            NSLog(@"Login From iphone 4");
            popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
            popView.backgroundColor = [[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.7];
            
            UIView *chooseView = [[UIView alloc]initWithFrame:CGRectMake(3, 40, 313, 304)];
            chooseView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone-n-choose-bg.png"]];
            [popView addSubview:chooseView];
            
            UIView *chooseName = [[UIView alloc]initWithFrame:CGRectMake(89, 85, 135, 36)];
            chooseName.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone-n-choose.png"]];
            [popView addSubview:chooseName];
            
            UIButton *btnAddContact = [[UIButton alloc]initWithFrame:CGRectMake(8, 140, 307, 57)];
            btnAddContact.backgroundColor = [UIColor clearColor];
            btnAddContact.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone-n-add-button.png"]];
            [btnAddContact addTarget:self action:@selector(btnAddContactPressed:) forControlEvents:UIControlEventTouchUpInside];
            [popView addSubview:btnAddContact];
            
            UIButton *btnImportContact = [[UIButton alloc]initWithFrame:CGRectMake(8, 195, 307, 57)];
            btnImportContact.backgroundColor = [UIColor clearColor];
            btnImportContact.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone-n-import-button.png"]];
            [btnImportContact addTarget:self action:@selector(btnImportContactPressed:) forControlEvents:UIControlEventTouchUpInside];
            [popView addSubview:btnImportContact];

            UIButton *btnCancel = [[UIButton alloc]initWithFrame:CGRectMake(90, 274, 148, 32)];
            btnCancel.backgroundColor = [UIColor clearColor];
            btnCancel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone-n-cancel.png"]];
            [btnCancel addTarget:self action:@selector(btnCancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [popView addSubview:btnCancel];
            
            [self.view addSubview:popView];
            
        }
        else
        {
            NSLog(@"Login From iphone 5");
            
            popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 520)];
            popView.backgroundColor = [[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.7];
            
            UIView *chooseView = [[UIView alloc]initWithFrame:CGRectMake(3, 75, 313, 304)];
            chooseView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone-n-choose-bg.png"]];
            [popView addSubview:chooseView];
            
            UIView *chooseName = [[UIView alloc]initWithFrame:CGRectMake(89, 120, 135, 36)];
            chooseName.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone-n-choose.png"]];
            [popView addSubview:chooseName];
            
            UIButton *btnAddContact = [[UIButton alloc]initWithFrame:CGRectMake(8, 175, 307, 57)];
            btnAddContact.backgroundColor = [UIColor clearColor];
            btnAddContact.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone-n-add-button.png"]];
            [btnAddContact addTarget:self action:@selector(btnAddContactPressed:) forControlEvents:UIControlEventTouchUpInside];
            [popView addSubview:btnAddContact];
            
            UIButton *btnImportContact = [[UIButton alloc]initWithFrame:CGRectMake(8, 230, 307, 57)];
            btnImportContact.backgroundColor = [UIColor clearColor];
            btnImportContact.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone-n-import-button.png"]];
            [btnImportContact addTarget:self action:@selector(btnImportContactPressed:) forControlEvents:UIControlEventTouchUpInside];
            [popView addSubview:btnImportContact];
            
            UIButton *btnCancel = [[UIButton alloc]initWithFrame:CGRectMake(90, 309, 148, 32)];
            btnCancel.backgroundColor = [UIColor clearColor];
            btnCancel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone-n-cancel.png"]];
            [btnCancel addTarget:self action:@selector(btnCancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [popView addSubview:btnCancel];
            
            [self.view addSubview:popView];
        }

    }
    
        
//    app.blAddContactCheck=YES;
//    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Choose" delegate:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add New Contact",@"Import Contact", nil];
//    popupQuery.frame  = CGRectMake(21, 158, 726, 707);
//    popupQuery.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-choose-bg.png"]];
//    //popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
//    popupQuery.delegate=self;
//    [popupQuery showInView:self.view];
//    [popupQuery release];

}

-(IBAction)btnAddContactPressed:(id)sender
{
    NSLog(@"Add Contact");
    [popView removeFromSuperview];
    Add_ImportContactView *addcon;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        addcon = [[Add_ImportContactView alloc] initWithNibName:@"Add_ImportContactView_Ipad" bundle:nil];
    }
    else
    {
        addcon = [[Add_ImportContactView alloc] initWithNibName:@"Add_ImportContactView" bundle:nil];
    }
    
    // Add_ImportContactView *addcon=[[Add_ImportContactView alloc] initWithNibName:@"Add_ImportContactView" bundle:nil];
    [self.navigationController pushViewController:addcon animated:YES];
    [addcon release];
}

-(IBAction)btnImportContactPressed:(id)sender
{
    NSLog(@"Import Contact");
    [popView removeFromSuperview];
    ImportContactView *impCon;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        impCon = [[ImportContactView alloc] initWithNibName:@"ImportContactView_ipad" bundle:nil];
    }
    else {
        impCon = [[ImportContactView alloc] initWithNibName:@"ImportContactView" bundle:nil];
    }
    
    //        ImportContactView *impCon=[[ImportContactView alloc] initWithNibName:@"ImportContactView" bundle:nil];
    [self.navigationController pushViewController:impCon animated:YES];
    [impCon release];
}

-(IBAction)btnCancelButtonPressed:(id)sender
{
    [popView removeFromSuperview];
    NSLog(@"Cancel Contact");
}


//- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
//    NSLog(@"Action Sheet Presented...");
//    int i=0;
//    actionSheet.backgroundColor = [UIColor clearColor];
//    
//    
//    [actionSheet setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-choose-bg.png"]]];
//    for (UIView* view in [actionSheet subviews]) {
//        
//        if ([view isKindOfClass:NSClassFromString(@"UIAlertButton")]) {
//            
//            //view.alpha =0;
//            //UIButton* bview = [[UIButton alloc ] initWithFrame:CGRectMake(5, 10 + i* 40, 310, 35)];
//            if (i==0) {
//                [view setBackgroundColor:[UIColor clearColor]];
//                [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-add-button.png"]]];
//            }
//            else if (i==1) {
//                [view setBackgroundColor:[UIColor clearColor]];
//                [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-cancel.png"]]];
//                //[bview setBackgroundImage:[UIImage imageNamed:@"ipad-cancel.png"] forState:0];
//            }
//            else if (i==2) {
//                //[bview setBackgroundImage:[UIImage imageNamed:@"BtnShoppingReport.png"] forState:0];
//            }
//            [actionSheet addSubview:view];
//            i+=1;
//        }
//    }
//}





-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0)
    {
        Add_ImportContactView *addcon;
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            addcon = [[Add_ImportContactView alloc] initWithNibName:@"Add_ImportContactView_Ipad" bundle:nil];
        }
        else
        {
            addcon = [[Add_ImportContactView alloc] initWithNibName:@"Add_ImportContactView" bundle:nil];
        }

       // Add_ImportContactView *addcon=[[Add_ImportContactView alloc] initWithNibName:@"Add_ImportContactView" bundle:nil];
        [self.navigationController pushViewController:addcon animated:YES];
        [addcon release];
    }
    else if (buttonIndex == 1)
    {        
        
       ImportContactView *impCon;
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            impCon = [[ImportContactView alloc] initWithNibName:@"ImportContactView_ipad" bundle:nil];
        }
        else {
            impCon = [[ImportContactView alloc] initWithNibName:@"ImportContactView" bundle:nil];
        }

//        ImportContactView *impCon=[[ImportContactView alloc] initWithNibName:@"ImportContactView" bundle:nil];
        [self.navigationController pushViewController:impCon animated:YES];
        [impCon release];
    }
    else
    {
        NSLog(@"Cancel..");
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contactsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CustomCellIdentifier = @"ContCustomCell";
    
    ContactCustomCell *cell = (ContactCustomCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if (cell == nil) {
        NSArray *nib;
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"ContactCustomCell_Ipad" owner:self options:nil];
        }
        else {
            nib = [[NSBundle mainBundle] loadNibNamed:@"ContactCustomCell" owner:self options:nil];
        }
        

       // nib = [[NSBundle mainBundle] loadNibNamed:@"ContactCustomCell" owner:self options:nil];
        for(id oneObject in nib)
            if([oneObject isKindOfClass:[ContactCustomCell class]])
                cell = (ContactCustomCell *)oneObject;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ContactListView *contObj=contactsArr[indexPath.row];
  
    cell.contNameLbl.text=contObj.contName;
    cell.ContactNumLbl.text = contObj.contNum;
//    if(contObj.contPic.length <=7)
//    {
//       cell.conPicImg.image=[UIImage imageNamed:@"ipad-addimage.png"];
//    }else 
//    {
//        cell.conPicImg.image=[UIImage imageWithContentsOfFile:contObj.contPic];
//        NSLog(@"Image path from delegate::: %@",contObj.contPic);
//    }
//  
//    cell.ContactNumLbl.text=contObj.contNum;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    app.EditContactFlag=YES;
    ContactListView *contObj=contactsArr[indexPath.row];
    app.conid=contObj.contID;
    app.conNm=contObj.contName;
    app.conPhone=contObj.contNum;
    app.conRate=contObj.conRating;
    app.ConNote=contObj.conNote;
    app.conImg=contObj.contPic;
    app.conEmail=contObj.conEmail;
    
    Add_ImportContactView *addcon;
     app.blAddContactCheck=NO;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        addcon = [[Add_ImportContactView alloc] initWithNibName:@"Add_ImportContactView_Ipad" bundle:nil];
    }
    else {
        addcon = [[Add_ImportContactView alloc] initWithNibName:@"Add_ImportContactView" bundle:nil];
    }

    
//    Add_ImportContactView *addcon=[[Add_ImportContactView alloc] initWithNibName:@"Add_ImportContactView" bundle:nil];
    [self.navigationController pushViewController:addcon animated:YES];
    [addcon release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        return 60;
    }
    else {
    return 45;
    }
    
}

#pragma mark Row Rearrange

- (IBAction) EditTable:(id)sender{
    if(self.editing)
    {
        [super setEditing:NO animated:NO]; 
        [contactTbl setEditing:NO animated:NO];
        [contactTbl reloadData];
        (self.navigationItem.rightBarButtonItem).title = @"Edit";
        (self.navigationItem.rightBarButtonItem).style = UIBarButtonItemStylePlain;
    }
    else
    {
        [super setEditing:YES animated:YES]; 
        [contactTbl setEditing:YES animated:YES];
        [contactTbl reloadData];
        (self.navigationItem.rightBarButtonItem).title = @"Done";
        (self.navigationItem.rightBarButtonItem).style = UIBarButtonItemStyleDone;
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
      return YES;
}

// Move row
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
      toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString *item = [contactsArr[fromIndexPath.row] retain];
    [contactsArr removeObject:item];
    [contactsArr insertObject:item atIndex:toIndexPath.row];
    [item release];
}

#pragma mark - Delete row

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        ContactListView *conObj=contactsArr[indexPath.row];
        conid=(conObj.contID).intValue;
        NSLog(@"Cont id=== %d",conid);
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Alert!!" message:@"Are you sure you want to delete the contact?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:nil];
        
        [alert addButtonWithTitle:@"YES"];
        [alert show];
        [alert release]; 
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
        /********* On Confirmation to delete contact  ***********/
        if([title isEqualToString:@"YES"])
        {
            [self deleteContact];
        }
}

#pragma mark - DisplayContacts

-(void)dispAllContacts{
    
    [contactsArr removeAllObjects];
    databasepath = [app getDBPathNew];
    
    if (sqlite3_open(databasepath.UTF8String, &dbSecret) == SQLITE_OK) {
        
        NSString *sql =[NSString stringWithFormat:@"select * from ContactTbl where UserID=%d",(app.LoginUserID).intValue];
            
        sqlite3_stmt *selectstmt;
        const char *sel_query=sql.UTF8String;
        if(sqlite3_prepare(dbSecret, sel_query, -1, &selectstmt, NULL) == SQLITE_OK) {
            
            while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {
                ContactListView *contObj = [[ContactListView alloc] init];
                
                contObj.contID =@((char *)sqlite3_column_text(selectstmt, 0));
                
                contObj.uid=@((char *)sqlite3_column_text(selectstmt, 1));
                
                contObj.contName=  @((char *)sqlite3_column_text(selectstmt, 2)); 
                
                contObj.contNum=  @((char *)sqlite3_column_text(selectstmt, 3)); 
                
                contObj.conEmail=[NSString stringWithFormat:@"%s",sqlite3_column_text(selectstmt, 4)]; 
                
                 contObj.conRating=[NSString stringWithFormat:@"%s",sqlite3_column_text(selectstmt, 5)];
                
                 contObj.conNote=[NSString stringWithFormat:@"%s",sqlite3_column_text(selectstmt, 6)];
                
                contObj.contPic= [NSString stringWithFormat:@"%s",sqlite3_column_text(selectstmt, 7)];
                
                [contactsArr addObject:contObj];
                //[contObj release];
            }
        }
        sqlite3_finalize(selectstmt);
    }
    else
        sqlite3_close(dbSecret);
    
    NSLog(@"contacts count::: %lu",(unsigned long)contactsArr.count);
    [contactTbl reloadData];
}

#pragma mark Contact Delete

- (IBAction) deleteContact
{
    databasepath=[app getDBPathNew];
    if (sqlite3_open(databasepath.UTF8String, &dbSecret) == SQLITE_OK) 
    {
        NSString *DeleteQuery = [NSString stringWithFormat:@"Delete from ContactTbl Where ContactID=%d",conid];
        
         NSLog(@"Query : %@",DeleteQuery);
        const char *deleteStmt = DeleteQuery.UTF8String;
        sqlite3_stmt *query_stmt;
        
        if(sqlite3_prepare_v2(dbSecret, deleteStmt, -1, &query_stmt, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(query_stmt)== SQLITE_DONE)
            {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Delete Result" message:@"Contact Deleted Successfully...." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Deleted Result" message:@"Data Not Found To Be Deleted...." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                
            }
            sqlite3_finalize(query_stmt);
        }
    }
    sqlite3_close(dbSecret);  
    [self dispAllContacts];
}

#pragma mark - TapForTap Methods

-(IBAction)showInterstitial:(id)sender
{
   // [TFTInterstitial showWithRootViewController:self];
}

-(IBAction)showMoreApps:(id)sender
{
    //[TFTAppWall showWithRootViewController:self];
}

-(UIViewController *)rootViewController
{
    return self;
}

#pragma mark - GADDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    if(self == self.navigationController.topViewController)
        [self.interstitial presentFromRootViewController:self];
}

@end
