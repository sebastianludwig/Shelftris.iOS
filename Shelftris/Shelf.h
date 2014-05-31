//
//  Shelf.h
//  Shelftris
//
//  Created by Sebastian Ludwig on 28.05.14.
//  Copyright (c) 2014 Sebastian Ludwig. All rights reserved.
//

#import "Brick.h"

@interface Shelf : UIView

@property (nonatomic, readonly) CGFloat squareSize;
@property (nonatomic, readonly) CGFloat gridWidth;

- (id)initWithFrame:(CGRect)frame columns:(int)columns rows:(int)rows;

- (BOOL)dropBrick:(Brick *)brick;

@end
