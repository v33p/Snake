//
//  Food.h
//  Snake
//
//  Created by Lucas Padilha on 3/30/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Game.h"
#import "GameSnake.h"

@class Game;
@class GameSnake;

@interface Food : NSObject

-(Food *) initWithGame: (Game *) game;

-(void) placeFoodRandom;
-(void) placeFoodAtPosition:(CGPoint)position;
-(CGPoint) position;
-(void) foodWasEatenBySnake: (GameSnake *)snake;

@end
