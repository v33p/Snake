//
//  Snake.h
//  Snake
//
//  Created by Lucas Padilha on 3/30/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"

@interface Snake : NSObject

@property (readonly) NSInteger *size;

-(void) initialize:(Game *)game;

-(void) turnLeft;
-(void) turnRight;
-(void) turnUp;
-(void) turnBack;

-(void) startMoving;
-(void) stopMoving;

-(void) enlarge;

@end
