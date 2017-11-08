//
//  GlobalFunctions.m
//  ArborGold
//
//  Created by Jon Garner on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GlobalFunctions.h"

@implementation GlobalFunctions
- (void)dealloc
{
    [super dealloc];
}

+(void)urlSaveToUserDefaults:(NSString*)myString
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults) 
    {
		[standardUserDefaults setObject:myString forKey:@"url"];
		[standardUserDefaults synchronize];
	}
}

+(NSString*)urlRetrieveFromUserDefaults
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSString *val = nil;
	
	if (standardUserDefaults) 
		val = [standardUserDefaults objectForKey:@"url"];
	
	return val;
}

+(void)usernameSaveToUserDefaults:(NSString*)myString
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults) 
    {
		[standardUserDefaults setObject:myString forKey:@"UserName"];
		[standardUserDefaults synchronize];
	}
}

+(NSString*)usernameRetrieveFromUserDefaults
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSString *val = nil;
	
	if (standardUserDefaults) 
		val = [standardUserDefaults objectForKey:@"UserName"];
	
	return val;
}

+(void)passwordSaveToUserDefaults:(NSString*)myString
{
    NSUserDefaults *standardUserDefaults=[NSUserDefaults standardUserDefaults];
    if(standardUserDefaults)
    {
        [standardUserDefaults setObject:myString forKey:@"password"];
        [standardUserDefaults synchronize];
    }
}

+(NSString*)passwordRetrieveFromUserDefaults
{
    NSUserDefaults *standardUserDefaults=[NSUserDefaults standardUserDefaults];
    NSString *val=nil;
    if(standardUserDefaults)
        val=[standardUserDefaults objectForKey:@"password"];
    return  val;
}

+(void)rememberSetTagDefaults:(NSString *)remTag
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults) 
    {
		[standardUserDefaults setObject:remTag forKey:@"RememberURL"];
		[standardUserDefaults synchronize];
	}
}
+(NSString*)rememberRetrieveTagDefaults{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSString *val = nil;
	
	if (standardUserDefaults) 
		val = [standardUserDefaults objectForKey:@"RememberURL"];
	
	return val;
}
+(void)VersionNameSaveToUserDefaults:(NSString*)myString
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults)
    {
		[standardUserDefaults setObject:myString forKey:@"Version"];
		[standardUserDefaults synchronize];
	}

}
+(NSString*)VersionNameRetrieveFromUserDefaults
{
    NSUserDefaults *standardUserDefaults=[NSUserDefaults standardUserDefaults];
    NSString *val=nil;
    if(standardUserDefaults)
        val=[standardUserDefaults objectForKey:@"Version"];
    return  val;

}

+ (void)setStringValueToUserDefaults:(NSString *)strValue ForKey:(NSString *)strKey
{
    if ([NSUserDefaults standardUserDefaults]) {
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@", strValue] forKey:strKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSString *)getStringValueFromUserDefaults_ForKey:(NSString *)strKey
{
    NSString *s = nil;
    if ([NSUserDefaults standardUserDefaults]) {
        s = [[NSUserDefaults standardUserDefaults] valueForKey:strKey];
    }
    return s;
}
@end
