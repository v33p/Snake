//
//  AppDelegate.h
//  Snake
//
//  Created by Lucas Padilha on 3/27/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MCController *mcController;
@property (nonatomic, strong) NSString *name;

@end

