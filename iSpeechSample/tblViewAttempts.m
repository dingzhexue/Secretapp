//
//  tblViewAttempts.m
//  SecretApp
//
//  Created by c27 on 15/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "tblViewAttempts.h"
#import "tblViewLoginCustomCell.h"
#import "LoginAttemptsCls.h"
@interface tblViewAttempts ()

@end

@implementation tblViewAttempts
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

- (void)dealloc
{
    //[databasepath release];
    [listOfItems release];
   
    [super dealloc];
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
    
    listOfItems = [[NSMutableArray alloc] init];
  

}
-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBarHidden=NO;
    [self getImages];
    [self.tableView reloadData];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear History"
                                                                    style:UIBarButtonSystemItemDone target:self action:@selector(BtnClearHSClicked:)];
    self.navigationItem.rightBarButtonItem = rightButton; 
    [rightButton release];


}


-(void) getImages
{
    [listOfItems removeAllObjects];
    databasepath = [app getDBPathNew];
    NSLog( @"DB Path %@ ",databasepath);
    if (sqlite3_open(databasepath.UTF8String, &dbSecret) == SQLITE_OK) {
        
        // NSString *sql = [NSString stringWithFormat:@"select * from AlbumTbl where UserID=%d ORDER BY ImageID ASC",[app.LoginUserID intValue]];
        
        NSString *sql = [NSString stringWithFormat:@"select * from ViewImageLogtbl  where  isBreakIn = \"true\" AND UserID=%@ Order BY imageID DESC",app.LoginUserID];
        NSLog(@"query is %@",sql);
 
        sqlite3_stmt *selectstmt;
        const char *sel_query=sql.UTF8String;
        
        if(sqlite3_prepare(dbSecret, sel_query, -1, &selectstmt, NULL) == SQLITE_OK) {
            
            while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {

               
                LoginAttemptsCls *objLAC=[[LoginAttemptsCls alloc]init];
                objLAC.imgId=@((char *)sqlite3_column_text(selectstmt, 0));
                
                objLAC.strIMgPath = @((char *)sqlite3_column_text(selectstmt, 2));

                objLAC.strTime=@((char *)sqlite3_column_text(selectstmt, 5));
                
                objLAC.strDate=@((char *)sqlite3_column_text(selectstmt, 6));
                [listOfItems addObject:objLAC];
                NSLog(@"Image path %@",objLAC.strIMgPath);
                [objLAC release];
              
            }
        }
        sqlite3_finalize(selectstmt);
        sqlite3_close(dbSecret);
    }
    else
        sqlite3_close(dbSecret);
    
    NSLog(@"img count::: %lu",(unsigned long)listOfItems.count);
  
    
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

-(IBAction)BtnClearHSClicked:(id)sender{
    if([self delImage])
    {
        [listOfItems removeAllObjects];
        [self getImages];
        [self.tableView reloadData];
    }}



#pragma mark - TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"bookmark data count:::: %lu",(unsigned long)listOfItems.count);
    return listOfItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    static NSString *CustomCellIdentifier = @"tblViewLoginCustomCell";
    tblViewLoginCustomCell *cell = (tblViewLoginCustomCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if (cell == nil) {
        NSArray *nib;
        
        nib = [[NSBundle mainBundle] loadNibNamed:@"tblViewLoginCustomCell" owner:self options:nil];
        
        for(id oneObject in nib)
            if([oneObject isKindOfClass:[tblViewLoginCustomCell class]])
                cell = (tblViewLoginCustomCell *)oneObject;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;


    LoginAttemptsCls *objLACls=[[LoginAttemptsCls alloc]init];
    objLACls=listOfItems[indexPath.row];
    (cell.imgLoginPhoto).image = [UIImage imageWithContentsOfFile:objLACls.strIMgPath];
    cell.lblTime.text=objLACls.strTime;
    cell.lblDate.text=objLACls.strDate;
   NSLog(@"imapge path is %@",objLACls.strIMgPath);
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{


}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        return 100;
    }
    else {
        return 100;
    }
    
    
    
}


-(Boolean)delImage{
    Boolean returnVal;
    databasepath=[app getDBPathNew];
    @try 
    {
        if (sqlite3_open(databasepath.UTF8String, &dbSecret) == SQLITE_OK) 
        {
            NSString *selectSql = [NSString stringWithFormat:@"Delete from ViewImageLogtbl where isBreakIn = \"true\" AND UserID=%@",app.LoginUserID];
            
            NSLog(@"Query : %@",selectSql);
            
            const char *deleteStmt = selectSql.UTF8String;
            sqlite3_stmt *query_stmt;
            
            if(sqlite3_prepare_v2(dbSecret, deleteStmt, -1, &query_stmt, NULL) == SQLITE_OK)
            {
                @try {
                    
                 if(sqlite3_step(query_stmt)== SQLITE_DONE)
                 {
                     returnVal =true;
                 }
                 else
                 {
                        UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:@"Clear  Result" message:@"History not clear...." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                     returnVal =false;
                }
                sqlite3_finalize(query_stmt);
               }
                @catch (NSException *exception) 
                {
                    sqlite3_finalize(query_stmt); 
                    sqlite3_close(dbSecret);
                    returnVal =false;
                    return returnVal;
                
                }
                
                }
        }
        sqlite3_close(dbSecret);
        return  returnVal;
    }
    @catch (NSException *exception) 
    {
    
    sqlite3_close(dbSecret);  
    return returnVal;
    }
    
}



@end
