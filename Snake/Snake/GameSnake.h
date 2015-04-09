//
//  GameSnake.h
//  Snake
//
//  Created by Lucas Padilha on 4/8/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import "Snake.h"
#import "Game.h"

@class Game;

@interface GameSnake : Snake

@property Game *game;

-(GameSnake *) initWithGame: (Game *) game;

-(void) move;

@end
