//
//  MyAnimator.m
//  Chapter14_A
//
//  Created by Jayant Varma on 11/04/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import "MyAnimator.h"

@implementation MyAnimator


-(NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect endFrame = [[UIScreen mainScreen] bounds];
    
    if (_presenting == YES){
        [fromView.view setUserInteractionEnabled:NO];
        
        [[transitionContext containerView] addSubview:fromView.view];
        [[transitionContext containerView] addSubview:toView.view];
        
        CGRect startFrame = endFrame;
        startFrame.origin.x += 320;
        
        [toView.view setFrame:startFrame];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             [fromView.view setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
                             [toView.view setFrame:endFrame];
                             [fromView.view setAlpha:0];
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
    } else {
        [toView.view setUserInteractionEnabled:YES];
        
        [[transitionContext containerView] addSubview:toView.view];
        [[transitionContext containerView]addSubview:fromView.view];
        
        endFrame.origin.x += 320;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             [toView.view setTintAdjustmentMode:UIViewTintAdjustmentModeAutomatic];
                             [fromView.view setFrame:endFrame];
                             [toView.view setAlpha:1];
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }
         ];
    }
    
}


-(void) dummy {
}

@end
