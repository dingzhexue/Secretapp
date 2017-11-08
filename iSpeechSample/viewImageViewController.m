//
//  viewImageViewController.m
//  SecretApp
//
//  Created by c35 on 26/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "ImportedContCustomCell.h"
#import "viewImageViewController.h"
#import "AppDelegate.h"
@interface viewImageViewController ()

@end

@implementation viewImageViewController
//@synthesize  lblTime,lblDate,imgPhoto,lblTitle;
@synthesize contactsTable;
AppDelegate *app;
- (void)dealloc
{
//    [imgPhoto release];
//    [lblDate release];
//    [lblTitle release];
//    [lblTime release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self importContacts];   
}
-(void)viewWillAppear:(BOOL)animated
{
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.navigationController.navigationBarHidden=NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
}
- (void)viewDidUnload
{
    [super viewDidUnload];
   
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
    arrSelectedNumber=[[NSMutableArray alloc]init];
    ABAddressBookRef addressBook = ABAddressBookCreate();
    // NSArray *thePeople = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
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
                if ([name length]>0 && count1!=0)
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
            
            [contactsTable reloadData];
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
            if ([name length]>0 && count1!=0)
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
        
        [contactsTable reloadData];
    }
    else {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Update permissions for Contects in Settings" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"cont data count:::: %d",[wantedname count]);
    return [wantedname count];
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
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.impConNmLbl.text=[wantedname objectAtIndex:indexPath.row];
    cell.impConPhoneLbl.text=[wantednumber objectAtIndex:indexPath.row];
    if(arrSelectedNumber.count>=1){
        Boolean flag=false;
    for(NSInteger i=0;i<arrSelectedNumber.count;i++)
    {
        if([[arrSelectedNumber objectAtIndex:i] isEqual:[wantednumber objectAtIndex:indexPath.row]])
        {
            flag =true;
            break;
        }     
    }
        if(flag)
        {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;               
        }else {
            cell.accessoryType=UITableViewCellAccessoryNone;   
        }
    }else {
            cell.accessoryType=UITableViewCellAccessoryNone;   
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if(arrSelectedNumber.count>=1){
   
        Boolean flag=false;
        for(NSInteger i=0;i<arrSelectedNumber.count;i++)
        {
        if([[arrSelectedNumber objectAtIndex:i] isEqual:[wantednumber objectAtIndex:indexPath.row]])
        {
            [arrSelectedNumber removeObjectAtIndex:i];
            flag=true;
            break;
        }        
        }
        if(!flag)
        {
            [arrSelectedNumber addObject: [wantednumber objectAtIndex:indexPath.row]];    
        }
    }else{
            [arrSelectedNumber addObject: [wantednumber objectAtIndex:indexPath.row]];
    }
        
    [contactsTable reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        return 60;
    }else
    {
        return  45;    
    }
}
-(IBAction)btnSendClick:(id)sender
{
    if(arrSelectedNumber.count>=1)
        {
            NSArray *toRecipients=[[NSArray alloc]init];
            //         NSArray *toRecipients = [NSArray arrayWithObjects:@"+919913567316", nil];
            //        for (NSInteger i=0; i<arrSelectedNumber.count; i++) {
            ////            toRecipients = [arrSelectedNumber objectAtIndexnnnnnnhggh:i];
            //            [toRecipients indexOfObject:[arrSelectedNumber objectAtIndex:i] ];
            //        }
            NSLog(@"Recipient Count  %d",toRecipients.count);
#ifdef LITEVERSION
            [self sendSMS:(NSString *)[NSString stringWithFormat:@"%@",@"Secret Vault"] recipientList:arrSelectedNumber];
#else
            [self sendSMS:(NSString *)[NSString stringWithFormat:@"%@",@"Secret Vault Pro"] recipientList:arrSelectedNumber];
#endif
            NSLog(@"Count  %d",arrSelectedNumber.count);
            
        }else {
            
        }
}
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSMutableArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;    
        controller.recipients=arrSelectedNumber;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
    [controller release];
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



    
    

@end
