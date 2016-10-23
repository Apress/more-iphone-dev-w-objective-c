//
//  ViewController.m
//  TicTacToe
//
//  Created by Jayant Varma on 31/12/2014.
//  Copyright (c) 2014 OZ Apps. All rights reserved.
//

#import "ViewController.h"

#import "Packet.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *feedbacklabel;
@property (weak, nonatomic) IBOutlet UIButton *gameButton;
//- (IBAction)gameButtonPressed:(id)sender;

//- (IBAction)gameSpacePressed:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _myDieRoll = kDiceNotRolled;
    self.oPieceImage = [UIImage imageNamed:@"O.png"];
    self.xPieceImage = [UIImage imageNamed:@"X.png"];
    
    NSString *DeviceName = @"iMac" ;//[[UIDevice currentDevice]name];
    self.peerID = [[MCPeerID alloc] initWithDisplayName: DeviceName];
    self.session = [[MCSession alloc] initWithPeer: self.peerID];
    self.session.delegate = self;
    
    NSLog(@"Peer -> %@ = %@", self.peerID, self.peerID.displayName);
    NSLog(@"session -> %@", self.session);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [self.session disconnect];
    self.session.delegate = nil;
    self.session = nil;
    self.peerID = nil;
}

#pragma mark - MCBrowserViewController Delegate Methods

-(void) browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.browser.delegate = nil;
    self.browser = nil;
    
    [self.assistant stop];
    self.assistant = nil;
    
    [self.nearbyBrowser stopBrowsingForPeers];
    self.nearbyBrowser = nil;
    
    [self startNewGame];
}

-(void) browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    _gameButton.hidden = NO;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//-(void) dummy {
//    
//    NSString *deviceName = @"iMac";  //[[UIDevice currentDevice] name];
//    MCPeerID *peerID = [[MCPeerID alloc]initWithDisplayName: deviceName];
//    
//    MCSession *theSession = [[MCSession alloc]initWithPeer:peerID];
//
//    MCSessionStateNotConnected,     // not in the session
//    MCSessionStateConnecting,       // connecting to this peer
//    MCSessionStateConnected         // connected to the session

    
    
//    MCAdvertiserAssistant *assistant;
//    MCSession *session;
//    MCBrowserViewController *browser;
//    MCNearbyServiceBrowser *nearbyBrowser;
//    MCPeerID *peerID;
//    
///*
//
//    assistant = [[MCAdvertiserAssistant alloc] initWithServiceType:@"oz-appsgame" discoveryInfo:nil session:session];
//    
//    [assistant start];
////    
////    peerID = [[MCPeerID alloc]initWithDisplayName:@""];
//
//    MCNearbyServiceBrowser nearbyBrowser = [[MCNearbyServiceBrowser alloc]initWithPeer:peerID serviceType:@"oz-appsgame"];
//
//    //    nearbyBrowser = [[MCNearbyServiceBrowser alloc]initWithPeer:peerID serviceType:@"oz-appsgame"];
//
//        browser = [[MCBrowserViewController alloc] initWithBrowser: nearbyBrowser session:session];
//    
//    browser.delegate = self;
//    
//    [self presentViewController:browser animated:YES completion:nil];
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//
//    NSData *theData;
//    NSError *error = nil;
//    if (![self.session sendData:theData
//                        toPeers:self.session.connectedPeers
//                       withMode:MCSessionSendDataReliable
//                          error:&error]){
//        NSLog(@"error in sending %@", [error localizedDescription]);
//    }
//    
//
//    NSError *error = nil;
//    if (![self.session sendData:theData
//                        toPeers:[NSArray arrayWithObject:peerID]
//                       withMode:MCSessionSendDataReliable
//                          error:&error]){
//        NSLog(@"error in sending %@", [error localizedDescription]);
//    }
//
// */
//    
//    NSUInteger foo;
//    NSUInteger bar;
// 
//    
//    
//    NSUInteger packetData[2];
//    packetData[0] = foo;
//    packetData[1] = bar;
//    NSData *packet = [NSData dataWithBytes:packetData length:2 * sizeof(packetData)];
//
//    NSError *error = nil;
//    if (![session sendData:packet
//                   toPeers:session.connectedPeers
//                  withMode:MCSessionSendDataReliable
//                     error:&error])
//    {
//        NSLog(@"error in sending %@", [error localizedDescription]);
//    }
//
//}

#pragma mark - Game Specific Actions

- (IBAction)gameButtonPressed:(id)sender {
    _dieRollAcknowledged = NO;
    _dieRollRecieved = NO;
    
    _gameButton.hidden = YES;
    
    if (self.assistant == nil)
        self.assistant = [[MCAdvertiserAssistant alloc]initWithServiceType:kTicTacToeSessionID discoveryInfo:nil session:self.session];
    [self.assistant start];
    
    if (self.nearbyBrowser == nil)
        self.nearbyBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer: self.peerID serviceType: kTicTacToeSessionID];

    if (self.browser == nil)
        self.browser = [[MCBrowserViewController alloc]initWithBrowser:self.nearbyBrowser session:self.session];
    self.browser.delegate = self;
    [self presentViewController:self.browser animated:YES completion:nil];
}

