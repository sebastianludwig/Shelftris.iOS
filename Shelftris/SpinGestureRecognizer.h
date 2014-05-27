//
//  SpinGestureRecognizer.h
//  Karussell
//
//  Created by Sebastian Ludwig on 03.02.14.
//  Copyright (c) 2014 Sebastian Ludwig. All rights reserved.
//

@interface SpinGestureRecognizer : UIGestureRecognizer

@property (nonatomic, weak) UIView *spinView;

- (id)initWithSpinView:(UIView*)view target:(id)target action:(SEL)action;

@property (nonatomic, readonly) float angle;
@property (nonatomic, readonly) float velocity;

@end
