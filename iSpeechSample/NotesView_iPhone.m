//
//  NotesView_iPhone.m
//  SecretApp
//
//  Created by c62 on 09/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotesView_iPhone.h"
#import "AppDelegate.h"
#import "NotesCustomCell.h"
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"
#import "GADInterstitial.h"

@interface NotesView_iPhone () <GADInterstitialDelegate, GADBannerViewDelegate>

@property (nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation NotesView_iPhone

@synthesize notesTbl,noteTxt,NotesStr,NoteID,notesArr;
@synthesize notesDetailView,accessoryView;
@synthesize savedoneBtn,CancelBtn;
@synthesize cancelBgImg;
@synthesize scrlVw;

@synthesize interstitial;

AppDelegate *app;

UIBarButtonItem *addButton;
UIButton *delButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) dealloc
{    
    [notesArr release];
    [NoteID release];
    [NotesStr release];
    [cancelBgImg release];
    [savedoneBtn release];
    [CancelBtn release];
    [accessoryView release];
    [noteTxt release];
    [notesDetailView release];
    [notesTbl release];
    [scrlVw release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // Do any additional setup after loading the view from its nib.
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    notesArr=[[NSMutableArray alloc] init];
    self.title=@"Notes";
    notesDetailView.hidden=true;
    
    addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(noteAddClicked:)];
    addButton.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem=addButton;
    [addButton release];
    
    scrlVw.scrollEnabled = YES;
    scrlVw.delegate = self;
    scrlVw.contentSize=CGSizeMake(300, 600);
    [self.view addSubview:scrlVw];
    scrlVw.hidden=true;
    [self.navigationController setNavigationBarHidden:NO];
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
    }
    
    [self NotesToDisplay];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Notes data count:::: %d",[notesArr count]);
    return [notesArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//    }
//    
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    cell.textLabel.textColor=[UIColor whiteColor];
//    NotesView_iPhone *obj = [notesArr objectAtIndex:indexPath.row];
//    cell.textLabel.text= obj.NotesStr;
//    cell.textLabel.font= [UIFont fontWithName:@"Arial Rounded MT Bold" size:15.0];
//    
//    return cell;
    
    static NSString *CustomCellIdentifier = @"CustomCell";
    
    NotesCustomCell *cell = (NotesCustomCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"NotesCustomCell_iPad" owner:self options:nil];
        }
        else {
            nib = [[NSBundle mainBundle] loadNibNamed:@"NotesCustomCell" owner:self options:nil];
        }
    
        for(id oneObject in nib)
            if([oneObject isKindOfClass:[NotesCustomCell class]])
                cell = (NotesCustomCell *)oneObject;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        NotesView_iPhone *contObj=[notesArr objectAtIndex:indexPath.row];
        cell.lblNotes.text = contObj.NotesStr;
    }
    
    

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
//    if (adView!=nil) {
//        NSLog(@"Ad Shown");
//        adView.hidden = TRUE;
//    }
//    
    self.navigationItem.hidesBackButton=TRUE;
    addButton.enabled=FALSE;
    [savedoneBtn setTitle:@"Edit" forState:UIControlStateNormal];
    
    [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    
    delButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [delButton setImage:[UIImage imageNamed:@"gnome_delete.png"] forState:UIControlStateNormal];
    [delButton addTarget:self action:@selector(deleteConfirmation) forControlEvents:UIControlEventTouchUpInside];
    [delButton setFrame:CGRectMake(0, 0, 30, 30)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:delButton];
    
    UIView *parentView = self.view;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                           forView:parentView
                             cache:YES];
    
    [UIView setAnimationDuration:1];
    self.notesDetailView.hidden = NO;
    
    NotesView_iPhone *obj = [notesArr objectAtIndex:indexPath.row];
    noteTxt.text=obj.NotesStr;
    selectedNoteId=[obj.NoteID intValue];
    NSLog(@"Note ID==== %d",selectedNoteId);
    scrlVw.hidden=NO;
    [UIView commitAnimations];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NotesView_iPhone *obj = [notesArr objectAtIndex:indexPath.row];
        selectedNoteId=[obj.NoteID intValue];
        
        [self deleteNote];
    }   
}

