//
//  Game.h
//  Snake
//
//  Created by Lucas Padilha on 3/30/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GameSnake.h"
#import "Food.h"

#define maxWidth 320
#define maxHeight 620

@class GameSnake;
@class Food;

@interface Game : NSObject

@property (readwrite) int blockWidth;
@property (readwrite) int blockHeight;

@property GameSnake *snake;
@property Food *food;

@property (readwrite) UIView *view;

-(Game *) initWithView: (UIView *)view;

-(void) pauseGame;
-(void) endGame;

-(void) addImage: (UIImageView *)image;

-(void) moveSnakeLeft;
-(void) moveSnakeRight;
-(void) moveSnakeDown;
-(void) moveSnakeUp;

-(void) checkSnakePosition: (CGPoint) position;

-(CGPoint)checkSnakeOutOfBounds:(CGPoint)position;
-(CGPoint) snakeOutOfBound:(int)bound andPosition:(CGPoint)snake;

@end
