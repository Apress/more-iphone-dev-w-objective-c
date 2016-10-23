//
//  SuperDBCell.h
//  
//
//  Created by Jayant Varma on 8/03/2015.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface SuperDBCell : UITableViewCell
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UITextField *textField;

@property(strong, nonatomic) NSString *key;
@property(strong, nonatomic) id value;

@property(strong, nonatomic) NSManagedObject *hero;

-(BOOL)isEditable;
@end
