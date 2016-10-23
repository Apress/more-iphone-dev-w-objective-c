//
//  HeroDetailController.m
//  SuperDB
//
//  Created by Jayant Varma on 8/03/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import "ManagedObjectController.h"
#import "SuperDBEditCell.h"
#import "ManagedObjectConfiguration.h"

@interface ManagedObjectController ()
//@property (strong, nonatomic) NSArray * sections;
//@property (strong, nonatomic) ManagedObjectConfiguration *config;
@property (strong, nonatomic) UIBarButtonItem *saveButton;
-(void) save;
@property (strong, nonatomic) UIBarButtonItem *backButton;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;
-(void) cancel;

-(void)updateDynamicSections:(BOOL)editing;
-(void)saveManagedObjectContext;
@end

@implementation ManagedObjectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.saveButton = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                 target:self
                                 action:@selector(save)];
    self.backButton = self.navigationItem.leftBarButtonItem;
    self.cancelButton = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                 target:self
                                 action:@selector(cancel)];
    
//    NSURL *plistURL = [[NSBundle mainBundle] URLForResource:@"HeroDetailConfiguration" withExtension:@"plist"];
//    NSDictionary *plist = [NSDictionary dictionaryWithContentsOfURL:plistURL];
//    self.sections = [plist valueForKey:@"sections"];
    
    //self.config = [[ManagedObjectConfiguration alloc] initWithResource:@"HeroDetailConfiguration"];
    //self.config = [[ManagedObjectConfiguration alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [self.tableView beginUpdates];
    [self updateDynamicSections:editing];
    
    [super setEditing:editing animated:animated];
    //[self.tableView reloadData];

    [self.tableView endUpdates];
    
    self.navigationItem.rightBarButtonItem = (editing) ? self.saveButton : self.editButtonItem;
    self.navigationItem.leftBarButtonItem = (editing) ? self.cancelButton : self.backButton;
}

#pragma mark - (Private) Instance Methods
-(void) save {
    [self setEditing:NO animated:YES];

    for (SuperDBEditCell *cell in [self.tableView visibleCells])
        //[self.hero setValue:[cell value] forKey:[cell key]];
        if([cell isEditable])
            [self.managedObject setValue:[cell value] forKey:[cell key]];
    
    //    NSError *error = nil;
    //    if (![self.managedObject.managedObjectContext save:&error])
    //        NSLog(@"Error saving: %@", [error localizedDescription]);
    
    [self saveManagedObjectContext];
    [self.tableView reloadData];

}

-(void)cancel {
    [self setEditing:NO animated:YES];
}

