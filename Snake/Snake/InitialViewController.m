//
//  InitialViewController.m
//  Snake
//
//  Created by Lucas Padilha on 3/27/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import "InitialViewController.h"

@interface InitialViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property Snake *snake;
@property AppDelegate *appDelegate;

@property NSTimer *snakeTimer;

@property int countSteps;
@property int countTurn;

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setAppDelegate:[[UIApplication sharedApplication] delegate]];
    [[self nameTextField] setText:[[self appDelegate] name]];
    
    [self setSnake:[[Snake alloc] initWithView:[self view] andPosition:CGPointMake(108, 162) andSize:35]];
    [[self snake] startMoving];
    [self setCountSteps:0];
    [self setCountTurn:0];
    [self setSnakeTimer:[NSTimer scheduledTimerWithTimeInterval:0.2
                                                         target:self
                                                       selector:@selector(snakeMove)
                                                       userInfo:nil
                                                        repeats:YES]];
}

-(void) snakeMove {
    [self setCountSteps:[self countSteps] + 1];
    if (([self countSteps] % 9) == 0) {
        switch (([self countTurn] % 4)) {
            case 0:
                [[self snake] turnRight];
                break;
            case 1:
                [[self snake] turnUp];
                break;
            case 2:
                [[self snake] turnLeft];
                break;
            case 3:
                [[self snake] turnDown];
                break;
            default:
                break;
        }
        if ([self countTurn] >= 4)
            [self setCountTurn:0];
        [self setCountTurn:[self countTurn] + 1];
    }
    if ([self countSteps] >= 9)
        [self setCountSteps:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //    [self result].text = [[self calculate:[self textField].text] stringValue];
    [textField resignFirstResponder];
    return YES;
}




- (IBAction)editingDidEnd:(id)sender {
    [[self appDelegate] setName:[[self nameTextField] text]];
}

- (IBAction)didTapOnScreen:(id)sender {
    [[self view] endEditing:YES];
}

@end
