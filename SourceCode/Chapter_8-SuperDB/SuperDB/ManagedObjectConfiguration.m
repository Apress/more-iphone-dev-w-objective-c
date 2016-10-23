//
//  HeroDetailConfiguration.m
//  SuperDB
//
//  Created by Jayant Varma on 8/03/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import "ManagedObjectConfiguration.h"

@interface ManagedObjectConfiguration()
@property (strong, nonatomic) NSArray *sections;
@end

@implementation ManagedObjectConfiguration

-(id)initWithResource:(NSString *)resource{
        self = [super init];
        if(self){
            NSURL *pListURL = [[NSBundle mainBundle] URLForResource:resource withExtension:@"plist"];
            NSDictionary *plist = [NSDictionary dictionaryWithContentsOfURL:pListURL];
            self.sections = [plist valueForKey:@"sections"];
        }
        return self;
}

//-(id)init {
//    self = [super init];
//    if(self){
//        NSURL *pListURL = [[NSBundle mainBundle] URLForResource:@"ManagedObjectConfiguration" withExtension:@"plist"];
//        NSDictionary *plist = [NSDictionary dictionaryWithContentsOfURL:pListURL];
//        self.sections = [plist valueForKey:@"sections"];
//    }
//    return self;
//}

-(NSInteger)numberOfSections {
    return self.sections.count;
}

-(NSInteger)numberOfRowsInSection:(NSInteger)section {
    NSDictionary *sectionsDict = [self.sections objectAtIndex:section];
    NSArray *rows = [sectionsDict objectForKey:@"rows"];
    return rows.count;
}

-(NSString *)headerInSection:(NSInteger)section{
    NSDictionary *sectionDict = [self.sections objectAtIndex:section];
    return [sectionDict objectForKey:@"header"];
}

-(NSDictionary *)rowForIndexPath:(NSIndexPath *)indexPath {
    NSUInteger sectionIndex = [indexPath section];

    //NSUInteger rowIndex = [indexPath row];
    NSUInteger rowIndex = ([self isDynamicSection:sectionIndex]) ? 0 : [indexPath row];
    
    NSDictionary *section = [self.sections objectAtIndex:sectionIndex];
    NSArray *rows = [section objectForKey:@"rows"];
    NSDictionary *row = [rows objectAtIndex:rowIndex];
    
    return row;
}

- (NSString *)cellClassnameForIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *row = [self rowForIndexPath:indexPath];
    return [row objectForKey:@"class"];
}

- (NSArray *)valuesForIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *row = [self rowForIndexPath:indexPath];
    return [row objectForKey:@"values"];
}

- (NSString *)attributeKeyForIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *row = [self rowForIndexPath:indexPath];
    return [row objectForKey:@"key"];
}

- (NSString *)labelForIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *row = [self rowForIndexPath:indexPath];
    return [row objectForKey:@"label"];
}

-(BOOL)isDynamicSection:(NSInteger)section {
    BOOL dynamic = NO;
    
    NSDictionary *sectionDict = [self.sections objectAtIndex:section];
    NSNumber *dynamicNumber = [sectionDict objectForKey:@"dynamic"];
    if (dynamicNumber != nil) {
        dynamic = [dynamicNumber boolValue];
    }
    
    return dynamic;
}

-(NSString *)dynamicAttributeKeyForSection:(NSInteger) section {
    if (![self isDynamicSection:section])
        return nil;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    return [self attributeKeyForIndexPath:indexPath];
}





@end
