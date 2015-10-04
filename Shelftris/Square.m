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

+ (CALayer *)squareWithSize:(CGSize)size baseColor:(UIColor *)baseColor
{
    static CALayer *cachedLayer = nil;
    static UIColor *cachedColor = nil;
    static CGSize cachedSize;
    
    if ([baseColor isEqual:cachedColor] && CGSizeEqualToSize(size, cachedSize)) {
        return cachedLayer;
    }
    
    CGFloat baseHue, baseSaturation, baseBrightness, baseAlpha;
    if (![baseColor getHue:&baseHue saturation:&baseSaturation brightness:&baseBrightness alpha:&baseAlpha]) {
        return nil;
    }
    
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    
    CGFloat inset = size.width / 8.0;
    CGRect centerRect = CGRectInset(frame, inset, inset);
    centerRect = CGRectIntegral(centerRect);
    
    CALayer *layer = [CALayer new];
    layer.frame = frame;
    
    // center
    layer.backgroundColor = baseColor.CGColor;

    // sides
    {
        UIColor *sideColor = [UIColor colorWithHue:baseHue saturation:baseSaturation brightness:(baseBrightness - 0.1) alpha:baseAlpha];
        CGMutablePathRef path = CGPathCreateMutable();
        // left
        CGPathMoveToPoint(path, NULL, frame.origin.x, frame.origin.y);
        CGPathAddLineToPoint(path, NULL, frame.origin.x, CGRectGetMaxY(frame));
        CGPathAddLineToPoint(path, NULL, centerRect.origin.x, CGRectGetMaxY(centerRect));
        CGPathAddLineToPoint(path, NULL, centerRect.origin.x, centerRect.origin.y);
        
        // right
        CGPathMoveToPoint(path, NULL, CGRectGetMaxX(frame), frame.origin.y);
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(frame), CGRectGetMaxY(frame));
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(centerRect), CGRectGetMaxY(centerRect));
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(centerRect), centerRect.origin.y);
        
        CAShapeLayer *sides = [CAShapeLayer new];
        sides.path = path;
        sides.fillColor = sideColor.CGColor;
        [layer addSublayer:sides];
        CGPathRelease(path);
    }
    
    // top
    {
        UIColor *topColor = [UIColor colorWithHue:baseHue saturation:(baseSaturation - 0.4) brightness:baseBrightness alpha:baseAlpha];

        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, frame.origin.x, frame.origin.y);
        CGPathAddLineToPoint(path, NULL, centerRect.origin.x, centerRect.origin.y);
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(centerRect), centerRect.origin.y);
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(frame), frame.origin.y);
        
        CAShapeLayer *top = [CAShapeLayer new];
        top.path = path;
        top.fillColor = topColor.CGColor;
        [layer addSublayer:top];
        CGPathRelease(path);
    }
    
    // bottom
    {
        UIColor *bottomColor = [UIColor colorWithHue:baseHue saturation:baseSaturation brightness:(baseBrightness - 0.4) alpha:baseAlpha];
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, frame.origin.x, CGRectGetMaxY(frame));
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(frame), CGRectGetMaxY(frame));
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(centerRect), CGRectGetMaxY(centerRect));
        CGPathAddLineToPoint(path, NULL, centerRect.origin.x, CGRectGetMaxY(centerRect));
        
        CAShapeLayer *bottom = [CAShapeLayer new];
        bottom.path = path;
        bottom.fillColor = bottomColor.CGColor;
        [layer addSublayer:bottom];
        CGPathRelease(path);
    }
    
    cachedLayer = layer;
    cachedColor = baseColor;
    cachedSize = size;
    
    return layer;
}

+ (void)drawSqureInRect:(CGRect)rect withBaseColor:(UIColor *)baseColor inContext:(CGContextRef)context
{
    CALayer *square = [self squareWithSize:rect.size baseColor:baseColor];
    
    CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);
    [square renderInContext:context];
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
}

@end
