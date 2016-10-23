//
//  TicTacToe.h
//  TicTacToe
//
//  Created by Jayant Varma on 31/12/2014.
//  Copyright (c) 2014 OZ Apps. All rights reserved.
//

#ifndef TicTacToe_TicTacToe_h
#define TicTacToe_TicTacToe_h

#define kTicTacToeSessionID @"oz-tictactoe"

#define kTicTacToeArchiveKey @"com.oz-apps.TicTacToe"

#define dieRoll() (arc4random() % 1000000)

#define kDiceNotRolled INT_MAX

typedef enum GameStates{
    kGameStateBeginning,
    kGameStateRollingDice,
    kGameStateMyTurn,
    kGameStateYourTurn,
    kGameStateInterrupted,
    kGameStateDone,
} GameState;

typedef enum BoardSpaces {
    kUpperLeft = 1000,
    kUpperMiddle,
    kUpperRight,
    kMiddleLeft,
    kMiddleMiddle,
    kMiddleRight,
    kLowerLeft,
    kLowerMiddle,
    kLowerRight
} BoardSpace;

typedef enum PlayerPieces {
    kPlayerPieceUndecided,
    kPlayerPieceO,
    kPlayerPieceX
} PlayerPiece;


typedef enum PacketTypes
{
    kPacketTypeDieRoll,
    kPacketTypeAck,
    kPacketTypeMove,
    kPacketTypeReset,
} PacketType;


#endif
