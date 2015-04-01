//
//  MultiGame.m
//  Snake
//
//  Created by Lucas Padilha on 3/30/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import "MultiGame.h"

@interface MultiGame()

@property UIViewController *viewController;
@property AppDelegate *appDelegate;
@property HostManager *hostManager;

@end

@implementation MultiGame

#pragma mark - Game Control

-(MultiGame *) initWithView: (UIView *) view andController: (UIViewController *) viewController {
    self = [super initWithView:view];
    
    if (self) {
        [self setViewController:viewController];
        [self setAppDelegate:(AppDelegate *)[[UIApplication sharedApplication] delegate]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(peerDidChangeStateWithNotification:)
                                                     name:@"MCDidChangeStateNotification"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveDataWithNotification:)
                                                     name:@"MCDidReceiveDataNotification"
                                                   object:nil];
        
        [self setHostManager:[HostManager sharedManager]];
    }
    
    return self;
}

-(void) startGame {
    
    NSLog(@"startGame");
    
    [self setSnake:[[Snake alloc] initWithGame: (Game *)self]];
    
    [self setFood: [[Food alloc] initWithGame:(Game *) self]];
    
    
    if ([[HostManager sharedManager] isHost]) {
        NSString *data = [@"@" stringByAppendingString:[self convertPositionIntoString:[[self food] position]]];
        [self sendData:data];
    }
    
    [[self snake] startMoving];
}

-(void) pauseGame {
    // multipeer comunication:
    [[self snake] stopMoving];
    
    // menu aparece
}

-(void) endGame {
    // multipeer comunication:
    // tela de fim de jogo
}

#pragma mark - Snake Loop

-(void) checkSnakePosition:(CGPoint)position {
    
    [self checkSnakeOutOfBounds:position];
    
    if ([[self snake] compareBodyWithHeadPosition:position]) {
        [self endGame];
    }
    
//    else if (position.x == [[self food] position].x &&
//             position.y == [[self food] position].y) {
//        //multipeer comunication: outro sofre efeito
//    }
    
}

#pragma mark - Utilities

-(NSString *) convertPositionIntoString: (CGPoint) position {
    return [[[[[NSNumber alloc] initWithDouble:position.x] stringValue] stringByAppendingString:@":"] stringByAppendingString:[[[NSNumber alloc] initWithDouble:position.y] stringValue]];
}

-(CGPoint) convertStringIntoCGPoint: (NSString *) string {
    NSArray *pos = [[NSArray alloc] init];
    pos = [string componentsSeparatedByString:@":"];
    
    return CGPointMake([pos[0] doubleValue], [pos[1] doubleValue]);
}

#pragma mark - Connection

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification{
    
    NSLog(@"state changed");
    
    //MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    //NSString *peerDisplayName = peerID.displayName;
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (state != MCSessionStateConnecting) {
            if (state == MCSessionStateConnected) {
                NSLog(@"Connected");
            }
            else if (state == MCSessionStateNotConnected){
                NSLog(@"Not connected");
            }
        }
        
    });
}

-(void)didReceiveDataWithNotification:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
        NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", receivedText);
        
        // place food
        if ([receivedText hasPrefix:@"@"]) {
            receivedText = [receivedText stringByReplacingOccurrencesOfString:@"@" withString:@""];
            [[self food] placeFoodAtPosition:[self convertStringIntoCGPoint:receivedText]];
        }
    });
}

-(void) sendData: (NSString *) data {
    NSLog(@"%@", data);
    NSData *dataToSend = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = [[[[self appDelegate] mcController] session ] connectedPeers];
    NSError *error;
    
    [[[[self appDelegate] mcController] session] sendData:dataToSend
                                                  toPeers:allPeers
                                                 withMode:MCSessionSendDataReliable
                                                    error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

@end
