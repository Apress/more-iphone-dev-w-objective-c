//
//  HeroDetailController.m
//  SuperDB
//
//  Created by Jayant Varma on 8/03/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import "HeroDetailController.h"
#import "ManagedObjectConfiguration.h"
#import "HeroReportController.h"

@interface HeroDetailController ()

@end

@implementation HeroDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.config = [[ManagedObjectConfiguration alloc] initWithResource:@"HeroDetailConfiguration"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View data source

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self removeRelationshipObjectInIndexPath:indexPath];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        NSManagedObject *newObject = [self addRelationshipObjectForSection:[indexPath section]];
        [self performSegueWithIdentifier:@"PowerViewSegue" sender:newObject];
    }
    
    [super tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [self.config attributeKeyForIndexPath:indexPath];
    NSEntityDescription *entity = [self.managedObject entity];
    NSDictionary *properties = [entity propertiesByName];
    NSPropertyDescription *property = [properties objectForKey:key];
    
    if([property isKindOfClass:[NSRelationshipDescription class]]) {
        NSMutableSet *relationshipSet = [self.managedObject mutableSetValueForKey:key];
        NSManagedObject *relationshipObject = [[relationshipSet allObjects] objectAtIndex:[indexPath row]];
        [self performSegueWithIdentifier:@"PowerViewSegue" sender:relationshipObject];
    } else if([property isKindOfClass:[NSFetchedPropertyDescription class]]) {
        NSArray *fetchedProperties = [self.managedObject valueForKey:key];
        [self performSegueWithIdentifier:@"ReportViewSegue" sender:fetchedProperties];
    }
    
    
//    NSMutableSet *relationshipSet = [self.managedObject mutableSetValueForKey:key];
//    NSManagedObject *relationshipObject = [[relationshipSet allObjects] objectAtIndex:[indexPath row]];
//    [self performSegueWithIdentifier:@"PowerViewSegue" sender:relationshipObject];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"PowerViewSegue"]) {
        if([sender isKindOfClass:[NSManagedObject class]]) {
            ManagedObjectController *detailController = segue.destinationViewController;
            detailController.managedObject = sender;
        }
    } else if ([segue.identifier isEqualToString:@"ReportViewSegue"]) {
            if ([sender isKindOfClass:[NSArray class]]) {
                HeroReportController *reportController = segue.destinationViewController;
                reportController.heroes = sender;
            } else {
                //Show Alert
            }
        }
}

-(void) dummy {
    
    NSError *error;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error saving entity", @"Error saving entity") message:[NSString stringWithFormat:NSLocalizedString(@"Error was: %@, quitting", @"Error was: %@, quitting"), [error localizedDescription]] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:NSLocalizedString(@"Aw, Nuts",@"Aw, Nuts") style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelButton];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
