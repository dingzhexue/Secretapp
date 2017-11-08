//
//  tblViewLoginCustomCell.m
//  SecretApp
//
//  Created by c27 on 19/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "tblViewLoginCustomCell.h"

@interface tblViewLoginCustomCell ()

@end

@implementation tblViewLoginCustomCell
@synthesize  lblDate,lblTime,imgLoginPhoto;
- (void)dealloc
{
    [lblDate release];
    [lblTime release];
    [imgLoginPhoto release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
