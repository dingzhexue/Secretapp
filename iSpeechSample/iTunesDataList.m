//
//  iTunesDataList.m
//  RDRProject
//
//  Created by C31 on 28/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "iTunesDataList.h"
#import "iTunesCustomCell.h"
#import "AppDelegate.h"
#import "ImportFromPC.h"
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"
#import "GADInterstitial.h"

@interface iTunesDataList () <GADInterstitialDelegate, GADBannerViewDelegate>

@property (nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation iTunesDataList

@synthesize mytable,songToRemove,songToAdd,DateStr;
@synthesize queue = _queue;

AppDelegate *app;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

-(void)dealloc{
    [listOfImages release];
    [self.queue release];
    [songToAdd release];
    [super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    app = (AppDelegate *) [[UIApplication sharedApplication] delegate];

    // Tap For Tap Adview Starts Here
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
#ifdef LITEVERSION
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
#else
#endif
    }
    else
    {
#ifdef LITEVERSION
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
#else
#endif
    }
    // Tap For Tap Adview Ends Here
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    UIBarButtonItem *buttonRef= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
         buttonRef.tintColor=[UIColor whiteColor];
    }
    else
    {
        buttonRef.tintColor=[UIColor blackColor];
    }
    self.navigationItem.rightBarButtonItem = buttonRef;
    [buttonRef release];
    
    UIBarButtonItem *buttonClose= [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(btnClose:)];
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        buttonClose.tintColor=[UIColor whiteColor];
    }
    else
    {
        buttonClose.tintColor=[UIColor blackColor];
    }
    self.navigationItem.leftBarButtonItem = buttonClose;
    [buttonClose release];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    }
    self.title=@"iTunes Library Songs";
    
    listOfImages = [[NSMutableArray alloc] init];
    app.AddedSongsArray=[[NSMutableArray alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    NSString *filePath;
    
    for(int i = 0; i < filePathsArray.count; i ++)
    {
        filePath = [documentsDirectory stringByAppendingPathComponent:[filePathsArray objectAtIndex:i]];
        // NSLog(@"files array %@", filePath);
        
        NSArray *array = [filePath componentsSeparatedByString:@"/"];
        NSLog(@"music== %@", [array objectAtIndex:[array count]-1]);
     
        if([[[array objectAtIndex:[array count]-1] componentsSeparatedByString:@"."] containsObject:@"mp3"] )
        {
            [listOfImages addObject:filePath];
        }
    }
    
    NSLog(@"List of images count=== %d",listOfImages.count);
    self.queue = [[NSOperationQueue alloc] init];
    
    if(listOfImages.count > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Message" message:@"Click On Songs One By One To Add Into Application's Song List. " delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
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

#pragma mark - Table view Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return listOfImages.count;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{  
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        return 60.00;
    }
    else
    {
        return 50.00;
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CustomCellIdentifier = @"iTunesCell";
    iTunesCustomCell *cell = (iTunesCustomCell *)[tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
      if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
      {

        nib= [[NSBundle mainBundle] loadNibNamed:@"iTunesCustomCell_Ipad" owner:self options:nil];
      }else
      {
          nib= [[NSBundle mainBundle] loadNibNamed:@"iTunesCustomCell" owner:self options:nil];
      }       
        
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[iTunesCustomCell class]])
                cell = (iTunesCustomCell *)oneObject;
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        
        cell.textLabel.textColor=[UIColor blackColor];
        cell.textLabel.font= [UIFont fontWithName:@"Arial Rounded MT Bold" size:15.0];
        
        [cell.mybtn setHidden:YES];
        [cell.mybtn setTag:indexPath.row];
        [cell.mybtn addTarget:self action:@selector(btnExport:) forControlEvents:UIControlEventTouchUpInside];
        cell.myimg.image = [UIImage imageWithContentsOfFile:[listOfImages objectAtIndex:indexPath.row]];   
        
        NSString *filePath = [listOfImages objectAtIndex:indexPath.row];
        // NSLog(@"files array %@", filePath);
        NSArray *array = [filePath componentsSeparatedByString:@"/"];
        cell.mylbl.text = [array objectAtIndex:[array count]-1];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    songToRemove=indexPath.row;
	app.iTuneSongPath = [listOfImages objectAtIndex:indexPath.row];
    NSLog(@"selected song PATH=== %@",app.iTuneSongPath);
    NSArray *array = [app.iTuneSongPath componentsSeparatedByString:@"/"];
    app.iTuneSongTitle=[array objectAtIndex:[array count]-1];
    NSLog(@"selected song title::: %@",app.iTuneSongTitle);
    
    NSLog(@"List of images arr:::: %@",listOfImages);
    
    /* ************************* Add song into library directory ************************** */
        
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"Songs"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; 
    
    NSString *filePath =[NSString stringWithFormat:@"%@/%@",dataPath,app.iTuneSongTitle];
    NSLog(@"song file path=== %@",filePath);
    
    NSData *data1=[NSData dataWithContentsOfFile:app.iTuneSongPath];
    NSLog(@"data len from sel data-------> %d",[data1 length]);
    
    if (data1 != nil)
    {
        [data1 writeToFile:filePath atomically:YES];
        songToAdd=filePath;
        [app.AddedSongsArray addObject:songToAdd];
        [self addMusic];
    }
    
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:[listOfImages objectAtIndex:songToRemove] error: &error];
    [listOfImages removeObjectAtIndex:songToRemove];
    
     NSLog(@"List of images count=== %d",listOfImages.count);
     NSLog(@"List of images count=== %d",[app.AddedSongsArray count]);
    [mytable reloadData];    
}

