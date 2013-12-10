//
//  BTPageViewController.h
//  BTPageViewControllerDemo
//
//  Created by 巩 鹏军 on 13-12-10.
//  Copyright (c) 2013年 巩 鹏军. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTPageViewController;

@protocol BTPageViewControllerDataSource <NSObject>
@required
- (NSInteger)numberOfPagesInPageViewController:(BTPageViewController *)pageViewController;
- (UIViewController *)pageViewController:(BTPageViewController *)pageViewController viewControllerForPage:(NSInteger)page;
@end


@protocol BTPageViewControllerDelegate <UIScrollViewDelegate>
@optional
- (void)pageViewController:(BTPageViewController *)pageViewController willScrollToPage:(NSInteger)toPage toController:(UIViewController *)toController;
- (void)pageViewController:(BTPageViewController *)pageViewController didScrollToPage:(NSInteger)toPage toController:(UIViewController *)toController;
- (void)pageViewController:(BTPageViewController *)pageViewController didTapOnPage:(NSInteger)page controller:(UIViewController *)controller;
- (void)pageViewController:(BTPageViewController *)pageViewController didScrollToOffset:(CGFloat)offset;
@end


@interface BTPageViewController : UIViewController

@property (assign, nonatomic) id<BTPageViewControllerDataSource> dataSource;
@property (assign, nonatomic) id<BTPageViewControllerDelegate>   delegate;

- (id)init;
- (void)reloadData;

@end
