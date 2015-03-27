//
//  MCController.m
//  Snake
//
//  Created by Lucas Padilha on 3/18/15.
//  Copyright (c) 2015 UnderCaffiene. All rights reserved.
//

#import "MCController.h"

@implementation MCController

#pragma mark - NSObject

-(id) init {
    self = [super init];
    
    if (self) {
        [self setPeerID:nil];
        [self setSession:nil];
        [self setBrowser:nil];
        [self setAdvertiser:nil];
    }
    
    return self;
}

#pragma mark - MCSession Delegate

-(void) session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    NSDictionary *dict = @{@"peerID": peerID,
                           @"state" : [NSNumber numberWithInt:state]
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidChangeStateNotification"
                                                        object:nil
                                                      userInfo:dict];
}

-(void) session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    
}

-(void) session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    
}

-(void) session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
}

-(void) session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
}

#pragma mark - MCManager

-(void) setupPeerAndSessionWithDisplayName:(NSString *)displayName{
    [self setPeerID:[[MCPeerID alloc] initWithDisplayName:displayName]];
    [self setSession:[[MCSession alloc] initWithPeer:_peerID]];
    [[self session] setDelegate:self];
}

-(void) setupMCBrowser{
    [self setBrowser:[[MCBrowserViewController alloc] initWithServiceType:@"snake"
                                                                  session:[self session]]];
}

-(void)advertiseSelf:(BOOL)shouldAdvertise{
    if (shouldAdvertise) {
        [self setAdvertiser:[[MCAdvertiserAssistant alloc] initWithServiceType:@"snake"
                                                                 discoveryInfo:nil
                                                                       session:_session]];
        [[self advertiser] start];
    }
    else{
        [[self advertiser] stop];
        [self setAdvertiser:nil];
    }
}
@end
