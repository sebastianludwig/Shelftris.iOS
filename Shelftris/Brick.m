//
//  Brick.m
//  Shelftris
//
//  Created by Sebastian Ludwig on 27.05.14.
//  Copyright (c) 2014 Sebastian Ludwig. All rights reserved.
//

#import "Brick.h"
#import "Square.h"

@implementation Brick
{
	NSDictionary* patterns;
	NSArray* pattern;
}

- (id)initWithFrame:(CGRect)frame shape:(BrickShape)brickShape
{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.color = [UIColor whiteColor];
        _shape = brickShape;
		
		patterns = @{
					 @0: @{
							 @(BrickShapeT): @[@[@YES, @NO], @[@YES, @YES], @[@YES, @NO]],
							 @(BrickShapeO): @[@[@YES, @YES], @[@YES, @YES]],
							 @(BrickShapeI): @[@[@YES, @YES, @YES, @YES]],
							 @(BrickShapeJ): @[@[@NO, @NO, @YES], @[@YES, @YES, @YES]],
							 @(BrickShapeL): @[@[@YES, @YES, @YES], @[@NO, @NO, @YES]],
							 @(BrickShapeZ): @[@[@YES, @NO], @[@YES, @YES], @[@NO, @YES]],
							 @(BrickShapeS): @[@[@NO, @YES], @[@YES, @YES], @[@YES, @NO]]
							 },
					 @1: @{
							 @(BrickShapeT): @[@[@NO, @YES, @NO], @[@YES, @YES, @YES]],
							 @(BrickShapeO): @[@[@YES, @YES], @[@YES, @YES]],
							 @(BrickShapeI): @[@[@YES], @[@YES], @[@YES], @[@YES]],
							 @(BrickShapeJ): @[@[@YES, @YES], @[@NO, @YES], @[@NO, @YES]],
							 @(BrickShapeL): @[@[@YES, @YES], @[@YES, @NO], @[@YES, @NO]],
							 @(BrickShapeZ): @[@[@NO, @YES, @YES], @[@YES, @YES, @NO]],
							 @(BrickShapeS): @[@[@YES, @YES, @NO], @[@NO, @YES, @YES]]
							 },
					 @2: @{
							 @(BrickShapeT): @[@[@NO, @YES], @[@YES, @YES], @[@NO, @YES]],
							 @(BrickShapeO): @[@[@YES, @YES], @[@YES, @YES]],
							 @(BrickShapeI): @[@[@YES, @YES, @YES, @YES]],
							 @(BrickShapeJ): @[@[@YES, @YES, @YES], @[@YES, @NO, @NO]],
							 @(BrickShapeL): @[@[@YES, @NO, @NO], @[@YES, @YES, @YES]],
							 @(BrickShapeZ): @[@[@YES, @NO], @[@YES, @YES], @[@NO, @YES]],
							 @(BrickShapeS): @[@[@NO, @YES], @[@YES, @YES], @[@YES, @NO]]
							 },
					 @3: @{
							 @(BrickShapeT): @[@[@YES, @YES, @YES], @[@NO, @YES, @NO]],
							 @(BrickShapeO): @[@[@YES, @YES], @[@YES, @YES]],
							 @(BrickShapeI): @[@[@YES], @[@YES], @[@YES], @[@YES]],
							 @(BrickShapeJ): @[@[@YES, @NO], @[@YES, @NO], @[@YES, @YES]],
							 @(BrickShapeL): @[@[@NO, @YES], @[@NO, @YES], @[@YES, @YES]],
							 @(BrickShapeZ): @[@[@NO, @YES, @YES], @[@YES, @YES, @NO]],
							 @(BrickShapeS): @[@[@YES, @YES, @NO], @[@NO, @YES, @YES]]
							 }
					 };
		pattern = patterns[@0][@(_shape)];
    }
    return self;
}

- (void)rotateClockwise
{
	[self setRotation:(self.rotation + 1) animated:YES];
}

#pragma properties

- (void)setColor:(UIColor *)color
{
	_color = color;
	[self setNeedsDisplay];
}

- (void)setRotation:(int)rotation
{
	[self setRotation:rotation animated:NO];
}

- (void)setRotation:(int)rotation animated:(BOOL)animated
{
	int oldRotation = _rotation;
	_rotation = rotation % 4;
	
	if (animated) {
		[UIView animateWithDuration:0.2
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 self.transform = CGAffineTransformMakeRotation((_rotation - oldRotation) * M_PI_2);
						 } completion:^(BOOL finished) {
							 self.transform = CGAffineTransformIdentity;
							 pattern = patterns[@(_rotation)][@(_shape)];
							 [self setNeedsDisplay];
						 }];
	} else {
		pattern = patterns[@(_rotation)][@(_shape)];
		[self setNeedsDisplay];
	}
}

#pragma mark drawing

- (int)widthOfShape
{
	return [pattern count] * [self maxSquareSize];
}

- (int)heightOfShape
{
	return [pattern[0] count] * [self maxSquareSize];
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
	for (int xIndex = 0; xIndex < [pattern count]; ++xIndex) {
		for (int yIndex = 0; yIndex < [pattern[0] count]; ++yIndex) {
			if (![pattern[xIndex][yIndex] boolValue]) {
				continue;
			}
			
			CGRect squareRect = CGRectMake(origin.x + xIndex * squareSize, origin.y + yIndex * squareSize, squareSize, squareSize);
			[Square drawSqureInRect:squareRect withBaseColor:self.color inContext:context];
		}
	}
}

@end
