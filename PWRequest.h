//
//  PWRequest.h
//  Pushwoosh SDK
//  (c) Pushwoosh 2012
//

#import <Foundation/Foundation.h>

@interface PWRequest : NSObject

@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *hwid;

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *methodName;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSDictionary *requestDictionary;

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSMutableDictionary *baseDictionary;
- (void) parseResponse: (NSDictionary *) response;

@end
