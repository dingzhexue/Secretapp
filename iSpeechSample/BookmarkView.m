//
//  BookmarkView.m
//  SecretApp
//
//  Created by c62 on 23/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BookmarkView.h"
#import "AppDelegate.h"
#import "WebViewController.h"
#import "GlobalFunctions.h"
#import "BookmarkCustomCell.h"
#import "EditBookmarkView.h"
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"
#import "GADInterstitial.h"

@interface BookmarkView () <GADInterstitialDelegate, GADBannerViewDelegate>

@property (nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation BookmarkView

@synthesize webVw,toolbar,bookmarkTbl,bookmarkArr;

@synthesize bookmarkID,bookmarkURL,bookmarkTitle;

@synthesize interstitial;

AppDelegate *app;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{    
    [bookmarkID release];
    [bookmarkURL release];
    [bookmarkTitle release];
    [bookmarkArr release];
    [bookmarkTbl release];
    [webVw release];
    [toolbar release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [toolbar setBarTintColor:[UIColor blackColor]];
    }

    app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    bookmarkArr=[[NSMutableArray alloc] init];
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
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
    
}

-(void) viewWillAppear:(BOOL)animated{
    
    self.title=@"Bookmark";
    [self.navigationController setNavigationBarHidden:NO];
    editBookmarkflag=NO;
    
  /*  editdoneButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                      style:UIBarButtonSystemItemDone target:self action:@selector(EditTableVideos:)];
    self.navigationItem.rightBarButtonItem = editdoneButton;
    [editdoneButton release];*/
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    UIButton *infoButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [infoButton addTarget:self action:@selector(webBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    infoButton.frame = CGRectMake(0, 0, 30.0, 30.0);
    [infoButton setBackgroundImage:[UIImage imageNamed:@"www1.png"] forState:UIControlStateNormal];
    [self.view addSubview:infoButton];
    
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc]initWithCustomView:infoButton];
    doneButton.style = UIBarButtonItemStyleBordered;
    
    [buttons addObject:doneButton];
    [doneButton release];
    
    [toolbar setItems:buttons];
    [buttons release];
    
    [self BookmarkToDisplay];
}

-(IBAction)webBtnPressed:(id)sender{
    
    WebViewController *webView;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        webView = [[WebViewController alloc] initWithNibName:@"WebViewController_ipad" bundle:nil];
    }
    else
    {
        webView = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    }

//    WebViewController *web=[[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    [self.navigationController pushViewController:webView animated:YES];
    [webView release];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"bookmark data count:::: %d",[bookmarkArr count]);
    return [bookmarkArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CustomCellIdentifier = @"CustomBookMark";
    
    BookmarkCustomCell *cell = (BookmarkCustomCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if (cell == nil) {
        NSArray *nib;
        
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"BookmarkCustomCell_ipad" owner:self options:nil];
        }
        else {
            nib = [[NSBundle mainBundle] loadNibNamed:@"BookmarkCustomCell" owner:self options:nil];
        }
        
        
        // nib = [[NSBundle mainBundle] loadNibNamed:@"BookmarkCustomCell" owner:self options:nil];
        
        for(id oneObject in nib)
            if([oneObject isKindOfClass:[BookmarkCustomCell class]])
                cell = (BookmarkCustomCell *)oneObject;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    BookmarkView *bookObj=[bookmarkArr objectAtIndex:indexPath.row];
    
    [cell.bookmarkTitleBtn addTarget:self action:@selector(btnBMPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.bookmarkTitleBtn setTag:indexPath.row];
    
    NSLog(@"Title=== %@",bookObj.bookmarkTitle);
    [cell.bookmarkTitleBtn setTitle:bookObj.bookmarkTitle forState:UIControlStateNormal];
    cell.bookmarkTitleBtn.tag=indexPath.row;
    
    // [cell.contentView addSubview:cell.bookmarkTitleBtn];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    BookmarkView *bookObj=[bookmarkArr objectAtIndex:indexPath.row];
    [GlobalFunctions urlSaveToUserDefaults:bookObj.bookmarkURL];
    NSLog(@"Global url=== %@",[GlobalFunctions urlRetrieveFromUserDefaults]);
    
    WebViewController *webView;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        webView = [[WebViewController alloc] initWithNibName:@"WebViewController_ipad" bundle:nil];
    }
    else {
        webView = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    }

   // WebViewController *webView=[[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    [self.navigationController pushViewController:webView animated:YES];
    [webView release];
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

- (IBAction) EditTableVideos:(id)sender{
	if(self.editing)
	{
		[super setEditing:NO animated:NO]; 
		[bookmarkTbl setEditing:NO animated:NO];
		[bookmarkTbl reloadData];
		[self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
	}
	else
	{
		[super setEditing:YES animated:YES]; 
		[bookmarkTbl setEditing:YES animated:YES];
		[bookmarkTbl reloadData];
        editBookmarkflag=YES;
		[self.navigationItem.rightBarButtonItem setTitle:@"Done"];
		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
	}
}

-(IBAction)btnBMPressed:(id)sender{
    NSLog(@"tag= %d",[sender tag]);
    BookmarkView *bookObj=[bookmarkArr objectAtIndex:[sender tag]];
    [GlobalFunctions urlSaveToUserDefaults:bookObj.bookmarkURL];
    NSLog(@"Global url=== %@",[GlobalFunctions urlRetrieveFromUserDefaults]);
    
    if(editBookmarkflag)
    {
         NSLog(@"Edit bmark...");
        app.globBmID=bookObj.bookmarkID;
        app.globBmTitle=bookObj.bookmarkTitle;
        app.globBmURL=bookObj.bookmarkURL;
        
        editBookmarkflag=NO;
     
        EditBookmarkView *editView;
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            editView = [[EditBookmarkView alloc] initWithNibName:@"EditBookmarkView_Ipad" bundle:nil];
        }
        else {
            editView = [[EditBookmarkView alloc] initWithNibName:@"EditBookmarkView" bundle:nil];
        }
        

        //EditBookmarkView *editView=[[EditBookmarkView alloc] initWithNibName:@"EditBookmarkView" bundle:nil];
        [self.navigationController pushViewController:editView animated:YES];
        [editView release];
    }
    else
    {
        WebViewController *webView;
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            webView = [[WebViewController alloc] initWithNibName:@"WebViewController_ipad" bundle:nil];
        }
        else {
            webView = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        }

        
      //  WebViewController *webView=[[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        [self.navigationController pushViewController:webView animated:YES];
        [webView release];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Move row

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
      toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString *item = [[bookmarkArr objectAtIndex:fromIndexPath.row] retain];
    [bookmarkArr removeObject:item];
    [bookmarkArr insertObject:item atIndex:toIndexPath.row];
    [item release];
}

#pragma mark - Delete Video

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        BookmarkView *bookObj=[bookmarkArr objectAtIndex:indexPath.row];
        selBookID=bookObj.bookmarkID ;
        
        NSLog(@"Cont id=== %d",[selBookID intValue]);
        
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Alert!!" message:@"Are you sure you want to delete the selected bookmark?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:nil];
        
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
        [self deleteBookmark];
    }
}

