//
//  HostManager.h
//  Snake
//
//  Created by Lucas Padilha on 4/1/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HostManager : NSObject

@property (nonatomic) BOOL isHost;

+(id)sharedManager;

@end
