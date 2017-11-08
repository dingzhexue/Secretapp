//
//  GlobalFunctions.h
//  ArborGold
//
//  Created by Jon Garner on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalFunctions : NSObject
{
    BOOL rememberMeTag;
}

+(void)urlSaveToUserDefaults:(NSString*)myString;
+(NSString*)urlRetrieveFromUserDefaults;

+(void)usernameSaveToUserDefaults:(NSString*)myString;
+(NSString*)usernameRetrieveFromUserDefaults;

+(void)passwordSaveToUserDefaults:(NSString*)myString;
+(NSString*)passwordRetrieveFromUserDefaults;

+(void)rememberSetTagDefaults:(NSString *)remTag;
+(NSString*)rememberRetrieveTagDefaults;

+(void)VersionNameSaveToUserDefaults:(NSString*)myString;
+(NSString*)VersionNameRetrieveFromUserDefaults;

+ (void)setStringValueToUserDefaults:(NSString *)strValue ForKey:(NSString *)strKey;
+ (NSString *)getStringValueFromUserDefaults_ForKey:(NSString *)strKey;
@end
