//
//  HeroDetailConfiguration.h
//  SuperDB
//
//  Created by Jayant Varma on 8/03/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ManagedObjectConfiguration : NSObject
-(NSInteger) numberOfSections;
-(NSInteger) numberOfRowsInSection:(NSInteger)section;
-(NSString *) headerInSection:(NSInteger)section;
-(NSDictionary *)rowForIndexPath:(NSIndexPath *)indexPath;

-(NSString *)cellClassnameForIndexPath:(NSIndexPath *)indexPath;
-(NSArray *)valuesForIndexPath:(NSIndexPath *)indexPath;
-(NSString *)attributeKeyForIndexPath:(NSIndexPath *)indexPath;
-(NSString *)labelForIndexPath:(NSIndexPath *)indexPath;

-(BOOL)isDynamicSection:(NSInteger)section;
-(NSString *)dynamicAttributeKeyForSection:(NSInteger) section;
-(id)initWithResource:(NSString *) resource;
@end
