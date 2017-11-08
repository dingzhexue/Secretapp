//
//  VideoCustomView.m
//  SecretApp
//
//  Created by c62 on 20/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VideoCustomView.h"

@interface VideoCustomView ()

@end

@implementation VideoCustomView
@synthesize vtitleLbl,vDateLbl;


-(void)dealloc{
    [vtitleLbl release];
    [vDateLbl release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
