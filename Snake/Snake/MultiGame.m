//
//  MultiGame.m
//  Snake
//
//  Created by Lucas Padilha on 3/30/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import "MultiGame.h"

@implementation MultiGame

#pragma mark - Game Control

-(void) startGame {
    // multipeer comunication:
    // cobras em posicao randomica
    // foods no mesmo local
}

-(void) pauseGame {
    // multipeer comunication:
    // pause das cobras
    // menu aparece
}

-(void) endGame {
    // multipeer comunication:
    // tela de fim de jogo
}

#pragma mark - Snake Loop

-(void) checkSnakePosition:(CGPoint)position {
    
    [self checkSnakePosition:position];
    
    if ([[self snake] compareBodyWithHeadPosition:position]) {
        [self endGame];
    }
    
    else if (position.x == [[self food] position].x &&
             position.y == [[self food] position].y) {
        //multipeer comunication: outro sofre efeito
    }
    
}

@end
