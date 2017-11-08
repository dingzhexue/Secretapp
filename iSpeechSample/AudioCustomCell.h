//
//  AudioCustomCell.h
//  SecretApp
//
//  Created by c62 on 13/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioCustomCell : UITableViewCell
{
    UILabel *titleLbl,*DateLbl,*timeLbl;
    UIButton *mailBtn;
}

@property(nonatomic,retain) IBOutlet UIButton *mailBtn;
@property(nonatomic,retain) IBOutlet UILabel *titleLbl,*DateLbl,*timeLbl;
@end
