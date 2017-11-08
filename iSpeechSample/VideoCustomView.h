//
//  VideoCustomView.h
//  SecretApp
//
//  Created by c62 on 20/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCustomView : UITableViewCell
{
    UILabel *vtitleLbl,*vDateLbl;
}
@property(nonatomic,retain) IBOutlet UILabel *vtitleLbl,*vDateLbl;

//@property(nonatomic, retain) TFTBanner *adView;

@end
