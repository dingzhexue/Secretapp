//
//  iTunesDataList.h
//  RDRProject
//
//  Created by C31 on 28/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImportFromPC.h"
#import <sqlite3.h>
#import "GADHelper.h"

@interface iTunesDataList : GADBannerViewController  <ImportFromPCDelegate>
{
    IBOutlet UITableView *mytable;
    NSMutableArray *listOfImages;
    sqlite3 *dbSecret;
    NSString *databasepath,*DateStr,*songToAdd;
    int songToRemove;
}
@property(nonatomic,retain) IBOutlet UITableView *mytable;
@property (retain) NSOperationQueue *queue;
@property(nonatomic,readwrite) int songToRemove;
@property(nonatomic,retain) NSString *songToAdd;
@property(nonatomic, retain) NSString *DateStr;

-(void)refresh;
-(IBAction)btnClose:(id)sender;

//-(IBAction)btnImport:(id)sender;
//- (BOOL)exportToDiskWithForce:(BOOL)force atIndex:(NSInteger)atIndex;


@end
