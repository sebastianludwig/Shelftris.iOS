//
//  Square.m
//  Shelftris
//
//  Created by Sebastian Ludwig on 28.05.14.
//  Copyright (c) 2014 Sebastian Ludwig. All rights reserved.
//

#import "Square.h"

@implementation Square

- (id)initWithFrame:(CGRect)frame baseColor:(UIColor *)baseColor
{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
        self.baseColor = baseColor;
    }
    return self;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
	_borderWidth = borderWidth;
	[self setNeedsDisplay];
}

- (void)setBorderColor:(UIColor *)borderColor
{
	_borderColor = borderColor;
	[self setNeedsDisplay];
}

- (void)setBaseColor:(UIColor *)baseColor
{
	_baseColor = baseColor;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[self.borderColor setStroke];
	CGContextStrokeRectWithWidth(context, self.bounds, 2 * self.borderWidth);
	
	CGRect squareRect = CGRectInset(self.bounds, self.borderWidth, self.borderWidth);
	[Square drawSqureInRect:squareRect withBaseColor:self.baseColor inContext:context];
}

+ (void)drawSqureInRect:(CGRect)rect withBaseColor:(UIColor *)baseColor inContext:(CGContextRef)context
{
	CGFloat baseHue, baseSaturation, baseBrightness, baseAlpha;
	if (![baseColor getHue:&baseHue saturation:&baseSaturation brightness:&baseBrightness alpha:&baseAlpha]) {
		return;
	}
	
	rect = CGRectIntegral(rect);
	
	CGFloat inset = rect.size.width / 8.0;
	CGRect centerRect = CGRectInset(rect, inset, inset);
	centerRect = CGRectIntegral(centerRect);
		
	CGContextFillRect(context, rect);
	
	CGContextSaveGState(context);
	{
		CGMutablePathRef path = CGPathCreateMutable();
		CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y);
		CGPathAddLineToPoint(path, NULL, rect.origin.x, CGRectGetMaxY(rect));
		CGPathAddLineToPoint(path, NULL, centerRect.origin.x, CGRectGetMaxY(centerRect));
		CGPathAddLineToPoint(path, NULL, centerRect.origin.x, centerRect.origin.y);
		
		UIColor *sideColor = [UIColor colorWithHue:baseHue saturation:baseSaturation brightness:(baseBrightness - 0.1) alpha:baseAlpha];
		CGContextSetFillColorWithColor(context, [sideColor CGColor]);
		CGContextAddPath(context, path);
		CGContextFillPath(context);
		CGPathRelease(path);
	}
	CGContextRestoreGState(context);
	
	CGContextSaveGState(context);
	{
		CGMutablePathRef path = CGPathCreateMutable();
		CGPathMoveToPoint(path, NULL, CGRectGetMaxX(rect), rect.origin.y);
		CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
		CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(centerRect), CGRectGetMaxY(centerRect));
		CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(centerRect), centerRect.origin.y);
		
		UIColor *sideColor = [UIColor colorWithHue:baseHue saturation:baseSaturation brightness:(baseBrightness - 0.1) alpha:baseAlpha];
		CGContextSetFillColorWithColor(context, [sideColor CGColor]);
		CGContextAddPath(context, path);
		CGContextFillPath(context);
		CGPathRelease(path);
	}
	CGContextRestoreGState(context);
		
	CGContextSaveGState(context);
	{
		CGMutablePathRef path = CGPathCreateMutable();
		CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y);
		CGPathAddLineToPoint(path, NULL, centerRect.origin.x, centerRect.origin.y);
		CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(centerRect), centerRect.origin.y);
		CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), rect.origin.y);
		CGContextAddPath(context, path);
		UIColor *topColor = [UIColor colorWithHue:baseHue saturation:(baseSaturation - 0.4) brightness:baseBrightness alpha:baseAlpha];
		CGContextSetFillColorWithColor(context, [topColor CGColor]);
		CGContextFillPath(context);
		CGPathRelease(path);
	}
	CGContextRestoreGState(context);
	
	CGContextSaveGState(context);
	{
		CGMutablePathRef path = CGPathCreateMutable();
		CGPathMoveToPoint(path, NULL, rect.origin.x, CGRectGetMaxY(rect));
		CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
		CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(centerRect), CGRectGetMaxY(centerRect));
		CGPathAddLineToPoint(path, NULL, centerRect.origin.x, CGRectGetMaxY(centerRect));
		CGContextAddPath(context, path);
		UIColor *bottomColor = [UIColor colorWithHue:baseHue saturation:baseSaturation brightness:(baseBrightness - 0.4) alpha:baseAlpha];
		CGContextSetFillColorWithColor(context, [bottomColor CGColor]);
		CGContextFillPath(context);
		CGPathRelease(path);
	}
	CGContextRestoreGState(context);

	CGContextSetFillColorWithColor(context, [baseColor CGColor]);
	CGContextFillRect(context, centerRect);
}

@end
