//
//  GameSnake.m
//  Snake
//
//  Created by Lucas Padilha on 4/8/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import "GameSnake.h"

@interface Game()

@end

@implementation GameSnake

-(Snake *) initWithGame:(Game *)game {
    
    self = [super initWithView:[game view]];
    
    if (self) {

        [self setGame:game];
        
    }
    
    return self;
}

-(void) move {
    [super move];
    [[self game] checkSnakePosition:[super headPosition]];
}

@end
