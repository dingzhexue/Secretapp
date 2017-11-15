//
//  InAppRageIAPHelper.m
//  InAppRage
//
//  Created by Ray Wenderlich on 2/28/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "InAppRageIAPHelper.h"

@implementation InAppRageIAPHelper

static InAppRageIAPHelper * _sharedHelper;

+ (InAppRageIAPHelper *) sharedHelper {
    
    if (_sharedHelper != nil) {
        return _sharedHelper;
    }
    _sharedHelper = [[InAppRageIAPHelper alloc] init];
    return _sharedHelper;
    
}

- (instancetype)init {
    
    //1) You can provide number of features here. 
    //2) Give ProductID in reverse domain pattern in itunesconnect .
    //3) Configure proper test user in itunessconnect > manage user > test user.
   /* NSSet *productIdentifiers = [NSSet setWithObjects:@"com.sublime.GreetingCardApp.BirthdayNormal0temp",
                                 @"com.sublime.GreetingCardApp.BirthdayNormal1temp",@"com.sublime.GreetingCardApp.BirthdayNormal2temp",
                                 @"com.sublime.GreetingCardApp.BirthdayNormal3temp",@"com.sublime.GreetingCardApp.BirthdayNormal4temp",
                                 @"com.sublime.GreetingCardApp.BirthdayNormal5temp",@"com.sublime.GreetingCardApp.BirthdayNormal6temp",
                                 @"com.sublime.GreetingCardApp.BirthdayNormal7temp",@"com.sublime.GreetingCardApp.BirthdayNormal8temp",
                                 @"com.sublime.GreetingCardApp.BirthdayNormal9temp",@"com.sublime.GreetingCardApp.BirthdayNormal10temp",
                                 @"com.sublime.GreetingCardApp.BirthdayNormal11temp",@"com.sublime.GreetingCardApp.BirthdayNormal12temp",
                                 @"com.sublime.GreetingCardApp.BirthdayNormal13temp",@"com.sublime.GreetingCardApp.BirthdayNormal14temp",
                                 @"com.sublime.GreetingCardApp.BirthdayNormal15temp",@"com.sublime.GreetingCardApp.BirthdayNormal16temp",
                                 @"com.sublime.GreetingCardApp.BirthdayNormal17temp",@"com.sublime.GreetingCardApp.BirthdayNormal18temp",
                                 @"com.sublime.GreetingCardApp.BirthdayNormal19temp",@"com.sublime.GreetingCardApp.BirthdayAnimated0temp",
                                 @"com.sublime.GreetingCardApp.BirthdayAnimated1temp",@"com.sublime.GreetingCardApp.BirthdayAnimated2temp",
                                 @"com.sublime.GreetingCardApp.BirthdayAnimated3temp",@"com.sublime.GreetingCardApp.BirthdayAnimated4temp",
                                 @"com.sublime.GreetingCardApp.BirthdayAnimated5temp",@"com.sublime.GreetingCardApp.BirthdayAnimated6temp",
                                 @"com.sublime.GreetingCardApp.BirthdayAnimated7temp",@"com.sublime.GreetingCardApp.BirthdayAnimated8temp",
                                 @"com.sublime.GreetingCardApp.BirthdayAnimated9temp",@"com.sublime.GreetingCardApp.AnniversaryNormal0temp",
                                 @"com.sublime.GreetingCardApp.AnniversaryNormal1temp",@"com.sublime.GreetingCardApp.AnniversaryNormal2temp",
                                 @"com.sublime.GreetingCardApp.AnniversaryNormal3temp",@"com.sublime.GreetingCardApp.AnniversaryNormal4temp",
                                 @"com.sublime.GreetingCardApp.AnniversaryNormal5temp",@"com.sublime.GreetingCardApp.AnniversaryNormal6temp",
                                 @"com.sublime.GreetingCardApp.AnniversaryNormal7temp",@"com.sublime.GreetingCardApp.AnniversaryNormal8temp",
                                 @"com.sublime.GreetingCardApp.AnniversaryNormal9temp",@"com.sublime.GreetingCardApp.AnniversaryNormal10temp",
                                 @"com.sublime.GreetingCardApp.AnniversaryNormal11temp",@"com.sublime.GreetingCardApp.AnniversaryNormal12temp"
                                 @"com.sublime.GreetingCardApp.AnniversaryNormal13temp",@"com.sublime.GreetingCardApp.AnniversaryNormal14temp"
                                 ,@"com.sublime.GreetingCardApp.AnniversaryNormal15temp",@"com.sublime.GreetingCardApp.AnniversaryNormal16temp",
                                 @"com.sublime.GreetingCardApp.AnniversaryNormal17temp",@"com.sublime.GreetingCardApp.AnniversaryNormal18temp"
                                 ,@"com.sublime.GreetingCardApp.AnniversaryNormal19temp",@"com.sublime.GreetingCardApp.AnniversaryAnimated0temp",
                                 @"com.sublime.GreetingCardApp.AnniversaryAnimated1temp",@"com.sublime.GreetingCardApp.AnniversaryAnimated2temp",
                                 @"com.sublime.GreetingCardApp.AnniversaryAnimated3temp",@"com.sublime.GreetingCardApp.AnniversaryAnimated4temp",
                                 @"com.sublime.GreetingCardApp.AnniversaryAnimated5temp",@"com.sublime.GreetingCardApp.AnniversaryAnimated6temp",
                                 @"com.sublime.GreetingCardApp.AnniversaryAnimated7temp",@"com.sublime.GreetingCardApp.AnniversaryAnimated8temp",
                                 @"com.sublime.GreetingCardApp.AnniversaryAnimated9temp",@"com.sublime.GreetingCardApp.WeddingNormal0temp",
                                 @"com.sublime.GreetingCardApp.WeddingNormal1temp",@"com.sublime.GreetingCardApp.WeddingNormal2temp",
                                 @"com.sublime.GreetingCardApp.WeddingNormal3temp",@"com.sublime.GreetingCardApp.WeddingNormal4temp",
                                 @"com.sublime.GreetingCardApp.WeddingNormal5temp",@"com.sublime.GreetingCardApp.WeddingNormal6temp",
                                 @"com.sublime.GreetingCardApp.WeddingNormal7temp",@"com.sublime.GreetingCardApp.WeddingNormal8temp",
                                 @"com.sublime.GreetingCardApp.WeddingNormal9temp",@"com.sublime.GreetingCardApp.WeddingNormal10temp",
                                 @"com.sublime.GreetingCardApp.WeddingNormal11temp",@"com.sublime.GreetingCardApp.WeddingNormal12temp",
                                 @"com.sublime.GreetingCardApp.WeddingNormal13temp",@"com.sublime.GreetingCardApp.WeddingNormal14temp",
                                 @"com.sublime.GreetingCardApp.WeddingNormal15temp",@"com.sublime.GreetingCardApp.WeddingNormal16temp",
                                 @"com.sublime.GreetingCardApp.WeddingNormal17temp",@"com.sublime.GreetingCardApp.WeddingNormal18temp",
                                 @"com.sublime.GreetingCardApp.WeddingNormal19temp",@"com.sublime.GreetingCardApp.WeddingAnimated0temp",
                                 @"com.sublime.GreetingCardApp.WeddingAnimated1temp",@"com.sublime.GreetingCardApp.WeddingAnimated2temp",
                                 @"com.sublime.GreetingCardApp.WeddingAnimated3temp",@"com.sublime.GreetingCardApp.WeddingAnimated4temp",
                                 @"com.sublime.GreetingCardApp.WeddingAnimated5temp",@"com.sublime.GreetingCardApp.WeddingAnimated6temp",
                                 @"com.sublime.GreetingCardApp.WeddingAnimated7temp",@"com.sublime.GreetingCardApp.WeddingAnimated8temp",
                                 @"com.sublime.GreetingCardApp.WeddingAnimated9temp",@"com.sublime.GreetingCardApp.EngagementNormal0temp",
                                 @"com.sublime.GreetingCardApp.EngagementNormal1temp",@"com.sublime.GreetingCardApp.EngagementNormal2temp",
                                 @"com.sublime.GreetingCardApp.EngagementNormal3temp",@"com.sublime.GreetingCardApp.EngagementNormal4temp",
                                 @"com.sublime.GreetingCardApp.EngagementNormal5temp",@"com.sublime.GreetingCardApp.EngagementNormal6temp",
                                 @"com.sublime.GreetingCardApp.EngagementNormal7temp",@"com.sublime.GreetingCardApp.EngagementNormal8temp",
                                 @"com.sublime.GreetingCardApp.EngagementNormal9temp",@"com.sublime.GreetingCardApp.EngagementNormal10temp",
                                 @"com.sublime.GreetingCardApp.EngagementNormal11temp",@"com.sublime.GreetingCardApp.EngagementNormal12temp",
                                 @"com.sublime.GreetingCardApp.EngagementNormal13temp",@"com.sublime.GreetingCardApp.EngagementNormal14temp",
                                 @"com.sublime.GreetingCardApp.EngagementNormal15temp",@"com.sublime.GreetingCardApp.EngagementNormal16temp",
                                 @"com.sublime.GreetingCardApp.EngagementNormal17temp",@"com.sublime.GreetingCardApp.EngagementNormal18temp",
                                 @"com.sublime.GreetingCardApp.EngagementNormal19temp",@"com.sublime.GreetingCardApp.EngagementAnimated0temp",
                                 @"com.sublime.GreetingCardApp.EngagementAnimated1temp",@"com.sublime.GreetingCardApp.EngagementAnimated2temp",
                                 @"com.sublime.GreetingCardApp.EngagementAnimated3temp",@"com.sublime.GreetingCardApp.EngagementAnimated4temp",
                                 @"com.sublime.GreetingCardApp.EngagementAnimated5temp",@"com.sublime.GreetingCardApp.EngagementAnimated6temp",
                                 @"com.sublime.GreetingCardApp.EngagementAnimated7temp",@"com.sublime.GreetingCardApp.EngagementAnimated8temp",
                                 @"com.sublime.GreetingCardApp.EngagementAnimated9temp",@"com.sublime.GreetingCardApp.ChristmasNormal0temp",
                                 @"com.sublime.GreetingCardApp.ChristmasNormal1temp",@"com.sublime.GreetingCardApp.ChristmasNormal2temp",
                                 @"com.sublime.GreetingCardApp.ChristmasNormal3temp",@"com.sublime.GreetingCardApp.ChristmasNormal4temp",
                                 @"com.sublime.GreetingCardApp.ChristmasNormal5temp",@"com.sublime.GreetingCardApp.ChristmasNormal6temp",
                                 @"com.sublime.GreetingCardApp.ChristmasNormal7temp",@"com.sublime.GreetingCardApp.ChristmasNormal8temp",
                                 @"com.sublime.GreetingCardApp.ChristmasNormal9temp",@"com.sublime.GreetingCardApp.ChristmasNormal10temp",
                                 @"com.sublime.GreetingCardApp.ChristmasNormal11temp",@"com.sublime.GreetingCardApp.ChristmasNormal12temp",
                                 @"com.sublime.GreetingCardApp.ChristmasNormal13temp",@"com.sublime.GreetingCardApp.ChristmasNormal14temp",
                                 @"com.sublime.GreetingCardApp.ChristmasNormal15temp",@"com.sublime.GreetingCardApp.ChristmasNormal16temp",
                                 @"com.sublime.GreetingCardApp.ChristmasNormal17temp",@"com.sublime.GreetingCardApp.ChristmasNormal18temp",
                                 @"com.sublime.GreetingCardApp.ChristmasNormal19temp",@"com.sublime.GreetingCardApp.ChristmasAnimated0temp",
                                 @"com.sublime.GreetingCardApp.ChristmasAnimated1temp",@"com.sublime.GreetingCardApp.ChristmasAnimated2temp",
                                 @"com.sublime.GreetingCardApp.ChristmasAnimated3temp",@"com.sublime.GreetingCardApp.ChristmasAnimated4temp",
                                 @"com.sublime.GreetingCardApp.ChristmasAnimated5temp",@"com.sublime.GreetingCardApp.ChristmasAnimated6temp",
                                 @"com.sublime.GreetingCardApp.ChristmasAnimated7temp",@"com.sublime.GreetingCardApp.ChristmasAnimated8temp",
                                 @"com.sublime.GreetingCardApp.ChristmasAnimated9temp",@"com.sublime.GreetingCardApp.EasterNormal0temp",
                                 @"com.sublime.GreetingCardApp.EasterNormal1temp",@"com.sublime.GreetingCardApp.EasterNormal2temp",
                                 @"com.sublime.GreetingCardApp.EasterNormal3temp",@"com.sublime.GreetingCardApp.EasterNormal4temp",
                                 @"com.sublime.GreetingCardApp.EasterNormal5temp",@"com.sublime.GreetingCardApp.EasterNormal6temp",
                                 @"com.sublime.GreetingCardApp.EasterNormal7temp",@"com.sublime.GreetingCardApp.EasterNormal8temp",
                                 @"com.sublime.GreetingCardApp.EasterNormal9temp",@"com.sublime.GreetingCardApp.EasterNormal10temp",
                                 @"com.sublime.GreetingCardApp.EasterNormal11temp",@"com.sublime.GreetingCardApp.EasterNormal12temp",
                                 @"com.sublime.GreetingCardApp.EasterNormal13temp",@"com.sublime.GreetingCardApp.EasterNormal14temp",
                                 @"com.sublime.GreetingCardApp.EasterNormal15temp",@"com.sublime.GreetingCardApp.EasterNormal16temp",
                                 @"com.sublime.GreetingCardApp.EasterNormal17temp",@"com.sublime.GreetingCardApp.EasterNormal18temp",
                                 @"com.sublime.GreetingCardApp.EasterNormal19temp",@"com.sublime.GreetingCardApp.EasterAnimated0temp",
                                 @"com.sublime.GreetingCardApp.EasterAnimated1temp",@"com.sublime.GreetingCardApp.EasterAnimated2temp",
                                 @"com.sublime.GreetingCardApp.EasterAnimated3temp",@"com.sublime.GreetingCardApp.EasterAnimated4temp",
                                 @"com.sublime.GreetingCardApp.EasterAnimated5temp",@"com.sublime.GreetingCardApp.EasterAnimated6temp",
                                 @"com.sublime.GreetingCardApp.EasterAnimated7temp",@"com.sublime.GreetingCardApp.EasterAnimated8temp",
                                 @"com.sublime.GreetingCardApp.EasterAnimated9temp",@"com.sublime.GreetingCardApp.NewyearNormal0temp",
                                 @"com.sublime.GreetingCardApp.NewyearNormal1temp",@"com.sublime.GreetingCardApp.NewyearNormal2temp",
                                 @"com.sublime.GreetingCardApp.NewyearNormal3temp",@"com.sublime.GreetingCardApp.NewyearNormal4temp",
                                 @"com.sublime.GreetingCardApp.NewyearNormal5temp",@"com.sublime.GreetingCardApp.NewyearNormal6temp",
                                 @"com.sublime.GreetingCardApp.NewyearNormal7temp",@"com.sublime.GreetingCardApp.NewyearNormal8temp",
                                 @"com.sublime.GreetingCardApp.NewyearNormal9temp",@"com.sublime.GreetingCardApp.NewyearAnimated0temp",
                                 @"com.sublime.GreetingCardApp.NewyearAnimated1temp",@"com.sublime.GreetingCardApp.NewyearAnimated2temp",
                                 @"com.sublime.GreetingCardApp.NewyearAnimated3temp",@"com.sublime.GreetingCardApp.NewyearAnimated4temp",
                                 @"com.sublime.GreetingCardApp.NewyearAnimated5temp",@"com.sublime.GreetingCardApp.NewyearAnimated6temp",
                                 @"com.sublime.GreetingCardApp.NewyearAnimated7temp",@"com.sublime.GreetingCardApp.NewyearAnimated8temp",
                                 @"com.sublime.GreetingCardApp.NewyearAnimated9temp",@"com.sublime.GreetingCardApp.BirthdayNormalPack1temp",
                                 @"com.sublime.GreetingCardApp.BirthdayNormalPack2temp",@"com.sublime.GreetingCardApp.BirthdayNormalPack3temp",
                                 @"com.sublime.GreetingCardApp.BirthdayNormalPack4temp",@"com.sublime.GreetingCardApp.BirthdayNormalPack5temp",
                                 @"com.sublime.GreetingCardApp.BirthdayAnimatedPack1temp",@"com.sublime.GreetingCardApp.BirthdayAnimatedPack2temp"
                                 ,@"com.sublime.GreetingCardApp.BirthdayAnimatedPack3temp",@"com.sublime.GreetingCardApp.AnniversaryNormalPack1temp"                       ,@"com.sublime.GreetingCardApp.AnniversaryNormalPack2temp",@"com.sublime.GreetingCardApp.AnniversaryNormalPack3temp",@"com.sublime.GreetingCardApp.AnniversaryNormalPack4temp",@"com.sublime.GreetingCardApp.AnniversaryNormalPack5temp",@"com.sublime.GreetingCardApp.AnniversaryAnimatedPack1temp",@"com.sublime.GreetingCardApp.AnniversaryAnimatedPack2temp",
                                 @"com.sublime.GreetingCardApp.AnniversaryAnimatedPack3temp",@"com.sublime.GreetingCardApp.WeddingNormalPack1temp",
                                 @"com.sublime.GreetingCardApp.WeddingNormalPack2temp",@"com.sublime.GreetingCardApp.WeddingNormalPack3temp",
                                 @"com.sublime.GreetingCardApp.WeddingNormalPack4temp",@"com.sublime.GreetingCardApp.WeddingNormalPack5temp",
                                 @"com.sublime.GreetingCardApp.WeddingAnimatedPack1temp",@"com.sublime.GreetingCardApp.WeddingAnimatedPack2temp",
                                 @"com.sublime.GreetingCardApp.WeddingAnimatedPack3temp",@"com.sublime.GreetingCardApp.EngagementNormalPack1temp",
                                 @"com.sublime.GreetingCardApp.EngagementNormalPack2temp",@"com.sublime.GreetingCardApp.EngagementNormalPack3temp",
                                 @"com.sublime.GreetingCardApp.EngagementNormalPack4temp",@"com.sublime.GreetingCardApp.EngagementNormalPack5temp",
                                 @"com.sublime.GreetingCardApp.EngagementAnimatedPack1temp",@"com.sublime.GreetingCardApp.EngagementAnimatedPack2temp",                                 @"com.sublime.GreetingCardApp.EngagementAnimatedPack3temp",@"com.sublime.GreetingCardApp.ChristmasNormalPack1temp",
                                 @"com.sublime.GreetingCardApp.ChristmasNormalPack2temp",@"com.sublime.GreetingCardApp.ChristmasNormalPack3temp",
                                 @"com.sublime.GreetingCardApp.ChristmasNormalPack4temp",@"com.sublime.GreetingCardApp.ChristmasNormalPack5temp",
                                 @"com.sublime.GreetingCardApp.ChristmasAnimatedPack1temp",@"com.sublime.GreetingCardApp.ChristmasAnimatedPack2temp",@"com.sublime.GreetingCardApp.ChristmasAnimatedPack3temp",
                                 @"com.sublime.GreetingCardApp.EasterNormalPack1temp",@"com.sublime.GreetingCardApp.EasterNormalPack2temp"
                                 @"com.sublime.GreetingCardApp.EasterNormalPack3temp",@"com.sublime.GreetingCardApp.EasterNormalPack4temp"
                                 @"com.sublime.GreetingCardApp.EasterNormalPack5temp",@"com.sublime.GreetingCardApp.EasterAnimatedPack1temp",
                                 @"com.sublime.GreetingCardApp.EasterAnimatedPack2temp",@"com.sublime.GreetingCardApp.EasterAnimatedPack3temp",
                                 @"com.sublime.GreetingCardApp.NewyearNormalPack1temp",@"com.sublime.GreetingCardApp.NewyearNormalPack2temp",
                                 @"com.sublime.GreetingCardApp.NewyearAnimatedPack1temp",@"com.sublime.GreetingCardApp.NewyearAnimatedPack2temp",
                                 @"com.sublime.GreetingCardApp.NewyearAnimatedPack3temp",@"com.sublime.GreetingCardApp.OwnCard0temp",
                                 @"com.sublime.GreetingCardApp.OwnCardtest",nil];*/
    
    NSLog(@"com.sublime.SecretApp.RemoveAds");
    
    NSSet *productIdentifiers = [NSSet setWithObjects:@"com.sublime.SecretApp.RemoveAds",@"com.sublime.SecretApp.attempts",nil];
    
    if ((self = [super initWithProductIdentifiers:productIdentifiers])) {                
        
    }
    return self;
    
}

@end
