//
//  Snake.h
//  Snake
//
//  Created by Lucas Padilha on 3/30/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define maxWidth 320
#define maxHeight 620

@interface Snake : NSObject

@property (readonly) double speed;

-(Snake *) initWithView:(UIView *)view;
-(Snake *) initWithView:(UIView *)view andPosition: (CGPoint)position andSize: (int) size;

-(void) move;

-(void) placeSnake:(CGPoint)position;

-(void) startMoving;
-(void) stopMoving;

-(void) turnLeft;
-(void) turnRight;
-(void) turnUp;
-(void) turnDown;

-(BOOL) compareBodyWithHeadPosition:(CGPoint)head;
-(CGPoint) headPosition;

-(void) enlarge;
-(void) changingSpeedByMultiplyingByFactor:(double)factor;
-(void) changingSpeedByAddingByFactor:(double)factor;
-(void) changingSpeed;

@end
