//
//  ColorPickerController.m
//  MathMonsters
//
//  Created by Ray Wenderlich on 5/3/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "ColorPickerController.h"
#import "AppDelegate.h"
#import "viewImageViewController.h"
#import "viewTermsAndConditions.h"
#import "viewHelp.h"
#import <QuartzCore/Quartzcore.h>
#import "RootViewController.h"
#import "FollowMeButton.h"
#import "Reachability.h"
#import "IAPHelper.h"
#import "InAppRageIAPHelper.h"

@implementation ColorPickerController
@synthesize colors = _colors;
@synthesize delegate = _delegate;
@synthesize listOfItems;
@synthesize facebook;
@synthesize facebookLikeView;
@synthesize Buy_vw;
@synthesize Info_view;
static NSString* kAppId = @"145792598897737";
AppDelegate *app;
bool isFacebookLike;
bool isSearching,isFree,isCosume;

bool productPurchased;
UIView *view;
#pragma mark -
#pragma mark Initialization

/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 if ((self = [super initWithStyle:style])) {
 }
 return self;
 }
 */


#pragma mark -
#pragma mark View lifecycle



- (void)viewDidLoad {
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.view.backgroundColor=[UIColor whiteColor];
    }
    facebook = [[Facebook alloc] initWithAppId:@"518705524822537" andDelegate:self];
    app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    
    NSLog(@"Product Count Begin. Total Products :: %d",app.Purchase_array.count);   
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        NSLog(@"No internet connection!");
    } else {
        if ([InAppRageIAPHelper sharedHelper].products == nil) {
//            [[InAppRageIAPHelper sharedHelper] requestProducts];
//            self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//            _hud.labelText = @"Loading Products...";
//            [self performSelector:@selector(timeout:) withObject:nil afterDelay:30.0];
        }
    }
}


-(void)viewWillAppear:(BOOL)animated
{
//#ifdef PROVERSION
//        productPurchased = YES;
//#else
//        productPurchased = NO;
//        UIButton *upgradeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        upgradeButton.frame = CGRectMake(0, 0, 75, 30);
//        [upgradeButton setImage:[UIImage imageNamed:@"iphone_upgrade.png"] forState:UIControlStateNormal];
//        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]  initWithCustomView:upgradeButton];
//        [upgradeButton addTarget:self action:@selector(buyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        self.navigationItem.rightBarButtonItem = rightButton;
//
//#endif
    
    NSLog(@"Started In App");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
    
    NSLog(@"USer ID is %@ ",app.LoginUserID);
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    listOfItems = [[NSMutableArray alloc] init];
    NSString *setValue = @"Dock Lock x9";
    NSString *strAutType=[self Authentication];

    strAutType = [GlobalFunctions getStringValueFromUserDefaults_ForKey:@"LockMethod2"];
    
    if([strAutType isEqualToString:@"Pattern"] || [strAutType isEqualToString:@""])
    {
        setValue=@"Dock Lock x9";
    }else if([strAutType isEqualToString:@"PinCode"]){
        setValue =@"PinCode";
    }else if([strAutType isEqualToString:@"Voice"])
    {
        setValue =@"Voice";
    }
    
    /* Nevil Extra Options
     NSString *time;
     NSString *strGetProperty=[self getProperties:@"Time"];
     if([strGetProperty isEqualToString:@"nil"] )
     {
     time=@"off oo";
     }else {
     time=[ NSString stringWithFormat: @"Auto Log out ( %@ )",strGetProperty];
     }
     
     //    @"High Quality UI Switvh",
     NSArray *itemsArray3 =[NSArray arrayWithObjects: nil];
     NSDictionary *itemsDict3 = [NSDictionary dictionaryWithObject:itemsArray3 forKey:@"2"];
     //[listOfItems addObject:itemsDict3];
     
     
     //    @"Face Book",
     NSArray *itemsArray5 =[NSArray arrayWithObjects: nil];
     NSDictionary *itemsDict5 = [NSDictionary dictionaryWithObject:itemsArray5 forKey:@"4"];
     // [listOfItems addObject:itemsDict5];
     
     
     
     //    @"Use DeskTop User Agent",
     NSArray *itemsArray6 =[NSArray arrayWithObjects: nil];
     NSDictionary *itemsDict6 = [NSDictionary dictionaryWithObject:itemsArray6 forKey:@"5"];
     // [listOfItems addObject:itemsDict6];
     
     
     */
    
    //,time,@"Email pin Code"
    NSArray *itemsArray1 =[NSArray arrayWithObjects:setValue,nil];
    NSDictionary *itemsDict1 = [NSDictionary dictionaryWithObject:itemsArray1 forKey:@"0"];
    [listOfItems addObject:itemsDict1];
    //    ,@"Email Break -in"
    NSArray *itemsArray3 =[NSArray arrayWithObjects:@"Break-in Attempts",@"View Attempts",@"Take Photo For Login",@"View Logins " ,nil];
    NSDictionary *itemsDict3 = [NSDictionary dictionaryWithObject:itemsArray3 forKey:@"1"];
    [listOfItems addObject:itemsDict3];
    
    
    NSArray *itemsArray4 =[NSArray arrayWithObjects:@"Edit Effects, Repeat, Shuffle", nil];
    NSDictionary *itemsDict4 = [NSDictionary dictionaryWithObject:itemsArray4 forKey:@"2"];
    [listOfItems addObject:itemsDict4];
    
    
    NSArray *itemsArray7 =[NSArray arrayWithObjects:@"Share This App", @"Help", @"Terms and Conditions", nil];
    NSDictionary *itemsDict7 = [NSDictionary dictionaryWithObject:itemsArray7 forKey:@"3"];
    [listOfItems addObject:itemsDict7];
    
    NSArray *itemsArray9 =[NSArray arrayWithObjects:@"Like Us On Facebook", @"Follow Us On Twitter", nil];
    NSDictionary *itemsDict9 = [NSDictionary dictionaryWithObject:itemsArray9 forKey:@"4"];
    [listOfItems addObject:itemsDict9];
#ifdef LITEVERSION
    NSArray *itemsArray10 =[NSArray arrayWithObjects:@"Restore Previous Purchase",nil];
    NSDictionary *itemsDict10 = [NSDictionary dictionaryWithObject:itemsArray10 forKey:@"5"];
    [listOfItems addObject:itemsDict10];
#else
#endif

#ifdef LITEVERSION
    NSArray *itemsArray2 = [NSArray arrayWithObjects:@"Remove All Ads", nil];
    NSDictionary *itemsDict2 = [NSDictionary dictionaryWithObject:itemsArray2 forKey:@"6"];
    if(![[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"AdPackagePurchased"] isEqualToString:@"YES"])
    {
        [listOfItems addObject:itemsDict2];
    }
    else
    {
        [listOfItems removeObject:itemsDict2];
    }
#else
#endif

    facebook = [[Facebook alloc]initWithAppId:kAppId andDelegate:self];
    
    //    UIImageView *BACK_IMG=[[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"main-bg.png"]] ];
    //    BACK_IMG.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    //    [self.view addSubview:BACK_IMG];
    
    
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        //        self.navigationController.navigationItem.hidesBackButton=YES;
        self.navigationController.navigationBarHidden=YES;
    // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"main-bg.png"]]];
    //  self.view.backgroundColor=[UIColor blackColor];
    }else {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            self.view.backgroundColor=[UIColor colorWithRed:214.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
        }
        else
        {
            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ipad-background.png"]]];
        }
        if(app.isnAvigateFromPattern)
        {
            UIBarButtonItem *lefttButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings"
                                                                            style:UIBarButtonSystemItemDone target:self action:@selector(BtnSettingsClicked:)];
            self.navigationItem.leftBarButtonItem = lefttButton;
            
        }
        [self performSelector:@selector(reloadTableView) withObject:nil afterDelay:1.0];
        //[self.tableView reloadData];
    }
}
-(void) sectionReload
{
     NSString *setValue = @"Dock Lock x9";
    //,time,@"Email pin Code"
    NSArray *itemsArray1 =[NSArray arrayWithObjects:setValue,nil];
    NSDictionary *itemsDict1 = [NSDictionary dictionaryWithObject:itemsArray1 forKey:@"0"];
    [listOfItems addObject:itemsDict1];
    //    ,@"Email Break -in"
    NSArray *itemsArray3 =[NSArray arrayWithObjects:@"Break-in Attempts",@"View Attempts",@"Take Photo For Login",@"View Logins " ,nil];
    NSDictionary *itemsDict3 = [NSDictionary dictionaryWithObject:itemsArray3 forKey:@"1"];
    [listOfItems addObject:itemsDict3];
    
    
    NSArray *itemsArray4 =[NSArray arrayWithObjects:@"Edit Effects, Repeat, Shuffle", nil];
    NSDictionary *itemsDict4 = [NSDictionary dictionaryWithObject:itemsArray4 forKey:@"2"];
    [listOfItems addObject:itemsDict4];
    
    
    NSArray *itemsArray7 =[NSArray arrayWithObjects:@"Share This App", @"Help", @"Terms and Conditions", nil];
    NSDictionary *itemsDict7 = [NSDictionary dictionaryWithObject:itemsArray7 forKey:@"3"];
    [listOfItems addObject:itemsDict7];
    
    NSArray *itemsArray9 =[NSArray arrayWithObjects:@"Like Us On Facebook", @"Follow Us On Twitter", nil];
    NSDictionary *itemsDict9 = [NSDictionary dictionaryWithObject:itemsArray9 forKey:@"4"];
    [listOfItems addObject:itemsDict9];
#ifdef LITEVERSION
    NSArray *itemsArray10 =[NSArray arrayWithObjects:@"Restore Previous Purchase",nil];
    NSDictionary *itemsDict10 = [NSDictionary dictionaryWithObject:itemsArray10 forKey:@"5"];
    [listOfItems addObject:itemsDict10];
#else
#endif
    
#ifdef LITEVERSION
    NSArray *itemsArray2 = [NSArray arrayWithObjects:@"Remove All Ads", nil];
    NSDictionary *itemsDict2 = [NSDictionary dictionaryWithObject:itemsArray2 forKey:@"6"];
    if(![[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"AdPackagePurchased"] isEqualToString:@"YES"])
    {
        [listOfItems addObject:itemsDict2];
    }
    else
    {
        [listOfItems removeObject:itemsDict2];
    }
#else
#endif
    [self.tableView reloadData];

}
-(void) reloadTableView
{
    [self.tableView reloadData];
}
-(IBAction)BtnSettingsClicked:(id)sender
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

