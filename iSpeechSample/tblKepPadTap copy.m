//
//  tblKepPadTap.m
//  SecretApp
//
//  Created by c27 on 15/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "tblKepPadTap.h"
#import "viewVoiceAuthentication.h"

#import "AppDelegate.h"
@interface tblKepPadTap ()

@end

@implementation tblKepPadTap
@synthesize delegate = _delegate;
@synthesize listOfItems;


AppDelegate *app;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    listOfItems = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"main-bg.png"]]];
    
    NSArray *itemsArray1 =[NSArray arrayWithObjects:@"Change Password ",@"Set as a Lock",nil];
    NSDictionary *itemsDict1 = [NSDictionary dictionaryWithObject:itemsArray1 forKey:@"0"];
    
    
    [listOfItems addObject:itemsDict1];

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
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
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSDictionary *objdict = [listOfItems objectAtIndex:indexPath.section];
        NSString *str = [NSString stringWithFormat:@"%i",indexPath.section];
        NSArray *objarray = [objdict objectForKey:str];
        
//        if(indexPath.section == 0 && indexPath.row == 0)
//        {
//            cell.textLabel.textColor = [UIColor  blackColor];
//            cell.textLabel.text = [objarray objectAtIndex:indexPath.row];
//            UISwitch* aswitch = [[UISwitch alloc] initWithFrame:CGRectZero];
//            aswitch.on = YES; // or NO
//            cell.accessoryView = aswitch;
//            [aswitch release];            
//        } else      {
            cell.textLabel.textColor = [UIColor  blackColor];
            cell.textLabel.text = [objarray objectAtIndex:indexPath.row];
            
//        }
        
    }
    
    
    
    
    return  cell;    
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
    if(section == 0)
    {
        return @"Voice Authentication settings";
    }
    else 
    {
        return @"";
    }
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}



#pragma mark -
#pragma mark Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {   if (_delegate != nil) {
    if(indexPath.section == 0 && indexPath.row == 0)
        {
            NSString *strAuth= [self Authentication];
        if([strAuth isEqualToString:@"false"])
        {
            NSLog(@"First set as a lock");  
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Voice Authentication Lock Settings" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
            alert.message=@"First set as a lock.";
            [alert show];
        }else
        {
            viewVoiceAuthentication *defAlVw;
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
            {
                defAlVw = [[viewVoiceAuthentication alloc] initWithNibName:@"viewVoiceAuthentication" bundle:nil];
            }
            else {
                defAlVw = [[viewVoiceAuthentication alloc] initWithNibName:@"viewVoiceAuthentication" bundle:nil];
            }
            [self.navigationController pushViewController:defAlVw animated:YES];
            [defAlVw release];
        }
//        app.chngePWD=true;
//        
//        DrawPatternLockViewController *drwNew=[[DrawPatternLockViewController alloc]init];
//        [self.navigationController pushViewController:drwNew animated:YES];
    } else if(indexPath.section == 0 && indexPath.row == 1)
    {
        NSString *strAuth= [self Authentication];
        if([strAuth isEqualToString:@"false"])
        {
            
            NSLog(@"set Voice as a Lock");  
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Voice Authentication Settings" message:@"" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
            alert.message=@"Do you want to set Voice Lock?";
            [alert show];
            [alert release];
        }else 
        {
            NSLog(@"set Voice as a Lock");  
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Voice Authentication Settings" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
            alert.message=@"Voice lock is alredy set as a lock!";
            [alert show];
            [alert release];
        } 
    }	 else if(indexPath.section == 0 && indexPath.row == 2)
    {
        NSString *strAuth= [self Authentication];
        if([strAuth isEqualToString:@"false"])
        {
            
            NSLog(@"Set PinCode as a Lock");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PinCode Authentication Settings" message:@"" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
            alert.message=@"Do you want to set PinCode Lock?";
            [alert show];
            [alert release];
        }else
        {
            NSLog(@"Set PinCode as a Lock");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PinCode Authentication Settings" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
            alert.message=@"PinCode lock is alredy set as a lock!";
            [alert show];
            [alert release];
        }
    }
    
    
}
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
      if([title isEqualToString:@"Yes"])
    {
        app.chngePWD = YES;
        viewVoiceAuthentication *defAlVw;
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            defAlVw = [[viewVoiceAuthentication alloc] initWithNibName:@"viewVoiceAuthentication" bundle:nil];
        }
        else {
            defAlVw = [[viewVoiceAuthentication alloc] initWithNibName:@"viewVoiceAuthentication" bundle:nil];
        }
        [self.navigationController pushViewController:defAlVw animated:YES];
        [defAlVw release];
   

    }
  
}

-(NSString *) Authentication
{
    NSString *strReturn=@"false";
    NSString *databasepath=[app getDBPath];
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
            sqlite3_finalize(query_stmt); 
        }
    }
    sqlite3_close(dbSecret);  
    return strReturn;
}


@end
