//
//  HeroDetailController.h
//  SuperDB
//
//  Created by Jayant Varma on 8/03/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface HeroDetailController : UITableViewController
@property(strong, nonatomic) NSManagedObject *hero;
@end
