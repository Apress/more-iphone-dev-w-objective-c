//
//  ViewController.h
//  TicTacToe
//
//  Created by Jayant Varma on 31/12/2014.
//  Copyright (c) 2014 OZ Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "TicTacToe.h"

@class Packet;

@interface ViewController : UIViewController <MCBrowserViewControllerDelegate, MCSessionDelegate>
{

    GameState _state;

    NSInteger _myDieRoll;
    NSInteger _opponentDieRoll;

    PlayerPiece _playerPiece;
    
    BOOL _dieRollRecieved;
    BOOL _dieRollAcknowledged;
    
}

@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, strong) MCNearbyServiceBrowser *nearbyBrowser;
@property (nonatomic, strong) MCAdvertiserAssistant *assistant;

@property (nonatomic, strong) UIImage *xPieceImage;
@property (nonatomic, strong) UIImage *oPieceImage;

-(void) resetBoard;
-(void) startNewGame;
-(void) resetDieState;
-(void) startGame;
-(void) sendPacket:(Packet *)packet;
-(void) sendDieRoll;
-(void) checkForEndGame;

@end

