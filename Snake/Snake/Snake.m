//
//  Snake.m
//  Snake
//
//  Created by Lucas Padilha on 3/30/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import "Snake.h"

@interface Snake()

@property Game *game;

@property UIImage *image;
@property NSMutableArray *body;
@property NSTimer *snakeTimer;

@property int axisX;
@property int axisY;

@property bool verticalMove;

@property (readwrite) double speed;

-(void) move;

@end

@implementation Snake

#pragma mark - Initializers

-(Snake *) initWithGame:(Game *)game {
    
    self = [super init];
    
    if (self) {
        
        [self setGame:game];
        
        [self setBody:[[NSMutableArray alloc] init]];
        
        [self setImage:[UIImage imageNamed:@"Snake(18).png"]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[self image]];
        
        [[self body] addObject:imageView];
        
        [self placeSnake:[self generateRandomPosition]];
        
        [self setAxisX:0];
        [self setAxisY:1];
        [self setVerticalMove:YES];
        
        [[self game] addImage:imageView];
        
        for (int i = 1; i < 5; i++) {
            imageView = [[UIImageView alloc] initWithImage:[self image]];
            [[self body] addObject:imageView];
            CGPoint point = CGPointMake(((UIImageView *) [self body][0]).center.x,
                                        ((UIImageView *) [self body][0]).center.y);
            [imageView setCenter:point];
            [[self game] addImage:imageView];
        }
        
        [self setSpeed:0.2];
        
    }
    
    return self;
}

#pragma mark - Position Controllers

-(void) placeSnake: (CGPoint) position {
    [((UIImageView *) [self body][0]) setCenter:position];
}

-(CGPoint) generateRandomPosition {
    return CGPointMake([[self game] blockWidth] * (arc4random() % (int)(maxWidth/[[self game] blockWidth])) + 30,
                       [[self game] blockHeight] * (arc4random() % (int)((maxHeight-300)/[[self game] blockHeight])) +30);
}

#pragma mark - Movimentation

-(void) move {
    for (int i = (int) [[self body] count] -1; i > 0; i--) {
        CGPoint point = CGPointMake(((UIImageView *) [self body][i-1]).center.x,
                                    ((UIImageView *) [self body][i-1]).center.y);
        [((UIImageView *)[self body][i]) setCenter:point];
    }
    
    CGPoint point = CGPointMake(((UIImageView *) [self body][0]).center.x + ([self axisX] * [[self game] blockWidth]),
                                ((UIImageView *) [self body][0]).center.y + ([self axisY] * [[self game] blockHeight]));
    
    [((UIImageView *) [self body][0]) setCenter:point];
    
    [[self game] checkSnakePosition:[((UIImageView *) [self body][0]) center]];
}

-(void) startMoving {
    [self setSnakeTimer:[NSTimer scheduledTimerWithTimeInterval:[self speed]
                                                         target:self
                                                       selector:@selector(move)
                                                       userInfo:nil
                                                        repeats:YES]];
}

-(void) stopMoving {
    [[self snakeTimer] invalidate];
    [self setAxisX:0];
    [self setAxisY:0];
}

-(void) turnUp {
    if (![self verticalMove]) {
        [self setAxisY:-1];
        [self setAxisX:0];
        [self setVerticalMove:YES];
    }
}

-(void) turnDown {
    if (![self verticalMove]) {
        [self setAxisY:1];
        [self setAxisX:0];
        [self setVerticalMove:YES];
    }
}

-(void) turnLeft {
    if ([self verticalMove]) {
        [self setAxisY:0];
        [self setAxisX:-1];
        [self setVerticalMove:NO];
    }
}

-(void) turnRight {
    if ([self verticalMove]) {
        [self setAxisY:0];
        [self setAxisX:1];
        [self setVerticalMove:NO];
    }
}

#pragma mark - Compare

//*
-(BOOL) compareBodyWithHeadPosition: (CGPoint) head {
    for (int i = 1; i < [[self body] count]; i++) {
        if ([self compareCGPoint:head with:((UIImageView *) [self body][i]).center]) {
            return YES;
        }
    }
    return NO;
}

-(BOOL) compareCGPoint: (CGPoint) one with: (CGPoint) two {
    if (one.x == two.x && one.y == two.y)
        return YES;
    else
        return NO;
}

#pragma mark - Effects

-(void) enlarge {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self image]];
    
    CGPoint point = CGPointMake(((UIImageView *) [self body][[[self body] count] -1]).center.x,
                                ((UIImageView *) [self body][[[self body] count] -1]).center.y);
    
    [imageView setCenter:point];
    
    [[self body] addObject:imageView];
    
    [[self game] addImage:imageView];
}

-(void) changingSpeedByMultiplyingByFactor: (double) factor {
    [[self snakeTimer] invalidate];
    [self setSpeed:[self speed] * factor];
    [self setSnakeTimer:[NSTimer scheduledTimerWithTimeInterval:[self speed]
                                                         target:self
                                                       selector:@selector(move)
                                                       userInfo:nil
                                                        repeats:YES]];
}

-(void) changingSpeedByAddingByFactor: (double) factor {
    [[self snakeTimer] invalidate];
    [self setSpeed:[self speed] + factor];
    [self setSnakeTimer:[NSTimer scheduledTimerWithTimeInterval:[self speed]
                                                         target:self
                                                       selector:@selector(move)
                                                       userInfo:nil
                                                        repeats:YES]];
}

@end
