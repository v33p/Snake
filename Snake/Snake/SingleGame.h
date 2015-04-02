//
//  SingleGame.h
//  Snake
//
//  Created by Lucas Padilha on 3/30/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import "Game.h"
#import "SingleGameViewController.h"

@class SingleGameViewController;

@interface SingleGame : Game

-(SingleGame *) initWithView: (UIView *)view andViewController: (SingleGameViewController *) viewController;

-(void) pauseGame;
-(void) resumeGame;
-(void) endGame;

-(void) checkSnakePosition:(CGPoint)position;

@end
