//
//  BTPageViewController.m
//  BTPageViewControllerDemo
//
//  Created by 巩 鹏军 on 13-12-10.
//  Copyright (c) 2013年 巩 鹏军. All rights reserved.
//

#import "BTPageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BTPageContainerView.h"

@interface BTPageViewController () <UIScrollViewDelegate>
@property (retain, readonly, nonatomic) UIScrollView   *scrollView;
@property (retain, readonly, nonatomic) UIPageControl  *pageControl;
@property (retain, readonly, nonatomic) NSMutableArray *pageViews;
@property (assign, nonatomic) NSInteger numberOfPages;
@property (assign, nonatomic) NSInteger currentPage;
@end

@implementation BTPageViewController

- (void)dealloc
{
    [_scrollView release];
    [_pageControl release];
    [_pageViews release];
    [super dealloc];
}

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        CGRect frame = [[UIScreen mainScreen] bounds];
        
        self.wantsFullScreenLayout = YES;
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.layer.masksToBounds = YES;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - 36 - 20, frame.size.width, 36)];
        _pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [_pageControl addTarget:self action:@selector(pageControlPageDidChange:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_pageControl];
        
        _pageViews = [[NSMutableArray alloc] init];
        _currentPage = 0;
    }
    return self;
}

- (void)reloadData
{
    self.numberOfPages = [self.dataSource numberOfPagesInPageViewController:self];
    NSAssert(self.numberOfPages >= 0, @"Error: Number of pages in BTPageViewController < 0!");
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * self.numberOfPages, _scrollView.frame.size.height);
    _pageControl.numberOfPages = self.numberOfPages;
    
    CGSize mySize = self.scrollView.bounds.size;
    BTPageContainerView* containerView = nil;
    for(NSUInteger i = 0; i < self.numberOfPages; i++)
    {
        containerView = [[BTPageContainerView alloc] initWithFrame:self.view.bounds];
        containerView.frame = CGRectMake(mySize.width*i, 0, mySize.width, mySize.height);
        [_scrollView addSubview:containerView];
        [_pageViews addObject:containerView];
        [containerView release];
    }

    self.currentPage = MAX(0, MIN(self.numberOfPages - 1, self.currentPage));
    
    [self loadViewControllers];
}

- (void)loadViewControllers
{
    BTPageContainerView* containerView = nil;
    for(NSInteger i = 0; i < self.numberOfPages; i++)
    {
        containerView = [_pageViews objectAtIndex:i];
        if(i == self.currentPage - 1 || i == self.currentPage || i == self.currentPage + 1)
        {
            if(!containerView.viewController)
                containerView.viewController = [self viewControllerForPage:i];
        }
        else
        {
            containerView.viewController = nil;
        }
    }
}

- (void)pageControlPageDidChange:(UIPageControl *)pageControl
{
    [self scrollToPageWithIndex:pageControl.currentPage animated:YES];
}

- (void)scrollToPageWithIndex:(NSUInteger)pageIndex animated:(BOOL)animated
{
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * pageIndex;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:animated];
    
    self.currentPage = pageIndex;
    [self loadViewControllers];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2.0) / pageWidth) + 1;
	_pageControl.currentPage = page;
    
    self.currentPage = page;
    [self loadViewControllers];
}

- (UIViewController *)viewControllerForPage:(NSInteger)page
{
    UIViewController *controller = nil;
    
    if (page >= 0 && page < self.numberOfPages) {
        controller = [self.dataSource pageViewController:self viewControllerForPage:page];
    }
    
    return controller;
}


@end
