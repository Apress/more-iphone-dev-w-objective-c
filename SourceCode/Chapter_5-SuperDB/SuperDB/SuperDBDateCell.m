//
//  SuperDBDateCell.m
//  SuperDB
//
//  Created by Jayant Varma on 8/03/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import "SuperDBDateCell.h"

static NSDateFormatter *__dateFormatter = nil;

@interface SuperDBDateCell ()
@property (strong, nonatomic) UIDatePicker *datePicker;
-(IBAction)datePickerChanged:(id)sender;
@end

@implementation SuperDBDateCell

+(void)initialize {
    __dateFormatter = [[NSDateFormatter alloc] init];
    [__dateFormatter setDateStyle:NSDateFormatterMediumStyle];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        // Initialization Code
        self.textField.clearButtonMode = UITextFieldViewModeNever;
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        [self.datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
        self.textField.inputView = _datePicker;
    }
    return self;
}

#pragma mark - SuperDBEditCell Overrides
-(id)value {
    if(self.textField.text == nil || [self.textField.text length] == 0)
        return nil;
    return self.datePicker.date;
}

-(void)setValue:(id)value {
    if (value != nil && [value isKindOfClass:[NSDate class]]) {
        self.textField.text = [__dateFormatter stringFromDate:value];
    } else {
        self.textField.text = nil;
    }
}

#pragma mark - (Private) Instance Methods

-(IBAction)datePickerChanged:(id)sender {
    NSDate *date = [self.datePicker date];
    self.value = date;
    self.textField.text = [__dateFormatter stringFromDate:date];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
