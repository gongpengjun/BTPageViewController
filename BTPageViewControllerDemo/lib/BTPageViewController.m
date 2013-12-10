//
//  BTPageViewController.m
//  BTPageViewControllerDemo
//
//  Created by 巩 鹏军 on 13-12-10.
//  Copyright (c) 2013年 巩 鹏军. All rights reserved.
//

#import "BTPageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BTSwipeGestureRecognizer.h"
#import "BTPageContainerView.h"
#import "UIView+Position.h"

@interface BTPageViewController ()
@property (strong, nonatomic) UIViewController *needsAppearanceUpdateViewController;
@property (strong, nonatomic) BTSwipeGestureRecognizer *swipeGestureRecognizer;

@property (strong, nonatomic) NSMutableDictionary *options;

@property (assign, nonatomic) BOOL isAnimatingToRest;
@end

@implementation BTPageViewController

- (void)dealloc
{
    self.previousViewContainer = nil;
    self.currentViewContainer = nil;
    self.nextViewContainer = nil;
    [super dealloc];
}

- (id)initWithOptions:(NSDictionary *)options
{
    self.options = [options mutableCopy];
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        [self initializePrivateProperties];
        
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.layer.masksToBounds = YES;
        
        [self loadContainerViews];
        
        /* This guy provides swiping mechanism */
        self.swipeGestureRecognizer = [[BTSwipeGestureRecognizer alloc] initWithPageViewController:self];
        [self.view addGestureRecognizer:self.swipeGestureRecognizer];
        
    }
    return self;
}

