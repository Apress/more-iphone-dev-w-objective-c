//
//  BasicControl.h
//  Chapter14_A
//
//  Created by Jayant Varma on 10/04/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface BasicControl : UIView
//@property (nonatomic, strong) IBInspectable NSString *text;
//@property (nonatomic) IBInspectable int secretID;


//@property (nonatomic, strong) CAShapeLayer *shape;
//@property (nonatomic, strong) CAGradientLayer *gradient;
@property (nonatomic) IBInspectable CGFloat value;
@property (nonatomic) IBInspectable BOOL useFlatColor;
@property (nonatomic, strong) IBInspectable UIColor *theColor;
@end

CAShapeLayer *shape;
CAGradientLayer *gradient;
