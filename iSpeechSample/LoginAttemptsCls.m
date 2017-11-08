//
//  LoginAttemptsCls.m
//  SecretApp
//
//  Created by c35 on 24/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginAttemptsCls.h"

@implementation LoginAttemptsCls
@synthesize strDate,strTime,strIMgPath;
@synthesize imgId;

- (void)dealloc
{
    [strTime release];
    [strDate release];
    [imgId release];
    [strIMgPath release];
    [super dealloc];
}

@end
