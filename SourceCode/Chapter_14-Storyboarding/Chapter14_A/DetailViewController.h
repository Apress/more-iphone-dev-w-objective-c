//
//  DetailViewController.h
//  Chapter14_A
//
//  Created by Jayant Varma on 11/04/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property IBOutlet UILabel *theLabel;
@property (nonatomic, strong) NSString *theText;
@property (nonatomic) BOOL hideButton;
@end
