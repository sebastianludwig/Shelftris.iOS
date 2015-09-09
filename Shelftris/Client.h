//
//  Client.h
//  Shelftris
//
//  Created by Sebastian Ludwig on 05.06.14.
//  Copyright (c) 2014 Sebastian Ludwig. All rights reserved.
//

#import "Brick.h"

@interface Client : NSObject

- (void)setHueAsync:(float)hue cells:(NSArray *)cells;		// cells = NSArray of CGPoint
- (void)setSaturationAsync:(float)hue cells:(NSArray *)cells;
- (void)setBrightnessAsync:(float)hue cells:(NSArray *)cells;

- (void)addBrickAsync:(Brick *)brick origin:(CGPoint)origin;

- (void)clearAsync;

- (NSArray *)update;		// returns 2D NSArray of UIColor

@end
