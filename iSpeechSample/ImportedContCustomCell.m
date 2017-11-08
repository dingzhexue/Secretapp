//
//  ImportedContCustomCell.m
//  SecretApp
//
//  Created by c62 on 18/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImportedContCustomCell.h"

@interface ImportedContCustomCell ()

@end

@implementation ImportedContCustomCell

@synthesize impConNmLbl,impConPhoneLbl;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc{
    [impConNmLbl release];
    [impConPhoneLbl release];
    [super dealloc];
}
@end