-(void)viewWillDisappear:(BOOL)animated
{
//    if (app.Purchase_array.count > 0) {
//        app.flagTapForTap = false;
//    }
//    else
//    {
//        app.flagTapForTap = true;
//    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    // Override to allow orientations other than the default portrait orientation.
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     NSLog(@"%@",listOfItems);
    
    return [listOfItems count];
   
    //return 1;
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
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryView = UITableViewCellAccessoryNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *objdict = [listOfItems objectAtIndex:indexPath.section];
    NSString *str = [NSString stringWithFormat:@"%i",indexPath.section];
    NSArray *objarray = [objdict objectForKey:str];
    
    if(indexPath.section == 0 && indexPath.row == 0)
    {
#ifdef LITEVERSION
        NSLog(@"Product Button Not Purchased");
            UIButton *buyButtton = [[UIButton alloc]initWithFrame:CGRectMake(150, 10, 70, 35)];
            UIImage *image = [UIImage imageNamed:@"Purchase.png"];
            [buyButtton addTarget:self action:@selector(buyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [buyButtton setBackgroundImage:image forState:UIControlStateNormal];
            
            cell.accessoryView = buyButtton;
            cell.accessoryType = UITableViewCellAccessoryNone;
#else
            NSLog(@"Product Button Purchased");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
#endif
        cell.textLabel.textColor = [UIColor  blackColor];
        cell.textLabel.text = [objarray objectAtIndex:indexPath.row];
        
    }
    else if(indexPath.section == 1 && indexPath.row == 0)
    {
        Boolean strBreakIn=YES;
        NSString *strGetPropertyBrekIn=[self getProperties:@"BrekIn"];
        if([strGetPropertyBrekIn  isEqualToString:@"false"])
        {
            strBreakIn =NO;
        }else
        {
            strBreakIn=YES;
        }
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.text = [objarray objectAtIndex:indexPath.row];
        
#ifdef LITEVERSION
        if(![[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"BreakInPackagePurchased"] isEqualToString:@"YES"])
        {
            
            UIButton *buyButtton = [[UIButton alloc]initWithFrame:CGRectMake(150, 10, 70, 35)];
            UIImage *image = [UIImage imageNamed:@"Purchase.png"];
            [buyButtton addTarget:self action:@selector(purchaseButtonClicked1:) forControlEvents:UIControlEventTouchUpInside];
            [buyButtton setBackgroundImage:image forState:UIControlStateNormal];
            
            cell.accessoryView = buyButtton;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            UISwitch* aswitch = [[UISwitch alloc]  initWithFrame:CGRectZero];
            [aswitch setTag: 1];
            [aswitch addTarget:self action:@selector(swtValueChanged:) forControlEvents:UIControlEventValueChanged];
            aswitch.on = strBreakIn; // or NO
            cell.accessoryView = aswitch;
            [aswitch release];
        }
#else
        UISwitch* aswitch = [[UISwitch alloc]  initWithFrame:CGRectZero];
        [aswitch setTag: 1];
        [aswitch addTarget:self action:@selector(swtValueChanged:) forControlEvents:UIControlEventValueChanged];
        aswitch.on = strBreakIn; // or NO
        cell.accessoryView = aswitch;
        [aswitch release];
#endif
    }
    else if(indexPath.section == 1 && indexPath.row == 1)
    {
//#ifdef PROVERSION
        cell.textLabel.textColor = [UIColor  blackColor];
        cell.textLabel.text = [objarray objectAtIndex:indexPath.row];
//#else
//        cell.textLabel.text = [objarray objectAtIndex:indexPath.row];
//        //cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        cell.textLabel.enabled=NO;
//        cell.backgroundColor=[UIColor redColor];
//#endif
    }
    else  if(indexPath.section == 1 && indexPath.row == 2)
    {
        
        Boolean swtValue=YES;
        NSString *strGetPropertyBrekIn=[self getProperties:@"LoginPhoto"];
        if([strGetPropertyBrekIn  isEqualToString:@"false"])
        {
            swtValue =NO;
        }else
        {
            swtValue=YES;
        }
        cell.textLabel.textColor = [UIColor  blackColor];
        cell.textLabel.text = [objarray objectAtIndex:indexPath.row];
        UISwitch* aswitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        aswitch.on = swtValue; // or NO
        [aswitch setTag: 2];
        [aswitch addTarget:self action:@selector(swtValueChanged:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = aswitch;
        [aswitch release];
    }else if(indexPath.section == 1 && indexPath.row == 3)
    {
        cell.textLabel.textColor = [UIColor  blackColor];
        cell.textLabel.text = [objarray objectAtIndex:indexPath.row];
    
    }else if(indexPath.section ==2 && indexPath.row == 0)
    {
        cell.textLabel.textColor = [UIColor  blackColor];
        cell.textLabel.text = [objarray objectAtIndex:indexPath.row];
        
    }else if(indexPath.section == 3 && indexPath.row == 0)
    {
        cell.textLabel.textColor = [UIColor  blackColor];
        cell.textLabel.text = [objarray objectAtIndex:indexPath.row];
        
    }else if(indexPath.section == 3 && indexPath.row == 1)
    {
        cell.textLabel.textColor = [UIColor  blackColor];
        cell.textLabel.text = [objarray objectAtIndex:indexPath.row];
        
    }else if(indexPath.section == 3 && indexPath.row == 2)
    {
        cell.textLabel.textColor = [UIColor  blackColor];
        cell.textLabel.text = [objarray objectAtIndex:indexPath.row];
        
    }
    else if(indexPath.section == 4 && indexPath.row == 0)
    {
        cell.textLabel.textColor = [UIColor  blackColor];
        cell.textLabel.text = [objarray objectAtIndex:indexPath.row];
        cell.accessoryView = UITableViewCellAccessoryNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        self.facebookLikeView=[[FacebookLikeView alloc]initWithFrame:CGRectMake(310, 16,90, 22)];
        
        cell.accessoryView = self.facebookLikeView;
        
        self.facebookLikeView.href = [NSURL URLWithString:@"http://www.facebook.com/pages/Secret-App-Private-Albums-Manger/419463658136588"];
        self.facebookLikeView.layout = @"button_count";
        self.facebookLikeView.showFaces = NO;
        self.facebookLikeView.delegate=self;
        self.facebookLikeView.alpha = 0;
        [self.facebookLikeView load];
        [self.facebookLikeView release];
    }
    else if(indexPath.section == 4 && indexPath.row == 1)
    {
        cell.textLabel.textColor = [UIColor  blackColor];
        cell.textLabel.text = [objarray objectAtIndex:indexPath.row];
        
    }
    else if(indexPath.section == 5 && indexPath.row == 0)
    {
        cell.textLabel.textColor = [UIColor  blackColor];
        cell.textLabel.text = [objarray objectAtIndex:indexPath.row];
        
    }
#ifdef LITEVERSION
    else if(indexPath.section == 6 && indexPath.row == 0)
    {
        if(![[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"AdPackagePurchased"] isEqualToString:@"YES"])
        {
            NSLog(@"Product Button Not Purchased");
            
            UIButton *buyButtton = [[UIButton alloc]initWithFrame:CGRectMake(150, 10, 70, 35)];
            UIImage *image = [UIImage imageNamed:@"Purchase.png"];
            [buyButtton addTarget:self action:@selector(purchaseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [buyButtton setBackgroundImage:image forState:UIControlStateNormal];
            
            cell.accessoryView = buyButtton;
            cell.accessoryType = UITableViewCellAccessoryNone;
            NSLog(@"Product Button Purchased");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.textColor = [UIColor  blackColor];
            cell.textLabel.text = [objarray objectAtIndex:indexPath.row];
        }
    }
#else
#endif
        return  cell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSLog(@"section>>>>%d",section);
    
    if(section == 0)
    {
        return @"Select Active type";
    }
    else if(section == 1)
    {
        return @"Break in Attempts";
    }

    else if(section == 2)
    {
        return @"SlideShows";
    }
    else if(section == 3)
    {
        return @"More";
    }
    else if(section == 4)
    {
        return @"Like Us";
    }
#ifdef LITEVERSION
    else if(section == 5)
    {
        return @"In-App Purchase";
    }
#else
#endif

#ifdef LITEVERSION
    else if(section == 6)
    {
        if(![[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"AdPackagePurchased"] isEqualToString:@"YES"])
        {
            return @"Ad-Free Version";
        }
    }
#else
#endif
    else
    {
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    // if (_delegate != nil) {
    
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        NSLog(@"indexPath.section == 0 && indexPath.row == 0");
#ifdef PROVERSION
        //if (app.Purchase_array.count>0) {
            tablKeyPad *tabKey;
            tabKey= [[[tablKeyPad alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
            tabKey.delegate = self;
            [self.navigationController pushViewController:tabKey animated:YES];
#else
        [self buyButtonClicked:self];
#endif
    }
        else if(indexPath.section == 1 && indexPath.row == 0)
    {
#ifdef PROVERSION
        
#else
         //[self purchaseButtonClicked1:self];
#endif
//        if (app.Purchase_array.count<=0) {
//           
//        }
        
    }
    else if(indexPath.section == 1 && indexPath.row == 1)
    {
#ifdef PROVERSION
        tblViewAttempts *tabKey;
        tabKey= [[[tblViewAttempts alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
        tabKey.delegate = self;
        [self.navigationController pushViewController:tabKey animated:YES];

#else
      if([[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"BreakInPackagePurchased"] isEqualToString:@"YES"])
      {
          tblViewAttempts *tabKey;
          tabKey= [[[tblViewAttempts alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
          tabKey.delegate = self;
          [self.navigationController pushViewController:tabKey animated:YES];

      }
#endif
    }
    else  if(indexPath.section == 1 && indexPath.row == 2)
    {
        
    }
    else if(indexPath.section == 1 && indexPath.row == 3)
    {
        tblViewLogins *tabKey;
        tabKey= [[[tblViewLogins alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
        // tabKey.delegate = self;
        [self.navigationController pushViewController:tabKey animated:YES];
    }
    else if(indexPath.section == 1 && indexPath.row == 4)
    {
        
    }
    else if(indexPath.section == 2 && indexPath.row == 0)
    {
        tblSlideShow *tabKey;
        tabKey= [[[tblSlideShow alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
        tabKey.delegate = self;
        [self.navigationController pushViewController:tabKey animated:YES];
        
    }
    else if(indexPath.section == 3 && indexPath.row == 0)
    {
        UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:NULL delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:NULL otherButtonTitles:@"Email", @"SMS Message", @"Tweet", @"Post To Facebook" ,nil];
        popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [popupQuery showInView:self.view];
        [popupQuery release];
        
    }
    else if(indexPath.section == 3 && indexPath.row == 1)
    {
        viewHelp *defAlVw;
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            defAlVw = [[viewHelp alloc] initWithNibName:@"viewHelp_Ipad" bundle:nil];
        }
        else {
            defAlVw = [[viewHelp alloc] initWithNibName:@"viewHelp" bundle:nil];
        }
        
        CATransition *transUp=[CATransition animation];
        transUp.duration=0.5;
        transUp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transUp.delegate=self;
        transUp.type=kCATransitionMoveIn;
        transUp.subtype=kCATransitionFromTop;
        
        //addTitleView.hidden=NO;
        
        [self.navigationController pushViewController:defAlVw animated:YES];
        //[defAlVw release];
        
    }
    else if(indexPath.section == 3 && indexPath.row == 2)
    {
        
        viewTermsAndConditions *defAlVw;
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            defAlVw = [[viewTermsAndConditions alloc] initWithNibName:@"View" bundle:nil];
        }
        else {
            defAlVw = [[viewTermsAndConditions alloc] initWithNibName:@"viewTermsAndConditions" bundle:nil];
        }
        [self.navigationController pushViewController:defAlVw animated:YES];
        //[defAlVw release];
    }
    else if(indexPath.section == 4 && indexPath.row == 0)
    {
        NSLog(@"Like Us On Facebook");
        self.facebookLikeView.hidden = NO;
    }
    else if(indexPath.section == 4 && indexPath.row == 1)
    {
        NSLog(@"Like Us On Twitter");
        [self shareOnTwitter];
    }
    else if (indexPath.section == 6 && indexPath.row == 0)
    {
        if(![[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"AdPackagePurchased"] isEqualToString:@"YES"])
        {
            [self purchaseButtonClicked:self];
        }
        else
        {
            
        }
    }

    else if(indexPath.section == 5 && indexPath.row == 0)
    {
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions]; 
    }
    
}

//}
//- (void) accessoryButtonTapped: (UIControl *)sender withEvent: (UIEvent *) event
//{
//    UISwitch *switch1 = (UISwitch *)sender;
//    UITableViewCell *cell = (UITableViewCell *)switch1.superview;
//    NSIndexPath *indexPath = [self.tblFilters indexPathForCell:cell];
//
//    if (indexPath != nil)
//    {
//        clsWebFilter *ObjWF=[arrWebFilterList objectAtIndex:indexPath.row];
//        if(switch1.on)
//        {
//            [ObjDBMnager update:@"true" :ObjWF.WF_ID];
//        }else {
//            [ObjDBMnager update:@"false":ObjWF.WF_ID];
//        }
//    }
//
//    [arrWebFilterList removeAllObjects];
//    arrWebFilterList=[ObjDBMnager selectAll];
//    [tblFilters reloadData];
//}

-(IBAction)swtValueChanged:(id)sender
{
    NSInteger value=[sender tag];
    
    UISwitch *switch1 = (UISwitch *)sender;
    
    
    
    if(value ==1)
    {
        
        if(switch1.on)
        {
            [self update:@"true" : app.LoginUserID :@"BrekIn"];
            
        }else {
            [self update:@"false":app.LoginUserID :@"BrekIn"];
        }
    }else if(value ==2)
    {
        if(switch1.on)
        {
            [self update:@"true" : app.LoginUserID :@"LoginPhoto"];
            
        }else {
            [self update:@"false":app.LoginUserID :@"LoginPhoto"];
        }
    }else if(value ==3)
    {
        
        if(switch1.on)
        {
            [self update:@"true" : app.LoginUserID :@"HighQuality"];
            
        }else {
            [self update:@"false":app.LoginUserID :@"HighQuality"];
        }
        
    }else if(value ==4)
    {
        
        if(switch1.on)
        {
            [self update:@"true" : app.LoginUserID :@"Facebook"];
            
        }else {
            [self update:@"false":app.LoginUserID :@"Facebook"];
        }
        
    }else if(value ==5)
    {
        
        if(switch1.on)
        {
            [self update:@"true" : app.LoginUserID :@"UseDeskAgent"];
            
        }else {
            [self update:@"false":app.LoginUserID :@"UseDeskAgent"];
        }
        
    }
    [self.tableView reloadData];
    
    NSLog(@"%d",value);
}
#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

-(NSString *) Authentication
{
    NSString *strReturn=@"false";
    NSString *databasepath=[app getDBPathNew];
    if (sqlite3_open([databasepath UTF8String], &dbSecret) == SQLITE_OK)
    {
        
        
        NSString *selectSql = [NSString stringWithFormat:@"select VoiceAuth from AuthentictionCheckTbl where UserID = %@",app.LoginUserID];
        
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
            
        }
    }
    sqlite3_close(dbSecret);
    return strReturn;
}

-(Boolean) update :(NSString *)strValue :(NSString * )UserID :(NSString *)strProperty
{
    sqlite3_stmt *statement;
    
    if(sqlite3_open([[app getDBPathNew] UTF8String],&dbTest)== SQLITE_OK)
    {
        NSString *insertquery;
        
        if([strProperty isEqualToString:@"BrekIn"]){
            insertquery=[NSString stringWithFormat:@"UPDATE AutoLogOffTbl SET BrekinPhoto =\"%@\" where UserID=%@",strValue,UserID];
        }else if([strProperty isEqualToString:@"LoginPhoto"]){
            insertquery=[NSString stringWithFormat:@"UPDATE AutoLogOffTbl SET LoginPhoto =\"%@\" where UserID=%@",strValue,UserID];
        }else if([strProperty isEqualToString:@"HighQuality"]){
            insertquery=[NSString stringWithFormat:@"UPDATE AutoLogOffTbl SET HighQuality =\"%@\" where UserID=%@",strValue,UserID];
        }else if([strProperty isEqualToString:@"UseDeskAgent"]){
            insertquery=[NSString stringWithFormat:@"UPDATE AutoLogOffTbl SET UseDeskAgent =\"%@\" where UserID=%@",strValue,UserID];
        }else if([strProperty isEqualToString:@"Facebook"]){
            insertquery=[NSString stringWithFormat:@"UPDATE AutoLogOffTbl SET Facebook =\"%@\" where UserID=%@",strValue,UserID];
        }
        
        
        //        insertquery=[NSString stringWithFormat:@"UPDATE AutoLogOffTbl SET BrekinPhoto =\"%@\" where UserID=%@",strValue,UserID];
        NSLog(@"Query::::%@",insertquery);
        
        const char *insert_query=[insertquery UTF8String];
        sqlite3_prepare(dbTest,insert_query,-1,&statement,NULL);
        
        if(sqlite3_step(statement) == SQLITE_DONE){
            NSLog(@"record updated");
            sqlite3_finalize(statement);
            sqlite3_close(dbTest);
            return true;
        }
        else{
            NSLog(@"failed 2 connect");
            sqlite3_finalize(statement);
            sqlite3_close(dbTest);
            return false;
        }
        
    }
    else
    {
        sqlite3_close(dbTest);
        return false;
    }
}

-(NSString *) getProperties :(NSString *)strProperty
{
    NSString *strReturn=@"false";
    NSString *databasepath=[app getDBPathNew];
    NSString *selectSql;
    if (sqlite3_open([databasepath UTF8String], &dbSecret) == SQLITE_OK)
    {
        
        if([strProperty isEqualToString:@"Time"])
        {
            selectSql = [NSString stringWithFormat:@"select Time from AutoLogOffTbl where UserID=%@",app.LoginUserID];
        }else if([strProperty isEqualToString:@"BrekIn"]){
            selectSql = [NSString stringWithFormat:@"select BrekinPhoto from AutoLogOffTbl where UserID=%@",app.LoginUserID];
        }else if([strProperty isEqualToString:@"LoginPhoto"]){
            selectSql = [NSString stringWithFormat:@"select LoginPhoto from AutoLogOffTbl where UserID=%@",app.LoginUserID];
        }else if([strProperty isEqualToString:@"HighQuality"]){
            selectSql = [NSString stringWithFormat:@"select HighQuality from AutoLogOffTbl where UserID=%@",app.LoginUserID];
        }else if([strProperty isEqualToString:@"UseDeskAgent"]){
            selectSql = [NSString stringWithFormat:@"select UseDeskAgent from AutoLogOffTbl where UserID=%@",app.LoginUserID];
        }else if([strProperty isEqualToString:@"Facebook"]){
            selectSql = [NSString stringWithFormat:@"select Facebook from AutoLogOffTbl where UserID=%@",app.LoginUserID];
        }
        NSLog(@"Query : %@",selectSql);
        const char *sqlStatement = [selectSql UTF8String];
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


- (void)dealloc {
    [listOfItems release];
    [self.facebookLikeView release];
    self.colors = nil;
    self.delegate = nil;
    [super dealloc];
}

- (IBAction)sendMail
{
#ifdef LITEVERSION
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mfViewController = [[MFMailComposeViewController alloc] init];
        mfViewController.mailComposeDelegate = self;
        [mfViewController setSubject:@"Secret Vault on Appstore"];
        [mfViewController setMessageBody:@"This note is for....." isHTML:YES];
        NSString *someString = @"This is a link to Secret Vault.Its a nice one to try...<br/><a href=\"https://itunes.apple.com/us/app/secret-app/id569771443?ls=1&mt=8\">Secret Vault on itunes</a>\n";
        [mfViewController setMessageBody:someString isHTML:YES];
        [self presentViewController:mfViewController animated:YES completion:nil];
        [mfViewController release];
	}
#else
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mfViewController = [[MFMailComposeViewController alloc] init];
        mfViewController.mailComposeDelegate = self;
        [mfViewController setSubject:@"Secret Vault Pro on Appstore"];
        [mfViewController setMessageBody:@"This note is for....." isHTML:YES];
        //GoProLink
        NSString *someString = @"This is a link to Secret Vault Pro.Its a nice one to try...<br/><a href=\"https://itunes.apple.com/us/app/secret-vault-pro-plus/id873504069?ls=1&mt=8\">Secret Vault Pro on itunes</a>\n";
        [mfViewController setMessageBody:someString isHTML:YES];
        [self presentViewController:mfViewController animated:YES completion:nil];
        [mfViewController release];
	}

#endif
    else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"Email is not configured." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
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
    [alert release];
}

- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    
    picker.recipients = [NSArray arrayWithObject:@"123-456-7890"];
#ifdef LITEVERSION
    picker.body=@"I like this link now it's you turn https://itunes.apple.com/us/app/secret-app/id569771443?ls=1&mt=8";
#else
    //GoProLink
    picker.body=@"I like this link now it's you turn https://itunes.apple.com/us/app/secret-vault-pro-plus/id873504069?ls=1&mt=8";
#endif
    [self presentViewController:picker animated:YES completion:nil];
    [picker release];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    
    switch (result) {
        case MessageComposeResultCancelled:
            alert.message = @"Cancelled";
            break;
        case MessageComposeResultFailed:
            alert.message = @"Failed";
            break;
        case MessageComposeResultSent:
            alert.message = @"Send";
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [alert show];
    [alert release];
}

#pragma mark - Twitter

- (void)buildTweetSheet{
    
    /* make instance of tweet sheet */
    tweetSheet = [[TWTweetComposeViewController alloc] init];
    
    //Specify the completion handler
    TWTweetComposeViewControllerCompletionHandler completionHandler = ^(TWTweetComposeViewControllerResult result){
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    [tweetSheet setCompletionHandler:completionHandler];
}

+(BOOL)canSendTweet{
    
    BOOL _showTweetButton;
    /* Checks For Service Availability */
    if ([TWTweetComposeViewController canSendTweet] ) {
        // show my tweet button
        _showTweetButton = YES;
    }
    
    return _showTweetButton;
}


/* Sizing Notes
 
 - 140 characters maximum
 - Images and URLs use characters
 - currently uses 19 characters
 - URL Lengths could change; use return BOOLs!
 
 */

/* This method sets the initial text of the tweet  */
- (BOOL)setIntialText:(NSString *)text{
    
    BOOL allowed;
    
    // Try to set initial text
    allowed = [tweetSheet setInitialText:text];
    
    return allowed;
}

/* Add Image To Image */
-(BOOL)addImageToSheet:(UIImage *)image{
    
    BOOL allowed;
    
    // Try to add an image to the sheet
    allowed = [tweetSheet addImage:image];
    
    return allowed;
}

/* Setup URL Shortening  */

- (BOOL)addURLToSheet:(NSURL *)url{
    
    NSString *stringURL = [NSString stringWithFormat:@"%@", url];
    
    NSURL *newURL = [[NSURL alloc] initWithString:stringURL];
    
    BOOL allowed;
    
    /* Try to add a URL to sheet, returns NO
     if unsuccessful. */
    
    allowed = [tweetSheet addURL:newURL];
    
    return allowed;
}



#pragma mark - ActionSheet Methods

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
    if (buttonIndex == 0) {
        [self sendMail];
	}
    else if(buttonIndex == 1)
    {
        viewImageViewController *defAlVw;
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            defAlVw = [[viewImageViewController alloc] initWithNibName:@"viewImageViewController" bundle:nil];
        }
        else {
            defAlVw = [[viewImageViewController alloc] initWithNibName:@"viewImageViewController" bundle:nil];
        }
        [self.navigationController pushViewController:defAlVw animated:YES];
        [defAlVw release];
        
    }
    else if(buttonIndex == 2)
    {
        [self buildTweetSheet];
#ifdef LITEVERSION
        [tweetSheet setInitialText:@"I like this App now it's your turn to try...https://itunes.apple.com/us/app/secret-app/id569771443?ls=1&mt=8"];
        
        NSURL *url = [[NSURL alloc] initWithString:@"https://itunes.apple.com/us/app/secret-app/id569771443?ls=1&mt=8"];
        [tweetSheet addURL:url];
#else
        //GoProLink
        [tweetSheet setInitialText:@"I like this App now it's your turn to try...https://itunes.apple.com/us/app/secret-vault-pro-plus/id873504069?ls=1&mt=8"];
        //GoProLink
        NSURL *url = [[NSURL alloc] initWithString:@"https://itunes.apple.com/us/app/secret-vault-pro-plus/id873504069?ls=1&mt=8"];
        [tweetSheet addURL:url];
#endif
        [tweetSheet addImage:[UIImage imageNamed:@"114.png"]];
        
        // Show our tweet sheet
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else if(buttonIndex == 3)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"FBAccessTokenKey"]
            && [defaults objectForKey:@"FBExpirationDateKey"]) {
            facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
            facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        }
        if (![facebook isSessionValid]) {
            NSArray *permissions = [[NSArray alloc]initWithObjects:@"publish_stream", nil];
            [facebook authorize:permissions];
        }else{
            [self postToWall];
        }
    }
    
}

#pragma mark - facebook

-(void)postToWall
{
#ifdef LITEVERSION
    NSString *desc = [NSString stringWithFormat:@"This is a link to Secret Vault.Its a nice one to try."];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"https://itunes.apple.com/us/app/secret-app/id569771443?ls=1&mt=8",@"link",
                                   @"",@"picture",
                                   @"Secret Vault",@"name",
                                   @" ",@"caption",
                                   desc,@"description",
                                   @"Great App!",@"message",
                                   nil];
#else
    NSString *desc = [NSString stringWithFormat:@"This is a link to Secret Vault Pro.Its a nice one to try."];
    //GoProLink
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"https://itunes.apple.com/us/app/secret-vault-pro-plus/id873504069?ls=1&mt=8",@"link",
                                   @"",@"picture",
                                   @"Secret Vault Pro",@"name",
                                   @" ",@"caption",
                                   desc,@"description",
                                   @"Great App!",@"message",
                                   nil];

#endif
    [[self facebook] dialog:@"feed" andParams:params andDelegate:self];
}

- (IBAction)facebookShareButtonPressed:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]
        && [defaults objectForKey:@"FBExpirationDateKey"])
    {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    if (![facebook isSessionValid])
    {
        NSArray *permissions = [[NSArray alloc]initWithObjects:@"publish_stream", nil];
        [facebook authorize:permissions];
    }else{
        [self postToWall];
    }
}

// Pre iOS 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [facebook handleOpenURL:url];
}

// For iOS 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [facebook handleOpenURL:url];
}

-(void)fbDidNotLogin:(BOOL)cancelled{
    if (cancelled) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Could not Login" message:@"Facebook Cannot login for your application." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
}

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt
{
    NSLog(@"token extended");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [facebook extendAccessTokenIfNeeded];
}

- (void)fbSessionInvalidated {}

- (void)fbDidLogin {}

- (void)fbDidLogout {}

#pragma mark - Twitter Methods

- (void)shareOnTwitter{
    
    [self buildTweetSheet];
#ifdef LITEVERSION
    [tweetSheet setInitialText:(NSString *)[NSString stringWithFormat:@"@Secret_Vault"]];
#else
    [tweetSheet setInitialText:(NSString *)[NSString stringWithFormat:@"@Secret_Vault_Pro"]];
#endif

    
    // Show our tweet sheet
    [self presentViewController:tweetSheet animated:YES completion:nil];
    
}

- (void) openTwitterAppForFollowingUser:(NSString *)twitterUserName
{
	UIApplication *app = [UIApplication sharedApplication];
    
	// Tweetie: http://developer.atebits.com/tweetie-iphone/protocol-reference/
	NSURL *tweetieURL = [NSURL URLWithString:[NSString stringWithFormat:@"tweetie://user?screen_name=%@", twitterUserName]];
	if ([app canOpenURL:tweetieURL])
	{
		[app openURL:tweetieURL];
		return;
	}
    
	// Birdfeed: http://birdfeed.tumblr.com/post/172994970/url-scheme
	NSURL *birdfeedURL = [NSURL URLWithString:[NSString stringWithFormat:@"x-birdfeed://user?screen_name=%@", twitterUserName]];
	if ([app canOpenURL:birdfeedURL])
	{
		[app openURL:birdfeedURL];
		return;
	}
    
	// Twittelator: http://www.stone.com/Twittelator/Twittelator_API.html
	NSURL *twittelatorURL = [NSURL URLWithString:[NSString stringWithFormat:@"twit:///user?screen_name=%@", twitterUserName]];
	if ([app canOpenURL:twittelatorURL])
	{
		[app openURL:twittelatorURL];
		return;
	}
    
	// Icebird: http://icebirdapp.com/developerdocumentation/
	NSURL *icebirdURL = [NSURL URLWithString:[NSString stringWithFormat:@"icebird://user?screen_name=%@", twitterUserName]];
	if ([app canOpenURL:icebirdURL])
	{
		[app openURL:icebirdURL];
		return;
	}
    
	// Fluttr: no docs
	NSURL *fluttrURL = [NSURL URLWithString:[NSString stringWithFormat:@"fluttr://user/%@", twitterUserName]];
	if ([app canOpenURL:fluttrURL])
	{
		[app openURL:fluttrURL];
		return;
	}
    
	// SimplyTweet: http://motionobj.com/blog/url-schemes-in-simplytweet-23
	NSURL *simplytweetURL = [NSURL URLWithString:[NSString stringWithFormat:@"simplytweet:?link=http://twitter.com/%@", twitterUserName]];
	if ([app canOpenURL:simplytweetURL])
	{
		[app openURL:simplytweetURL];
		return;
	}
    
	// Tweetings: http://tweetings.net/iphone/scheme.html
	NSURL *tweetingsURL = [NSURL URLWithString:[NSString stringWithFormat:@"tweetings:///user?screen_name=%@", twitterUserName]];
	if ([app canOpenURL:tweetingsURL])
	{
		[app openURL:tweetingsURL];
		return;
	}
    
	// Echofon: http://echofon.com/twitter/iphone/guide.html
	NSURL *echofonURL = [NSURL URLWithString:[NSString stringWithFormat:@"echofon:///user_timeline?%@", twitterUserName]];
	if ([app canOpenURL:echofonURL])
	{
		[app openURL:echofonURL];
		return;
	}
    
	// --- Fallback: Mobile Twitter in Safari
	NSURL *safariURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.twitter.com/%@", twitterUserName]];
	[app openURL:safariURL];
}

#pragma mark - FacebookLikeViewDelegate methods

- (void)facebookLikeViewRequiresLogin:(FacebookLikeView *)aFacebookLikeView
{
    isFacebookLike=YES;
    [facebook authorize:[NSArray array]];
}

- (void)facebookLikeViewDidRender:(FacebookLikeView *)aFacebookLikeView {
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDelay:0.5];
    self.facebookLikeView.alpha = 1;
    [UIView commitAnimations];
}

- (void)facebookLikeViewDidLike:(FacebookLikeView *)aFacebookLikeView {
#ifdef LITEVERSION
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Liked"
                                                     message:@"You liked Secret Vault. Thanks!"
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil] autorelease];
#else
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Liked"
                                                     message:@"You liked Secret Vault Pro. Thanks!"
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil] autorelease];
#endif
    [alert show];
}

- (void)facebookLikeViewDidUnlike:(FacebookLikeView *)aFacebookLikeView {
#ifdef LITEVERSION
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Unliked"
                                                     message:@"You unliked Secret Card Vault on facebook. Where's the love?"
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil] autorelease];
#else
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Unliked"
                                                     message:@"You unliked Secret Card Vault Pro on facebook. Where's the love?"
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil] autorelease];