-(void)deleteBookmark
{    
    NSLog(@"ID==== %d",[selBookID intValue]);
    
    databasepath=[app getDBPathNew];
    if (sqlite3_open([databasepath UTF8String], &dbSecret) == SQLITE_OK) 
    {
        NSString *DeleteQuery = [NSString stringWithFormat:@"Delete from BookmarkTbl Where BookmarkID=%d",[selBookID intValue]];
        
        NSLog(@"Query : %@",DeleteQuery);
        const char *deleteStmt = [DeleteQuery UTF8String];
        sqlite3_stmt *query_stmt;
        
        if(sqlite3_prepare_v2(dbSecret, deleteStmt, -1, &query_stmt, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(query_stmt)== SQLITE_DONE)
            {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Delete Result" message:@"Bookmark Deleted Successfully...." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Delete Result" message:@"Bookmark Not Deleted...." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                
            }
            sqlite3_finalize(query_stmt);
        }
    }
    sqlite3_close(dbSecret);  
    [self BookmarkToDisplay];
}

-(void) BookmarkToDisplay
{
    [bookmarkArr removeAllObjects];
    databasepath = [app getDBPathNew];
    
    if (sqlite3_open([databasepath UTF8String], &dbSecret) == SQLITE_OK) {
      //SELECT * FROM BookmarkTbl WHERE UserID =  '2' ORDER BY BookmarkID DESC
        NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM BookmarkTbl WHERE UserID = '%d'  ORDER BY BookmarkID DESC",[app.LoginUserID intValue]];
        
        NSLog(@"iS Query  %@ ",sqlQuery);
        sqlite3_stmt *selectstmt;
        const char *sql=[sqlQuery UTF8String];
       // const char *sql = "Select * from BookmarkTbl;";
       
        if(sqlite3_prepare(dbSecret, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
            
            while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {
                BookmarkView *bookObj = [[BookmarkView alloc] init];
                
                bookObj.bookmarkID =[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
                
                bookObj.bookmarkTitle = [NSString stringWithFormat:@"%s", sqlite3_column_text(selectstmt, 2)];
                
                 bookObj.bookmarkURL = [NSString stringWithFormat:@"%s",sqlite3_column_text(selectstmt, 3)];
                
                [bookmarkArr addObject:bookObj];
            }
        }
        sqlite3_finalize(selectstmt);
    }
    else
        sqlite3_close(dbSecret);
    
    NSLog(@"Notes count::: %d",[bookmarkArr count]);
    [bookmarkTbl reloadData];
}

#pragma mark - GADDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    if(self == self.navigationController.topViewController)
        [self.interstitial presentFromRootViewController:self];
}

@end
