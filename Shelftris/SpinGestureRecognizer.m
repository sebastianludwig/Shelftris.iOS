//
//  SpinGestureRecognizer.m
//  Karussell
//
//  Created by Sebastian Ludwig on 03.02.14.
//  Copyright (c) 2014 Sebastian Ludwig. All rights reserved.
//

#import "SpinGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

#define SPEED_MEASUREMENT_COUNT 5

@implementation SpinGestureRecognizer
{
	UITouch *touch;
	CGPoint lastPoint;
	float angle;
	
	float speeds[SPEED_MEASUREMENT_COUNT];
	int speedIndex;
	NSDate* lastSpeedMeasurement;
}

#pragma mark -
#pragma mark UIGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (touch) {
		return;
	}
	touch = [[touches allObjects] firstObject];
	angle = 0;
	lastPoint = [touch locationInView:self.view];
	[self resetSpeedMeasurements];
	self.state = UIGestureRecognizerStateBegan;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (!touch) {
		return;
	}
	if (![touches containsObject:touch]) {
		return;
	}
	// TODO cancel if touching the spinView

	CGPoint newPoint = [touch locationInView:self.view];
	float deltaAngle = [self angleBetween:lastPoint andPoint:newPoint];
	angle += deltaAngle;
	lastPoint = newPoint;
	[self registerSpeedMeasurementForAngularDelta:deltaAngle];
	
	self.state = UIGestureRecognizerStateChanged;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (![touches containsObject:touch]) {
		return;
	}
	touch = nil;
	self.state = UIGestureRecognizerStateEnded;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (![touches containsObject:touch]) {
		return;
	}
	touch = nil;
	self.state = UIGestureRecognizerStateCancelled;
}

#pragma mark -
#pragma mark SpinGestureRecognizer

- (id)initWithSpinView:(UIView *)view target:(id)target action:(SEL)action
{
	if (self = [super initWithTarget:target action:action]) {
		self.spinView = view;
	}
	return self;
}

- (float)angle
{
	return angle;
}

- (float)velocity
{
	return [self weightedVelocity];
}

#pragma mark private methods

- (float)angleBetween:(CGPoint)pointA andPoint:(CGPoint)pointB
{
	// a = startPoint - spinView.center
	CGPoint a = CGPointMake(pointA.x - self.spinView.center.x, pointA.y - self.spinView.center.y);
	
	// b = currentPoint - spinView.center
	CGPoint currentPoint = pointB;
	CGPoint b = CGPointMake(currentPoint.x - self.spinView.center.x, currentPoint.y - self.spinView.center.y);
	
	return atan2(a.x*b.y - a.y*b.x, a.x*b.x + a.y*b.y);
}

#pragma mark Speed measurement

- (void)resetSpeedMeasurements
{
	for (int i = 0; i < SPEED_MEASUREMENT_COUNT; ++i) {
		speeds[i] = 0;
	}
	lastSpeedMeasurement = [NSDate date];
}

- (void)registerSpeedMeasurementForAngularDelta:(float)delta
{
	float speedPerSecond = delta / -[lastSpeedMeasurement timeIntervalSinceNow];
	speeds[speedIndex] = speedPerSecond;
	speedIndex = ++speedIndex % SPEED_MEASUREMENT_COUNT;
	
	lastSpeedMeasurement = [NSDate date];
}

- (float)weightedVelocity
{
	return speeds[speedIndex - 1];
}

@end
