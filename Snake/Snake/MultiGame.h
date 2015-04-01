//
//  MultiGame.h
//  Snake
//
//  Created by Lucas Padilha on 3/30/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import "Game.h"
#import "AppDelegate.h"
#import "HostManager.h"

@interface MultiGame : Game

-(MultiGame *) initWithView: (UIView *) view andController: (UIViewController *) viewController;

@end
