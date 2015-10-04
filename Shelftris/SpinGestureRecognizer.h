//
//  SpinGestureRecognizer.h
//  Karussell
//
//  Created by Sebastian Ludwig on 03.02.14.
//  Copyright (c) 2014 Sebastian Ludwig. All rights reserved.
//

@interface SpinGestureRecognizer : UIGestureRecognizer

@property (nonatomic, readonly) float angle;
@property (nonatomic, readonly) float velocity;

@end
