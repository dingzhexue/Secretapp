//
//  tablKeyPad.m
//  SecretApp
//
//  Created by c27 on 15/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "tablKeyPad.h"
#import "tblKepPadTap.h"
#import "tblPinCodeLockTap.h"

@interface tablKeyPad ()

@end

@implementation tablKeyPad

@synthesize delegate = _delegate;
@synthesize listOfItems;
- (instancetype)initWithStyle:(UITableViewStyle)style
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
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    app=(AppDelegate *) [UIApplication sharedApplication].delegate;
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
      self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"main-bg.png"]]];
    listOfItems = [[NSMutableArray alloc] init];
    
    NSArray *itemsArray1 =@[@"Voice Authentication",@"DockLock x9",@"Pin Code"];
    NSDictionary *itemsDict1 = @{@"0": itemsArray1};
    
    
    [listOfItems addObject:itemsDict1];

}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    [self.tableView reloadData];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return listOfItems.count;
    //return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSDictionary *objdict = listOfItems[section];
    NSString *str = [NSString stringWithFormat:@"%li",(long)section];
    NSArray *objarray = objdict[str];
    return objarray.count;
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
    NSDictionary *objdict = listOfItems[indexPath.section];
    NSString *str = [NSString stringWithFormat:@"%li",(long)indexPath.section];
    NSArray *objarray = objdict[str];
    

    NSString *strAutType= [GlobalFunctions getStringValueFromUserDefaults_ForKey:@"LockMethod2"];

    NSLog(@"strAutType :: %@",strAutType);
    
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        if([strAutType isEqualToString:@"Voice"])
        {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;        
        }

      
    }else if(indexPath.section == 0 && indexPath.row == 1)
    {
        if([strAutType isEqualToString:@"Pattern"] || [strAutType isEqualToString:@""] || !strAutType)
        {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;        
        }
    }else if(indexPath.section == 0 && indexPath.row == 2)
    {
        if([strAutType isEqualToString:@"PinCode"])
        {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
    }
    
    cell.textLabel.textColor = [UIColor  blackColor];
    cell.textLabel.text = objarray[indexPath.row]; 
    
    return  cell;    
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
    {
        return @"Press code type";
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {   if (_delegate != nil) {
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        NSLog(@"indexPath.section == 0 && indexPath.row == 0");
        tblKepPadTap *tabKey;
        tabKey= [[[tblKepPadTap alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
        tabKey.delegate = self;
        [self.navigationController pushViewController:tabKey animated:YES];    
    }else if(indexPath.section == 0 && indexPath.row == 1)
    {
        NSLog(@"indexPath.section == 0 && indexPath.row == 1");
        tblDockLockTap *tabKey;
        tabKey= [[[tblDockLockTap alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
        tabKey.delegate = self;
        [self.navigationController pushViewController:tabKey animated:YES];
    }
    else if(indexPath.section == 0 && indexPath.row == 2)
    {
        NSLog(@"indexPath.section == 0 && indexPath.row == 2");

        tblPinCodeLockTap *tabKey;
        tabKey= [[[tblPinCodeLockTap alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
        tabKey.delegate = self;
        [self.navigationController pushViewController:tabKey animated:YES];
    }
}
    
}
-(NSString *) Authentication
{
    NSString *strReturn=@"false";
    NSString *databasepath=[app getDBPathNew];
    if (sqlite3_open(databasepath.UTF8String, &dbSecret) == SQLITE_OK) 
    {
        
        
        NSString *selectSql = [NSString stringWithFormat:@"select VoiceAuth from AuthentictionCheckTbl where UserID = %@",app.LoginUserID];
        
        NSLog(@"Query : %@",selectSql);
        const char *sqlStatement = selectSql.UTF8String;
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


@end
