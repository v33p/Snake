//
//  ConnectViewController.m
//  Snake
//
//  Created by Lucas Padilha on 3/27/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import "ConnectViewController.h"
#import "AppDelegate.h"

@interface ConnectViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *switchVisible;
@property (weak, nonatomic) IBOutlet UIButton *buttonDisconnect;
@property (weak, nonatomic) IBOutlet UILabel *labelConnected;
@property (weak, nonatomic) IBOutlet UIButton *buttonSearch;
@property (weak, nonatomic) IBOutlet UIButton *buttonStart;
@property (weak, nonatomic) IBOutlet UILabel *labelWaiting;

@property (nonatomic, strong) AppDelegate *appDelegate;

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification;

@end

@implementation ConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setAppDelegate:(AppDelegate *)[[UIApplication sharedApplication] delegate]];
    [[[self appDelegate] mcController] setupPeerAndSessionWithDisplayName:[[self appDelegate] name]];
    [[[self appDelegate] mcController] advertiseSelf:[[self switchVisible] isOn]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"MCDidChangeStateNotification"
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol

-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [[[self appDelegate] mcController].browser dismissViewControllerAnimated:YES
                                                               completion:nil];
}

-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [[[self appDelegate] mcController].browser dismissViewControllerAnimated:YES
                                                               completion:nil];
}

#pragma mark - Notification

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    BOOL peerExist;
    
    if (state != MCSessionStateConnecting) {
        if (state == MCSessionStateConnected) {
            [[self labelConnected] setText:peerDisplayName];
            peerExist = YES;
        }
        else if (state == MCSessionStateNotConnected){
            [[self labelConnected] setText:@" "];
            peerExist = NO;
        }
        
        [[self buttonDisconnect] setEnabled:peerExist];
        [[self buttonStart] setEnabled:peerExist];
        [[self buttonSearch] setEnabled:!peerExist];
    }
}

#pragma mark - Button Action

- (IBAction)startGame:(id)sender {
    NSLog(@"Clicked");
}

- (IBAction)searchForPlayers:(id)sender {
    
    [[[self appDelegate] mcController] setPeerID:nil];
    [[[self appDelegate] mcController] setSession:nil];
    [[[self appDelegate] mcController] setBrowser:nil];
    
    if ([[self switchVisible] isOn]) {
        [[[[self appDelegate] mcController] advertiser] stop];
    }
    
    [[[self appDelegate] mcController] setAdvertiser:nil];
    
    [[[self appDelegate] mcController] setupPeerAndSessionWithDisplayName:[[self appDelegate] name]];
    [[[self appDelegate] mcController] advertiseSelf:[[self switchVisible] isOn]];
    
    [[[self appDelegate] mcController] setupMCBrowser];
    [[[[self appDelegate] mcController] browser] setDelegate:self];
    [self presentViewController:[[[self appDelegate] mcController] browser]
                       animated:YES
                     completion:nil];
}

- (IBAction)disconnect:(id)sender {
    [[self buttonSearch] setEnabled:YES];
    
    [[[[self appDelegate] mcController] session] disconnect];
    
    [[self labelConnected] setText:@" "];
    
}

# pragma mark - Switch Action

- (IBAction)toggleVisibility:(id)sender {
    [[[self appDelegate] mcController] advertiseSelf:[[self switchVisible] isOn]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
