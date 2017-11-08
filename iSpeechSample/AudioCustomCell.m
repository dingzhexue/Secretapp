//
//  AudioCustomCell.m
//  SecretApp
//
//  Created by c62 on 13/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AudioCustomCell.h"

@interface AudioCustomCell ()

@end

@implementation AudioCustomCell

@synthesize titleLbl,timeLbl,DateLbl;
@synthesize mailBtn;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc{
    
    [timeLbl release];
    [titleLbl release];
    [DateLbl release];
    [mailBtn release];
    [super dealloc];
}

@end
