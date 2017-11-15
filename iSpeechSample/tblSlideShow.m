//
//  tblSlideShow.m
//  SecretApp
//
//  Created by c27 on 15/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "tblSlideShow.h"
@interface tblSlideShow ()

@end

@implementation tblSlideShow
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
    app=(AppDelegate *)[UIApplication sharedApplication ].delegate;
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    
    
     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"main-bg.png"]]];
       
 
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    listOfItems = [[NSMutableArray alloc] init];
    NSArray *itemsArray1 =@[@"2 Seconds",@" 3 Seconds",@"5 Seconds",@"10 Seconds",@"20 Seconds"];
    NSDictionary *itemsDict1 = @{@"0": itemsArray1};
    [listOfItems addObject:itemsDict1];
    
    NSArray *itemsArray2 =@[@"Flip from left Right",@"Flip from left",@"Curl Up",@"Raandom Effect"];
    NSDictionary *itemsDict2 = @{@"1": itemsArray2};
    
    [listOfItems addObject:itemsDict2];
    
    NSArray *itemsArray3 =@[@"Repeat",@"Shuffle"];
    NSDictionary *itemsDict3 = @{@"2": itemsArray3};
    [listOfItems addObject:itemsDict3];
  

}
-(void)viewWillDisappear:(BOOL)animated
{
    app.isnAvigateFromPattern=false;    
    
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

-(NSString *) getProperties :(NSString *)strProperty
{
    NSString *strReturn=@"false";
    NSString *databasepath=[app getDBPathNew];
    NSString *selectSql = nil;
    if (sqlite3_open(databasepath.UTF8String, &dbSecret) == SQLITE_OK) 
    {
        
        if([strProperty isEqualToString:@"Duration"])  
        {
            selectSql = [NSString stringWithFormat:@"select Duration from AutoLogOffTbl where UserID = %@ ",app.LoginUserID];
        }else if([strProperty isEqualToString:@"Transition"]){
            selectSql = [NSString stringWithFormat:@"select Transition from AutoLogOffTbl where UserID = %@ ",app.LoginUserID];
        }else if([strProperty isEqualToString:@"Repeat"]){
            selectSql = [NSString stringWithFormat:@"select Repeat from AutoLogOffTbl where UserID = %@ ",app.LoginUserID];
        }else if([strProperty isEqualToString:@"Shuffle"]){
            selectSql = [NSString stringWithFormat:@"select Shuffle from AutoLogOffTbl where UserID = %@ ",app.LoginUserID];
        }
        
        NSLog(@"Query : %@",selectSql);
        const char *sqlStatement = selectSql.UTF8String;
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
            strReturn =@"nil";
        }
        sqlite3_finalize(query_stmt);
    }
    sqlite3_close(dbSecret);  
    return strReturn;
}

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
    NSDictionary *objdict = listOfItems[indexPath.section];
    NSString *str = [NSString stringWithFormat:@"%li",(long)indexPath.section];
    NSArray *objarray = objdict[str];
    
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        NSString *strReturnedValue=[self getProperties:@"Duration"];
        if([strReturnedValue isEqualToString:@"2"])
        {
         
             cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
             cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.textLabel.textColor = [UIColor  blackColor];
        cell.textLabel.text = objarray[indexPath.row];
       
    }
    else if(indexPath.section == 0 && indexPath.row == 1)
    {
        
        NSString *strReturnedValue=[self getProperties:@"Duration"];
        if([strReturnedValue isEqualToString:@"3"])
        {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.textColor = [UIColor  blackColor];
        cell.textLabel.text = objarray[indexPath.row];
     
    }
    else if(indexPath.section == 0 && indexPath.row == 2)
    {
        NSString *strReturnedValue=[self getProperties:@"Duration"];
        if([strReturnedValue isEqualToString:@"5"])
        {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.textColor = [UIColor  blackColor];
        cell.textLabel.text = objarray[indexPath.row];
     
    }
    else if(indexPath.section == 0 && indexPath.row == 3)
    {
        
        NSString *strReturnedValue=[self getProperties:@"Duration"];
        if([strReturnedValue isEqualToString:@"10"])
        {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
       // cell.textLabel.textColor = [UIColor colorWithRed:103.0/255.0 green:0.0/255.0 blue:85.0/255.0 alpha:1.0];
        cell.textLabel.textColor = [UIColor  blackColor];
        cell.textLabel.text = objarray[indexPath.row];
    } 
    else if(indexPath.section == 0 && indexPath.row == 4)
    {
        NSString *strReturnedValue=[self getProperties:@"Duration"];
        if([strReturnedValue isEqualToString:@"20"])
        {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.textColor = [UIColor  blackColor];
        cell.textLabel.text = objarray[indexPath.row];
     
    }else  if(indexPath.section == 1 && indexPath.row == 0)
    {
        
        NSString *strReturnedValue=[self getProperties:@"Transition"];
        if([strReturnedValue isEqualToString:@"1"])
        {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.textColor = [UIColor  blackColor];
        cell.textLabel.text = objarray[indexPath.row];
    }else if(indexPath.section == 1 && indexPath.row == 1)
    {
        NSString *strReturnedValue=[self getProperties:@"Transition"];
        if([strReturnedValue isEqualToString:@"2"])
        {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.textColor = [UIColor  blackColor];
        cell.textLabel.text = objarray[indexPath.row];
     
    }else if(indexPath.section == 1 && indexPath.row == 2)
    {
        
        NSString *strReturnedValue=[self getProperties:@"Transition"];
        if([strReturnedValue isEqualToString:@"3"])
        {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.textColor = [UIColor  blackColor];
        cell.textLabel.text = objarray[indexPath.row];
        
    }else if(indexPath.section == 1 && indexPath.row == 3)
    {
      
        NSString *strReturnedValue=[self getProperties:@"Transition"];
        if([strReturnedValue isEqualToString:@"4"])
        {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.textColor = [UIColor  blackColor];
        cell.textLabel.text = objarray[indexPath.row];
        
    }else if(indexPath.section == 2 && indexPath.row == 0)
    {
        cell.textLabel.textColor = [UIColor  blackColor];
        cell.textLabel.text = objarray[indexPath.row];
        
        Boolean setValue;
        
        NSString *strReturnedValue=[self getProperties:@"Repeat"];
        if([strReturnedValue isEqualToString:@"true"])
        {
            
            setValue =YES;
            
        }else {
            setValue =NO;
        }

        
        UISwitch* aswitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        aswitch.on = setValue; // or NO
        aswitch.tag = 1;
        [aswitch addTarget:self action:@selector(swtValueChanged:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = aswitch;
        [aswitch release]; 
        
    }else if(indexPath.section ==2 && indexPath.row == 1)
    {
        cell.textLabel.textColor = [UIColor  blackColor];
        cell.textLabel.text = objarray[indexPath.row];
        Boolean setValue;
        NSString *strReturnedValue=[self getProperties:@"Shuffle"];
        if([strReturnedValue isEqualToString:@"true"])
        {
            setValue =YES;
        }else {
            setValue =NO;
        }
        UISwitch* aswitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        aswitch.on = setValue; // or NO
        aswitch.tag = 2;
        [aswitch addTarget:self action:@selector(swtValueChanged:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = aswitch;
        [aswitch release]; 
    }
    return  cell;    
    
}

-(Boolean) update :(NSString *)strValue :(NSString * )UserID :(NSString *)strProperty
{  
    sqlite3_stmt *statement;
    Boolean returnVal=false;
    @try 
    {

        if(sqlite3_open([app getDBPathNew].UTF8String,&dbSecret)== SQLITE_OK)
        {
            NSString *insertquery;
        
        if([strProperty isEqualToString:@"Duration"]){
            insertquery=[NSString stringWithFormat:@"UPDATE AutoLogOffTbl SET Duration =\"%@\" where UserID=%@",strValue,UserID];
        }else if([strProperty isEqualToString:@"Transition"]){
            insertquery=[NSString stringWithFormat:@"UPDATE AutoLogOffTbl SET Transition =\"%@\" where UserID=%@",strValue,UserID];
        }else if([strProperty isEqualToString:@"Repeat"]){
            insertquery=[NSString stringWithFormat:@"UPDATE AutoLogOffTbl SET Repeat =\"%@\" where UserID=%@",strValue,UserID];
        }else if([strProperty isEqualToString:@"Shuffle"]){
            insertquery=[NSString stringWithFormat:@"UPDATE AutoLogOffTbl SET Shuffle =\"%@\" where UserID=%@",strValue,UserID];
        }
        
        NSLog(@"Query::::%@",insertquery);
        
        @try 
        {

            const char *insert_query=insertquery.UTF8String;
            sqlite3_prepare(dbSecret,insert_query,-1,&statement,NULL);
            if(sqlite3_step(statement) == SQLITE_DONE){
                NSLog(@"record updated");
                returnVal= true;
            }
            else{
                NSLog(@"failed 2 connect");
                returnVal= false;
            }
            sqlite3_finalize(statement);
            }
        @catch (NSException *exception) 
        {
            sqlite3_finalize(statement);
            returnVal =false;
        }

        }
    
        sqlite3_close(dbSecret);
        [self.tableView reloadData];
        return    returnVal;
    }@catch (NSException *exception) 
    {
            sqlite3_finalize(statement);
            sqlite3_close(dbSecret);
            returnVal =false;
            return  returnVal;
    }
}
-(IBAction)swtValueChanged:(id)sender
{
    NSInteger value=[sender tag];
    
    UISwitch *switch1 = (UISwitch *)sender;
    
    
    
    if(value ==1)
    {
        
        if(switch1.on)
        {
            [self update:@"true" : app.LoginUserID :@"Repeat"];
            
        }else {
            [self update:@"false":app.LoginUserID :@"Repeat"];
        }
    }else if(value ==2)
    {
        if(switch1.on)
        {
            [self update:@"true" : app.LoginUserID :@"Shuffle"];
            
        }else {
            [self update:@"false":app.LoginUserID :@"Shuffle"];
        }
    }
    [self.tableView reloadData];
    
    NSLog(@"%ld",(long)value);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSLog(@"section>>>> %ld",(long)section);
    if(section == 0)
    {
        return @"Duration";
    }
    else if(section == 1)
    {
        return @"Transition";
    } else //if(section == 2)
    {
        return @" ";
    }     
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {  
    if (_delegate != nil) {
        if(indexPath.section == 0 && indexPath.row == 0)
        {
         
             [self update:@"2" : app.LoginUserID :@"Duration"];
        }
        else if(indexPath.section == 0 && indexPath.row == 1)
        {
            [self update:@"3" : app.LoginUserID :@"Duration"];
        }
        else if(indexPath.section == 0 && indexPath.row == 2)
        {
            [self update:@"5" : app.LoginUserID :@"Duration"];
         }
        else if(indexPath.section == 0 && indexPath.row == 3)
        {
            [self update:@"10" : app.LoginUserID :@"Duration"];
        } 
        else if(indexPath.section == 0 && indexPath.row == 4)
        {
            [self update:@"20" : app.LoginUserID :@"Duration"];
        }else  if(indexPath.section == 1 && indexPath.row == 0)
        {
             [self update:@"1" : app.LoginUserID :@"Transition"];
        }else if(indexPath.section == 1 && indexPath.row == 1)
        {
         [self update:@"2" : app.LoginUserID :@"Transition"];
        }else if(indexPath.section == 1 && indexPath.row == 2)
        {
         [self update:@"3" : app.LoginUserID :@"Transition"];
        }else if(indexPath.section == 1 && indexPath.row == 3)
        {
         [self update:@"4" : app.LoginUserID :@"Transition"];
        }
        
  [self.tableView reloadData];
//        else if(indexPath.section == 2 && indexPath.row == 0)
//        {
//             
//        }else if(indexPath.section ==2 && indexPath.row == 1)
//        {
//         
//        }
    }
    
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}


- (void)dealloc {
    [listOfItems release];
  
    self.delegate = nil;
    [super dealloc];
}


@end

