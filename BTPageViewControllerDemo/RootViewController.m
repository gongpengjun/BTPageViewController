//
//  RootViewController.m
//  BTPageViewControllerDemo
//
//  Created by 巩 鹏军 on 13-12-10.
//  Copyright (c) 2013年 巩 鹏军. All rights reserved.
//

#import "RootViewController.h"
#import "BTPageViewController.h"
#import "TestViewController.h"

@interface RootViewController () <BTPageViewControllerDataSource, BTPageViewControllerDelegate>

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    BTPageViewController *pageViewController = [[BTPageViewController alloc] initWithOptions:nil];
    pageViewController.dataSource = self;
    pageViewController.delegate = self;
    [self.view addSubview:pageViewController.view];
    [self addChildViewController:pageViewController];
    [pageViewController release];
    
    [pageViewController reloadData];
    
}

- (NSInteger)numberOfPagesInPageViewController:(BTPageViewController *)pageViewController
{
    return 6;
}

- (UIViewController *)pageViewController:(BTPageViewController *)pageViewController viewControllerForPage:(NSInteger)page
{
    UIViewController *controller = [[[TestViewController alloc] init] autorelease];
    UILabel *label = [[UILabel alloc] initWithFrame:controller.view.bounds];
    label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"This is page number %d", page];
    //label.backgroundColor = [UIColor colorWithHue:arc4random()/(float)UINT32_MAX saturation:arc4random()/(float)UINT32_MAX brightness:1 alpha:1];
    switch (page) {
        default:
        case 0:
            label.backgroundColor = [UIColor orangeColor];
            break;
        case 1:
            label.backgroundColor = [UIColor purpleColor];
            break;
        case 2:
            label.backgroundColor = [UIColor brownColor];
            break;
        case 3:
            label.backgroundColor = [UIColor redColor];
            break;
        case 4:
            label.backgroundColor = [UIColor greenColor];
            break;
            
        case 5:
            label.backgroundColor = [UIColor blueColor];
            break;
    }
    [controller.view addSubview:label];
    return controller;
}

- (void)pageViewController:(BTPageViewController *)pageViewController willScrollToPage:(NSInteger)toPage toController:(UIViewController *)toController
{
    DLog(@"fired. page %d", toPage);
}

- (void)pageViewController:(BTPageViewController *)pageViewController didScrollToPage:(NSInteger)toPage toController:(UIViewController *)toController
{
    DLog(@"fired. page %d", toPage);
}

- (void)pageViewController:(BTPageViewController *)pageViewController didTapOnPage:(NSInteger)page controller:(UIViewController *)controller
{
    DLog(@"fired. page %d", page);
}

- (void)pageViewController:(BTPageViewController *)pageViewController didScrollToOffset:(CGFloat)offset
{
    //DLog(@"fired. offset: %f", offset);
}

@end
