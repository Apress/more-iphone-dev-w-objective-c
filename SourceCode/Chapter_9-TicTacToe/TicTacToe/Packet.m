//
//  Packet.m
//  TicTacToe
//
//  Created by Jayant Varma on 31/12/2014.
//  Copyright (c) 2014 OZ Apps. All rights reserved.
//

#import "Packet.h"

@implementation Packet

-(id) initWithType:(PacketType)aPacketType
           dieRoll:(NSUInteger)aDieRoll
             space:(BoardSpace)aBoardSpace {
    self = [super init];
    if (self) {
        self.type = aPacketType;
        self.dieRoll = aDieRoll;
        self.space = aBoardSpace;
    }
    return self;
}

-(id) initDieRollPacket {
    int roll = dieRoll();
    return [self initWithType:kPacketTypeDieRoll dieRoll:roll space:0];
}

-(id) initDieRollPacketWithRoll:(NSUInteger)aDieRoll {
    return [self initWithType:kPacketTypeDieRoll dieRoll:aDieRoll space:0];
}

-(id) initMovePacketWithSpace:(BoardSpace)aBoardSpace {
    return [self initWithType:kPacketTypeMove dieRoll:0 space:aBoardSpace];
}

-(id) initAckPacketWithDieRoll:(NSUInteger)aDieRoll {
    return [self initWithType:kPacketTypeAck dieRoll:aDieRoll space:0];
}

-(id) initResetPacket {
    return [self initWithType:kPacketTypeReset dieRoll:0 space:0];
}

#pragma mark - NSCoder (Archiving) methods

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:[self type] forKey:@"type"];
    [aCoder encodeInteger:[self dieRoll] forKey:@"dieRoll"];
    [aCoder encodeInt:[self space] forKey:@"space"];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        [self setType:[aDecoder decodeIntForKey:@"type"]];
        [self setDieRoll:[aDecoder decodeIntegerForKey:@"dieRoll"]];
        [self setSpace:[aDecoder decodeIntForKey:@"space"]];
    }
    return self;
}

@end
