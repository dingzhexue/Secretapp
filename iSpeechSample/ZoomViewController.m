//
//  ZoomViewController.m
//  Zoom
//
//  Created by Fernando Bunn on 10/3/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ZoomViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation ZoomViewController


AppDelegate *app;
-(IBAction)start:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];  
}
- (void)loadView {

    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    CALayer *l1 = [image layer];
    [l1 setMasksToBounds:YES];
    [l1 setCornerRadius:10.0];
    [l1 setBorderWidth:2.0];  
    
       
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	scroll.backgroundColor = [UIColor blackColor];
	scroll.delegate = self;
    
	image = [[UIImageView alloc] initWithFrame:CGRectMake(0,20,320,320)];
    
    NSLog(@"image is %@",app.ZoomImage);
    
    
    //[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@", fullPath]]
    

     UIImage *img=[UIImage imageWithContentsOfFile:app.ZoomImage];
    image.image=img;
   // image.image=[UIImage imageNamed:app.ZoomImage];
    //image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hero.png"]];
   // image=[[UIImageView alloc]initWithImage:app.ZoomImage];
	scroll.contentSize = image.frame.size;
	[scroll addSubview:image];
	
	scroll.minimumZoomScale = scroll.frame.size.width / image.frame.size.width;
	scroll.maximumZoomScale = 2.0;
	[scroll setZoomScale:scroll.minimumZoomScale];

	self.view = scroll;
	[scroll release];

}

- (void)viewDidUnload {
	[image release], image = nil;
}

- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView {
	CGSize boundsSize = scroll.bounds.size;
    CGRect frameToCenter = rView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }
    else {
        frameToCenter.origin.x = 0;
    }
    
    // center vertically
    
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }
    else {
        frameToCenter.origin.y = 0;
    }
	
	return frameToCenter;
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
   image.frame = [self centeredFrameForScrollView:scrollView andUIView:image];
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
   /* UIImageView *vw=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300,300)];
    vw.image=app.ZoomImage;
    image.frame=vw.frame;*/
	return image;
}


- (void)dealloc {
    [super dealloc];
}

@end
