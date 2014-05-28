//
//  MainViewController.m
//  Shelftris
//
//  Created by Sebastian Ludwig on 26.05.14.
//  Copyright (c) 2014 Sebastian Ludwig. All rights reserved.
//

#import "MainViewController.h"

#import "Brick.h"

@implementation MainViewController
{
	NSMutableArray* bricks;
	
	IBOutlet HuePicker *huePicker;
	IBOutlet UIScrollView *brickScrollView;
	
	IBOutlet UILongPressGestureRecognizer* longPressGuestureRecognizer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	huePicker.donutThickness = 30;
	huePicker.color = [UIColor blueColor];
	huePicker.delegate = self;
	
	brickScrollView.contentSize = CGSizeMake(0, 0);
	bricks = [[NSMutableArray alloc] init];
	[self addBrickWithShape:BrickShapeS];
	for (int i = BrickShapeT; i <= BrickShapeS; ++i) {
		[self addBrickWithShape:i];
	}
	[self addBrickWithShape:BrickShapeT];
	brickScrollView.contentOffset = CGPointMake([bricks[0] size].width, 0);
	
	self.view.backgroundColor = [UIColor blackColor];
}

- (Brick *)addBrickWithShape:(BrickShape)shape
{
	return [self addBrickWithShape:shape origin:CGPointMake(brickScrollView.contentSize.width, 0)];
}

- (Brick *)addBrickWithShape:(BrickShape)shape origin:(CGPoint)origin
{
	CGRect frame = CGRectMake(origin.x, origin.y, brickScrollView.frame.size.width, brickScrollView.frame.size.height);
	Brick *brick = [[Brick alloc] initWithFrame:frame shape:shape];
	brick.layer.anchorPoint = CGPointMake(0.5, 0.5);
	brick.color = huePicker.color;
	
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:brick action:@selector(rotateClockwise)];
	[brick addGestureRecognizer:tapRecognizer];
	
	UILongPressGestureRecognizer *dragRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(dragBrick:)];
	dragRecognizer.minimumPressDuration = 0.3;
	[brick addGestureRecognizer:dragRecognizer];
	
	[brickScrollView addSubview:brick];
	[bricks addObject:brick];
	
	[bricks sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		return [@([obj1 frame].origin.x) compare:@([obj2 frame].origin.x)];
	}];
	
	CGFloat maxX = -1;
	for (UIView *subview in brickScrollView.subviews) {
		maxX = MAX(maxX, CGRectGetMaxX(subview.frame));
	}
	brickScrollView.contentSize = CGSizeMake(maxX, brickScrollView.frame.size.height);
	return brick;
}

- (int)currentBrickIndex
{
	return brickScrollView.contentOffset.x / brickScrollView.frame.size.width;
}

- (void)dragBrick:(UILongPressGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
		Brick* pickedBrick = bricks[[self currentBrickIndex]];
		[bricks removeObject:pickedBrick];
		
		Brick* replacementBrick = [self addBrickWithShape:pickedBrick.shape origin:pickedBrick.frame.origin];
		replacementBrick.hidden = YES;
		
		pickedBrick.frame = brickScrollView.frame;
		[self.view addSubview:pickedBrick];
		
		CGFloat squareSize = 20;	// TODO get this from Shelf view
		
		[UIView animateWithDuration:0.5
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 CGPoint center = [gestureRecognizer locationInView:self.view];
							 CGRect frame = pickedBrick.frame;
							 frame.size.width = squareSize * 4;
							 frame.size.height = squareSize * 4;
							 frame.origin.x = center.x - frame.size.width / 2;
							 frame.origin.y = center.y - frame.size.height / 2;
							 pickedBrick.frame = frame;
						 }
						 completion:^(BOOL finished) {
						 }];
	} else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
		CGPoint location = [gestureRecognizer locationInView:self.view];
		gestureRecognizer.view.center = location;
	} else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
		for (Brick *brick in bricks) {
			brick.hidden = NO;
		}
		//[gestureRecognizer.view removeFromSuperview];
	}
	
	if (longPressGuestureRecognizer.state != UIGestureRecognizerStateBegan) {
		return;
	}
}

#pragma mark -
#pragma mark HuePickerDelegate

- (void)huePicker:(HuePicker *)view didSelectHue:(CGFloat)hue
{
	for (Brick* brick in bricks) {
		brick.color = view.color;
	}
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	int brickIndex = [self currentBrickIndex];
	if (brickIndex == bricks.count - 1) {		// last -> jump to second
		CGPoint offset = CGPointMake(brickScrollView.frame.size.width, 0);
		[scrollView setContentOffset:offset animated:NO];
	} else if (brickIndex == 0) {				// first -> jump to second last
		CGPoint offset = CGPointMake(brickScrollView.contentSize.width - 2 * brickScrollView.frame.size.width, 0);
		[scrollView setContentOffset:offset animated:NO];
	}
}

@end
