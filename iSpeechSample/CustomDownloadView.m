//
//  CustomDownloadView.m
//  SecretApp
//
//  Created by c62 on 03/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomDownloadView.h"

@interface CustomDownloadView ()

@end

@implementation CustomDownloadView

@synthesize filenameLbl,totalSizeLbl,progressview,cancelDLodBtn;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc{
    
    [filenameLbl release];
    [totalSizeLbl release];
    [progressview release];
    [cancelDLodBtn release];
    
    [super dealloc];
}

@end
