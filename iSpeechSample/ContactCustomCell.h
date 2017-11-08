//
//  ContactCustomCell.h
//  SecretApp
//
//  Created by c62 on 17/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCustomCell : UITableViewCell
{
    UILabel *contNameLbl,*ContactNumLbl;
    UIImageView *conPicImg;
}

@property(nonatomic,retain) IBOutlet UILabel *contNameLbl,*ContactNumLbl;
@property(nonatomic,retain) IBOutlet UIImageView *conPicImg;



@end
