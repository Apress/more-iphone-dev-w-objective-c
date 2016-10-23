//
//  ViewController.h
//  Chapter14_A
//
//  Created by Jayant Varma on 10/04/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "frmCustomScene.h"
#import "BasicControl.h"
#import "MyAnimator.h"

@interface ViewController : UIViewController <UIViewControllerTransitioningDelegate>
@property IBOutlet BasicControl *theControl;
@end

