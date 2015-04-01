//
//  Food.m
//  Snake
//
//  Created by Lucas Padilha on 3/30/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import "Food.h"

@interface Food ()

@property Game *game;
@property UIImageView *food;

@end

@implementation Food

#pragma mark - Initializers

-(Food *) initWithGame:(Game *)game {
    self = [super init];
    
    if (self) {
        [self setGame:game];
        
        UIImage *image = [UIImage imageNamed:@"Food-2(18).png"];
        [self setFood:[[UIImageView alloc] initWithImage:image]];
        
        [[self game] addImage:[self food]];
        
        [self placeFoodRandom];
    }
    
    return self;
}

#pragma mark - Position Controllers

-(void) placeFoodRandom {
    CGPoint position = CGPointMake([[self game] blockWidth] * (arc4random() % (int)(maxWidth/[[self game] blockWidth])) + 30,
                                   [[self game] blockHeight] * (arc4random() % (int)((maxHeight)/[[self game] blockHeight])) +30);
    [[self food] setCenter:position];
}

-(void) placeFoodAtPosition: (CGPoint) position {
    [[self food] setCenter:position];
}

-(CGPoint) position {
    return [self food].center;
}

#pragma mark - Food Action

-(void) foodWasEatenBySnake: (Snake *)snake {
    [snake enlarge];
    [self placeFoodRandom];
}

@end