#endif
    [alert show];
}

#pragma mark - IN APP PURCHASE

-(void)RestorePreviousPurchase
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)timeout:(id)arg {
    
    _hud.labelText = @"Timeout!";
    _hud.detailsLabelText = @"Please try again later.";
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	_hud.mode = MBProgressHUDModeCustomView;
    [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:3.0];
}

- (void)dismissHUD:(id)arg
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    _hud = nil;
}

- (void)productsLoaded:(NSNotification *)notification {
    NSLog(@"productsLoaded");
    NSLog(@"app.Purchase_array%@ ",app.Purchase_array);
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}

- (void)productPurchased:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    NSString *productIdentifier = (NSString *)notification.object;
    NSLog(@"Purchased: %@", productIdentifier);
    
    [app.Purchase_array removeAllObjects];
    [[InAppRageIAPHelper alloc]init];
    NSLog(@"%hhd",[[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"BreakInPackagePurchased"] isEqualToString:@"YES"]);
//    if([[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"In-App Purchase"] isEqualToString:@"BreakIn Package"])
//     {
//        productPurchased = YES;
//        
//        [view removeFromSuperview];
//        self.navigationItem.rightBarButtonItem = nil;
//    }
//    
   // else
   // {
//        productPurchased = NO;
//        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"UPGRADE NOW!"
//                                                                        style:UIBarButtonSystemItemDone target:self action:@selector(buyButtonClicked:)];
//        rightButton.tintColor = [UIColor colorWithRed:20.0/255.0 green:183.0/255.0 blue:46.0/255.0 alpha:1.0];
//        self.navigationItem.rightBarButtonItem = rightButton;
  //  }

    [self sectionReload];
}
- (void)productPurchaseFailed:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notification.object;
    if (transaction.error.code != SKErrorPaymentCancelled) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error!"
                                                         message:transaction.error.localizedDescription
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil] autorelease];
        
        [alert show];
    }
}

