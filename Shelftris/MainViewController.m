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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	huePicker.donutThickness = 30;
	huePicker.color = [UIColor blueColor];
	huePicker.delegate = self;
	
	brickScrollView.contentSize = CGSizeMake(0, 0);
	bricks = [[NSMutableArray alloc] init];
	[self addBrickViewForShape:BrickShapeS];
	for (int i = BrickShapeT; i <= BrickShapeS; ++i) {
		[self addBrickViewForShape:i];
	}
	[self addBrickViewForShape:BrickShapeT];
	brickScrollView.contentOffset = CGPointMake([bricks[0] size].width, 0);
	
	self.view.backgroundColor = [UIColor blackColor];
}

- (void)addBrickViewForShape:(BrickShape)shape
{
	CGRect frame = CGRectMake(brickScrollView.contentSize.width, 0, brickScrollView.frame.size.width, brickScrollView.frame.size.height);
	Brick *brick = [[Brick alloc] initWithFrame:frame shape:shape];
	brick.color = huePicker.color;
	[brickScrollView addSubview:brick];
	[bricks addObject:brick];
	brickScrollView.contentSize = CGSizeMake(CGRectGetMaxX(brick.frame), brickScrollView.frame.size.height);
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
	int index = scrollView.contentOffset.x / brickScrollView.frame.size.width;
	if (index == bricks.count - 1) {
		CGPoint offset = CGPointMake(brickScrollView.frame.size.width, 0);
		[scrollView setContentOffset:offset animated:NO];
	} else if (index == 0) {
		CGPoint offset = CGPointMake(brickScrollView.contentSize.width - 2 * brickScrollView.frame.size.width, 0);
		[scrollView setContentOffset:offset animated:NO];
	}
}

@end
