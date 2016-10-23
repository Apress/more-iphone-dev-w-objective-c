//
//  HeroDetailController.h
//  SuperDB
//
//  Created by Jayant Varma on 8/03/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@class ManagedObjectConfiguration;

@interface ManagedObjectController : UITableViewController
@property (strong, nonatomic) ManagedObjectConfiguration *config;
@property(strong, nonatomic) NSManagedObject *managedObject;

-(NSManagedObject *)addRelationshipObjectForSection:(NSInteger) section;
-(void)removeRelationshipObjectInIndexPath:(NSIndexPath *)indexPath;
@end
