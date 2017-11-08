//
//  MonsterSelectionDelegate.h
//  MathMonsters
//
//  Created by Ray Wenderlich on 5/3/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Monster;

@protocol MonsterSelectionDelegate
- (void)monsterSelectionChanged:(Monster *)curSelection;
@end