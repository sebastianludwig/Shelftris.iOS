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
}

- (id)initWithFrame:(CGRect)frame shape:(BrickShape)brickShape
{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.color = [UIColor whiteColor];
        _shape = brickShape;
		
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
	_rotation = rotation % 4;
	
	if (animated) {
		[UIView animateWithDuration:0.2
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 self.transform = CGAffineTransformMakeRotation(_rotation * M_PI_2);
						 } completion:^(BOOL finished) {
						 }];
	} else {
		self.transform = CGAffineTransformMakeRotation(_rotation * M_PI_2);
	}
}

#pragma mark drawing

- (int)widthOfShape
{
	return [patterns[@(self.shape)] count] * [self maxSquareSize];
}

- (int)heightOfShape
{
	return [patterns[@(self.shape)][0] count] * [self maxSquareSize];
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
	for (int xIndex = 0; xIndex < [patterns[@(self.shape)] count]; ++xIndex) {
		for (int yIndex = 0; yIndex < [patterns[@(self.shape)][0] count]; ++yIndex) {
			if (![patterns[@(self.shape)][xIndex][yIndex] boolValue]) {
				continue;
			}
			
			CGRect squareRect = CGRectMake(origin.x + xIndex * squareSize, origin.y + yIndex * squareSize, squareSize, squareSize);
			[Square drawSqureInRect:squareRect withBaseColor:self.color inContext:context];
		}
	}
}

@end