- (IBAction)gameSpacePressed:(id)sender {
    UIButton *buttonPressed = sender;
    if (_state == kGameStateMyTurn && [buttonPressed imageForState:UIControlStateApplication] == nil) {
        [buttonPressed setImage:((_playerPiece == kPlayerPieceO) ? self.oPieceImage:self.xPieceImage) forState:UIControlStateNormal];
        _feedbacklabel.text = NSLocalizedString(@"Opponent's Turn", @"Opponent's Turn");
        _state = kGameStateYourTurn;
        
        Packet *packet = [[Packet alloc] initMovePacketWithSpace:buttonPressed.tag];
        [self sendPacket:packet];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self checkForEndGame];
        });
    }
}

-(void) startGame{
    if (_myDieRoll == _opponentDieRoll) {
        _myDieRoll = kDiceNotRolled;
        _opponentDieRoll = kDiceNotRolled;
        [self sendDieRoll];
        _playerPiece = kPlayerPieceUndecided;
        self.feedbacklabel.text = @"Waiting to start";
    } else if (_myDieRoll < _opponentDieRoll) {
        _state = kGameStateYourTurn;
        _playerPiece = kPlayerPieceX;
        self.feedbacklabel.text = NSLocalizedString(@"Opponent's Turn", @"Opponent's Turn");
    } else {
        _state = kGameStateMyTurn;
        _playerPiece = kPlayerPieceO;
        self.feedbacklabel.text = NSLocalizedString(@"Your Turn", @"Your Turn");
    }
    [self resetDieState];
}

-(void)resetBoard {
    for (int i = kUpperLeft; i <= kLowerRight; i++) {
        UIButton *aButton = (UIButton *)[self.view viewWithTag:i];
        [aButton setImage:nil forState:UIControlStateNormal];
    }
    
    self.feedbacklabel.text = @"";
    Packet *packet = [[Packet alloc] initResetPacket];
    [self sendPacket:packet];
    _playerPiece = kPlayerPieceUndecided;
}

-(void) resetDieState {
    _dieRollAcknowledged = NO;
    _dieRollRecieved = NO;
    _myDieRoll = kDiceNotRolled;
    _opponentDieRoll = kDiceNotRolled;
}

#pragma mark - Instance methods

-(void) startNewGame {
    [self resetBoard];
    [self sendDieRoll];
}

-(void) sendPacket:(Packet *)packet {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:packet forKey:kTicTacToeArchiveKey];
    [archiver finishEncoding];
    
    //NSLog(@"Sending packet of type %u", packet.type);
    //NSLog(@"There are %d connected peers -> %@", self.session.connectedPeers.count, self.session.connectedPeers);
    
    
    NSError *error = nil;
    if (![self.session sendData:data toPeers:self.session.connectedPeers withMode:MCSessionSendDataReliable error:&error]){
        NSLog(@"error in sending %@", [error localizedDescription]);
    }
}

-(void) sendDieRoll {
    Packet *rollPacket;
    _state = kGameStateRollingDice;
    if (_myDieRoll == kDiceNotRolled) {
        rollPacket = [[Packet alloc] initDieRollPacket];
        _myDieRoll = rollPacket.dieRoll;
    } else {
        rollPacket = [[Packet alloc] initDieRollPacketWithRoll:_myDieRoll];
    }
    [self sendPacket:rollPacket];
}

