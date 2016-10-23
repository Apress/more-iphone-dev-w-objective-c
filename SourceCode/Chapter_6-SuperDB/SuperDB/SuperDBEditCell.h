//
//  SuperDBEditCell.h
//  SuperDB
//
//  Created by Jayant Varma on 8/03/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "SuperDBCell.h"

@interface SuperDBEditCell : SuperDBCell <UITextFieldDelegate>
//@property (strong, nonatomic) UILabel *label;
//@property (strong, nonatomic) UITextField *textField;
//
//@property (strong, nonatomic) NSString *key;
//@property (strong, nonatomic) id value;
//
//@property (strong, nonatomic) NSManagedObject *hero;

-(IBAction)validate;
@end