-(IBAction)buyButtonClicked:(id)sender
{
    NSLog(@"Buy Button Clicked...");
    
    //self.tableView.scrollsToTop = YES;
    self.tableView.scrollEnabled = NO;
    [self.tableView setContentOffset:CGPointZero animated:NO];
    
    NSLog(@"Screen Height :: %f Width :: %f",self.view.bounds.size.height,self.view.bounds.size.width);
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        
        view = [[UIView alloc]initWithFrame:self.view.frame];
        view.backgroundColor = [[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.7];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            view.frame=CGRectMake(0,0,320,645);
        }
        
        UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(10, 60, 300, 560)];
        
        UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, 250, 100)];
        lbl1.text = @"To Gain Access To All Unlimited Features, additional features,";
        lbl1.numberOfLines = 3;
        lbl1.font = [UIFont systemFontOfSize:17.0];
        lbl1.lineBreakMode = NSLineBreakByWordWrapping;
        lbl1.textAlignment = NSTextAlignmentCenter;
        lbl1.textColor = [UIColor whiteColor];
        lbl1.backgroundColor = [UIColor blackColor];
        
        UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 140, 250, 330)];
        lbl2.text = @"1.NO ADS \n2.BREAK-IN ATTEMPTS FEATURE, \n you will be able to view any persons who try and attempt to access your information \n3.SELECT ACTIVE TYPE, you will \n be able to Change your passcode & \nchange the lock Type Voice Authentication, X9 Lock Code, Pin Code \n4. Video Folder, Store a video & record using the built in recorder";
        lbl2.numberOfLines = 10;
        lbl2.font = [UIFont systemFontOfSize:17.0];
        lbl2.textAlignment = NSTextAlignmentCenter;
        lbl2.lineBreakMode = NSLineBreakByWordWrapping;
        lbl2.textColor = [UIColor whiteColor];
        lbl2.backgroundColor = [UIColor blackColor];
        
        UIButton *btnBuy = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnBuy setTitle:@"Go Pro!" forState:UIControlStateNormal];
        [btnBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnBuy.titleLabel.font = [UIFont systemFontOfSize:24.0];
        btnBuy.frame = CGRectMake(45, 470, 220, 60);
        [btnBuy addTarget:self action:@selector(goProClicked:) forControlEvents:UIControlEventTouchDown];
        
        
        UIImage *backImage = [UIImage imageNamed:@"iphone-buy.png"];
        [btnBuy setBackgroundImage:backImage forState:UIControlStateNormal];
        
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchDown];
        
        UIImage *image = [UIImage imageNamed:@"close-right-part.png"];
        [btnCancel setImage:image forState:UIControlStateNormal];
        btnCancel.frame = CGRectMake(270, 0, 35, 35);
        
        [subView addSubview:lbl1];
        [subView addSubview:lbl2];
        [subView addSubview:btnBuy];
        [subView addSubview:btnCancel];
        
        
        [view addSubview:subView];
        
        [subView.layer setMasksToBounds:YES];
        subView.backgroundColor = [UIColor blackColor];
        
        [subView.layer setCornerRadius:10.0];
        subView.backgroundColor = [UIColor blackColor];
        [subView.layer setCornerRadius:10.0];
        [subView.layer setBorderColor:[[UIColor whiteColor]CGColor]];
        [subView.layer setBorderWidth:3.0];
        [self.view addSubview:view];
    }
    else
    {
        view = [[UIView alloc]initWithFrame:self.view.frame];
        view.backgroundColor = [[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.7];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            view.frame=CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height);
        }
        CGSize result = [[UIScreen mainScreen] bounds].size;
        UIView *subView;
        if(result.height < 568)
        {
            subView = [[UIView alloc] initWithFrame:CGRectMake(30,10,250,400)];
        }
        else
        {
            subView = [[UIView alloc]initWithFrame:CGRectMake(30, 40, 250, 400)];
        }
        UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 210, 60)];
        lbl1.text = @"To Gain Access To All Unlimited Features, additional features,";
        lbl1.numberOfLines = 3;
        lbl1.font = [UIFont systemFontOfSize:15.0];
        lbl1.lineBreakMode = NSLineBreakByWordWrapping;
        lbl1.textAlignment = NSTextAlignmentCenter;
        lbl1.textColor = [UIColor whiteColor];
        lbl1.backgroundColor = [UIColor blackColor];
        
        UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 210, 300)];
        lbl2.text = @"1.NO ADS \n2.BREAK-IN ATTEMPTS FEATURE, \n you will be able to view any persons who try and attempt to access your information \n3.SELECT ACTIVE TYPE, you will be able to Change your passcode & change the lock Type Voice Authentication, X9 Lock Code, Pin Code \n4. Video Folder, Store a video & record using the built in recorder";
        lbl2.numberOfLines = 20;
        lbl2.font = [UIFont systemFontOfSize:15.0];
        lbl2.lineBreakMode = NSLineBreakByWordWrapping;
        lbl2.textAlignment = NSTextAlignmentCenter;
        lbl2.textColor = [UIColor whiteColor];
        lbl2.backgroundColor = [UIColor blackColor];
        
        UIButton *btnBuy = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnBuy setTitle:@"Go Pro!" forState:UIControlStateNormal];
        [btnBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnBuy.frame = CGRectMake(65, 340, 120, 50);
        [btnBuy addTarget:self action:@selector(goProClicked:) forControlEvents:UIControlEventTouchDown];
        
        UIImage *backImage = [UIImage imageNamed:@"iphone-buy.png"];
        [btnBuy setBackgroundImage:backImage forState:UIControlStateNormal];
        
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchDown];
        
        UIImage *image = [UIImage imageNamed:@"close-right-part.png"];
        [btnCancel setImage:image forState:UIControlStateNormal];
        btnCancel.frame = CGRectMake(215, 0, 35, 35);
        
        [subView addSubview:lbl1];
        [subView addSubview:lbl2];
        [subView addSubview:btnBuy];
        [subView addSubview:btnCancel];
        
        [view addSubview:subView];
        
        [subView.layer setMasksToBounds:YES];
        subView.backgroundColor = [UIColor blackColor];
        
        [subView.layer setCornerRadius:10.0];
        subView.backgroundColor = [UIColor blackColor];
        [subView.layer setCornerRadius:10.0];
        [subView.layer setBorderColor:[[UIColor whiteColor]CGColor]];
        [subView.layer setBorderWidth:3.0];

        [self.view addSubview:view];
    }
}

