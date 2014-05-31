//
//  HuePicker.h
//  Shelftris
//
//  Created by Sebastian Ludwig on 26.05.14.
//  Copyright (c) 2014 Sebastian Ludwig. All rights reserved.
//

@class HuePicker;

@protocol HuePickerDelegate <NSObject>

- (void)huePicker:(HuePicker *)huePicker didSelectHue:(CGFloat)hue;

@end

@interface HuePicker : UIView

@property (nonatomic, weak) id<HuePickerDelegate> delegate;

@property UIEdgeInsets insets;
@property (nonatomic) CGFloat donutThickness;
@property (nonatomic) UIColor *color;
@property (nonatomic) CGFloat hue;

@end
