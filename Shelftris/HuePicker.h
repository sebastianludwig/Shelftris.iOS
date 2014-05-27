//
//  HuePicker.h
//  Shelftris
//
//  Created by Sebastian Ludwig on 26.05.14.
//  Copyright (c) 2014 Sebastian Ludwig. All rights reserved.
//

@class HuePicker;

@protocol HuePickerDelegate <NSObject>

-(void)HuePicker:(HuePicker *)view didSelectHue:(CGFloat *)hue;

@end

@interface HuePicker : UIView

@property (nonatomic, weak) id<HuePickerDelegate> delegate;

@property UIEdgeInsets insets;
@property (nonatomic) UIColor *color;
@property (nonatomic) CGFloat brightness;
@property (nonatomic) CGFloat donutThickness;

@end
