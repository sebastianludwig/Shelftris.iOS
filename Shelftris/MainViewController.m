//
//  MainViewController.m
//  Shelftris
//
//  Created by Sebastian Ludwig on 26.05.14.
//  Copyright (c) 2014 Sebastian Ludwig. All rights reserved.
//

#import "MainViewController.h"

#import "HuePicker.h"

@implementation MainViewController
{
	IBOutlet HuePicker *huePicker;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	huePicker.donutThickness = 30;
	huePicker.color = [UIColor blueColor];
	
	self.view.backgroundColor = [UIColor blackColor];
}
@end
