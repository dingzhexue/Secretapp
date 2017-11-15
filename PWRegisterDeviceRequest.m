//
//  PWRegisterDeviceRequest
//  Pushwoosh SDK
//  (c) Pushwoosh 2012
//

#import "PWRegisterDeviceRequest.h"
#import "PushNotificationManager.h"

#if ! __has_feature(objc_arc)
#error "ARC is required to compile Pushwoosh SDK"
#endif

@implementation PWRegisterDeviceRequest

- (NSString *) methodName {
    return @"registerDevice";
}

- (NSDictionary *) requestDictionary {
    NSMutableDictionary *dict = [self baseDictionary];
    
    dict[@"device_type"] = @1;
    dict[@"push_token"] = _pushToken;
    dict[@"language"] = _language;
    dict[@"timezone"] = _timeZone;
    
    if (_appVersion)
        dict[@"app_version"] = _appVersion;
    
    if (_isJailBroken)
         dict[@"black"] = @(YES);
    
    BOOL sandbox = ![PushNotificationManager getAPSProductionStatus];
    if(sandbox)
        dict[@"gateway"] = @"sandbox";
    else
        dict[@"gateway"] = @"production";

    NSString * package = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    dict[@"package"] = package;
    
    return dict;
}


@end
