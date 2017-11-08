//
//  CustomDownloadView.h
//  SecretApp
//
//  Created by c62 on 03/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDownloadView : UITableViewCell{
    UILabel *filenameLbl,*totalSizeLbl;
    UIProgressView *progressview;
    UIButton *cancelDLodBtn;
}
@property(nonatomic,retain) IBOutlet UIButton *cancelDLodBtn;
@property(nonatomic,retain) IBOutlet  UILabel *filenameLbl,*totalSizeLbl;
@property(nonatomic,retain) IBOutlet UIProgressView *progressview;

@end