-(IBAction)purchaseButtonClicked:(id)sender
{
    NSLog(@"Buy Button Clicked...");
    
    //self.tableView.scrollsToTop = YES;
    self.tableView.scrollEnabled = NO;
    [self.tableView setContentOffset:CGPointZero animated:NO];
    
    NSLog(@"Screen Height :: %f Width :: %f",self.view.bounds.size.height,self.view.bounds.size.width);
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        
        view = [[UIView alloc]initWithFrame:self.view.frame];
        view.backgroundColor = [[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.7];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            view.frame=CGRectMake(0,0,320,645);
        }
        
        UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(10, 60, 300, 250)];
        
        UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 250, 150)];
        lbl1.text = @"Upgrade now, to permanently remove Ads from your Secret Vault.";
        lbl1.numberOfLines = 6;
        lbl1.font = [UIFont systemFontOfSize:25.0];
        lbl1.lineBreakMode = NSLineBreakByWordWrapping;
        lbl1.textAlignment = NSTextAlignmentCenter;
        lbl1.textColor = [UIColor whiteColor];
        lbl1.backgroundColor = [UIColor blackColor];
        
        UIButton *btnBuy = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnBuy setTitle:@"Upgrade Now!" forState:UIControlStateNormal];
        [btnBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnBuy.titleLabel.font = [UIFont systemFontOfSize:24.0];
        btnBuy.frame = CGRectMake(30,155,250,75);
        [btnBuy addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchDown];        
        UIImage *backImage = [UIImage imageNamed:@"iphone-buy.png"];
        [btnBuy setBackgroundImage:backImage forState:UIControlStateNormal];
        
    
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchDown];
        
        UIImage *image = [UIImage imageNamed:@"close-right-part.png"];
        [btnCancel setImage:image forState:UIControlStateNormal];
        btnCancel.frame = CGRectMake(270, 0, 35, 35);
    
        [subView addSubview:lbl1];
        [subView addSubview:btnBuy];
        [subView addSubview:btnCancel];
        
        [view addSubview:subView];
        
        [subView.layer setMasksToBounds:YES];
        subView.backgroundColor = [UIColor blackColor];
        
        [subView.layer setCornerRadius:10.0];
        subView.backgroundColor = [UIColor blackColor];
        [subView.layer setCornerRadius:10.0];
        [subView.layer setBorderColor:[[UIColor whiteColor]CGColor]];
        [subView.layer setBorderWidth:3.0];
        
        [self.view addSubview:view];
    }
    else
    {
        view = [[UIView alloc]initWithFrame:self.view.frame];
        view.backgroundColor = [[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.7];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            view.frame=CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height);
        }
        CGSize result = [[UIScreen mainScreen] bounds].size;
        UIView *subView;
        if(result.height < 568)
        {
            subView = [[UIView alloc] initWithFrame:CGRectMake(30,10,250,150)];
        }
        else
        {
            subView = [[UIView alloc]initWithFrame:CGRectMake(30, 40, 250, 150)];
        }
        UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 210, 60)];
        lbl1.text = @"Upgrade now, to permanently remove Ads from your Secret Vault.";
        lbl1.numberOfLines = 3;
        lbl1.font = [UIFont systemFontOfSize:15.0];
        lbl1.lineBreakMode = NSLineBreakByWordWrapping;
        lbl1.textAlignment = NSTextAlignmentCenter;
        lbl1.textColor = [UIColor whiteColor];
        lbl1.backgroundColor = [UIColor blackColor];
        
        UIButton *btnBuy = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnBuy addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchDown];
        [btnBuy setTitle:@"Upgrade Now!" forState:UIControlStateNormal];
        [btnBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnBuy.frame = CGRectMake(50, 85, 150, 50);
        UIImage *backImage = [UIImage imageNamed:@"iphone-buy.png"];
        [btnBuy setBackgroundImage:backImage forState:UIControlStateNormal];
        
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchDown];
        
        UIImage *image = [UIImage imageNamed:@"close-right-part.png"];
        [btnCancel setImage:image forState:UIControlStateNormal];
        btnCancel.frame = CGRectMake(215, 0, 35, 35);
        
        [subView addSubview:lbl1];

        [subView addSubview:btnBuy];
        [subView addSubview:btnCancel];
        
        [view addSubview:subView];
        
        [subView.layer setMasksToBounds:YES];
        subView.backgroundColor = [UIColor blackColor];
        
        [subView.layer setCornerRadius:10.0];
        subView.backgroundColor = [UIColor blackColor];
        [subView.layer setCornerRadius:10.0];
        [subView.layer setBorderColor:[[UIColor whiteColor]CGColor]];
        [subView.layer setBorderWidth:3.0];
        
        [self.view addSubview:view];
    }
}
-(IBAction)purchaseButtonClicked1:(id)sender
{
    NSLog(@"Buy Button Clicked...");
    
    //self.tableView.scrollsToTop = YES;
    self.tableView.scrollEnabled = NO;
    [self.tableView setContentOffset:CGPointZero animated:NO];
    
    NSLog(@"Screen Height :: %f Width :: %f",self.view.bounds.size.height,self.view.bounds.size.width);
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        
        view = [[UIView alloc]initWithFrame:self.view.frame];
        view.backgroundColor = [[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.7];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            view.frame=CGRectMake(0,0,320,645);
        }
        
        UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(10, 60, 300, 320)];
        
        UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 250, 50)];
        lbl1.text = @"Upgrade & Gain Access To !";
        lbl1.numberOfLines = 1;
        lbl1.font = [UIFont systemFontOfSize:15.0];
        lbl1.lineBreakMode = NSLineBreakByWordWrapping;
        lbl1.textAlignment = NSTextAlignmentCenter;
        lbl1.textColor = [UIColor whiteColor];
        lbl1.backgroundColor = [UIColor blackColor];
        
        UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 250, 200)];
        lbl2.text = @"- Remove All Ads \n - BREAK-IN ATTEMPTS FEATURE, \n View Photo + Time & Date of the person attempting to break-in.";
        lbl2.numberOfLines = 6;
        lbl2.font = [UIFont systemFontOfSize:15.0];
        lbl2.lineBreakMode = NSLineBreakByWordWrapping;
        lbl2.textAlignment = NSTextAlignmentCenter;
        lbl2.textColor = [UIColor whiteColor];
        lbl2.backgroundColor = [UIColor blackColor];

        
        UIButton *btnBuy = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnBuy addTarget:self action:@selector(buyClick1) forControlEvents:UIControlEventTouchDown];
        [btnBuy setTitle:@"Upgrade Now!" forState:UIControlStateNormal];
        [btnBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnBuy.titleLabel.font = [UIFont systemFontOfSize:24.0];
        btnBuy.frame = CGRectMake(30,220,250,75);
        UIImage *backImage = [UIImage imageNamed:@"iphone-buy.png"];
        [btnBuy setBackgroundImage:backImage forState:UIControlStateNormal];
        
        
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchDown];
        
        UIImage *image = [UIImage imageNamed:@"close-right-part.png"];
        [btnCancel setImage:image forState:UIControlStateNormal];
        btnCancel.frame = CGRectMake(270, 0, 35, 35);
        
        [subView addSubview:lbl1];
        [subView addSubview:lbl2];
        [subView addSubview:btnBuy];
        [subView addSubview:btnCancel];
        
        [view addSubview:subView];
        
        [subView.layer setMasksToBounds:YES];
        subView.backgroundColor = [UIColor blackColor];
        
        [subView.layer setCornerRadius:10.0];
        subView.backgroundColor = [UIColor blackColor];
        [subView.layer setCornerRadius:10.0];
        [subView.layer setBorderColor:[[UIColor whiteColor]CGColor]];
        [subView.layer setBorderWidth:3.0];
        
        [self.view addSubview:view];
    }
    else
    {
        view = [[UIView alloc]initWithFrame:self.view.frame];
        view.backgroundColor = [[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.7];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            view.frame=CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height);
        }
        CGSize result = [[UIScreen mainScreen] bounds].size;
        UIView *subView;
        if(result.height < 568)
        {
            subView = [[UIView alloc] initWithFrame:CGRectMake(30,10,250,280)];
        }
        else
        {
            subView = [[UIView alloc]initWithFrame:CGRectMake(30, 40, 250, 280)];
        }
        UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 210, 60)];
        lbl1.text = @"Upgrade & Gain Access To !";
        lbl1.numberOfLines = 3;
        lbl1.font = [UIFont systemFontOfSize:15.0];
        lbl1.lineBreakMode = NSLineBreakByWordWrapping;
        lbl1.textAlignment = NSTextAlignmentCenter;
        lbl1.textColor = [UIColor whiteColor];
        lbl1.backgroundColor = [UIColor blackColor];
        
        UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 210, 150)];
        lbl2.text = @"- Remove All Ads \n - BREAK-IN ATTEMPTS FEATURE, \n View Photo + Time & Date of the person attempting to brea-in.";
        lbl2.numberOfLines = 20;
        lbl2.font = [UIFont systemFontOfSize:15.0];
        lbl2.lineBreakMode = NSLineBreakByWordWrapping;
        lbl2.textAlignment = NSTextAlignmentCenter;
        lbl2.textColor = [UIColor whiteColor];
        lbl2.backgroundColor = [UIColor blackColor];
        
        UIButton *btnBuy = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnBuy addTarget:self action:@selector(buyClick1) forControlEvents:UIControlEventTouchDown];
        [btnBuy setTitle:@"Upgrade Now!" forState:UIControlStateNormal];
        [btnBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnBuy.frame = CGRectMake(50, 220, 150, 50);
        UIImage *backImage = [UIImage imageNamed:@"iphone-buy.png"];
        [btnBuy setBackgroundImage:backImage forState:UIControlStateNormal];
        
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchDown];
        
        UIImage *image = [UIImage imageNamed:@"close-right-part.png"];
        [btnCancel setImage:image forState:UIControlStateNormal];
        btnCancel.frame = CGRectMake(215, 0, 35, 35);
        
        [subView addSubview:lbl1];
        [subView addSubview:lbl2];
        [subView addSubview:btnBuy];
        [subView addSubview:btnCancel];
        
        [view addSubview:subView];
        
        [subView.layer setMasksToBounds:YES];
        subView.backgroundColor = [UIColor blackColor];
        
        [subView.layer setCornerRadius:10.0];
        subView.backgroundColor = [UIColor blackColor];
        [subView.layer setCornerRadius:10.0];
        [subView.layer setBorderColor:[[UIColor whiteColor]CGColor]];
        [subView.layer setBorderWidth:3.0];
        

        [self.view addSubview:view];
    }
}

