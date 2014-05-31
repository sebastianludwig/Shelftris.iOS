//
//  MainViewController.h
//  Shelftris
//
//  Created by Sebastian Ludwig on 26.05.14.
//  Copyright (c) 2014 Sebastian Ludwig. All rights reserved.
//

#import "HuePicker.h"
#import "GradientPicker.h"

@interface MainViewController : UIViewController<HuePickerDelegate, GradientPickerDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>

@end
