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

@property (nonatomic) UIEdgeInsets insets;
@property (nonatomic) UIColor* color;

- (id)initWithFrame:(CGRect)frame shape:(BrickShape)brickShape;

@end
