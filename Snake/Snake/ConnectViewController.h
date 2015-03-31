//
//  ConnectViewController.h
//  Snake
//
//  Created by Lucas Padilha on 3/27/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface ConnectViewController : UIViewController <MCBrowserViewControllerDelegate>

@property BOOL ready;

@end
