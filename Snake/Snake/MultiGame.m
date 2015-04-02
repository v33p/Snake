//
//  MultiGame.m
//  Snake
//
//  Created by Lucas Padilha on 3/30/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import "MultiGame.h"

@interface MultiGame()

@property MultiGameViewController *viewController;
@property AppDelegate *appDelegate;
@property (nonatomic, strong) HostManager *hostManager;

@property BOOL hasStarted;

@property int scoreHost;
@property int scoreClient;

@end

@implementation MultiGame

#pragma mark - Game Control

-(MultiGame *) initWithView: (UIView *) view andController: (MultiGameViewController *) viewController {
    self = [super init];
    
    if (self) {
        UIImage *image = [UIImage imageNamed:@"Snake(18).png"];
        
        [self setBlockHeight:image.size.height];
        [self setBlockWidth:image.size.width];
        
        [self setView:view];
        
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
        
        [self setHasStarted:NO];
        
        [self startGame];
        
    }
    
    return self;
}

-(void) startGame {
    if (![self hasStarted]) {
        [self setHasStarted:YES];
        NSLog(@"start game");
        
        [self setSnake:[[Snake alloc] initWithGame: (Game *)self]];
        
        [self setFood: [[Food alloc] initWithGame:(Game *) self]];
        
        NSLog([[self hostManager] isHost] ? @"2 - Yes" : @"2 - No");
        
        if ([[self hostManager] isHost]) {
            NSString *data = [@"@" stringByAppendingString:[self convertPositionIntoString:[[self food] position]]];
            [self sendData:data];
            
            [[[self viewController] nameHost] setText:[[self appDelegate] name]];
            
            NSArray *allPeers = [[[[self appDelegate] mcController] session ] connectedPeers];
            MCPeerID *peerID = allPeers[0];
            NSString *peerDisplayName = peerID.displayName;
            [[[self viewController] nameClient] setText:peerDisplayName];
        }
        else {
            [[[self viewController] nameClient] setText:[[self appDelegate] name]];
            
            NSArray *allPeers = [[[[self appDelegate] mcController] session ] connectedPeers];
            MCPeerID *peerID = allPeers[0];
            NSString *peerDisplayName = peerID.displayName;
            [[[self viewController] nameHost] setText:peerDisplayName];
        }
        
        [[self snake] startMoving];
    }
}

-(void) resumeGame {
    [[self snake] startMoving];
    
    [[[self viewController] endGameView] setHidden:YES];
    [[self viewController] setIsPaused:NO];
}

-(void) pauseGame {
    // multipeer comunication?
    
    [[[self viewController] scoreHost] setText:[[[NSNumber alloc] initWithInt:[self scoreHost]] stringValue]];
    [[[self viewController] scoreClient] setText:[[[NSNumber alloc] initWithInt:[self scoreClient]] stringValue]];
    
    [[[self viewController] secondButton] setTitle:@"Resume" forState:UIControlStateNormal];
    [[[self viewController] label] setText:@"PAUSE"];
    
    [[[self viewController] view] addSubview:[[self viewController] endGameView]];
    [[[self viewController] endGameView] setHidden:NO];
    
    [[self snake] stopMoving];
}

-(void) endGame {
    // multipeer comunication:
    // tela de fim de jogo
    [[[self viewController] scoreHost] setText:[[[NSNumber alloc] initWithInt:[self scoreHost]] stringValue]];
    [[[self viewController] scoreClient] setText:[[[NSNumber alloc] initWithInt:[self scoreClient]] stringValue]];
    
    [[[self viewController] secondButton] setTitle:@"Restart" forState:UIControlStateNormal];
    [[[self viewController] label] setText:@"GAME OVER"];
    
    [[[self viewController] view] addSubview:[[self viewController] endGameView]];
    [[[self viewController] endGameView] setHidden:NO];
    
    [[self snake] stopMoving];
}

#pragma mark - Snake Loop

-(void) checkSnakePosition:(CGPoint)position {
    
    position = [self checkSnakeOutOfBounds:position];
    
    if ([[self snake] compareBodyWithHeadPosition:position]) {
        [self endGame];
        
        if ([[self hostManager] isHost]) {
            [[[self viewController] scoreClient] setTextColor:[UIColor greenColor]];
            [[[self viewController] scoreHost] setTextColor:[UIColor redColor]];
        }
        else {
            [[[self viewController] scoreHost] setTextColor:[UIColor greenColor]];
            [[[self viewController] scoreClient] setTextColor:[UIColor redColor]];
        }
        
        NSString *data = @"$";
        [self sendData:data];
    }
    
    else if (position.x == [[self food] position].x &&
             position.y == [[self food] position].y) {
        NSLog(@"head.pos == food.pos: %f, %f", position.x, position.y);
        
        // multipeer comunication: outro sofre efeito
        // troca comida de lugar
        [[self food] placeFoodRandom];
        NSString *data = [@"@" stringByAppendingString:[self convertPositionIntoString:[[self food] position]]];
        [self sendData:data];
        
        // outro sofre efeito
        data = @"#";
        [self sendData:data];
        
        if ([[self hostManager] isHost]) {
            [self setScoreHost:[self scoreHost]+1];
        }
        else {
            [self setScoreClient:[self scoreClient]+1];
        }
    }
    
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
                [[[self viewController] connecting] setHidden:YES];
            }
            else if (state == MCSessionStateConnecting) {
                [[[self viewController] connecting] setHidden:NO];
            }
            else if (state == MCSessionStateNotConnected){
                [[[self viewController] connecting] setHidden:NO];
                NSLog(@"Not connected");
            }
        }
    });
}

-(void)didReceiveDataWithNotification:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
        NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        
        NSLog(@"informacao recebida: %@", receivedText);
        
        // place food
        if ([receivedText hasPrefix:@"@"]) {
            receivedText = [receivedText stringByReplacingOccurrencesOfString:@"@" withString:@""];
            [[self food] placeFoodAtPosition:[self convertStringIntoCGPoint:receivedText]];
        }
        // snake enlarge
        else if ([receivedText hasPrefix:@"#"]) {
            if ([[self viewController] isPaused])
                [self resumeGame];
            
            
            [[self snake] enlarge];
            //[[self snake] changingSpeedByAddingByFactor:-0.01];
            [[self snake] changingSpeed];
            
            if ([[self hostManager] isHost]) {
                [self setScoreClient:[self scoreClient]+1];
            }
            else {
                [self setScoreHost:[self scoreHost]+1];
            }
        }
        // end game
        else if ([receivedText hasPrefix:@"$"]) {
            if ([[self hostManager] isHost]) {
                [[[self viewController] scoreHost] setTextColor:[UIColor greenColor]];
                [[[self viewController] scoreClient] setTextColor:[UIColor redColor]];
            }
            else {
                [[[self viewController] scoreClient] setTextColor:[UIColor greenColor]];
                [[[self viewController] scoreHost] setTextColor:[UIColor redColor]];
            }
            
            [self endGame];
        }
        
    });
}

-(void) sendData: (NSString *) data {
    NSLog(@"informacao enviada: %@", data);
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
