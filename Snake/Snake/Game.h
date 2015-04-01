//
//  Game.h
//  Snake
//
//  Created by Lucas Padilha on 3/30/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Snake.h"
#import "Food.h"

#define maxWidth 300
#define maxHeight 600

@class Snake;
@class Food;

@interface Game : NSObject

@property (readonly) int blockWidth;
@property (readonly) int blockHeight;

@property Snake *snake;
@property Food *food;

-(Game *) initWithView: (UIView *)view;

-(void) pauseGame;
-(void) endGame;

-(void) addImage: (UIImageView *)image;

-(void) moveSnakeLeft;
-(void) moveSnakeRight;
-(void) moveSnakeDown;
-(void) moveSnakeUp;

-(void) checkSnakePosition: (CGPoint) position;

-(void)checkSnakeOutOfBounds:(CGPoint)position;
-(void) snakeOutOfBound:(int)bound andPosition:(CGPoint)snake;

@end
