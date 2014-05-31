//
//  GradientPicker.h
//  Shelftris
//
//  Created by Sebastian Ludwig on 31.05.14.
//  Copyright (c) 2014 Sebastian Ludwig. All rights reserved.
//

@class GradientPicker;

@protocol GradientPickerDelegate <NSObject>

- (void)gradientPicker:(GradientPicker *)gradientPicker didSelectValue:(CGFloat)value;

@end

@interface GradientPicker : UIView

@property (nonatomic, weak) IBOutlet id<GradientPickerDelegate> delegate;

@property (nonatomic) UIColor *startColor;
@property (nonatomic) UIColor *endColor;
@property (nonatomic) CGFloat value;

- (void)setStartColor:(UIColor *)startColor endColor:(UIColor *)endColor;

@end
