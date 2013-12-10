//
//  BTPageContainerView.h
//  BTPageViewControllerDemo
//
//  Created by 巩 鹏军 on 13-12-10.
//  Copyright (c) 2013年 巩 鹏军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTPageViewController.h"

@interface BTPageContainerView : UIView
- (instancetype)initWithFrame:(CGRect)frame;
@property (retain, nonatomic) UIViewController *viewController;
@end
