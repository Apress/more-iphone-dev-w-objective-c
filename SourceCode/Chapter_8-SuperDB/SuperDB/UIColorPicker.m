//
//  UIColorPicker.m
//  SuperDB
//
//  Created by Jayant Varma on 8/03/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//

#import "UIColorPicker.h"
#import <QuartzCore/CAGradientLayer.h>

#define kTopBackgroundColor [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0]
#define kBottomBackgroundColor [UIColor colorWithRed:0.79 green:0.79 blue:0.79 alpha:1.0]


@interface UIColorPicker ()
@property(strong, nonatomic) UISlider *redSlider;
@property(strong, nonatomic) UISlider *greenSlider;
@property(strong, nonatomic) UISlider *blueSlider;
@property(strong, nonatomic) UISlider *alphaSlider;
-(IBAction)sliderChanged:(id)sender;
-(UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text;

-(UISlider *)createSliderWithAction:(CGRect) frame function:(SEL) theFunc;
@end

@implementation UIColorPicker

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self labelWithFrame:CGRectMake(20, 40, 60, 24) text:@"Red"];
        [self labelWithFrame:CGRectMake(20, 80, 60, 24) text:@"Green"];
        [self labelWithFrame:CGRectMake(20, 120, 60, 24) text:@"Blue"];
        [self labelWithFrame:CGRectMake(20, 160, 60, 24) text:@"Alpha"];
        
        SEL theFunc = @selector(sliderChanged:);
        
        self.redSlider = [self createSliderWithAction:CGRectMake(100, 40, 190, 24) function:theFunc];
        self.greenSlider = [self createSliderWithAction:CGRectMake(100, 80, 190, 24) function:theFunc];
        self.blueSlider = [self createSliderWithAction:CGRectMake(100, 120, 190, 24) function:theFunc];
        self.alphaSlider = [self createSliderWithAction:CGRectMake(100, 160, 190, 24) function:theFunc];
    }
    return self;
}

-(UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    
    [label setUserInteractionEnabled:NO];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
    [label setTextAlignment:NSTextAlignmentRight];
    [label setTextColor:[UIColor darkTextColor]];
    [label setText:text];
    [self addSubview:label];
    
    return label;
}

-(UISlider *) createSliderWithAction:(CGRect)frame function:(SEL)theFunc {
    UISlider *slider = [[UISlider alloc]initWithFrame:frame];
    [slider addTarget:self action:theFunc forControlEvents:UIControlEventValueChanged];
    [self addSubview:slider];
    return slider;
}

#pragma mark - Property Overrides
-(void)setColor:(UIColor *)color {
    _color = color;
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    [_redSlider setValue:components[0]];
    [_greenSlider setValue:components[1]];
    [_blueSlider setValue:components[2]];
    [_alphaSlider setValue:components[3]];
}

#pragma mark - (Private) Instance Methods

-(IBAction)sliderChanged:(id)sender{
    _color = [UIColor colorWithRed:_redSlider.value green:_greenSlider.value blue:_blueSlider.value alpha:_alphaSlider.value];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [NSArray arrayWithObjects:(__bridge id)[kTopBackgroundColor CGColor],
                       (__bridge id)[kBottomBackgroundColor CGColor], nil];
    [self.layer insertSublayer:gradient atIndex:0];
}

@end
