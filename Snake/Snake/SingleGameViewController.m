//
//  SingleGameViewController.m
//  Snake
//
//  Created by Lucas Padilha on 3/30/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import "SingleGameViewController.h"
#import "SingleGame.h"

@class SingleGame;

@interface SingleGameViewController ()

@property SingleGame *gameController;
@property BOOL isPaused;

@end

@implementation SingleGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown)];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipeDown];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp)];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swipeUp];
    
    [self setGameController:[[SingleGame alloc] initWithView:[self view] andViewController:self]];
    [self setIsPaused:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) swipeLeft {
    [[self gameController] moveSnakeLeft];
}

-(void) swipeRight {
    [[self gameController] moveSnakeRight];
}

-(void) swipeDown {
    [[self gameController] moveSnakeDown];
}

-(void) swipeUp {
    [[self gameController] moveSnakeUp];
}

- (IBAction)didPinch:(id)sender {
    if (![self isPaused]) {
        [[self gameController] pauseGame];
        [self setIsPaused:YES];
    }
}

- (IBAction)secondButtonClicked:(id)sender {
    if ([self isPaused]) {
        [self setIsPaused:NO];
        [[self gameController] resumeGame];
    }
    else {
        // restart game
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
