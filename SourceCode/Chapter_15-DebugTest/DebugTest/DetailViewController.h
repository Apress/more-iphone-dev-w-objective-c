//
//  DetailViewController.h
//  DebugTest
//
//  Created by Jayant Varma on 28/11/2014.
//  Copyright (c) 2014 OZ Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

