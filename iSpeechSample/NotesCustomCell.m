//
//  NotesCustomCell.m
//  SecretApp
//
//  Created by c78 on 26/02/13.
//
//

#import "NotesCustomCell.h"

@implementation NotesCustomCell

@synthesize lblNotes;

-(void)dealloc{
    [lblNotes release];
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
