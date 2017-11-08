//
//  iTunesCustomCell.h
//  RDRProject
//
//  Created by C31 on 28/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iTunesCustomCell : UITableViewCell
{
    IBOutlet UIImageView *myimg;
    IBOutlet UILabel *mylbl;
    IBOutlet UIButton *mybtn;
}
@property (nonatomic,retain ) IBOutlet UIImageView *myimg;
@property (nonatomic,retain ) IBOutlet UILabel *mylbl;
@property (nonatomic,retain ) IBOutlet UIButton *mybtn;


@end
