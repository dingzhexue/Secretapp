//
//  ImportedContCustomCell.h
//  SecretApp
//
//  Created by c62 on 18/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImportedContCustomCell : UITableViewCell
{
    UILabel *impConNmLbl,*impConPhoneLbl;
}
@property(nonatomic,retain) IBOutlet UILabel *impConNmLbl,*impConPhoneLbl;
@end
