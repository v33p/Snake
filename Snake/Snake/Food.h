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
#import "Snake.h"

@class Game;
@class Snake;

@interface Food : NSObject

-(Food *) initWithGame: (Game *) game;

-(void) placeFood;
-(CGPoint) position;
-(void) foodWasEatenBySnake: (Snake *)snake;

@end
