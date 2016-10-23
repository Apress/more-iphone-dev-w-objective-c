//
//  Hero.m
//  SuperDB
//
//  Created by Jayant Varma on 8/03/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import "Hero.h"


@implementation Hero

@dynamic birthDate;
@dynamic name;
@dynamic secretIdentity;
@dynamic sex;
@dynamic favoriteColor;
@dynamic age;


-(void) awakeFromInsert {
    self.favoriteColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    //self.birthDate = [NSDate date];
    
    [super awakeFromInsert];
}

-(BOOL) validateBirthDate:(id *)ioValue error:(NSError *__autoreleasing *)outError {
    NSDate *date = *ioValue;
    if ([date compare:[NSDate date]] == NSOrderedDescending) {
        if (outError != NULL) {
            NSString *errorStr = NSLocalizedString(@"Birthdate cannot be in the future",
                                                   @"Birthdate cannot be in the future");
            NSDictionary *userInfoDict = [NSDictionary dictionaryWithObject:errorStr
                                                                     forKey:NSLocalizedDescriptionKey];
            NSError *error = [[NSError alloc] initWithDomain:kHeroValidationDomain code:kHeroValidationBirthdateCode userInfo:userInfoDict];
            *outError = error;
        }
        return NO;
    }
    return YES;
}

-(BOOL) validateNameOrSecretIdentity:(NSError *__autoreleasing *)outError {
    if ((0 == [self.name length]) && (0 == [self.secretIdentity length])){
        NSString *errorStr = NSLocalizedString(@"Must provide name or secret identity",
                                               @"Must provide name or secret identity");
        NSDictionary *userInfoDict = [NSDictionary dictionaryWithObject:errorStr forKey:NSLocalizedDescriptionKey];
        NSError *error = [[NSError alloc] initWithDomain:kHeroValidationDomain code:kHeroValidationNameOrSecretIdentityCode userInfo:userInfoDict];
        *outError = error;
    }
    
    return YES;
}

-(BOOL)validateForInsert:(NSError *__autoreleasing *)outError {
    return [self validateNameOrSecretIdentity:outError];
}

-(BOOL) validateForUpdate:(NSError *__autoreleasing *)outError {
    return [self validateNameOrSecretIdentity:outError];
}

-(NSNumber *) age {
    if (self.birthDate == nil)
        return nil;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitYear
                                                fromDate:self.birthDate
                                                  toDate:[NSDate date]
                                                 options:0];
    NSInteger years = [components year];
    return [NSNumber numberWithInteger:years];
}



@end
