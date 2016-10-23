//
//  MapLocation.h
//  MapMe
//
//  Created by Jayant Varma on 17/02/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MapKit;

@interface MapLocation : NSObject <MKAnnotation, NSCoding>

@property (strong, nonatomic) NSString *street;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *zip;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@end
