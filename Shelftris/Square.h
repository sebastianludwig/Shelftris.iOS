//
//  Square.h
//  Shelftris
//
//  Created by Sebastian Ludwig on 28.05.14.
//  Copyright (c) 2014 Sebastian Ludwig. All rights reserved.
//

@interface Square : UIView

@property (nonatomic) UIColor *baseColor;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) UIColor *borderColor;

- (id)initWithFrame:(CGRect)frame baseColor:(UIColor *)baseColor;

+ (void)drawSqureInRect:(CGRect)rect withBaseColor:(UIColor *)baseColor inContext:(CGContextRef)context;

@end
