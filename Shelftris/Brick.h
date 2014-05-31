//
//  Brick.h
//  Shelftris
//
//  Created by Sebastian Ludwig on 27.05.14.
//  Copyright (c) 2014 Sebastian Ludwig. All rights reserved.
//

typedef enum {
    BrickShapeT,
    BrickShapeO,
    BrickShapeI,
	BrickShapeJ,
	BrickShapeL,
	BrickShapeZ,
	BrickShapeS
} BrickShape;

@interface Brick : UIView

@property (nonatomic, readonly) BrickShape shape;
@property (nonatomic) UIEdgeInsets insets;
@property (nonatomic) UIColor* color;
@property (nonatomic) int rotation;

- (id)initWithFrame:(CGRect)frame shape:(BrickShape)brickShape;
- (void)rotateClockwise;

- (CGFloat)squareSize;
- (NSArray *)squareOriginsInView:(UIView *)view;

@end
