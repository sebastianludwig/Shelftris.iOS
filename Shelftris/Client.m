//
//  Client.m
//  Shelftris
//
//  Created by Sebastian Ludwig on 05.06.14.
//  Copyright (c) 2014 Sebastian Ludwig. All rights reserved.
//

#import "Client.h"

@implementation Client

- (void)shutdownServer
{
    NSDictionary *command = @{@"action": @"system",
                              @"command": @"shutdown"
                              };
    [self sendCommandAsync:command];
}

- (void)setHueAsync:(float)hue cells:(NSArray *)cells
{
	NSDictionary *command = @{
							  @"action": @"set_hue",
							  @"hue": @(hue),
							  @"cells": [self serializeCells:cells]
							  };
	
	[self sendCommandAsync:command];
}

- (void)setSaturationAsync:(float)saturation cells:(NSArray *)cells
{
	NSDictionary *command = @{
							  @"action": @"set_saturation",
							  @"hue": @(saturation),
							  @"cells": [self serializeCells:cells]
							  };
	
	[self sendCommandAsync:command];
}

- (void)setBrightnessAsync:(float)brightness cells:(NSArray *)cells
{
	NSDictionary *command = @{
							  @"action": @"set_brightness",
							  @"hue": @(brightness),
							  @"cells": [self serializeCells:cells]
							  };
	
	[self sendCommandAsync:command];
}

- (void)addBrickAsync:(Brick *)brick origin:(Position)origin
{
	NSDictionary *command = @{
                               @"action": @"add_brick",
                               @"origin": [self serializePoint:origin],
                               @"shape": [self serializeShape:brick.shape],
                               @"color": [self serializeColor:brick.color],
                               @"rotation": @(brick.rotation)
                               };
	[self sendCommandAsync:command];
}

- (void)clearAsync
{
	NSDictionary *command = @{@"action": @"clear"};
	[self sendCommandAsync:command];
}

- (NSArray *)update
{
    // TODO: request current state from server
	return nil;
}

#pragma mark private methods

- (NSArray *)serializeCells:(NSArray *)cells
{
	NSMutableArray *serializedCells = [[NSMutableArray alloc] initWithCapacity:cells.count];
	for (NSValue *value in cells) {
		[serializedCells addObject:[self serializePoint:[value positionValue]]];
	}
	return serializedCells;
}

- (NSDictionary *)serializePoint:(Position)point
{
	return @{@"x": @(point.x), @"y": @(point.y)};
}

- (NSDictionary *)serializeColor:(UIColor *)color
{
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    
    [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    return @{@"hue": @(hue), @"saturation": @(saturation), @"brightness": @(brightness)};
}

- (NSString *)serializeShape:(BrickShape)shape
{
    switch (shape) {
        case BrickShapeT: return @"T";
        case BrickShapeO: return @"O";
        case BrickShapeI: return @"I";
        case BrickShapeJ: return @"J";
        case BrickShapeL: return @"L";
        case BrickShapeZ: return @"Z";
        case BrickShapeS: return @"S";
        default: return @"T";
    }
}

- (void)sendCommandAsync:(NSDictionary *)command
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://shelftris.local/command"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:command options:0 error:nil]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   NSLog(@"Error: %@", [connectionError description]);
                               } else if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                                   if (httpResponse.statusCode != 200) {
                                       NSLog(@"Failed with status code %ld", (long)httpResponse.statusCode);
                                   }
                               }
                           }];

}

@end
