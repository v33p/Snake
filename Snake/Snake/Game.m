//
//  Game.m
//  Snake
//
//  Created by Lucas Padilha on 3/30/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import "Game.h"

@interface Game()

@property UIView *view;

@property (readwrite) int blockWidth;
@property (readwrite) int blockHeight;

@end

@implementation Game

-(Game *) initWithView: (UIView *)view {
    self = [super init];
    
    if (self) {
        UIImage *image = [UIImage imageNamed:@"Snake.png"];
        
        [self setBlockHeight:image.size.height];
        [self setBlockWidth:image.size.width];
        
        [self setView:view];
        [self setSnake:[[Snake alloc] initWithGame: (Game *)self]];
        [[self snake] startMoving];
    }
    
    return self;
}

-(void) pauseGame {
    
    
}

-(void) endGame {
    
    
}

-(void) addImage: (UIImageView *)image {
    
    [[self view] addSubview:image];
    
}

@end
