//
//  DrawPatternLockView.m
//  AndroidLock
//
//  Created by Purnama Santo on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DrawPatternLockView.h"
@implementation DrawPatternLockView

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }

  return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSLog(@"drawrect...");
    

    if (!_trackPointValue)
        return;
 //   AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
                      CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 10.0);
//if(app.chngePWD)
//{
//    
//}else {
//    

    CGContextSetLineWidth(context, 10.0);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    //CGFloat components[] = {0.5, 0.5, 0.5, 0.8};
    CGFloat components[] = {1, 1, 1, 1};
  //  CGFloat components[] = {200, 200, 200, 400};
    
    CGColorRef color = CGColorCreate(colorspace, components);
    CGContextSetStrokeColorWithColor(context, color);
    
    CGPoint from;
    UIView *lastDot;
    for (UIView *dotView in _dotViews) {
        //dotView.opaque = YES;
        from = dotView.center;
        NSLog(@"drwaing dotview: %@", dotView);
        NSLog(@"\tdrawing from: %f, %f", from.x, from.y);
        
        if (!lastDot)
            CGContextMoveToPoint(context, from.x, from.y);
        else
            CGContextAddLineToPoint(context, from.x, from.y);
        
        lastDot = dotView;
    }
    
    CGPoint pt = _trackPointValue.CGPointValue;
    NSLog(@"\t to: %f, %f", pt.x, pt.y);
    CGContextAddLineToPoint(context, pt.x, pt.y);
    
    CALayer *layer;
    layer = self.layer;
    layer.zPosition = 9999;
    UIGraphicsBeginImageContext(self.frame.size);

    CGRect screenBound = [UIScreen mainScreen].bounds;
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    CGContextClipToRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, screenWidth, screenHeight));
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSString *path;
    path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"ScreenShot"];
    
    NSLog(@"Temp Directory :: %@", path);
    
    NSError *error;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:path])    //Does directory already exist?
    {
        if (![manager createDirectoryAtPath:path
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"error: %@", error);
        }
    }
    
    NSString *screenShotFilePath = [path stringByAppendingPathComponent:@"screenshot.jpg"];
    
    NSLog(@"File will be saved at :: %@",screenShotFilePath);
    
    if ([manager fileExistsAtPath:screenShotFilePath]) {
        
        [manager removeItemAtPath:screenShotFilePath error:nil];

    }
    
    NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(screenShot, 0.8f)];
    [data writeToFile:screenShotFilePath atomically:YES];
    
    NSLog(@"Screen Shot Taken Successfully..");
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);fileExistsAtPath:isDirectory:
    
    _trackPointValue = nil;
}

- (void)clearDotViews {
  [_dotViews removeAllObjects];
}


- (void)addDotView:(UIView *)view {
  if (!_dotViews)
    _dotViews = [NSMutableArray array];

  [_dotViews addObject:view];
}


- (void)drawLineFromLastDotTo:(CGPoint)pt {
  _trackPointValue = [NSValue valueWithCGPoint:pt];
  [self setNeedsDisplay];
}


@end
