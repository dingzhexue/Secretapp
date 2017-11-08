//
//  MenuCustomCell_iPhone.m
//  SecretApp
//
//  Created by c62 on 09/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuCustomCell_iPhone.h"

@interface MenuCustomCell_iPhone ()

@end

@implementation MenuCustomCell_iPhone

@synthesize  menuNmLbl,iconimage,rightArrowBtn,rightArImg;


-(void)dealloc{
    [rightArrowBtn release];
    [rightArImg release];
    [iconimage release];
    [menuNmLbl release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
