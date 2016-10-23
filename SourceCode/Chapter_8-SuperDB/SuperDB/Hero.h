//
//  Hero.h
//  SuperDB
//
//  Created by Jayant Varma on 8/03/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

#define kHeroValidationDomain @"com.oz-apps.SuperDB.HeroValidationDomain"
#define kHeroValidationBirthdateCode 1000
#define kHeroValidationNameOrSecretIdentityCode 1001

@class Power;

@interface Hero : NSManagedObject

@property (nonatomic, retain) NSDate * birthDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * secretIdentity;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) UIColor *favoriteColor;
@property (nonatomic, retain, readonly) NSNumber * age;

@property (nonatomic, retain) NSSet *powers;
@property (nonatomic, readonly) NSArray *olderHeroes;
@property (nonatomic, readonly) NSArray *youngerHeroes;
@property (nonatomic, readonly) NSArray *sameSexHeroes;
@property (nonatomic, readonly) NSArray *oppositeSexHeroes;

@end

@interface Hero (PowerAccessors)
-(void)addPowersObject:(Power *)value;
-(void)removePowersObject:(Power *)value;
-(void)addPowers:(NSSet *)value;
-(void)removePowers:(NSSet *)value;
@end

