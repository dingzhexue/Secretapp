//
//  BuyViewController.m
//  SecretApp
//
//  Created by c78 on 11/02/13.
//
//

#import "BuyViewController.h"
#import "ColorPickerController.h"

@interface BuyViewController ()

@end

@implementation BuyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnCancel:(id)sender
{
    NSLog(@"Model Present");
    ColorPickerController *clr = [[ColorPickerController alloc]init];
    [self dismissModalViewControllerAnimated:YES];
}

@end
