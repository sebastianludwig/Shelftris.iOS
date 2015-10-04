//
//  MainViewController.m
//  Shelftris
//
//  Created by Sebastian Ludwig on 26.05.14.
//  Copyright (c) 2014 Sebastian Ludwig. All rights reserved.
//

#import "MainViewController.h"

#import "Brick.h"
#import "Client.h"

@implementation MainViewController
{
	NSMutableArray* bricks;
	Shelf *shelf;
	Client *client;
	
	IBOutlet HuePicker *huePicker;
	IBOutlet GradientPicker *saturationPicker;
	IBOutlet GradientPicker *brightnessPicker;
	IBOutlet UIScrollView *brickScrollView;
	IBOutlet UIView *shelfContainer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	huePicker.donutThickness = 30;
	huePicker.color = [UIColor blueColor];
	huePicker.delegate = self;
	
	[self updateColoredViews];
	
	brickScrollView.contentSize = CGSizeMake(0, 0);
	bricks = [[NSMutableArray alloc] init];
	[self addBrickWithShape:BrickShapeS];
	for (int i = BrickShapeT; i <= BrickShapeS; ++i) {
		[self addBrickWithShape:i];
	}
	[self addBrickWithShape:BrickShapeT];
	brickScrollView.contentOffset = CGPointMake(brickScrollView.frame.size.width, 0);
	
	shelf = [[Shelf alloc] initWithFrame:shelfContainer.bounds columns:2 rows:4];
	[shelfContainer addSubview:shelf];
	
	client = [[Client alloc] init];
}

- (IBAction)shutdownServer
{
    [client shutdownServer];
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

- (void)updateColoredViews
{
	CGFloat hue = huePicker.hue;
	CGFloat saturation = saturationPicker.value;
	CGFloat brightness = brightnessPicker.value;
	
	huePicker.color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
	[saturationPicker setStartColor:[UIColor colorWithHue:hue saturation:0 brightness:brightness alpha:1]
						   endColor:[UIColor colorWithHue:hue saturation:1 brightness:brightness alpha:1]];
	[brightnessPicker setStartColor:[UIColor colorWithHue:hue saturation:saturation brightness:0 alpha:1]
						   endColor:[UIColor colorWithHue:hue saturation:saturation brightness:1 alpha:1]];
	
	for (Brick* brick in bricks) {
		brick.color = huePicker.color;
	}
}

- (int)currentBrickIndex
{
	return brickScrollView.contentOffset.x / brickScrollView.frame.size.width;
}

- (IBAction)rotateBrick:(UITapGestureRecognizer *)gestureRecognizer
{
	int brickIndex = [self currentBrickIndex];
	Brick* pickedBrick = bricks[brickIndex];
	[pickedBrick rotateClockwise];
	
	if (brickIndex == 1) {		// last -> jump to second
		Brick* duplicate = bricks.lastObject;
		duplicate.rotation = pickedBrick.rotation;
	} else if (brickIndex == bricks.count - 2) {				// first -> jump to second last
		Brick* duplicate = bricks[0];
		duplicate.rotation = pickedBrick.rotation;
	}
}

- (void)dragBrick:(UILongPressGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
		Brick* pickedBrick = bricks[[self currentBrickIndex]];
		[bricks removeObject:pickedBrick];
		for (UIGestureRecognizer *recognizer in pickedBrick.gestureRecognizers) {
			if (recognizer != gestureRecognizer) {
				[pickedBrick removeGestureRecognizer:recognizer];
			}
		}
		
		Brick* replacementBrick = [self addBrickWithShape:pickedBrick.shape origin:pickedBrick.frame.origin];
		replacementBrick.rotation = pickedBrick.rotation;
		replacementBrick.alpha = 0;
		
		pickedBrick.frame = brickScrollView.frame;
		[self.view addSubview:pickedBrick];
		
		[UIView animateWithDuration:0.3
							  delay:0
							options:UIViewAnimationOptionCurveLinear
						 animations:^{
							 CGPoint center = [gestureRecognizer locationInView:self.view];
							 CGRect frame = pickedBrick.frame;
							 frame.size.width = (shelf.squareSize - 2 * shelf.gridWidth) * 4;
							 frame.size.height = (shelf.squareSize - 2 * shelf.gridWidth) * 4;
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
        Brick *brick = (Brick *)gestureRecognizer.view;
        Position origin = [shelf dropBrick:brick];
		if (origin.x != NSNotFound) {
            [client addBrickAsync:brick origin:origin];
			[gestureRecognizer.view removeFromSuperview];
			
			[UIView animateWithDuration:0.3
								  delay:0
								options:UIViewAnimationOptionCurveLinear
							 animations:^{
								 for (Brick *brick in bricks) {
									 brick.alpha = 1;
								 }
							 }
							 completion:^(BOOL finished) {
							 }];
			
		} else {
			[UIView animateWithDuration:0.3
								  delay:0
								options:UIViewAnimationOptionCurveEaseOut
							 animations:^{
								 gestureRecognizer.view.frame = brickScrollView.frame;
							 }
							 completion:^(BOOL finished) {
								 [gestureRecognizer.view removeFromSuperview];
								 
								 for (Brick *brick in bricks) {
									 brick.alpha = 1;
								 }
							 }];
		}
	}
}

#pragma mark -
#pragma mark HuePickerDelegate

- (void)huePicker:(HuePicker *)view didSelectHue:(CGFloat)hue
{
	[self updateColoredViews];
	if (shelf.hasActiveCells) {
		[client setHueAsync:huePicker.hue cells:shelf.activeCells];
	}
}

#pragma mark -
#pragma mark GradientPickerDelegate

- (void)gradientPicker:(GradientPicker *)gradientPicker didSelectValue:(CGFloat)value
{
	[self updateColoredViews];
	
	if (shelf.hasActiveCells) {
		if (gradientPicker == saturationPicker) {
			[client setSaturationAsync:saturationPicker.value cells:shelf.activeCells];
		}
		if (gradientPicker == brightnessPicker) {
			[client setSaturationAsync:brightnessPicker.value cells:shelf.activeCells];
		}
	}
}

#pragma mark -
#pragma mark ShelfDelegate

- (void)shelfDidChangeCellActivity:(Shelf *)view
{
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
