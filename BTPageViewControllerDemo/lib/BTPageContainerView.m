//
//  BTPageContainerView.m
//  BTPageViewControllerDemo
//
//  Created by 巩 鹏军 on 13-12-10.
//  Copyright (c) 2013年 巩 鹏军. All rights reserved.
//

#import "BTPageContainerView.h"

@implementation BTPageContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)setViewController:(UIViewController *)viewController
{
    UIViewController *parentViewController = _viewController.parentViewController;
    
    [_viewController willMoveToParentViewController:nil];
    [_viewController.view removeFromSuperview];
    [_viewController removeFromParentViewController];
    
    [_viewController release];
    [viewController retain];
    _viewController = viewController;
    
    [parentViewController addChildViewController:_viewController];
    
    _viewController.view.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    _viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_viewController.view];
    
    [_viewController didMoveToParentViewController:parentViewController];
}

@end