-(void) checkForEndGame {
    
    NSInteger moves = 0;
    
    UIImage *currentButtonImages[9];
    UIImage *winningImage = nil;
    
    for (int i = kUpperLeft; i<= kLowerRight; i++){
        UIButton *aButton = (UIButton *)[self.view viewWithTag:i];
        if ([aButton imageForState:UIControlStateNormal])
            moves++;
        currentButtonImages[i - kUpperLeft] = [aButton imageForState:UIControlStateNormal];
    }
    
        //Top Row
        if(currentButtonImages[0] == currentButtonImages[1]
            && currentButtonImages[0] == currentButtonImages[2]
            && currentButtonImages[0] != nil)
            winningImage = currentButtonImages[0];

        //Middle Row
        else if(currentButtonImages[3] == currentButtonImages[4]
           && currentButtonImages[3] == currentButtonImages[5]
           && currentButtonImages[3] != nil)
            winningImage = currentButtonImages[3];
        
        
        //Bottom Row
        else if(currentButtonImages[6] == currentButtonImages[7]
                && currentButtonImages[6] == currentButtonImages[8]
                && currentButtonImages[6] != nil)
            winningImage = currentButtonImages[6];
        
        
        //Left Column
        else if(currentButtonImages[0] == currentButtonImages[3]
                && currentButtonImages[0] == currentButtonImages[6]
                && currentButtonImages[0] != nil)
            winningImage = currentButtonImages[0];
        
        
        //Middle Column
        else if(currentButtonImages[1] == currentButtonImages[4]
                && currentButtonImages[1] == currentButtonImages[7]
                && currentButtonImages[1] != nil)
            winningImage = currentButtonImages[1];
        
        
        //Right Column
        else if(currentButtonImages[2] == currentButtonImages[5]
                && currentButtonImages[2] == currentButtonImages[8]
                && currentButtonImages[2] != nil)
            winningImage = currentButtonImages[2];
        
        
        //Diagonal starting top left
        else if(currentButtonImages[0] == currentButtonImages[4]
                && currentButtonImages[0] == currentButtonImages[8]
                && currentButtonImages[0] != nil)
            winningImage = currentButtonImages[0];
        
        
        //Diagonal starting top Right
        else if(currentButtonImages[2] == currentButtonImages[4]
                && currentButtonImages[2] == currentButtonImages[6]
                && currentButtonImages[2] != nil)
            winningImage = currentButtonImages[2];
        

        if (winningImage == self.xPieceImage) {
            if (_playerPiece == kPlayerPieceX) {
                self.feedbacklabel.text = NSLocalizedString(@"You Won", @"You Won");
                _state = kGameStateDone;
            } else {
            _feedbacklabel.text = NSLocalizedString(@"Opponent Won!", @"Opponent Won!");
            _state = kGameStateDone;
            }
        } else if (winningImage == self.oPieceImage){
            if (_playerPiece == kPlayerPieceO) {
                self.feedbacklabel.text = NSLocalizedString(@"You Won", @"You Won");
                _state = kGameStateDone;
            } else {
                _feedbacklabel.text = NSLocalizedString(@"Opponent Won!", @"Opponent Won!");
                _state = kGameStateDone;
            }
        } else {
        if (moves >= 9) {
            _feedbacklabel.text = @"Cat Wins";
            _state = kGameStateDone;
        }
    }
    
    
    if (_state == kGameStateDone) {
        NSLog(@"The game is Done, will restart in 3");
        [self performSelector:@selector(startNewGame) withObject:nil afterDelay:3.0];
    }
}

#pragma mark - Multipeer Connectivity Session Delegate Methods

-(void) session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    //NSLog(@"%@ -> state %d", peerID.displayName, state);
    
    if (state == MCSessionStateNotConnected){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error Connecting" message:@"Unable to establish connection" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Bummer" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [self resetBoard];
            _gameButton.hidden = NO;
        }];
        [alert addAction:cancel];
//        [[[[UIApplication sharedApplication]keyWindow]rootViewController] presentViewController:alert animated:YES completion:nil];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void) session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {}

-(void) session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {}
-(void) session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {}

-(void) session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    
//    NSString *sender = peerID.displayName;
//    NSString *textData = [[NSString alloc]initWithData: data encoding: NSUTF8StringEncoding];
//    NSLog(@"%@ said %@", sender, textData);
//    
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    Packet *packet = [unarchiver decodeObjectForKey:kTicTacToeArchiveKey];
    
    //NSLog(@"We got the packet of type %u from %@", packet.type, peerID.displayName);
    
    switch (packet.type) {
        case kPacketTypeDieRoll: {
            _opponentDieRoll = packet.dieRoll;
            Packet *ack = [[Packet alloc] initAckPacketWithDieRoll:_opponentDieRoll];
            [self sendPacket:ack];
            _dieRollRecieved = YES;
            break;
        }
        case kPacketTypeAck: {
            if (packet.dieRoll != _myDieRoll) {
                NSLog(@"Ack packet doesn't match your die roll (mine: %lu, send: %ld", (unsigned long)packet.dieRoll, (long)_myDieRoll);
            }
            _dieRollAcknowledged = YES;
            break;
        }
        case kPacketTypeMove: {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIButton *aButton = (UIButton *) [self.view viewWithTag:[packet space]];
                [aButton setImage:((_playerPiece == kPlayerPieceO) ? self.xPieceImage: self.oPieceImage) forState:UIControlStateNormal];
                _state = kGameStateMyTurn;
                _feedbacklabel.text = NSLocalizedString(@"Your Turn", @"Your Turn");
                [self checkForEndGame];
            });
            break;
        }
        case kPacketTypeReset: {
            if (_state == kGameStateDone)
//                [self startNewGame];
//            else
                [self resetDieState];
            break;
        }
        default:
            break;
    }
    
    if (_dieRollRecieved == YES && _dieRollAcknowledged == YES)
        
        dispatch_async(dispatch_get_main_queue(), ^{
        [self startGame];
        });
    
}


@end
