//
//  Position.m
//  Shelftris
//
//  Created by Sebastian Ludwig on 13.09.15.
//  Copyright (c) 2015 Sebastian Ludwig. All rights reserved.
//

#import "Position.h"

Position PositionMake(NSInteger x, NSInteger y) {
    Position p; p.x = x; p.y = y; return p;
}

@implementation NSValue (Position)

+ (NSValue *)valueWithPosition:(Position)position
{
    return [NSValue value:&position withObjCType:@encode(Position)];
}

- (Position)positionValue
{
    Position position;
    [self getValue:&position];
    return position;
}

@end