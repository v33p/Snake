//
//  Snake.m
//  Snake
//
//  Created by Lucas Padilha on 3/30/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import "Snake.h"

@interface Snake()

@property UIView *view;

@property UIImage *image;
@property NSMutableArray *body;
@property NSTimer *snakeTimer;

@property int axisX;
@property int axisY;

@property int temporaryAxisXSaver;
@property int temporaryAxisYSaver;

@property bool verticalMove;

@property (readwrite) double speed;
@property (readwrite) double factor;

@property int blockWidth;
@property int blockHeight;

@end

@implementation Snake

#pragma mark - Initializers

-(Snake *) initWithView:(UIView *)view {
    
    self = [super init];
    
    if (self) {
        
        [self setView:view];
        
        [self setBody:[[NSMutableArray alloc] init]];
        
        [self setImage:[UIImage imageNamed:@"Snake(18).png"]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[self image]];
        
        [self setBlockHeight:[self image].size.height];
        [self setBlockWidth:[self image].size.width];
        
        [[self body] addObject:imageView];
        
        [self placeSnake:[self generateRandomPosition]];
        
        [self setTemporaryAxisXSaver:0];
        [self setTemporaryAxisYSaver:1];
        [self setVerticalMove:YES];
        
        [[self view] addSubview:imageView];
        
        for (int i = 1; i < 5; i++) {
            imageView = [[UIImageView alloc] initWithImage:[self image]];
            [[self body] addObject:imageView];
            CGPoint point = CGPointMake(((UIImageView *) [self body][0]).center.x,
                                        ((UIImageView *) [self body][0]).center.y);
            [imageView setCenter:point];
            [[self view] addSubview:imageView];
        }
        
        [self setSpeed:0.2];
        [self setFactor:0.02];
        
    }
    
    return self;
}

-(Snake *) initWithView:(UIView *)view andPosition: (CGPoint)position andSize: (int)size{
    
    self = [super init];
    
    if (self) {
        
        [self setView:view];
        
        [self setBody:[[NSMutableArray alloc] init]];
        
        [self setImage:[UIImage imageNamed:@"Snake(18).png"]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[self image]];
        
        [self setBlockHeight:[self image].size.height];
        [self setBlockWidth:[self image].size.width];
        
        [[self body] addObject:imageView];
        
        [self placeSnake:position];
        
        [self setTemporaryAxisXSaver:0];
        [self setTemporaryAxisYSaver:1];
        [self setVerticalMove:YES];
        
        [[self view] addSubview:imageView];
        
        for (int i = 1; i < size; i++) {
            imageView = [[UIImageView alloc] initWithImage:[self image]];
            [[self body] addObject:imageView];
            CGPoint point = CGPointMake(((UIImageView *) [self body][0]).center.x,
                                        ((UIImageView *) [self body][0]).center.y);
            [imageView setCenter:point];
            [[self view] addSubview:imageView];
        }
        
        [self setSpeed:0.2];
        [self setFactor:0.02];
        
    }
    
    return self;
}

#pragma mark - Position Controllers

-(void) placeSnake: (CGPoint) position {
    [((UIImageView *) [self body][0]) setCenter:position];
}

-(CGPoint) generateRandomPosition {
    return CGPointMake([self blockWidth] * (arc4random() % (int)(maxWidth/[self blockWidth])) + 30,
                       [self blockHeight] * (arc4random() % (int)((maxHeight-300)/[self blockHeight])) +30);
}

#pragma mark - Movimentation

-(void) move {
    for (int i = (int) [[self body] count] -1; i > 0; i--) {
        CGPoint point = CGPointMake(((UIImageView *) [self body][i-1]).center.x,
                                    ((UIImageView *) [self body][i-1]).center.y);
        [((UIImageView *)[self body][i]) setCenter:point];
    }
    
    CGPoint point = CGPointMake(((UIImageView *) [self body][0]).center.x + ([self axisX] * [self blockWidth]),
                                ((UIImageView *) [self body][0]).center.y + ([self axisY] * [self blockHeight]));
    
    [((UIImageView *) [self body][0]) setCenter:point];
}

-(void) startMoving {
    [self setSnakeTimer:[NSTimer scheduledTimerWithTimeInterval:[self speed]
                                                         target:self
                                                       selector:@selector(move)
                                                       userInfo:nil
                                                        repeats:YES]];
    [self setAxisX:[self temporaryAxisXSaver]];
    [self setAxisY:[self temporaryAxisYSaver]];
}

-(void) stopMoving {
    [[self snakeTimer] invalidate];
    [self setTemporaryAxisXSaver:[self axisX]];
    [self setTemporaryAxisYSaver:[self axisY]];
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

-(CGPoint) headPosition {
    return ((UIImageView *) [self body][0]).center;
}

#pragma mark - Effects

-(void) enlarge {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self image]];
    
    CGPoint point = CGPointMake(((UIImageView *) [self body][[[self body] count] -1]).center.x,
                                ((UIImageView *) [self body][[[self body] count] -1]).center.y);
    
    [imageView setCenter:point];
    
    [[self body] addObject:imageView];
    
    [[self view] addSubview:imageView];
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

-(void) changingSpeed {
    [[self snakeTimer] invalidate];
    [self setFactor:[self factor] * 0.8];
    [self setSpeed:[self speed] - [self factor]];
    [self setSnakeTimer:[NSTimer scheduledTimerWithTimeInterval:[self speed]
                                                         target:self
                                                       selector:@selector(move)
                                                       userInfo:nil
                                                        repeats:YES]];
}

@end