-(IBAction)btnSaveDoneClicked:(id)sender{

//    if (adView!=nil) {
//        NSLog(@"Ad Shown");
//        adView.hidden = FALSE;
//    }
    
    if([noteTxt.text isEqualToString:@""])
    {
        
//        if (adView!=nil) {
//            adView.hidden = YES;
//        }
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Message" message:@"Please enter Text to save ...!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }else {
         NSString *title = [savedoneBtn  titleForState:UIControlStateNormal];
    

    if([title isEqualToString:@"Save"])
    {
        [self InsertData];
    }
    
    if([title isEqualToString:@"Edit"])
    {
        [self editData];   
    }
    
    UIView *parentView = self.view;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:parentView
                             cache:YES];
    
    [UIView setAnimationDuration:1];
    self.notesDetailView.hidden = YES;
    self.scrlVw.hidden=true;
    [UIView commitAnimations];
    [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    addButton = [[UIBarButtonItem alloc]
                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(noteAddClicked:)];
    addButton.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem=addButton;
    [addButton release];
    
    //addButton.enabled=true;
    self.navigationItem.hidesBackButton=false;
    }    
}

-(void) NotesToDisplay
{
    [notesArr removeAllObjects];
    databasepath = [app getDBPathNew];
    
    if (sqlite3_open([databasepath UTF8String], &dbSecret) == SQLITE_OK) {
      
        NSString *sqlQuery = [NSString stringWithFormat:@"Select NoteID,NoteText from NotesTbl where UserID=%d",[app.LoginUserID intValue]];
        
        sqlite3_stmt *selectstmt;
        const char *sql=[sqlQuery UTF8String];
        if(sqlite3_prepare(dbSecret, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
            
            while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {
                NotesView_iPhone *contObj = [[NotesView_iPhone alloc] init];
                
                contObj.noteID =[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
                
                contObj.NotesStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                
                [notesArr addObject:contObj];
                //[contObj release];
            }
        }
        sqlite3_finalize(selectstmt);
    }
    else
        sqlite3_close(dbSecret);
    
    NSLog(@"Notes count::: %d",[notesArr count]);
    //  NSLog(@"Note Array:::: %@",);
    [notesTbl reloadData];
}

-(void)InsertData{
    // int uid=1;
    sqlite3_stmt *stmt;
    databasepath=[app getDBPathNew];
    const char *dbpath=[databasepath UTF8String];
    if(sqlite3_open(dbpath, &dbSecret) == SQLITE_OK)
    {
        NSString *insertquery=[NSString stringWithFormat:@"Insert into NotesTbl(UserID,NoteText) VALUES(%d,\"%@\")",[app.LoginUserID intValue],noteTxt.text];
        const char *insert_query=[insertquery UTF8String];
        sqlite3_prepare(dbSecret, insert_query, -1, &stmt, NULL);
        
        if(sqlite3_step(stmt)== SQLITE_DONE)
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Message" message:@"Note Added Successfully...!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        { 
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry" message:@"Failed To Insert Note.." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        sqlite3_finalize(stmt);
        sqlite3_close(dbSecret);
    }
    [self NotesToDisplay];
}

-(IBAction) editData{
    databasepath=[app getDBPathNew];
    if (sqlite3_open([databasepath UTF8String], &dbSecret) == SQLITE_OK) 
    {
        NSString *selectSql = [NSString stringWithFormat:@"Update NotesTbl set NoteText=\"%@\" Where NoteID=%d ;",noteTxt.text,selectedNoteId];
        
        NSLog(@"Query : %@",selectSql);
        const char *sqlStatement = [selectSql UTF8String];
        sqlite3_stmt *query_stmt;
        sqlite3_prepare(dbSecret, sqlStatement, -1, &query_stmt, NULL);
        
        if(sqlite3_step(query_stmt)== SQLITE_DONE)
        {
              /*  UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Result" message:@"Note Updated successfully...." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];*/
        }
        else
        {
                //status.text = @"Match Not Found..!!";
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Sorry" message:@"Failed To Update Data..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
               // txtcontact.text=@"";
        }
        sqlite3_finalize(query_stmt);
       
    }
    sqlite3_close(dbSecret);
    
    [self NotesToDisplay];
}    

-(void) deleteConfirmation{
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Alert !!" message:@"Do you really want to delete this note?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    /********* On Confirmation to delete note  ***********/
    
    if([title isEqualToString:@"YES"])
    {
        [self deleteNote];
    }
}

-(IBAction)deleteNote
{
    databasepath=[app getDBPathNew];
    if (sqlite3_open([databasepath UTF8String], &dbSecret) == SQLITE_OK) 
    {
        NSString *selectSql = [NSString stringWithFormat:@"Delete from NotesTbl Where NoteID=%d",selectedNoteId];
        
        // NSLog(@"Query : %@",selectSql);
        const char *deleteStmt = [selectSql UTF8String];
        sqlite3_stmt *query_stmt;
        
        if(sqlite3_prepare_v2(dbSecret, deleteStmt, -1, &query_stmt, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(query_stmt)== SQLITE_DONE)
            {
                // NSLog(@"Error: %s",sqlite3_errmsg(dbphonebook));
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Delete Result" message:@"Note Deleted Successfully...." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                
            }
            else
            {
                //status.text = @"Match Not Found..!!";
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Deleted Result" message:@"Data Not Found To Be Deleted...." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
               // txtcontact.text=@"";
            }
            sqlite3_finalize(query_stmt);
        }
    }
    
    sqlite3_close(dbSecret);  
    
    UIView *parentView = self.view;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:parentView
                             cache:YES];
    
    [UIView setAnimationDuration:1];
    self.notesDetailView.hidden = YES;
    self.scrlVw.hidden=true;
    [UIView commitAnimations];
    [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    addButton = [[UIBarButtonItem alloc]
                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(noteAddClicked:)];
    addButton.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem=addButton;
    [addButton release];
    
    self.navigationItem.hidesBackButton=false;
    [self NotesToDisplay];
}

-(IBAction)btnCancelClicked:(id)sender{
    
//    if (adView!=nil) {
//        NSLog(@"Ad Shown");
//        adView.hidden = FALSE;
//    }
    
    UIView *parentView = self.view;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:parentView
                             cache:YES];
    
    [UIView setAnimationDuration:1];
    self.notesDetailView.hidden = YES;
    self.scrlVw.hidden=true;
    [UIView commitAnimations];
    [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    addButton = [[UIBarButtonItem alloc]
                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(noteAddClicked:)];
    addButton.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem=addButton;
    [addButton release];
    self.navigationItem.hidesBackButton=false;
}

-(IBAction)noteAddClicked:(id)sender{
    
    NSLog(@"Add Notes Button Clicked..");
//    
//    if (adView!=nil) {
//        adView.hidden = YES;
//    }
    
    
    [savedoneBtn setTitle:@"Save" forState:UIControlStateNormal];
    scrlVw.hidden=FALSE;
    addclickTag=true;
    UIView *parentView = self.view;
    CancelBtn.hidden=FALSE;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                           forView:parentView
                             cache:YES];
    [UIView setAnimationDuration:1];
    self.notesDetailView.hidden = NO;
    [UIView commitAnimations];
    
    addButton.enabled=FALSE;
    self.navigationItem.hidesBackButton=TRUE;
    
    notesDetailView.hidden=false;
    noteTxt.text=@"";
    noteTxt.editable=true;
    
}

/*
 //// Method to hide KB on Enter of textview////
 
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
*/

-(BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    self.notesDetailView.contentStretch=CGRectMake(0, 200, 300,200);
    
    if (noteTxt.inputAccessoryView == nil) 
    {
        [[NSBundle mainBundle] loadNibNamed:@"AccessoryView" owner:self options:nil];
        // Loading the AccessoryView nib file sets the accessoryView outlet.
        noteTxt.inputAccessoryView = accessoryView;    
        self.accessoryView = nil;
    }
	return YES;
}

-(IBAction)goAway:(id)sender
{
    [noteTxt resignFirstResponder];
}


#pragma mark - GADDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    if(self == self.navigationController.topViewController)
        [self.interstitial presentFromRootViewController:self];
}

@end
