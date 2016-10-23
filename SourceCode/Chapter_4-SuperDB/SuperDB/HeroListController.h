//
//  HeroListController.h
//  SuperDB
//
//  Created by Jayant Varma on 7/03/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#define kSelectedTabDefaultsKey @"Selected Tab"
enum {
    kByName,
    kBySecretIdentity,
};

@interface HeroListController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *heroTableView;
@property (weak, nonatomic) IBOutlet UITabBar *heroTabBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
- (IBAction)addHero:(id)sender;
@end
