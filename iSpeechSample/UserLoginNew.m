//
//  UserLoginNew.m
//  SecretApp
//
//  Created by c27 on 14/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserLoginNew.h"

@interface UserLoginNew ()

@end

@implementation UserLoginNew
@synthesize  txtCode,btnCheck;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction)btnCheckClicked:(id)sender
{
    NSString *strCode=txtCode.text;
    if([strCode isEqualToString:@"1234"])
    {
    }else {
        NSLog(@"");
    }
    
}
@end
