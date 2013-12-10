//
//  BTGestureRecognizer.h
//  BTPageViewControllerDemo
//
//  Created by 巩 鹏军 on 13-12-10.
//  Copyright (c) 2013年 巩 鹏军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTPageViewController.h"

@interface BTSwipeGestureRecognizer : UIGestureRecognizer <UIGestureRecognizerDelegate>

@property (assign, nonatomic) BTPageViewController *pageViewController;
@property (assign, nonatomic) CGPoint previousTouchPoint;
@property (assign, nonatomic) CFAbsoluteTime previousTouchTime;
@property (assign, nonatomic) CGFloat velocity;

- (id)initWithPageViewController:(BTPageViewController *)pageViewController;

@end
