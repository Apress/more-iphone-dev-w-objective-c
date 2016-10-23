//
//  MapLocation.m
//  MapMe
//
//  Created by Jayant Varma on 17/02/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import "MapLocation.h"


@implementation MapLocation


#pragma mark - MKAnnotation Protocol Methods

-(NSString *) title {
    return NSLocalizedString(@"You are Here!", @"You are Here!");
}

-(NSString *) subtitle {
    NSMutableString *result = [NSMutableString string];
    if(self.street)
        [result appendString:self.street];
    if(self.street && (self.city || self.state || self.zip))
        [result appendString:@", "];
    if(self.city)
        [result appendString:self.city];
    if(self.city && self.state)
        [result appendString:@", "];
    if(self.state)
        [result appendString:self.state];
    if(self.zip)
        [result appendFormat:@"  %@", self.zip];
    
    return result;
}

#pragma mark - NSCoder Protocol Methods

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.street forKey:@"street"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.state forKey:@"state"];
    [aCoder encodeObject:self.zip forKey:@"zip"];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        [self setStreet:[aDecoder decodeObjectForKey:@"street"]];
        [self setCity:[aDecoder decodeObjectForKey:@"city"]];
        [self setState:[aDecoder decodeObjectForKey:@"state"]];
        [self setZip:[aDecoder decodeObjectForKey:@"zip"]];
    }
    
    return self;
}


@end
