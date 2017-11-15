//
//  tblDockLockTap.m
//  SecretApp
//
//  Created by c27 on 15/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "tblDockLockTap.h"
#import "DrawPatternLockViewController.h"

#import "ABPadLockScreenController.h"

@interface tblDockLockTap ()
@property (nonatomic, strong) ABPadLockScreenController *pinScreen;
@end

@implementation tblDockLockTap
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
    app=(AppDelegate  *)[UIApplication sharedApplication].delegate;
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    
     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"main-bg.png"]]];
    
    listOfItems = [[NSMutableArray alloc] init];
    NSArray *itemsArray1 =@[@"Change pattern ",@"Set as a Lock"];
    NSDictionary *itemsDict1 = @{@"0": itemsArray1};
    
    
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
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSDictionary *objdict = listOfItems[indexPath.section];
        NSString *str = [NSString stringWithFormat:@"%li",(long)indexPath.section];
        NSArray *objarray = objdict[str];
        
        if(indexPath.section == 0 && indexPath.row == 1)
        {
            cell.textLabel.textColor = [UIColor  blackColor];
            cell.textLabel.text = objarray[indexPath.row];
        } else      {
            cell.textLabel.textColor = [UIColor  blackColor];
            cell.textLabel.text = objarray[indexPath.row];
            
        }
        
    }

    return  cell;    
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
    {
        return @"Dock Lock Settings";
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Dock Lock Set");
    
    if (_delegate != nil) 
    {
        if(indexPath.section == 0 && indexPath.row == 0)
        {
            NSString *strAuth= [self Authentication];
            if([strAuth isEqualToString:@"true"])
            {
                NSLog(@"Password Changing");
                app.chngePWD=true;
                DrawPatternLockViewController *drwNew=[[DrawPatternLockViewController alloc]init];
                [self.navigationController pushViewController:drwNew animated:YES];
            }else
            {
                NSLog(@"First set as a lock");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pattern Lock Settings" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
                alert.message=@"First set as a lock!";
                [alert show];
                [alert release];
            }
           
        } else if(indexPath.section == 0 && indexPath.row == 1)
        {
            NSString *strAuth= [self Authentication];
            if([strAuth isEqualToString:@"true"])
            {
                NSLog(@"set Pattern as a Lock");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"set Pattern as a Lock" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
                alert.message=@"Pattern lock is alredy set as a lock!";
                [alert show];
                [alert release];
            }else 
            {
                NSLog(@"set Pattern as a Lock");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"set Pattern as a Lock" message:@"" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
                alert.message=@"Do you want to set Patttern Lock?";
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
        Boolean isUserHavePattern=YES;
        if(isUserHavePattern)
        {
            //[app.userDefaults setObject:@"Pattern" forKey:@"LockMethod"];
            [GlobalFunctions setStringValueToUserDefaults:@"Pattern" ForKey:@"LockMethod2"];
            app.chngePWD=YES;
            app.isNewPattern=YES;
            DrawPatternLockViewController *drwNew=[[DrawPatternLockViewController alloc]init];
            [self.navigationController pushViewController:drwNew animated:YES];
        }else 
        {
            
        }
      
    }else if([title isEqualToString:@"No"])
    {
        
    }
}


-(NSString *) Authentication
{
    NSString *strReturn=@"false";
    NSString *databasepath=[app getDBPathNew];
    if (sqlite3_open(databasepath.UTF8String, &dbSecret) == SQLITE_OK) 
    {
        
        
        NSString *selectSql = [NSString stringWithFormat:@"select PatternAuth from AuthentictionCheckTbl where UserID = %@",app.LoginUserID];
        
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
            sqlite3_finalize(query_stmt); 
        }
    }
    sqlite3_close(dbSecret);  
    return strReturn;
}
- (void)unlockWasCancelled { 
    return;
}

- (void)unlockWasSuccessful { 
    return;
}

- (void)unlockWasUnsuccessful:(NSString *)falsePin afterAttemptNumber:(NSInteger)attemptNumber { 
    return;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder { 
    return;
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection { 
    return;
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container { 
    return;
}
- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container { 
    return;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator { 
    return;
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator { 
    return;
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator { 
    return;
}

- (void)setNeedsFocusUpdate { 
    return;
}

- (void)updateFocusIfNeeded { 
    return;
}

@end

