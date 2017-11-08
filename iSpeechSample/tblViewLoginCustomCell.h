//
//  tblViewLoginCustomCell.h
//  SecretApp
//
//  Created by c27 on 19/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tblViewLoginCustomCell : UITableViewCell
{
    UIImageView *imgLoginPhoto;
    UILabel *lblTime;
    UILabel *lblDate;
}
@property(retain,nonatomic)IBOutlet     UILabel *lblTime,*lblDate;
@property (retain,nonatomic)IBOutlet      UIImageView *imgLoginPhoto;

@end
