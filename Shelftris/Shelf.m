//
//  Shelf.m
//  Shelftris
//
//  Created by Sebastian Ludwig on 28.05.14.
//  Copyright (c) 2014 Sebastian Ludwig. All rights reserved.
//

#import "Shelf.h"
#import "Square.h"

@implementation Shelf
{
	NSMutableArray *squares;
	NSMutableArray *activeStatus;
	
	UIColor *activeBorderColor;
	UIColor *inactiveBorderColor;
	CGFloat inactiveSquareAlpha;
	
	BOOL panActivation;
}

- (id)initWithFrame:(CGRect)frame columns:(int)columns rows:(int)rows
{
    self = [super initWithFrame:frame];
    if (self) {
		activeBorderColor = [UIColor whiteColor];
		inactiveBorderColor = [UIColor colorWithWhite:0.5 alpha:1];
		inactiveSquareAlpha = 0.3;
		
		_gridWidth = 2;
		CGFloat maxColumnWidth = (frame.size.width - _gridWidth) / columns;
		CGFloat maxRowHeight = (frame.size.height - _gridWidth) / rows;
		
		_squareSize = MIN(maxColumnWidth, maxRowHeight);
		
		CGPoint squaresOrigin = CGPointMake((frame.size.width - columns * (_squareSize - _gridWidth) + _gridWidth) / 2, (frame.size.height - rows * (_squareSize - _gridWidth) + _gridWidth) / 2);
		
		squares = [[NSMutableArray alloc] initWithCapacity:columns];
		activeStatus = [[NSMutableArray alloc] initWithCapacity:columns];
		for (int columnIndex = 0; columnIndex < columns; ++columnIndex) {
			NSMutableArray *rowSquares = [NSMutableArray arrayWithCapacity:rows];
			NSMutableArray *squareStatus = [NSMutableArray arrayWithCapacity:rows];
						
			for (int rowIndex = 0; rowIndex < rows; ++rowIndex) {
				CGRect squareFrame = CGRectMake(squaresOrigin.x + columnIndex * (_squareSize - _gridWidth), squaresOrigin.y + rowIndex * (_squareSize - _gridWidth), _squareSize, _squareSize);
				Square *square = [[Square alloc] initWithFrame:squareFrame baseColor:[UIColor clearColor]];
				square.borderWidth = _gridWidth;
				square.borderColor = inactiveBorderColor;
				
				[self addSubview:square];
				[rowSquares addObject:square];
				[squareStatus addObject:@NO];
			}
			
			[squares addObject:rowSquares];
			[activeStatus addObject:squareStatus];
		}
		
		UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
		[self addGestureRecognizer:tapRecognizer];
		
		UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
		[self addGestureRecognizer:panRecognizer];
    }
    return self;
}

#pragma mark Gesture recognition / de-/activation

- (void)setSquareInColumn:(int)column row:(int)row active:(BOOL)active
{
	Square *square = squares[column][row];
	if (active) {
		[square setBorderColor:activeBorderColor];
		square.baseColor = [square.baseColor colorWithAlphaComponent:1];
		[self bringSubviewToFront:square];
	} else {
		[square setBorderColor:inactiveBorderColor];
		square.baseColor = [square.baseColor colorWithAlphaComponent:inactiveSquareAlpha];
		[self sendSubviewToBack:square];
	}
	activeStatus[column][row] = @(active);
}

- (Square *)squareAtPoint:(CGPoint)point column:(int *)outColumn row:(int *)outRow
{
	for (int column = 0; column < [squares count]; ++column) {
		for (int row = 0; row < [squares[0] count]; ++row) {
			Square *square = squares[column][row];
			
			if (CGRectContainsPoint(square.frame, point)) {
				if (outColumn) {
					*outColumn = column;
				}
				if (outRow) {
					*outRow = row;
				}
				
				return square;
			}
		}
	}
	
	return nil;
}

- (void)onTap:(UITapGestureRecognizer *)tapRecognizer
{
	CGPoint tapLocation = [tapRecognizer locationInView:self];
	
	int column, row;
	Square *square = [self squareAtPoint:tapLocation column:&column row:&row];
	
	if (!square) {
		for (int column = 0; column < [squares count]; ++column) {
			for (int row = 0; row < [squares[0] count]; ++row) {
				[self setSquareInColumn:column row:row active:NO];
			}
		}
		return;
	}
	
	[self setSquareInColumn:column row:row active:![activeStatus[column][row] boolValue]];
}

- (void)onPan:(UIPanGestureRecognizer *)panRecognizer
{
	CGPoint location = [panRecognizer locationInView:self];
	
	int column, row;
	Square *square = [self squareAtPoint:location column:&column row:&row];
	
	if (panRecognizer.state == UIGestureRecognizerStateBegan) {
		if (!square) {
			panActivation = NO;
		} else {
			panActivation = ![activeStatus[column][row] boolValue];
			[self setSquareInColumn:column row:row active:panActivation];
		}
	} else if (panRecognizer.state == UIGestureRecognizerStateChanged) {
		if (square) {
			[self setSquareInColumn:column row:row active:panActivation];
		}
	}
}

@end