-(void)updateDynamicSections:(BOOL)editing {
    for (NSInteger section = 0; section < [self.config numberOfSections]; section++){
        if ([self.config isDynamicSection:section]){
            NSIndexPath *indexPath;
            NSInteger row = [self tableView:self.tableView numberOfRowsInSection:section];
            if(editing){
                indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                indexPath = [NSIndexPath indexPathForRow:row-1 inSection:section];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
}

-(void)saveManagedObjectContext {
    NSError *error;
    if (![self.managedObject.managedObjectContext save:&error]) {
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    //return [self.sections count];
    return [self.config numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
//    NSDictionary *sectionDict = [self.sections objectAtIndex:section];
//    NSArray *rows = [sectionDict objectForKey:@"rows"];
//    return rows.count;

    //return [self.config numberOfRowsInSection:section];
    
    NSInteger rowCount = [self.config numberOfRowsInSection:section];
    if([self.config isDynamicSection:section]) {
        NSString *key = [self.config dynamicAttributeKeyForSection:section];
        NSSet *attributeSet = [self.managedObject mutableSetValueForKey:key];
        //rowCount = attributeSet.count;
        rowCount = (self.editing) ? attributeSet.count + 1 : attributeSet.count;
    }
    
    return rowCount;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //NSDictionary *sectionDict = [self.sections objectAtIndex:section];
    //return [sectionDict objectForKey:@"header"];
    
    return [self.config headerInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //static NSString *CellIdentifier = @"HeroDetailCell";
    //    static NSString *CellIdentifier = @"SuperDBEditCell";
    //    SuperDBEditCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
//    NSUInteger sectionIndex = [indexPath section];
//    NSUInteger rowIndex = [indexPath row];
//    NSDictionary *section = [self.sections objectAtIndex:sectionIndex];
//    NSArray *rows = [section objectForKey:@"rows"];
//    NSDictionary *row = [rows objectAtIndex:rowIndex];
//    NSDictionary *row = [self.config rowForIndexPath:indexPath];
    
//    NSString *cellClassName = [row valueForKey:@"class"];
    NSString *cellClassName = [self.config cellClassnameForIndexPath:indexPath];
    SuperDBEditCell *cell = [tableView dequeueReusableCellWithIdentifier:cellClassName];
    
    if (cell == nil){
        Class cellClass = NSClassFromString(cellClassName);
        cell = [cellClass alloc];
        cell = [cell initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellClassName];
    }
    
        //        cell = [[SuperDBEditCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
        //cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    
    
    // Configure the cell...
    //cell.key = [row objectForKey:@"key"];
    //cell.value = [self.hero valueForKey:[row objectForKey:@"key"]];
    cell.key = [self.config attributeKeyForIndexPath:indexPath];
    
    //cell.value = [self.hero valueForKey:[self.config attributeKeyForIndexPath:indexPath]];
    if([self.config isDynamicSection:[indexPath section]]) {
        NSString *key = [self.config attributeKeyForIndexPath:indexPath];
        NSMutableSet *relationshipSet = [self.managedObject mutableSetValueForKey:key];
        NSArray *relationshipArray = [relationshipSet allObjects];
        if([indexPath row] != [relationshipArray count]){
            NSManagedObject *relationshipObject = [relationshipArray objectAtIndex:[indexPath row]];
            cell.value = [relationshipObject valueForKey:@"name"];
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        }
    } else {
        //cell.value = [self.managedObject valueForKey:[self.config attributeKeyForIndexPath:indexPath]];
        NSString *value = [[self.config rowForIndexPath:indexPath] objectForKey:@"value"];
        if(value != nil) {
            cell.value = value;
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        } else
            cell.value = [self.managedObject valueForKey:[self.config attributeKeyForIndexPath:indexPath]];
    }
    
    //TODO://is this to be changed too?
    cell.hero = self.managedObject;
    
    //NSArray *values = [row valueForKey:@"values"];
    NSArray *values = [self.config valuesForIndexPath:indexPath];
    
    if (values != nil) {
        [cell performSelector:@selector(setValues:) withObject:values];
    }
    
    //cell.label.text = [row objectForKey:@"label"];
    cell.label.text = [self.config labelForIndexPath:indexPath];
    
    
    //cell.textLabel.text = [row objectForKey:@"label"];
    //cell.detailTextLabel.text = [self.hero valueForKey:[row objectForKey:@"key"]];
    //cell.detailTextLabel.text = [[self.hero valueForKey:[row objectForKey:@"key"]] description];
    //cell.textField.text = [[self.hero valueForKey:[row objectForKey:@"key"]] description];
    
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
    
    //NSString *key = [self.config attributeKeyForIndexPath:indexPath];
    //NSMutableSet *relationshipSet = [self.managedObject mutableSetValueForKey:key];
    //NSManagedObjectContext *managedObjectContext = [self.managedObject managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //NSManagedObject *relationshipObject = [[relationshipSet allObjects] objectAtIndex:[indexPath row]];
        //[relationshipSet removeObject:relationshipObject];
        } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        //NSEntityDescription *entity = [self.managedObject entity];
        //NSDictionary *relationships = [entity relationshipsByName];
        //NSRelationshipDescription *destRelationship = [relationships objectForKey:key];
        //NSEntityDescription *destEntity = [destRelationship destinationEntity];
        //NSManagedObject *relationshipObject = [NSEntityDescription insertNewObjectForEntityForName:[destEntity name] inManagedObjectContext:managedObjectContext];
        //[relationshipSet addObject:relationshipObject];
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    
    //NSError *error = nil;
    //if (![managedObjectContext save:&error]){
    //    //ShowAlert
    //    NSLog(@"Error occurred");
    //}
    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
    
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


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //return UITableViewCellEditingStyleNone;
    UITableViewCellEditingStyle editStyle = UITableViewCellEditingStyleNone;
    NSInteger section = [indexPath section];
    if ([self.config isDynamicSection:section]) {
        NSInteger rowCount = [self tableView:self.tableView numberOfRowsInSection:section];
        if([indexPath row] == rowCount - 1)
            editStyle = UITableViewCellEditingStyleInsert;
        else
            editStyle = UITableViewCellEditingStyleDelete;
    }
    return editStyle;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Instance Methods

-(NSManagedObject *) addRelationshipObjectForSection:(NSInteger)section{
    NSString *key = [self.config dynamicAttributeKeyForSection:section];
    NSMutableSet *relationshipSet = [self.managedObject mutableSetValueForKey:key];
    
    NSEntityDescription *entity = [self.managedObject entity];
    NSDictionary *relationships = [entity relationshipsByName];
    NSRelationshipDescription *destRelationship = [relationships objectForKey:key];
    NSEntityDescription *destEntity = [destRelationship destinationEntity];
    
    NSManagedObject *relationshipObject = [NSEntityDescription insertNewObjectForEntityForName:[destEntity name] inManagedObjectContext:self.managedObject.managedObjectContext];
    [relationshipSet addObject:relationshipObject];
    [self saveManagedObjectContext];
    return relationshipObject;
}

-(void)removeRelationshipObjectInIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [self.config dynamicAttributeKeyForSection:[indexPath section]];
    NSMutableSet *relationshipSet = [self.managedObject mutableSetValueForKey:key];
    NSManagedObject *relationshipObject = [[relationshipSet allObjects] objectAtIndex:[indexPath row]];
    [relationshipSet removeObject:relationshipObject];
    [self saveManagedObjectContext];
}


@end
