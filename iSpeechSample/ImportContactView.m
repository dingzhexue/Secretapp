//
//  ImportContactView.m
//  SecretApp
//
//  Created by c62 on 18/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImportContactView.h"
#import "ImportedContCustomCell.h"
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"
#import "GADInterstitial.h"

@interface ImportContactView () <GADInterstitialDelegate, GADBannerViewDelegate>

@property (nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation ImportContactView
@synthesize contactsTable;

@synthesize interstitial;


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
    [contactsTable release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    contactsTable.delegate = self;
    contactsTable.dataSource = self;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    }

    // Do any additional setup after loading the view from its nib.
    app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
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
    
    [self importContacts];
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

-(void)importContacts
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    else
    {
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    }
    
    self.title = @"iPhone Contacts";
    
    wantedname= [[NSMutableArray alloc] init];
    wantednumber= [[NSMutableArray alloc] init];
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    //Priyank Change
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            // First time access has been granted, add the contact
            ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
            NSArray *thePeople = (NSArray*)ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByLastName);

            NSString *name;
            for (id person in thePeople)
            {
                name = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
                NSLog(@" name ---> %@",name);
                ABMultiValueRef multi = ABRecordCopyValue(person, kABPersonPhoneProperty);
                int count1=ABMultiValueGetCount(multi);
                NSLog(@"%d",count1);
                if (name.length>0 && count1!=0)
                {
                    NSString *beforenumber = (NSString *)ABMultiValueCopyValueAtIndex(multi, 0);
                    NSLog(@" contacts:::: %@",beforenumber );
                    NSString* removed1=[beforenumber stringByReplacingOccurrencesOfString:@"-"withString:@""];
                    NSString* removed2=[removed1 stringByReplacingOccurrencesOfString:@")"withString:@""];
                    NSString* removed3=[removed2 stringByReplacingOccurrencesOfString:@" "withString:@""];
                    NSString* removed4=[removed3 stringByReplacingOccurrencesOfString:@"("withString:@""];
                    NSString* removed5=[removed4 stringByReplacingOccurrencesOfString:@"+"withString:@""];
                    [wantedname addObject:name];
                    [wantednumber addObject:removed5];
                    // CFRelease(beforenumber);
                    [beforenumber release];
                    //CFRelease(name);
                }
                //CFRelease(name);
                [name release];
                CFRelease(multi);
            }

            CFRelease(addressBook);
            CFRelease(thePeople);


            [contactsTable performSelectorOnMainThread:@selector(reloadData)
                                            withObject:nil
                                         waitUntilDone:NO];
//            [contactsTable reloadData];
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
        NSArray *thePeople = (NSArray*)ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByLastName);
        
        NSString *name;
        for (id person in thePeople)
        {
            name = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
            NSLog(@" name ---> %@",name);
            ABMultiValueRef multi = ABRecordCopyValue(person, kABPersonPhoneProperty);
            int count1=ABMultiValueGetCount(multi);
            NSLog(@"%d",count1);
            if (name.length>0 && count1!=0)
            {
                NSString *beforenumber = (NSString *)ABMultiValueCopyValueAtIndex(multi, 0);
                NSLog(@" contacts:::: %@",beforenumber );
                NSString* removed1=[beforenumber stringByReplacingOccurrencesOfString:@"-"withString:@""];
                NSString* removed2=[removed1 stringByReplacingOccurrencesOfString:@")"withString:@""];
                NSString* removed3=[removed2 stringByReplacingOccurrencesOfString:@" "withString:@""];
                NSString* removed4=[removed3 stringByReplacingOccurrencesOfString:@"("withString:@""];
                NSString* removed5=[removed4 stringByReplacingOccurrencesOfString:@"+"withString:@""];
                [wantedname addObject:name];
                [wantednumber addObject:removed5];
                // CFRelease(beforenumber);
                [beforenumber release];
                //CFRelease(name);
            }
            //CFRelease(name);
            [name release];
            CFRelease(multi);
        }
        
        CFRelease(addressBook);
        CFRelease(thePeople);
        
        contactsTable.delegate = self;
        contactsTable.dataSource = self;
        
                    [contactsTable performSelectorOnMainThread:@selector(reloadData)
                                                    withObject:nil
                                                 waitUntilDone:NO];
//        [contactsTable reloadData];
    }
    else {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Update permissions for Contects in Settings" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    //Change Over
    
    
    
    // NSArray *thePeople = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"cont data count:::: %lu",(unsigned long)wantedname.count);
    return wantedname.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ImportedContactCustomCell";
    
    ImportedContCustomCell *cell = (ImportedContCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib;
      
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        nib = [[NSBundle mainBundle] loadNibNamed:@"ImportedContCustomCell_Ipad" owner:self options:nil];
    }else {
        nib = [[NSBundle mainBundle] loadNibNamed:@"ImportedContCustomCell" owner:self options:nil];
    }
        
        
//        nib = [[NSBundle mainBundle] loadNibNamed:@"ImportedContCustomCell" owner:self options:nil];
        for(id oneObject in nib)
            if([oneObject isKindOfClass:[ImportedContCustomCell class]])
                cell = (ImportedContCustomCell *)oneObject;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.impConNmLbl.text=wantedname[indexPath.row];
    cell.impConPhoneLbl.text=wantednumber[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    app.conNm=wantedname[indexPath.row];
    app.conPhone=wantednumber[indexPath.row];
    
    sqlite3_stmt *stmt;
    databasepath=[app getDBPathNew];
    const char *dbpath=databasepath.UTF8String;
    if(sqlite3_open(dbpath, &dbSecret) == SQLITE_OK)
    {
        NSString *insertquery=[NSString stringWithFormat:@"Insert into ContactTbl (UserID,ContName,ContPhone) VALUES(%d,\"%@\",\"%@\")",(app.LoginUserID).intValue,app.conNm,app.conPhone];
        
        NSLog(@"insert Query::::> %@",insertquery);
        
        const char *insert_query=insertquery.UTF8String;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
            return 60;
    }
    else
    {
        return  45;    
    }
}

#pragma mark - GADDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    if(self == self.navigationController.topViewController)
        [self.interstitial presentFromRootViewController:self];
}

@end
