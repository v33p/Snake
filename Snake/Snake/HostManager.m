//
//  HostManager.m
//  Snake
//
//  Created by Lucas Padilha on 4/1/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import "HostManager.h"

@implementation HostManager

+ (id) sharedManager {
    static HostManager *sharedHostManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,
                  ^{sharedHostManager = [[self alloc] init];
    });
    return sharedHostManager;
}

- (id) init {
    if (self = [super init]) {
        [self setIsHost:NO];
    }
    return self;
}

-(void) dealloc {
    
}

@end
