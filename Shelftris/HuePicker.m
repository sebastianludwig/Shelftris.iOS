//
//  HuePicker.m
//  Shelftris
//
//  Created by Sebastian Ludwig on 26.05.14.
//  Copyright (c) 2014 Sebastian Ludwig. All rights reserved.
//

#import "HuePicker.h"

#import <QuartzCore/QuartzCore.h>
#import "UIColor+Additions.h"
#import "SpinGestureRecognizer.h"

#define M_PI_3    M_PI/3

@interface HuePicker()

@property (nonatomic) CGFloat rotationAngle;

@end

@implementation HuePicker
{
	CGFloat gradientStartAngle;
	CGFloat gradientEndAngle;
	NSArray *gradientColors;
}

#pragma mark -
#pragma mark UIView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[self setupView];
    }
    return self;
}

- (void)awakeFromNib {
	[self setupView];
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
	
	CGRect frame = UIEdgeInsetsInsetRect(self.bounds, self.insets);
	
	CGFloat maxRadius = -1 + MIN(frame.size.width, frame.size.height) / 2;
	CGFloat internalRadius = maxRadius - self.donutThickness + 2;
	CGPoint center = CGPointMake(floorf(0.5 + CGRectGetMidX(frame)), floorf(0.5 + CGRectGetMidY(frame)));
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGMutablePathRef path = CGPathCreateMutable();
	CGContextSaveGState(context);
	{
		// the donut is reduced by 1 at both diameters because to clip op includes the path thickness
		CGPathAddRelativeArc(path, NULL, center.x, center.y, maxRadius - 1, 0, 2 * M_PI);
		CGPathMoveToPoint(path, NULL, center.x + internalRadius, center.y);
		CGPathAddRelativeArc(path, NULL, center.x, center.y, internalRadius + 1, 0, 2 * M_PI);
		
		CGContextAddPath(context, path);
		CGPathRelease(path);
		
		CGContextEOClip(context);
		
		[self drawGradientWithCenter:center radius:maxRadius context:context];
	}
	CGContextRestoreGState(context);
	
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.80 alpha:0.45] .CGColor);
	CGContextSetLineWidth(context, 2);
	
	path = CGPathCreateMutable();
	CGPathAddRelativeArc(path, NULL, center.x, center.y, maxRadius, 0, 2 * M_PI);
	CGPathMoveToPoint(path, NULL, center.x + internalRadius, center.y);
	CGPathAddRelativeArc(path, NULL, center.x, center.y, internalRadius, 0, 2 * M_PI);
	CGContextAddPath(context, path);
	CGContextStrokePath(context);
	CGPathRelease(path);
	
	self.layer.transform = CATransform3DMakeRotation(self.rotationAngle, 0, 0, 1);
}

#pragma mark -
#pragma mark HuePicker

#pragma mark properties

- (void)setDonutThickness:(CGFloat)donutThickness
{
	_donutThickness = donutThickness;
	[self setNeedsDisplay];
}

- (UIColor *)color
{
	return [UIColor colorWithHue:self.hue saturation:1 brightness:self.brightness alpha:1];
}

- (void)setColor:(UIColor *)color
{
	CGFloat hue, brightness;
	BOOL success = [color getHue:&hue saturation:nil brightness:&brightness alpha:nil];
	
	if (!success) {
		return;
	}
	
	self.hue = hue;
	self.brightness = brightness;
}

- (void)setBrightness:(CGFloat)brightness
{
	_brightness = brightness;
	[self setNeedsDisplay];
}

#pragma mark private methods

- (void)setupView
{
	self.rotationAngle = 0;
	self.brightness = 1;
	
	gradientStartAngle = -M_PI_2;
	gradientEndAngle = 2 * M_PI - M_PI_2;
	
	gradientColors = @[
					   [UIColor colorWithHue:0.0001f saturation:1 brightness:1 alpha:1],
					   [UIColor colorWithHue:0.9999f saturation:1 brightness:1 alpha:1]
					   ];
	
	
	self.donutThickness = 50;
	self.color = [UIColor colorWithHue:0 saturation:1 brightness:1 alpha:1];
	
	SpinGestureRecognizer *spinRecognizer = [[SpinGestureRecognizer alloc] initWithSpinView:self target:self action:@selector(handleSpin:)];
	[self addGestureRecognizer:spinRecognizer];
}

