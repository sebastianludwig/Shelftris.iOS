//
//  Position.h
//  Shelftris
//
//  Created by Sebastian Ludwig on 13.09.15.
//  Copyright (c) 2015 Sebastian Ludwig. All rights reserved.
//

#import <Foundation/Foundation.h>

struct Position {
    NSInteger x;
    NSInteger y;
};
typedef struct Position Position;

Position PositionMake(NSInteger x, NSInteger y);

@interface NSValue (Position)

+ (NSValue *)valueWithPosition:(Position)position;
- (Position)positionValue;

@end