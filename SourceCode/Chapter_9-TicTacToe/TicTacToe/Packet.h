//
//  Packet.h
//  TicTacToe
//
//  Created by Jayant Varma on 31/12/2014.
//  Copyright (c) 2014 OZ Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TicTacToe.h"

@interface Packet : NSObject <NSCoding>

@property (nonatomic) PacketType type;
@property (nonatomic) NSUInteger dieRoll;
@property (nonatomic) BoardSpace space;

-(id)initWithType:(PacketType)aPacketType
          dieRoll:(NSUInteger) aDieRoll
            space:(BoardSpace) aBoardSpace;
-(id)initDieRollPacket;
-(id)initDieRollPacketWithRoll:(NSUInteger) aDieRoll;
-(id)initMovePacketWithSpace:(BoardSpace) aBoardSpace;
-(id)initAckPacketWithDieRoll:(NSUInteger) aDieRoll;
-(id)initResetPacket;

@end
