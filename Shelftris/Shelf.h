//
//  Shelf.h
//  Shelftris
//
//  Created by Sebastian Ludwig on 28.05.14.
//  Copyright (c) 2014 Sebastian Ludwig. All rights reserved.
//

#import "Brick.h"
#import "Position.h"

@class Shelf;

@protocol ShelfDelegate <NSObject>      // TODO: move down

- (void)shelfDidChangeCellActivity:(Shelf *)shelf;

@end


@interface Shelf: UIView       // TODO: rename to ShelfView

@property (nonatomic, weak) IBOutlet id<ShelfDelegate> delegate;

@property (nonatomic, readonly) CGFloat squareSize;
@property (nonatomic, readonly) CGFloat gridWidth;

- (id)initWithFrame:(CGRect)frame columns:(int)columns rows:(int)rows;

- (Position)dropBrick:(Brick *)brick;

- (NSArray *)activeCells;	// NSArray of Position
- (BOOL)hasActiveCells;

@end