- (BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers
{
    return NO;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}

- (BOOL)shouldAutomaticallyForwardRotationMethods
{
    return NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Properties

- (void)initializePrivateProperties
{
    self.isAnimatingToRest = NO;
    self.wantsFullScreenLayout = YES;
    self.currentPage = 0;
}

- (UIColor *)frontPageShadowColor
{
    return nil;
}

- (CGFloat)frontPageShadowOpacity
{
    return 0.0f;
}

- (CGFloat)frontPageShadowRadius
{
    return 0.0f;
}

- (UIEdgeInsets)frontPageInsets
{
    return UIEdgeInsetsZero;
}

- (CGFloat)sidePagesSpaceDelayRate
{
    return 0.0f;
}

- (CGFloat)borderPageMaxIndent
{
    return 0.0f;
}

- (BTPreloadLevel)preloadLevel
{
    return BTPreloadLevelLoadAndRelease;
}

- (UIViewController *)currentViewController
{
    return self.currentViewContainer.viewController;
}

#pragma mark - View handling

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)loadContainerViews
{
    self.previousViewContainer = [[BTPageContainerView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.previousViewContainer];
    
    self.nextViewContainer = [[BTPageContainerView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.nextViewContainer];
    
    self.currentViewContainer = [[BTPageContainerView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.currentViewContainer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self removeQuartzCoreEffects:self.currentViewContainer];
    
    [self.currentViewContainer.viewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.previousViewContainer.viewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.nextViewContainer.viewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self applyQuartzCoreEffects:self.currentViewContainer];
    [self layoutForDragging];
    
    [self.currentViewContainer.viewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.previousViewContainer.viewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.nextViewContainer.viewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (self.currentViewContainer.viewController) {
        return [self.currentViewContainer.viewController supportedInterfaceOrientations];
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (self.currentViewContainer.viewController) {
        return [self.currentViewContainer.viewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    } else {
        return YES;
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self layoutForDragging];
}

- (void)layoutForDragging
{
    [self.view sendSubviewToBack:self.previousViewContainer];
    [self.view sendSubviewToBack:self.nextViewContainer];
    
    CGSize mySize = self.view.bounds.size;
    self.previousViewContainer.frame = UIEdgeInsetsInsetRect(CGRectMake(-mySize.width * self.sidePagesSpaceDelayRate, 0, mySize.width, mySize.height), self.frontPageInsets);
    self.nextViewContainer.frame = UIEdgeInsetsInsetRect(CGRectMake(mySize.width * self.sidePagesSpaceDelayRate, 0, mySize.width, mySize.height), self.frontPageInsets);
    self.currentViewContainer.frame = UIEdgeInsetsInsetRect(CGRectMake(0, 0, mySize.width, mySize.height), self.frontPageInsets);
    [self updateQuartzCoreEffects:self.currentViewContainer];
}

- (void)setCurrentViewContainer:(BTPageContainerView *)currentViewContainer
{
    [self removeQuartzCoreEffects:_currentViewContainer];
    _currentViewContainer = currentViewContainer;
    [self applyQuartzCoreEffects:_currentViewContainer];
}

- (void)updateQuartzCoreEffects:(UIView *)view
{
    return;
    view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
}

- (void)applyQuartzCoreEffects:(UIView *)view
{
    return;
    view.layer.shadowColor = self.frontPageShadowColor.CGColor;
    view.layer.shadowRadius = self.frontPageShadowRadius;
    view.layer.shadowOpacity = self.frontPageShadowOpacity;
    view.layer.shadowOffset = CGSizeMake(0, 0);
    view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
}

- (void)removeQuartzCoreEffects:(UIView *)view
{
    return;
    view.layer.shadowRadius = 0;
    view.layer.shadowOpacity = 0;
    view.layer.shadowOffset = CGSizeMake(0, 0);
    view.layer.shadowPath = nil;
}

- (void)animateToRestAndMakeAppearanceUpdates:(CompletionBlock)completion
{
    self.isAnimatingToRest = YES;
    [UIView animateWithDuration:0.185 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutForDragging];
    } completion:^(BOOL finished) {
        
        // if for some reason not properly ended, try again
        if (ABS(self.currentViewContainer.origin.x - [self frontPageInsets].left) > 1.0) {
            [self animateToRestAndMakeAppearanceUpdates:completion];
            return;
        }
        
        self.isAnimatingToRest = NO;
        
        if ([self preloadLevel] == BTPreloadLevelLoadAndRelease) {
            self.previousViewContainer.viewController = self.nextViewContainer.viewController = nil;
        }
        
        if (self.needsAppearanceUpdateViewController) {
            [self.needsAppearanceUpdateViewController endAppearanceTransition];
            self.needsAppearanceUpdateViewController = nil;
            [self.currentViewContainer.viewController endAppearanceTransition];
        }
        
        completion();
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(simulateDidScroll:) userInfo:nil repeats:YES];
}

- (void)simulateDidScroll:(id)timer
{
    if (self.isAnimatingToRest) {
        [self didScrollToOffset:[self.currentViewContainer.layer.presentationLayer frame].origin.x];
    } else {
        [self didScrollToOffset:self.currentViewContainer.frame.origin.x];
        [timer invalidate];
    }
}

#pragma mark - Data handling

- (void)reloadData
{
    self.numberOfPages = [self.dataSource numberOfPagesInPageViewController:self];
    NSAssert(self.numberOfPages >= 0, @"Error: Number of pages in BTPageViewController < 0!");
    
    self.currentPage = MAX(0, MIN(self.numberOfPages - 1, self.currentPage));
    
    if (self.numberOfPages > 0) {
        self.currentViewContainer.viewController = [self viewControllerForPage:self.currentPage];
        
        if ([self preloadLevel] == BTPreloadLevelPreload && self.currentPage > 0) {
            self.previousViewContainer.viewController = [self viewControllerForPage:self.currentPage-1];
        }
        
        if ([self preloadLevel] == BTPreloadLevelPreload && self.currentPage < self.numberOfPages - 1) {
            self.nextViewContainer.viewController = [self viewControllerForPage:self.currentPage+1];
        }
    }
    
    [self fixScrollingToTop];
}

- (void)shiftContainersRight
{
    [self willScrollToPage:self.currentPage+1 toController:self.nextViewContainer.viewController];
    
    self.currentPage++;
    BTPageContainerView *previousViewContainer = self.previousViewContainer;
    
    [self.currentViewContainer.viewController beginAppearanceTransition:NO animated:YES];
    [self.nextViewContainer.viewController beginAppearanceTransition:YES animated:YES];
    self.needsAppearanceUpdateViewController = self.currentViewContainer.viewController;
    
    self.previousViewContainer = self.currentViewContainer;
    self.currentViewContainer = self.nextViewContainer;
    self.nextViewContainer = previousViewContainer;
    
    if ([self preloadLevel] == BTPreloadLevelPreload) {
        [self loadNextViewController];
    } else if ([self preloadLevel] == BTPreloadLevelLoadAndKeep) {
        self.nextViewContainer.viewController = nil;
    }
    
    [self fixScrollingToTop];
}

- (void)shiftContainersLeft
{
    [self willScrollToPage:self.currentPage-1 toController:self.nextViewContainer.viewController];
    
    self.currentPage--;
    
    BTPageContainerView *nextViewContainer = self.nextViewContainer;
    
    [self.currentViewContainer.viewController beginAppearanceTransition:NO animated:YES];
    [self.previousViewContainer.viewController beginAppearanceTransition:YES animated:YES];
    self.needsAppearanceUpdateViewController = self.currentViewContainer.viewController;
    
    self.nextViewContainer = self.currentViewContainer;
    self.currentViewContainer = self.previousViewContainer;
    self.previousViewContainer = nextViewContainer;
    
    if ([self preloadLevel] == BTPreloadLevelPreload) {
        [self loadPreviousViewController];
    } else if ([self preloadLevel] == BTPreloadLevelLoadAndKeep) {
        self.previousViewContainer.viewController = nil;
    }
    
    [self fixScrollingToTop];
}

- (void)loadPreviousViewController
{
    self.previousViewContainer.viewController = [self viewControllerForPage:self.currentPage-1];
}

- (void)loadNextViewController
{
    self.nextViewContainer.viewController = [self viewControllerForPage:self.currentPage+1];
}

#pragma mark - Helper methods

- (void)setViewHierarchy:(UIView *)rootView scrollsToTop:(BOOL)scrollsToTop maxLevel:(NSInteger)maxLevel
{
    if (maxLevel < 0) return;
    if ([rootView isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView *)rootView setScrollsToTop:scrollsToTop];
    } else {
        for (UIView *view in [rootView subviews]) {
            [self setViewHierarchy:view scrollsToTop:scrollsToTop maxLevel:maxLevel-1];
        }
    }
}

- (void)fixScrollingToTop
{
    [self setViewHierarchy:self.currentViewContainer.viewController.view scrollsToTop:YES maxLevel:2];
    [self setViewHierarchy:self.previousViewContainer.viewController.view scrollsToTop:NO maxLevel:2];
    [self setViewHierarchy:self.nextViewContainer.viewController.view scrollsToTop:NO maxLevel:2];
}

#pragma mark -- DataSource methods

- (UIViewController *)viewControllerForPage:(NSInteger)page
{
    UIViewController *controller = nil;
    
    if (page >= 0 && page < self.numberOfPages) {
        controller = [self.dataSource pageViewController:self viewControllerForPage:page];
    }
    
    return controller;
}


#pragma mark -- Delegate methods

- (void)willScrollToPage:(NSInteger)toPage toController:(UIViewController *)toController
{
    if ([self.delegate respondsToSelector:@selector(pageViewController:willScrollToPage:toController:)]) {
        [self.delegate pageViewController:self willScrollToPage:toPage toController:toController];
    }
}

- (void)didScrollToPage:(NSInteger)toPage toController:(UIViewController *)toController
{
    if ([self.delegate respondsToSelector:@selector(pageViewController:didScrollToPage:toController:)]) {
        [self.delegate pageViewController:self didScrollToPage:toPage toController:toController];
    }
}

- (void)didTapOnPage:(NSInteger)page controller:(UIViewController *)controller
{
    if ([self.delegate respondsToSelector:@selector(pageViewController:didTapOnPage:controller:)]) {
        [self.delegate pageViewController:self didTapOnPage:page controller:controller];
    }
}

- (void)didScrollToOffset:(CGFloat)offset
{
    if ([self.delegate respondsToSelector:@selector(pageViewController:didScrollToOffset:)]) {
        [self.delegate pageViewController:self didScrollToOffset:offset];
    }
}

@end
