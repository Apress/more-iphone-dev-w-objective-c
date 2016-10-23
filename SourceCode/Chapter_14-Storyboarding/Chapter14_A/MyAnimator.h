//
//  MyAnimator.h
//  Chapter14_A
//
//  Created by Jayant Varma on 11/04/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic) BOOL presenting;
@end

