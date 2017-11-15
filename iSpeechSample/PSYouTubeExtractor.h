//
//  PSYouTubeExtractor.h
//  PSYouTubeExtractor
//
//  Created by Peter Steinberger on 2/9/12.
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>

/// This class opens a hidden UIWebView and extracts the mobile YouTube URL if possible.
/// It's not a subclass of NSOperation because of the UIWebView interaction.
/// While running, the class retains itself. Call cancel to stop and release the internal retain.
@interface PSYouTubeExtractor : NSObject

/// Tries to extract the actual mp4 used to play a YouTube movie. 
/// There are quite some movies out there that don't support mobile and don't have a mp4 version set.
- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithYouTubeURL:(NSURL *)youTubeURL success:(void(^)(NSURL *URL))success failure:(void(^)(NSError *error))failure NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithNSNotificationName:(NSString *)s NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithNSNotificationName:(NSString *)s youTubeLink:(NSURL *)u NS_DESIGNATED_INITIALIZER;

- (void) getVideoUrlForUrl:(NSURL *)u notificatoinName:(NSString *)n;

/// Cancels a potential running request. Returns NO if request already finished.
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL cancel;

/// Access the original YouTube URL.
@property(nonatomic, strong, readonly) NSURL *youTubeURL;

@end
