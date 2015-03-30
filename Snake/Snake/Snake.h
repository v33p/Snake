//
//  Snake.h
//  Snake
//
//  Created by Lucas Padilha on 3/30/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Game.h"

@class Game;

@interface Snake : NSObject

-(Snake *) initWithGame:(Game *)game;

-(void) turnLeft;
-(void) turnRight;
-(void) turnUp;
-(void) turnDown;

-(void) startMoving;
-(void) stopMoving;

-(void) enlarge;

@end
