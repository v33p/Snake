//
//  Game.m
//  Snake
//
//  Created by Lucas Padilha on 3/30/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import "Game.h"

@interface Game()

@end

@implementation Game

#pragma mark - Initializers

-(Game *) initWithView: (UIView *)view {
    self = [super init];
    
    if (self) {
        UIImage *image = [UIImage imageNamed:@"Snake(18).png"];
        
        [self setBlockHeight:image.size.height];
        [self setBlockWidth:image.size.width];
        
        [self setView:view];
        
        [self startGame];
    }
    
    return self;
}

#pragma mark - Game Control

-(void) startGame {
    [self setSnake:[[Snake alloc] initWithGame: (Game *)self]];
    [self setFood:[[Food alloc] initWithGame:(Game *)self]];
    
    [[self snake] startMoving];
}

-(void) pauseGame {
    
    
}

-(void) endGame {
    
    [[self snake] stopMoving];
    
    NSLog(@"Fim de Jogo");
    
}

#pragma mark - View Controller Comunication

-(void) addImage: (UIImageView *)image {
    [[self view] addSubview:image];
}

#pragma mark - Snake Comunication

-(void) moveSnakeLeft {
    [[self snake] turnLeft];
}

-(void) moveSnakeRight {
    [[self snake] turnRight];
}

-(void) moveSnakeDown {
    [[self snake] turnDown];
}

-(void) moveSnakeUp {
    [[self snake] turnUp];
}

#pragma mark - Snake Loop

-(void) checkSnakePosition:(CGPoint)position {
    // compara a posicao da cabeca da cobra com limites
    [self checkSnakeOutOfBounds:position];
    // compara se a posicao da cabeca da cobra com restante da cobra
    if ([[self snake] compareBodyWithHeadPosition:position]) {
        [self endGame];
    }
    // compara se a posicoa da cabeca da cobra com a comida
    else if (position.x == [[self food] position].x && position.y == [[self food] position].y) {
        [[self food] foodWasEatenBySnake:[self snake]];
    }
    
}

#pragma mark - Compare

-(void) checkSnakeOutOfBounds: (CGPoint) position {
    if (position.x < 30) {
        [self snakeOutOfBound:1 andPosition:position];
    }
    else if (position.x > (maxWidth + 30)) {
        [self snakeOutOfBound:2 andPosition:position];
    }
    else if (position.y < 30) {
        [self snakeOutOfBound:3 andPosition:position];
    }
    else if (position.y > (maxHeight + 30)) {
        [self snakeOutOfBound:4 andPosition:position];
    }
}

//*
-(void) snakeOutOfBound: (int) bound andPosition: (CGPoint) snake {
    if (bound == 1) {
        [[self snake] placeSnake:CGPointMake(([self blockWidth] * ((int)(maxWidth/[self blockWidth]))) + 30,
                                             snake.y)];
    }
    else if (bound == 2) {
        [[self snake] placeSnake:CGPointMake([self blockWidth] + 30,
                                             snake.y)];
    }
    else if (bound == 3) {
        [[self snake] placeSnake:CGPointMake(snake.x,
                                             ([self blockHeight] * ((int)(maxHeight/[self blockHeight]))) + 30)];
    }
    else {
        [[self snake] placeSnake:CGPointMake(snake.x,
                                             [self blockHeight] + 30)];
    }
}

@end
