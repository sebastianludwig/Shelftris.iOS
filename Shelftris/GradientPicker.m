//
//  GradientPicker.m
//  Shelftris
//
//  Created by Sebastian Ludwig on 31.05.14.
//  Copyright (c) 2014 Sebastian Ludwig. All rights reserved.
//

#import "GradientPicker.h"

@implementation GradientPicker
{
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setupView];
    }
    return self;
}

- (void)awakeFromNib
{
	[self setupView];
}

- (void)setupView
{
	self.backgroundColor = [UIColor clearColor];
	self.startColor = [UIColor clearColor];
	self.endColor = [UIColor clearColor];
	self.value = 1;
	
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateValue:)];
	[self addGestureRecognizer:tapRecognizer];
	
	UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(updateValue:)];
	[self addGestureRecognizer:panRecognizer];
}

- (void)setStartColor:(UIColor *)startColor
{
	_startColor = startColor;
	[self setNeedsDisplay];
}

- (void)setEndColor:(UIColor *)endColor
{
	_endColor = endColor;
	[self setNeedsDisplay];
}

- (void)setStartColor:(UIColor *)startColor endColor:(UIColor *)endColor
{
	self.startColor = startColor;
	self.endColor = endColor;
}

- (void)setValue:(CGFloat)value
{
	_value = MAX(0.001, MIN(1, value));
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
	
	float indicatorHeight = 20;
	float indicatorLineWidth = 3;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	CGContextSaveGState(context);
	CGContextAddRect(context, CGRectInset(self.bounds, indicatorLineWidth, 0));
	CGContextClip(context);

	NSArray *colors = @[(__bridge id)self.startColor.CGColor, (__bridge id)self.endColor.CGColor];
	CGFloat locations[] = { 0.0, 1.0 };
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
	
	CGContextDrawLinearGradient(context, gradient, CGPointMake(0, self.bounds.size.height), CGPointMake(0, 0), 0);
	CGContextRestoreGState(context);
	
	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorSpace);
	
	// indicator
	[[UIColor whiteColor] setStroke];
	CGRect indicatorRect = CGRectMake(0, (1 - _value) * self.bounds.size.height, self.bounds.size.width, indicatorHeight);
	indicatorRect = CGRectInset(indicatorRect, indicatorLineWidth / 2, indicatorLineWidth / 2);
	indicatorRect.origin.y = MAX(0, MIN(self.bounds.size.height - indicatorRect.size.height - indicatorLineWidth / 2, indicatorRect.origin.y));
	indicatorRect = CGRectIntegral(indicatorRect);
	UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:indicatorRect cornerRadius:4];
	roundedRect.lineWidth = indicatorLineWidth;
	[roundedRect strokeWithBlendMode:kCGBlendModeNormal alpha:1];
}

#pragma mark actions

- (void)updateValue:(UIGestureRecognizer *)recognizer
{
	self.value = 1 - [recognizer locationInView:self].y / self.bounds.size.height;
	[self.delegate gradientPicker:self didSelectValue:self.value];
}

@end
