//
//  BasicControl.m
//  Chapter14_A
//
//  Created by Jayant Varma on 10/04/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import "BasicControl.h"
@import QuartzCore;


#define midX(A) (A.size.width/2)
#define midY(A) (A.size.height/2)

@implementation BasicControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    
    NSLog(@"Init with coder...");
    [self initializeDefaults];
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self){
        self.frame = frame;
    }
    [self initializeDefaults];
    NSLog(@"Init with frame...");
    return self;
}

-(void) initializeDefaults {
}


-(void)prepareForInterfaceBuilder{
    //
}

-(void)layoutSubviews {
    
    [super layoutSubviews];

    if (!shape) {
        shape = [CAShapeLayer layer];
        [self.layer addSublayer:shape];
        [shape setBackgroundColor:_theColor.CGColor];
        [shape setMasksToBounds:YES];
    }
    
    if (!gradient) {
        gradient = [CAGradientLayer layer];
        [self.layer addSublayer:gradient];
        
        UIColor *red = [UIColor redColor];
        UIColor *blue = [UIColor blueColor];
        NSArray *colors = [NSArray arrayWithObjects:(id)red.CGColor, (id)blue.CGColor, nil];
        
        [gradient setColors:colors];
        [gradient setBackgroundColor:_theColor.CGColor];
        [gradient setMasksToBounds:YES];
    }
    
    CGRect frame = self.bounds;
    CGFloat x = MAX( midX(frame) , frame.size.width - midX(frame));
    CGFloat y = MAX( midY(frame), frame.size.height - midY(frame));
    CGFloat radius = sqrt(x*x + y*y) * _value;

    frame = CGRectMake(midX(self.frame) - radius, midY(self.frame) - radius, radius * 2, radius * 2);
    CGRect bounds = frame;
    
    [CATransaction begin];
    //[CATransaction setAnimationDuration:0];
    //[CATransaction setDisableActions:YES];
    
    if (_value < 0){
        shape.hidden = YES;
        gradient.hidden = YES;
    } else {
        shape.hidden = NO;
        gradient.hidden = (_useFlatColor == YES);
    }
    
    if (shape) {
        [shape setCornerRadius:radius];
        [shape setFrame:frame];
        [shape setBounds:bounds];        
    }
    
    if(gradient) {
        gradient.cornerRadius = shape.cornerRadius;
        gradient.frame = shape.frame;
        gradient.bounds = shape.bounds;
    }
    
    [CATransaction commit];
    
    self.clipsToBounds = YES;
    
    
//    NSLog(@"Value (layout) = %f\n", _value);
//    
//    CGRect frame = self.frame;
//
//    CGFloat x = MAX( midX(frame) , frame.size.width - midX(frame));
//    CGFloat y = MAX( midY(frame), frame.size.height - midY(frame));
//    CGFloat radius = sqrt(x*x + y*y) * _value;
//
//    CGRect bounds = frame;
//
//    frame = CGRectMake(midX(self.frame) - radius, midY(self.frame) - radius, radius * 2, radius * 2);
//    bounds = frame;
//
//    //Do the initialization here
//    if (!self.shape) {
//        self.shape = [[CAShapeLayer alloc]init];
//        [self.layer addSublayer:self.shape];
//        [self.shape setBackgroundColor: _theColor.CGColor];
//    }
//    
//    if (!gradient) {
//        gradient = [CAGradientLayer layer];
//        [self.layer addSublayer:gradient];
//        
//        UIColor *red = [UIColor redColor];
//        UIColor *blue = [UIColor blueColor];
//        NSArray *colors = [NSArray arrayWithObjects:(id)red.CGColor, (id)blue.CGColor, nil];
//        gradient.colors = colors;
//    }
//    
//    //self.layer.masksToBounds = YES;
//    self.clipsToBounds = YES;
//
//    
//    if(shape) {
//        
//        [shape setCornerRadius:radius];
//        //[shape setMasksToBounds:YES];
//        
//        [shape setFrame: frame];
//        [shape setBounds: bounds];
//        
//        shape.backgroundColor = _theColor.CGColor;
//        
//        shape.shadowColor = [UIColor blackColor].CGColor;
//        shape.shadowOpacity = 0.3;
//        shape.shadowOffset = CGSizeMake(3, -3);
//        shape.shadowRadius = 2.5;
//    }
//
//    
//    if(gradient) {
//        UIColor *red = [UIColor redColor];
//        UIColor *blue = [UIColor blueColor];
//        NSArray *colors = [NSArray arrayWithObjects:(id)red.CGColor, (id)blue.CGColor, nil];
//        
//        gradient.colors = colors;
//
//        [gradient setFrame: frame];
//        [gradient setBounds: bounds];
//        [gradient setCornerRadius:radius];
//        [gradient setMasksToBounds:YES];
//    }
//
//    if (_useFlatColor == YES) {
//        gradient.hidden = YES;
//    }else{
//        gradient.hidden = NO;
//    }
}


-(void)setUseFlatColor:(BOOL)useFlatColor {
    _useFlatColor = useFlatColor;
    gradient.hidden = (useFlatColor == YES);
}

-(void) setValue:(CGFloat)value{
    _value = value;
    [self layoutSubviews];
}

@end


