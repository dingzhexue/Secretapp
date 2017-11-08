//
//  NotesCustomCell.h
//  SecretApp
//
//  Created by c78 on 26/02/13.
//
//

#import <UIKit/UIKit.h>

@interface NotesCustomCell : UITableViewCell
{
    UILabel *lblNotes;
}

@property (nonatomic,retain) IBOutlet UILabel *lblNotes;

@end
