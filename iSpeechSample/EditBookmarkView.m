//
//  EditBookmarkView.m
//  SecretApp
//
//  Created by c62 on 31/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditBookmarkView.h"
#import "AppDelegate.h"

@interface EditBookmarkView ()

@end

@implementation EditBookmarkView

@synthesize bmURLTxt,bmTitleTxt;

AppDelegate *app;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    
    [bmTitleTxt release];
    [bmURLTxt release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    self.title=@"Edit Bookmark";
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                style:UIBarButtonSystemItemDone target:self action:@selector(editBookmark)];
    self.navigationItem.rightBarButtonItem = saveBtn;
    saveBtn.style=UIBarButtonItemStyleBordered;
    [saveBtn release];
    
    selBmID=app.globBmID;
    
    bmTitleTxt.text=app.globBmTitle;
    bmURLTxt.text=app.globBmURL;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)editBookmark{
    
    databasepath=[app getDBPathNew];
    if (sqlite3_open([databasepath UTF8String], &dbSecret) == SQLITE_OK) 
    {
        NSString *selectSql = [NSString stringWithFormat:@"Update BookmarkTbl set BookmarkTitle=\"%@\" ,BookmarkURL=\"%@\" Where BookmarkID=%@ ",bmTitleTxt.text,bmURLTxt.text,selBmID];
        
        NSLog(@"Query : %@",selectSql);
        const char *sqlStatement = [selectSql UTF8String];
        sqlite3_stmt *query_stmt;
        sqlite3_prepare(dbSecret, sqlStatement, -1, &query_stmt, NULL);
        
        if(sqlite3_step(query_stmt)== SQLITE_DONE)
        {
           /* UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Result" message:@"Data Updated successfully...." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];*/
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            //status.text = @"Match Not Found..!!";
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry" message:@"Failed To Update Data..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            // txtcontact.text=@"";
        }
        sqlite3_finalize(query_stmt);
        // }
    }
    sqlite3_close(dbSecret);
    
}

@end
