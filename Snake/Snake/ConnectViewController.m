//
//  ConnectViewController.m
//  Snake
//
//  Created by Lucas Padilha on 3/27/15.
//  Copyright (c) 2015 UnderCaffeine. All rights reserved.
//

#import "ConnectViewController.h"
#import "AppDelegate.h"
#import "HostManager.h"

@interface ConnectViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *connecting;

@property (weak, nonatomic) IBOutlet UISwitch *switchVisible;
@property (weak, nonatomic) IBOutlet UIButton *buttonDisconnect;
@property (weak, nonatomic) IBOutlet UIImageView *buttonDisconnectImageView;

@property (weak, nonatomic) IBOutlet UILabel *labelConnected;
@property (weak, nonatomic) IBOutlet UIButton *buttonSearch;
@property (weak, nonatomic) IBOutlet UIImageView *buttonSearchImageView;

@property (weak, nonatomic) IBOutlet UIButton *buttonStart;
@property (weak, nonatomic) IBOutlet UIImageView *buttonStartImageView;

@property (weak, nonatomic) IBOutlet UILabel *labelWaiting;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *waiting;

@property BOOL ready;

@property (nonatomic, strong) AppDelegate *appDelegate;

@property (nonatomic, strong) HostManager *hostManager;

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification;
-(void)didReceiveDataWithNotification:(NSNotification *)notification;

@end

@implementation ConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setReady:NO];
    
    [self setAppDelegate:(AppDelegate *)[[UIApplication sharedApplication] delegate]];
    [[[self appDelegate] mcController] setupPeerAndSessionWithDisplayName:[[self appDelegate] name]];
    [[[self appDelegate] mcController] advertiseSelf:[[self switchVisible] isOn]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"MCDidChangeStateNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:@"MCDidReceiveDataNotification"
                                               object:nil];
    
    //iniciando host manager
    [self setHostManager:[HostManager sharedManager]];
    
    
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
    
    NSLog(@"state changed");
    
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        BOOL peerExist;
        if (state != MCSessionStateConnecting) {
            [[self connecting] setHidden:NO];
            if (state == MCSessionStateConnected) {
                
                [[self connecting] setHidden:YES];
                
                [[self labelConnected] setText:peerDisplayName];
                peerExist = YES;
                NSLog(@"Connected");
                
                [self changeImage:@"purpleButtonBig.png" ofImageView:[self buttonStartImageView]];
                [self changeImage:@"deactivatedButton.png" ofImageView:[self buttonSearchImageView]];
                [self changeImage:@"purpleButton.png" ofImageView:[self buttonDisconnectImageView]];
            }
            else if (state == MCSessionStateNotConnected){
                
                [[self connecting] setHidden:YES];
                
                NSLog(@"Not connected");
                [[self labelConnected] setText:@" "];
                [[self hostManager] setIsHost:NO];
                NSLog (@"Host atualizado em change state: NO");
                
                peerExist = NO;
                
                [self changeImage:@"purpleButtonBigDeactivated.png" ofImageView:[self buttonStartImageView]];
                [self changeImage:@"purpleButton.png" ofImageView:[self buttonSearchImageView]];
                [self changeImage:@"deactivatedButton.png" ofImageView:[self buttonDisconnectImageView]];
                
            }
            
            [[self buttonDisconnect] setEnabled:peerExist];
            [[self buttonStart] setEnabled:peerExist];
            [[self buttonSearch] setEnabled:!peerExist];
        }
        
    });
}

-(void)didReceiveDataWithNotification:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
        NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        
        // place food
        if ([receivedText hasPrefix:@"!"]) {
            if (![self ready]) {
                [self setReady:YES];
            }
            else {
                [self performSegueWithIdentifier:@"connectSegue"
                                          sender:self];
            }
        }
    });
}

#pragma mark - Button Action

- (IBAction)startGame:(id)sender {
    
    NSData *dataToSend = [@"!start" dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = [[[[self appDelegate] mcController] session ] connectedPeers];
    NSError *error;
    
    [[[[self appDelegate] mcController] session] sendData:dataToSend
                                                  toPeers:allPeers
                                                 withMode:MCSessionSendDataReliable
                                                    error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    if ([self ready]) {
        [self performSegueWithIdentifier:@"connectSegue"
                                  sender:self];
        
        [[self hostManager] setIsHost:NO];
        NSLog (@"Host atualizado em start game: NO");
    }
    else {
        [[self hostManager] setIsHost:YES];
        NSLog (@"Host atualizado em start game: YES");
        
        [[self labelWaiting] setHidden:NO];
        [[self waiting] setHidden:NO];
        
        [[self buttonStart] setHidden:YES];
        [[self buttonStartImageView] setHidden:YES];
        
        [self setReady:YES];
    }
    
    NSLog([[self hostManager] isHost] ? @"1 - Yes" : @"1 - No");
    
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
    [self changeImage:@"purpleButton.png" ofImageView:[self buttonSearchImageView]];
    
    [[self buttonStart] setEnabled:NO];
    [self changeImage:@"purpleButtonBigDeactivated.png" ofImageView:[self buttonStartImageView]];
    
    [[[[self appDelegate] mcController] session] disconnect];
    
    [[self hostManager] setIsHost:NO];
    NSLog (@"Host atualizado em disconnect: NO");
    
    [[self labelConnected] setText:@" "];
    
    if (![[self labelWaiting] isHidden]) {
        [[self labelWaiting] setHidden:YES];
        [[self waiting] setHidden:YES];
    }
    if ([[self buttonStart] isHidden]) {
        [[self buttonStart] setHidden:NO];
        [[self buttonStartImageView] setHidden:NO];
    }
    
    [self setReady:NO];
}

- (IBAction)back:(id)sender {
    //[[self navigationController] popToRootViewControllerAnimated:NO];
    [[self navigationController] popViewControllerAnimated:YES];
}

# pragma mark - Switch Action

- (IBAction)toggleVisibility:(id)sender {
    [[[self appDelegate] mcController] advertiseSelf:[[self switchVisible] isOn]];
}

# pragma mark - Image

-(void) changeImage: (NSString *) nameOfImage ofImageView: (UIImageView *) imageView {
    UIImage *image = [UIImage imageNamed:nameOfImage];
    [imageView setImage:image];
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
