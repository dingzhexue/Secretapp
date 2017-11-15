//
//  NotesView_iPhone.h
//  SecretApp
//
//  Created by c62 on 09/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADHelper.h"

@interface NotesView_iPhone : GADBannerViewController<UITextViewDelegate>
{
    UITableView *notesTbl;
    UIView *notesDetailView;
    UITextView *noteTxt;
    UIView *accessoryView;
    BOOL addclickTag;
    UIButton *savedoneBtn,*CancelBtn;
    UIImageView *cancelBgImg;
    UIScrollView *scrlVw;
    NSString *databasepath,*NotesStr,*NoteID,*selNoteID;
    sqlite3 *dbSecret;
    NSMutableArray *notesArr;
    int selectedNoteId;
    
    AppDelegate *app;
    
    UIBarButtonItem *addButton;
    UIButton *delButton;
}

@property(nonatomic,retain) NSMutableArray *notesArr;
@property(nonatomic,retain) NSString *NotesStr,*NoteID;
@property(nonatomic,retain) IBOutlet UIScrollView *scrlVw;
@property(nonatomic,retain) IBOutlet UIImageView *cancelBgImg;
@property(nonatomic,retain) IBOutlet UIButton *savedoneBtn,*CancelBtn;
@property(nonatomic,retain) IBOutlet UIView *accessoryView;
@property(nonatomic,retain) IBOutlet UITextView *noteTxt;
@property(nonatomic,retain) IBOutlet UIView *notesDetailView;
@property(nonatomic,retain) IBOutlet UITableView *notesTbl;

-(IBAction)btnSaveDoneClicked:(id)sender;
-(IBAction)btnCancelClicked:(id)sender;
-(IBAction)noteAddClicked:(id)sender;
-(IBAction)goAway:(id)sender;
-(IBAction) editData;
@end