-(IBAction)goProClicked:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://itunes.apple.com/us/app/secret-vault-pro-plus/id873504069?ls=1&mt=8"]];
}

-(void)buyClick
{
    app.iSBuyCLick=YES;
    NSString *identifier=[NSString stringWithFormat:@"com.sublime.SecretApp.RemoveAds"];
    //   SKProduct *product = [[InAppRageIAPHelper sharedHelper].products objectAtIndex:tag_value];
    [[InAppRageIAPHelper sharedHelper] buyProductIdentifier:identifier];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _hud.labelText = @"Buying Package...";
    app.buyProduct = [NSString stringWithFormat:@"Buy Remove Ads In-App Purchase"];
    [self performSelector:@selector(timeout:) withObject:nil afterDelay:60*5];
    NSLog(@"Buy Button Clicked...");
}
-(void)buyClick1
{
    app.iSBuyCLick=YES;
    NSString *identifier=[NSString stringWithFormat:@"com.sublime.SecretApp.attempts"];
    NSLog(@"Buying %@...",app.Purchase_array);
    
    [[InAppRageIAPHelper sharedHelper] buyProductIdentifier:identifier];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _hud.labelText = @"Buying Package...";
    app.buyProduct = [NSString stringWithFormat:@"Buy Break-In Attempts In-App Purchase"];
    [self performSelector:@selector(timeout:) withObject:nil afterDelay:60*5];
    NSLog(@"Buy Button Clicked...");
}

-(void)cancelClick
{
    [view removeFromSuperview];
    self.tableView.scrollEnabled = YES;
    
    NSLog(@"Cancel Button Clicked...");
}

@end

