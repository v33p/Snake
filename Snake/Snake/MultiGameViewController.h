//
//  MultiGameViewController.h
//  Snake
//
//  Created by Lucas Padilha on 3/31/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "MultiGame.h"

@interface MultiGameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UILabel *nameHost;
@property (weak, nonatomic) IBOutlet UILabel *scoreHost;

@property (weak, nonatomic) IBOutlet UILabel *nameClient;
@property (weak, nonatomic) IBOutlet UILabel *scoreClient;

@property (weak, nonatomic) IBOutlet UIView *endGameView;

@property BOOL isPaused;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *connecting;

@end
