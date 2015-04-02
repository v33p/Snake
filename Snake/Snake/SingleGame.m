//
//  SingleGame.m
//  Snake
//
//  Created by Lucas Padilha on 3/30/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import "SingleGame.h"

@interface SingleGame()

@property SingleGameViewController *viewController;
@property int score;

@end

@implementation SingleGame

-(SingleGame *) initWithView: (UIView *)view andViewController: (SingleGameViewController *) viewController {
    self = [super initWithView:view];
    
    if (self) {
        [self setViewController:viewController];
        [self setScore:0];
    }
    
    return self;
}

-(void) pauseGame {
    [[[self viewController] score] setText:[[[NSNumber alloc] initWithInt:[self score]] stringValue]];
    [[[self viewController] secondButton] setTitle:@"Resume" forState:UIControlStateNormal];
    [[[self viewController] label] setText:@"Pause"];
    
    [[[self viewController] view] addSubview:[[self viewController] endGameView]];
    [[[self viewController] endGameView] setHidden:NO];
    
    [[self snake] stopMoving];
}

-(void) resumeGame {
    [[self snake] startMoving];
    
    [[[self viewController] endGameView] setHidden:YES];
    
}

-(void) endGame {    
    [[[self viewController] score] setText:[[[NSNumber alloc] initWithInt:[self score]] stringValue]];
    [[[self viewController] secondButton] setTitle:@"Restart" forState:UIControlStateNormal];
    [[[self viewController] label] setText:@"Game Over"];
    
    [[[self viewController] view] addSubview:[[self viewController] endGameView]];
    [[[self viewController] endGameView] setHidden:NO];
    
    [[self snake] stopMoving];
    NSLog(@"Fim de Jogo");
}

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
        [[self snake] changingSpeedByAddingByFactor:-0.01];
        NSLog(@"%f", [[self snake] speed]);
        [self setScore:[self score]+1];
    }
}

@end