- (void)setRotationAngle:(CGFloat)rotationAngle
{
	_rotationAngle = rotationAngle;
	[self setNeedsDisplay];
	[self.delegate huePicker:self didSelectHue:self.hue];
}

- (void)setHue:(CGFloat)hue
{
	self.rotationAngle = -hue * 2 * M_PI;
	[self setNeedsDisplay];
}

- (CGFloat)hue
{
	CGFloat modAngle = fmodf(-self.rotationAngle, 2 * M_PI);
	modAngle = fmodf(modAngle + 2 * M_PI, 2 * M_PI);
	return modAngle / (2 * M_PI);
}

#pragma mark gradient drawing

- (UIColor *)interpolateFromColor:(UIColor *)startColor to:(UIColor *)endColor at:(CGFloat)percent
{
	CGFloat startHue, endHue;
	if (![startColor getHue:&startHue saturation:nil brightness:nil alpha:nil]) {
		return nil;
	}
	if (![endColor getHue:&endHue saturation:nil brightness:nil alpha:nil]) {
		return nil;
	}
	CGFloat interpolatedHue = startHue + ((endHue - startHue) * percent);
	
	return [UIColor colorWithHue:interpolatedHue saturation:1 brightness:self.brightness alpha:1];
}

- (void)drawGradientWithCenter:(CGPoint)center radius:(CGFloat)radius context:(CGContextRef)context
{
	CGContextSetAllowsAntialiasing(context, false);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextSetFillColorSpace(context, colorSpace);
	
	UIColor *startColor = gradientColors[0];
	CGFloat positionStartAngle = gradientStartAngle;
	CGPoint prev =  CGPointMake(center.x + cosf(positionStartAngle) * radius, center.y + sinf(positionStartAngle) * radius);
	CGPoint part[3];
	CGPoint dest;
	
	for (int i = 1; i < [gradientColors count]; i++) {
		UIColor *endColor = gradientColors[i];
		
		CGFloat positionEndAngle = gradientStartAngle + ((gradientEndAngle - gradientStartAngle) * i);
		
		CGFloat angle;
		for (angle = positionStartAngle; angle <= positionEndAngle; angle += (positionEndAngle - positionStartAngle) / 300 ) {
			
			dest = CGPointMake(center.x + cosf(angle) * radius, center.y + sinf(angle) * radius);
			
			CGFloat progress = (angle - positionStartAngle) / (positionEndAngle - positionStartAngle);

			UIColor* interpolatedColor = [self interpolateFromColor:startColor to:endColor at:progress];
			CGContextSetFillColorWithColor(context, interpolatedColor.CGColor);
			CGContextSetStrokeColorWithColor(context, interpolatedColor.CGColor);
			
			part[0] = center;
			part[1] = prev;
			part[2] = dest;
			
			CGContextAddLines(context, part, 3);
			CGContextFillPath(context);
			prev = dest;
		}
		
		positionStartAngle = angle;
		startColor = endColor;
	}
	
	
	dest = CGPointMake(center.x + cosf(gradientStartAngle) * radius, center.y + sinf(gradientStartAngle) * radius);
	part[0] = center;
	part[1] = prev;
	part[2] = dest;
	CGContextAddLines(context, part, 3);
	CGContextFillPath(context);
	
	CGColorSpaceRelease(colorSpace);
	
	CGContextSetAllowsAntialiasing(context, true);
}

#pragma mark - Gesture recognizer

- (void)handleSpin:(SpinGestureRecognizer *)spinRecognizer {
	self.rotationAngle += spinRecognizer.angle;
}

@end