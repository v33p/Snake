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

#define maxWidth 300
#define maxHeight 600

@class Snake;

@interface Game : NSObject

@property (readonly) int blockWidth;
@property (readonly) int blockHeight;

@property Snake *snake;

-(Game *) initWithView: (UIView *)view;

-(void) pauseGame;
-(void) endGame;

-(void) addImage: (UIImageView *)image;

@end
