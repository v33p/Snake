//
//  Snake.m
//  Snake
//
//  Created by Lucas Padilha on 3/30/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import "Snake.h"

@interface Snake()

@property NSMutableArray *body;
@property NSTimer *snakeTimer;
@property (readwrite) NSInteger *size;

-(void) move;

@end

@implementation Snake


-(void) startMoving {
    
    [self setSnakeTimer:[NSTimer scheduledTimerWithTimeInterval:0.3
                                                         target:self
                                                       selector:@selector(move)
                                                       userInfo:nil repeats:YES]];
    
}

-(void) move {
    
}


@end
