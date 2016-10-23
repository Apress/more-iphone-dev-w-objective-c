//
//  SuperDBEditCell.m
//  SuperDB
//
//  Created by Jayant Varma on 8/03/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import "SuperDBEditCell.h"

static NSDictionary *__CoreDataErrors;

@implementation SuperDBEditCell

+(void)initialize{
    NSURL *pListURL = [[NSBundle mainBundle] URLForResource:@"CoreDataErrors" withExtension:@"plist"];
    __CoreDataErrors = [NSDictionary dictionaryWithContentsOfURL:pListURL];
}

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        //Initialization code
        self.textField.delegate = self;
    }
    return self;
}

-(IBAction)validate {
    id val = self.value;
    NSError *error;
    if (![self.hero validateValue:&val forKey:self.key error:&error]) {
        NSString *message = nil;

    //        if ([[error domain] isEqualToString:@"NSCocoaErrorDomain"]) {
    //            NSDictionary *userInfo = [error userInfo];
    //            message = [NSString stringWithFormat:NSLocalizedString(@"Validation error on: %@\rFailure Reason: %@", @"Validation error on: %@\rFailure Reason: %@"), [userInfo valueForKey:@"NSValidationErrorKey"], [error localizedFailureReason]];
    //
        if ([[error domain] isEqualToString:@"NSCocoaErrorDomain"]) {
            NSString *errorCodeStr = [NSString stringWithFormat:@"%ld", (long)[error code]];
            NSString *errorMessage = [__CoreDataErrors valueForKey:errorCodeStr];
            NSDictionary *userInfo = [error userInfo];
            message = [NSString
                       stringWithFormat:NSLocalizedString(@"Validation Error on:%@\rFailure Reason:%@",
                                                          @"Validation Error on:%@\rFailure Reason:%@"),
                       [userInfo valueForKey:@"NSValidationErrorKey"],
                       errorMessage];
        } else {
            message = [error localizedDescription];
        }
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:NSLocalizedString(@"Validation Error",
                                                                                   @"Validation Error")
                                        message:message
                                        preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *buttonCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self setValue:[self.hero valueForKey:self.key]];
            }];
            UIAlertAction *buttonFix = [UIAlertAction actionWithTitle:NSLocalizedString(@"Fix", @"Fix") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self.textField becomeFirstResponder];
            }];
            [alert addAction:buttonCancel];
            [alert addAction:buttonFix];
            
            [[[[[UIApplication sharedApplication]delegate]window]rootViewController] presentViewController:alert animated:YES completion:nil];
    }
}


#pragma mark - UITextFieldDelegate methods

-(void) textFieldDidEndEditing:(UITextField *)textField {
    [self validate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


#pragma mark - Instance Methods

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    self.textField.enabled = editing;
}

#pragma mark - SuperDBCell Overrides

-(BOOL) isEditable {
    return YES;
}

@end
