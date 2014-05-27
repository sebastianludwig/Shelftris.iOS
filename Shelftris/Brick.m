//
//  Brick.m
//  Shelftris
//
//  Created by Sebastian Ludwig on 27.05.14.
//  Copyright (c) 2014 Sebastian Ludwig. All rights reserved.
//

#import "Brick.h"

@implementation Brick
{
	BrickShape shape;
	NSDictionary* patterns;
}

- (id)initWithFrame:(CGRect)frame shape:(BrickShape)brickShape
{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.color = [UIColor whiteColor];
        shape = brickShape;
		
		patterns = @{
					 @(BrickShapeT): @[@[@YES, @NO], @[@YES, @YES], @[@YES, @NO]],
					 @(BrickShapeO): @[@[@YES, @YES], @[@YES, @YES]],
					 @(BrickShapeI): @[@[@YES, @YES, @YES, @YES]],
					 @(BrickShapeJ): @[@[@YES, @NO, @NO], @[@YES, @YES, @YES]],
					 @(BrickShapeL): @[@[@YES, @YES, @YES], @[@NO, @NO, @YES]],
					 @(BrickShapeZ): @[@[@YES, @NO], @[@YES, @YES], @[@NO, @YES]],
					 @(BrickShapeS): @[@[@NO, @YES], @[@YES, @YES], @[@YES, @NO]]
					};
    }
    return self;
}

- (void)setColor:(UIColor *)color
{
	_color = color;
	[self setNeedsDisplay];
}

- (int)widthOfShape
{
	return [patterns[@(shape)] count] * [self maxSquareSize];
}

- (int)heightOfShape
{
	return [patterns[@(shape)][0] count] * [self maxSquareSize];
}

- (CGFloat)maxSquareSize
{
	return MIN(self.bounds.size.width, self.bounds.size.height) / 4;
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
	CGRect contentSize = UIEdgeInsetsInsetRect(self.bounds, self.insets);
	
	CGPoint origin = CGPointMake((contentSize.size.width - [self widthOfShape]) / 2.0 , (contentSize.size.height - [self heightOfShape]) / 2.0);
	
	CGFloat squareSize = [self maxSquareSize];
	CGContextRef context = UIGraphicsGetCurrentContext();
	for (int xIndex = 0; xIndex < [patterns[@(shape)] count]; ++xIndex) {
		for (int yIndex = 0; yIndex < [patterns[@(shape)][0] count]; ++yIndex) {
			if (![patterns[@(shape)][xIndex][yIndex] boolValue]) {
				continue;
			}
			
			CGRect squareRect = CGRectMake(origin.x + xIndex * squareSize, origin.y + yIndex * squareSize, squareSize, squareSize);
			[self drawSqureInRect:squareRect withBaseColor:self.color inContext:context];
		}
	}
}

- (void)drawSqureInRect:(CGRect)rect withBaseColor:(UIColor *)baseColor inContext:(CGContextRef)context
{
	CGFloat baseHue, baseSaturation, baseBrightness;
	if (![baseColor getHue:&baseHue saturation:&baseSaturation brightness:&baseBrightness alpha:nil]) {
		return;
	}
	UIColor *sideColor = [UIColor colorWithHue:baseHue saturation:baseSaturation brightness:(baseBrightness - 0.1) alpha:1];
	CGContextSetFillColorWithColor(context, [sideColor CGColor]);
	CGContextFillRect(context, rect);
	
	CGMutablePathRef path = CGPathCreateMutable();
	CGContextSaveGState(context);
	{
		CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y);
		CGPathAddLineToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMidY(rect));
		CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), rect.origin.y);
		CGContextAddPath(context, path);
		UIColor *topColor = [UIColor colorWithHue:baseHue saturation:(baseSaturation - 0.4) brightness:baseBrightness alpha:1];
		CGContextSetFillColorWithColor(context, [topColor CGColor]);
		CGContextFillPath(context);
	}
	CGContextRestoreGState(context);
	
	path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, rect.origin.x, CGRectGetMaxY(rect));
	CGPathAddLineToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMidY(rect));
	CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
	CGContextAddPath(context, path);
	UIColor *bottomColor = [UIColor colorWithHue:baseHue saturation:baseSaturation brightness:(baseBrightness - 0.4) alpha:1];
	CGContextSetFillColorWithColor(context, [bottomColor CGColor]);
	CGContextFillPath(context);
	
	
	CGFloat inset = rect.size.width / 8.0;
	CGRect centerRect = UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(inset, inset, inset, inset));
	CGContextSetFillColorWithColor(context, [baseColor CGColor]);
	CGContextFillRect(context, centerRect);
}

@end
