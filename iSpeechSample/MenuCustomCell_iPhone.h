//
//  MenuCustomCell_iPhone.h
//  SecretApp
//
//  Created by c62 on 09/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCustomCell_iPhone : UITableViewCell
{
    UIImageView *iconimage,*rightArImg;
    UILabel *menuNmLbl;
    UIButton *rightArrowBtn;
    
}
@property(nonatomic,retain) IBOutlet UIImageView *iconimage,*rightArImg;
@property(nonatomic,retain) IBOutlet UILabel *menuNmLbl;
@property(nonatomic,retain) IBOutlet UIButton *rightArrowBtn;

@end
