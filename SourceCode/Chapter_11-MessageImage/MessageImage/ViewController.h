//
//  ViewController.h
//  MessageImage
//
//  Created by Jayant Varma on 28/02/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIImage *image;

-(IBAction)selectAndSendMessage:(id)sender;
-(void)showActivityViewController;

@end