#pragma mark - My Methods

-(IBAction)btnClose:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
   // [app.popoverController dismissPopoverAnimated:YES];
}

-(IBAction)currentdate
{
    NSDate* date = [NSDate date];    
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM:SS"];
    DateStr = [[NSString alloc]initWithFormat:@"%@",[formatter stringFromDate:date]];
    NSLog(@"Date::: %@",DateStr);
}

-(void)addMusic
{
    [self currentdate];
    
    sqlite3_stmt *stmt;
    databasepath=[app getDBPathNew];
    const char *dbpath=[databasepath UTF8String];
    if(sqlite3_open(dbpath, &dbSecret) == SQLITE_OK)
    {
        NSData *data=[NSData dataWithContentsOfFile:app.iTuneSongPath];
        NSLog(@"data length  from ins qurey ====> %d",[data length]);
        
        NSString *insertquery=[NSString stringWithFormat:@"Insert into MusicTbl(UserID,MusicTitle,MusicPath,MusicDate) VALUES(%d,\"%@\",\"%@\",\"%@\");",[app.LoginUserID intValue],app.iTuneSongTitle,songToAdd,DateStr];
        
        NSLog(@"Query:: %@",insertquery);
        
        const char *insert_query=[insertquery UTF8String];
        
        sqlite3_prepare_v2(dbSecret, insert_query, -1, &stmt, NULL);
        
        if(sqlite3_step(stmt)== SQLITE_DONE)
        {
            NSLog(@"Song added successfully...");
            
          /*  UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Message" message:@"Recording Added Successfully...!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];*/
            
           

        }
        else
        { 
            /*UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry" message:@"Failed To Insert Recording.." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];*/
            
             NSLog(@"Song not added... ");
        }
        
        sqlite3_finalize(stmt);
        sqlite3_close(dbSecret);
    }
        
   // [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnImport:(id)sender
{
   
    ImportFromPC *import;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        import = [[ImportFromPC alloc]initWithNibName:@"ImportFromPC_Ipad" bundle:[NSBundle mainBundle]];
    }else {
        import = [[ImportFromPC alloc]initWithNibName:@"ImportFromPC" bundle:[NSBundle mainBundle]];
    }
   
    import.delegate = self;
    import.contentSizeForViewInPopover=CGSizeMake(import.view.frame.size.width, import.view.frame.size.height);
    [self.navigationController pushViewController:import animated:YES];
}

-(IBAction)btnExport:(id)sender
{
    NSLog(@"TAG: %d" , [sender tag]);
    [_queue addOperationWithBlock: ^{
        BOOL exported = [self exportToDiskWithForce:FALSE atIndex:[sender tag]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (!exported) {
                UIAlertView *alertView = [[[UIAlertView alloc] 
                                           initWithTitle:@"File Already Exists!" 
                                           message:@"An exported song with this name already exists.  Overwrite?" 
                                           delegate:self 
                                           cancelButtonTitle:@"Cancel" 
                                           otherButtonTitles:@"Overwrite", nil] autorelease];
                [alertView show];
            }
        }];
    }]; 
}

- (BOOL)exportToDiskWithForce:(BOOL)force atIndex:(NSInteger)atIndex
{
    NSString *filename = [listOfImages objectAtIndex:atIndex];
    
    
    // Check if file already exists (unless we force the write)
    if (!force && [[NSFileManager defaultManager] fileExistsAtPath:filename]) {
        return FALSE;
    }
    
    // Export to data buffer
    NSError *error;
    NSURL *url = [NSURL fileURLWithPath:[listOfImages objectAtIndex:atIndex]];
    NSFileWrapper *dirWrapper = [[[NSFileWrapper alloc] initWithURL:url options:0 error:&error] autorelease];
    if (dirWrapper == nil) {
        NSLog(@"Error creating directory wrapper: %@", error.localizedDescription);
        return FALSE;
    }   
    
    //NSData *dirData = [dirWrapper serializedRepresentation];
    NSData *data =  [NSData dataWithContentsOfURL:[listOfImages objectAtIndex:atIndex]];  
    if (data == nil) 
        return FALSE;
        
    // Write to disk
    [data writeToFile:[listOfImages objectAtIndex:atIndex] atomically:YES];
    return TRUE;
}

#pragma mark ImportFromPCDelegate

- (void)importableDocTapped:(NSString*)importPath {
    [self.navigationController popViewControllerAnimated:YES];
//    ScaryBugDoc *newDoc = [[[ScaryBugDoc alloc] init] autorelease];
//    if ([newDoc importFromPath:importPath]) {
//        [self addNewDoc:newDoc];
//    }
    NSData *data = [NSData dataWithContentsOfFile:importPath];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Private Documents"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    // Read data into a dir Wrapper
    NSFileWrapper *dirWrapper = [[[NSFileWrapper alloc] initWithSerializedRepresentation:data] autorelease];
    if (dirWrapper == nil) {
        NSLog(@"Error creating dir wrapper from unzipped data");
    }
    
    // Calculate desired name
    NSString *dirPath = documentsDirectory;                                
    NSURL *dirUrl = [NSURL fileURLWithPath:dirPath];                
    BOOL success = [dirWrapper writeToURL:dirUrl options:NSFileWrapperWritingAtomic originalContentsURL:nil error:&error];
    if (!success) {
        NSLog(@"Error importing file: %@", error.localizedDescription);
    }
}

-(void) refresh
{
  //  [self viewWillAppear:NO];
    [mytable reloadSections: [NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

}

#pragma mark - GADDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    if(self == self.navigationController.topViewController)
        [self.interstitial presentFromRootViewController:self];
}

@end
