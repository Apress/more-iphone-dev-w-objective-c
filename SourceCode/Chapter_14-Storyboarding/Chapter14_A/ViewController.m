//
//  ViewController.m
//  Chapter14_A
//
//  Created by Jayant Varma on 10/04/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"

@interface ViewController ()

@end

@implementation ViewController

UITapGestureRecognizer *tap;
bool presenting = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //frmCustomScene *tmpForm = [story instantiateViewControllerWithIdentifier:@"frmCustomScene"];
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer: tap];
}

-(void)tap:(id)sender{
    _theControl.value += 0.05;
    if (_theControl.value > 1)
        _theControl.value = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailViewController *dest = [segue destinationViewController];
    [dest setTheText:@"This is not sparta, Mate!"];
    [dest setHideButton:YES];
}

-(IBAction)displayAnimated:(id)sender{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *newVC = [story instantiateViewControllerWithIdentifier:@"sparta"];
    
    newVC.transitioningDelegate = self;
    newVC.modalPresentationStyle = UIModalPresentationCustom;

    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    newVC.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self presentViewController:newVC animated:YES completion:nil];
}

-(id <UIViewControllerAnimatedTransitioning>) animationControllerForDismissedController:(UIViewController *)dismissed {
    MyAnimator *animator = [[MyAnimator alloc]init];
    return animator;
}


-(id <UIViewControllerAnimatedTransitioning>) animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    MyAnimator *animator = [[MyAnimator alloc]init];
    animator.presenting = YES;
    return animator;
}

@end
