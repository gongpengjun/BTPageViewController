//
//  BTPageViewController.h
//  BTPageViewControllerDemo
//
//  Created by 巩 鹏军 on 13-12-10.
//  Copyright (c) 2013年 巩 鹏军. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTPageViewController;
@class BTPageContainerView;

typedef void (^CompletionBlock)(void);

typedef enum {
    //! Load previous/next when needed (when revealing starts). Release when not needed. Keeps only current view controller in memory.
    BTPreloadLevelLoadAndRelease,
    
    //! Load previous/next when needed (when revealing starts) and keep cached while they stay being previous/current/next.
    BTPreloadLevelLoadAndKeep,
    
    //! Preload previous and next view controller. Previous, current and next view controller are always cached in memory.
    BTPreloadLevelPreload
    
} BTPreloadLevel;

@protocol BTPageViewControllerDataSource <NSObject>
@required
- (NSInteger)numberOfPagesInPageViewController:(BTPageViewController *)pageViewController;
- (UIViewController *)pageViewController:(BTPageViewController *)pageViewController viewControllerForPage:(NSInteger)page;
@end


@protocol BTPageViewControllerDelegate <NSObject>
@optional
- (void)pageViewController:(BTPageViewController *)pageViewController willScrollToPage:(NSInteger)toPage toController:(UIViewController *)toController;
- (void)pageViewController:(BTPageViewController *)pageViewController didScrollToPage:(NSInteger)toPage toController:(UIViewController *)toController;
- (void)pageViewController:(BTPageViewController *)pageViewController didTapOnPage:(NSInteger)page controller:(UIViewController *)controller;
- (void)pageViewController:(BTPageViewController *)pageViewController didScrollToOffset:(CGFloat)offset;
@end


@interface BTPageViewController : UIViewController

@property (assign, nonatomic) NSInteger numberOfPages;
@property (assign, nonatomic) id<BTPageViewControllerDataSource> dataSource;
@property (assign, nonatomic) id<BTPageViewControllerDelegate> delegate;
@property (strong, nonatomic) BTPageContainerView *previousViewContainer;
@property (retain, nonatomic, readonly) UIViewController *currentViewController;
@property (strong, nonatomic) BTPageContainerView *nextViewContainer;
@property (strong, nonatomic) BTPageContainerView *currentViewContainer;
@property (assign, nonatomic) NSInteger currentPage;

@property (assign, nonatomic) CGFloat sidePagesSpaceDelayRate;
@property (assign, nonatomic) CGFloat borderPageMaxIndent;

// Methods
- (id)initWithOptions:(NSDictionary *)options;
- (void)reloadData;

- (void)loadPreviousViewController;
- (void)loadNextViewController;
- (void)shiftContainersLeft;
- (void)shiftContainersRight;

- (void)willScrollToPage:(NSInteger)toPage toController:(UIViewController *)toController;
- (void)didScrollToPage:(NSInteger)toPage toController:(UIViewController *)toController;
- (void)didTapOnPage:(NSInteger)page controller:(UIViewController *)controller;
- (void)didScrollToOffset:(CGFloat)offset;

- (void)animateToRestAndMakeAppearanceUpdates:(CompletionBlock)completion;
@end
