//
//  ContactCustomCell.m
//  SecretApp
//
//  Created by c62 on 17/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactCustomCell.h"

@interface ContactCustomCell ()

@end

@implementation ContactCustomCell
@synthesize contNameLbl,conPicImg,ContactNumLbl;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    [contNameLbl release];
    [conPicImg release];
    [ContactNumLbl release];
    [super dealloc];
}

@end
