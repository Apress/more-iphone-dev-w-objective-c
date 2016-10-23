//
//  HeroListController.m
//  SuperDB
//
//  Created by Jayant Varma on 7/03/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import "HeroListController.h"
#import "AppDelegate.h"

@interface HeroListController ()
@property (nonatomic, strong, readonly) NSFetchedResultsController *fetchedResultsController;
@end

@implementation HeroListController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    // Select the Tab Bar button
    //    UITabBarItem *item = [self.heroTabBar.items objectAtIndex:0];
    //    [self.heroTabBar setSelectedItem:item];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger selectedTab = [defaults integerForKey:kSelectedTabDefaultsKey];
    UITabBarItem *item = [self.heroTabBar.items objectAtIndex:selectedTab];
    [self.heroTabBar setSelectedItem:item];
    
    //Fetch any existing entities
    NSError *error = nil;
    if(![[self fetchedResultsController] performFetch:&error]) {
        NSString *message = [NSString stringWithFormat:@"Error was %@: quitting",[error localizedDescription]];
        [self showAlert:NSLocalizedString(@"Error fetching entity", @"Error fetching entity")
                message:NSLocalizedString(message, message)
             buttonText:NSLocalizedString(@"Aw, nuts", @"Aw, nuts")
                handler:^(UIAlertAction *alert) {
                    [self dismissButtonOnAlertController:alert];
                }];
    }
    
}

#pragma mark - TabBar Delegate Methods

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSUInteger tabIndex = [tabBar.items indexOfObject:item];
    [defaults setInteger:tabIndex forKey:kSelectedTabDefaultsKey];
    
    [NSFetchedResultsController deleteCacheWithName:@"Hero"];
    _fetchedResultsController.delegate = nil;
    _fetchedResultsController = nil;
    
    NSError *error = nil;
    if(![self.fetchedResultsController performFetch:&error]){
        NSLog(@"Error performing fetch: %@", [error localizedDescription]);
    }
    [self.heroTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return[[self.fetchedResultsController sections]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"HeroListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSManagedObject *aHero = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSInteger tab = [self.heroTabBar.items indexOfObject:self.heroTabBar.selectedItem];
    
    switch (tab) {
        case kByName:
            cell.textLabel.text = [aHero valueForKey:@"name"];
            cell.detailTextLabel.text = [aHero valueForKey:@"secretIdentity"];
            break;
        case kBySecretIdentity:
            cell.textLabel.text = [aHero valueForKey:@"secretIdentity"];
            cell.detailTextLabel.text = [aHero valueForKey:@"name"];
            break;
            
        default:
            break;
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObjectContext *managedObjectContext = [self.fetchedResultsController managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];

        NSError *error = nil;
        if(![managedObjectContext save:&error]) {
            NSString *message = [NSString stringWithFormat:@"Error was %@: quitting",[error localizedDescription]];
            [self showAlert:NSLocalizedString(@"Error saving entity", @"Error saving entity")
                    message:NSLocalizedString(message, message)
                 buttonText:NSLocalizedString(@"Aw, nuts", @"Aw, nuts")
                    handler:^(UIAlertAction *alert) {
                        [self dismissButtonOnAlertController:alert];
                    }];
        }
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIAlertController Handler method
-(void) dismissButtonOnAlertController:(UIAlertAction *) action {
    exit(-1);
}

-(void) showAlert:(NSString *) title
          message:(NSString *) message
       buttonText:(NSString *) buttonText
          handler:(void (^)(UIAlertAction* alert)) handler {
    UIAlertController *alert = [UIAlertController
                alertControllerWithTitle:title
                                 message:message
                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OKButton = [UIAlertAction
                actionWithTitle:buttonText
                          style:UIAlertActionStyleDefault
                        handler:handler];
    [alert addAction:OKButton];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - NSFetchedResultsControllerDelegate Property

-(NSFetchedResultsController *) fetchedResultsController{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Hero" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSUInteger tabIndex = [self.heroTabBar.items indexOfObject:self.heroTabBar.selectedItem];
    if (tabIndex == NSNotFound) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        tabIndex = [defaults integerForKey:kSelectedTabDefaultsKey];
    }
    
    NSString *sectionKey = nil;
    switch (tabIndex) {
        case kByName: {
            NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"secretIdentity" ascending:YES];
            
            NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor1, sortDescriptor2, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
            sectionKey = @"name";
            break;
        }
        case kBySecretIdentity: {
            NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"secretIdentity" ascending:YES];
            
            NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor1, sortDescriptor2, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
            sectionKey = @"secretIdentity";
            break;
        }
        default:
            break;
    }
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:sectionKey cacheName:@"Hero"];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate Methods

-(void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.heroTableView beginUpdates];
}

-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.heroTableView endUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller
 didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
          atIndex:(NSUInteger)sectionIndex
    forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.heroTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.heroTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}

-(void)controller:(NSFetchedResultsController *)controller
  didChangeObject:(id)anObject
      atIndexPath:(NSIndexPath *)indexPath
    forChangeType:(NSFetchedResultsChangeType)type
     newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.heroTableView  insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.heroTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}

- (IBAction)addHero:(id)sender {
    NSManagedObjectContext *managedObjectContext = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:managedObjectContext];
    NSError *error = nil;
    if(![managedObjectContext save:&error]) {
        NSString *message = [NSString stringWithFormat:@"Error was %@: quitting",[error localizedDescription]];
        [self showAlert:NSLocalizedString(@"Error saving entity", @"Error saving entity")
                message:NSLocalizedString(message, message)
             buttonText:NSLocalizedString(@"Aw, nuts", @"Aw, nuts")
                handler:^(UIAlertAction *alert) {
                    [self dismissButtonOnAlertController:alert];
                }];
    }
}


-(void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    self.addButton.enabled = !editing;
    [self.heroTableView setEditing:editing animated:animated];
}

@end
