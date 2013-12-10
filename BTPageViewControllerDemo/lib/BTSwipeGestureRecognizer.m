//
//  BTGestureRecognizer.m
//  BTPageViewControllerDemo
//
//  Created by 巩 鹏军 on 13-12-10.
//  Copyright (c) 2013年 巩 鹏军. All rights reserved.
//

#import "BTSwipeGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "BTPageContainerView.h"
#import "UIView+Position.h"

@implementation BTSwipeGestureRecognizer

- (id)initWithPageViewController:(BTPageViewController *)pageViewController
{
    self = [super init];
    if (self) {
        self.pageViewController = pageViewController;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    self.previousTouchPoint = [touch locationInView:self.view];
    self.previousTouchTime = CFAbsoluteTimeGetCurrent();
    self.state = (self.previousTouchPoint.x > 20) ? UIGestureRecognizerStatePossible : UIGestureRecognizerStateFailed;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    
    if (self.state == UIGestureRecognizerStatePossible) {
        CGFloat dx = location.x - self.previousTouchPoint.x;
        CGFloat dy = location.y - self.previousTouchPoint.y;
        
        if (ABS(dx) > ABS(dy)) {
            self.state = UIGestureRecognizerStateBegan;
            
            // load view controllers
            if (dx > 0 && !self.pageViewController.previousViewContainer.viewController) {
                [self.pageViewController loadPreviousViewController];
            } else if (dx < 0 && !self.pageViewController.nextViewContainer.viewController){
                [self.pageViewController loadNextViewController];
            }
            
        } else {
            self.state = UIGestureRecognizerStateFailed;
        }
    } else if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
        CFAbsoluteTime time = CFAbsoluteTimeGetCurrent();
        
        CGFloat deltaX = location.x - self.previousTouchPoint.x;
        CFAbsoluteTime deltaT = time - self.previousTouchTime;
        
        UIView *view = self.pageViewController.currentViewContainer;
        view.origin = CGPointMake(view.origin.x + deltaX, view.origin.y);
        
        // load view controllers
        if (view.origin.x > 0 && !self.pageViewController.previousViewContainer.viewController) {
            [self.pageViewController loadPreviousViewController];
        } else if (view.origin.x < 0 && !self.pageViewController.nextViewContainer.viewController){
            [self.pageViewController loadNextViewController];
        }
        
        view = self.pageViewController.previousViewContainer;
        view.origin = CGPointMake(view.origin.x + deltaX * self.pageViewController.sidePagesSpaceDelayRate, view.origin.y);
        
        view = self.pageViewController.nextViewContainer;
        view.origin = CGPointMake(view.origin.x + deltaX * self.pageViewController.sidePagesSpaceDelayRate, view.origin.y);
        
        self.velocity = deltaX / deltaT;
        self.previousTouchPoint = location;
        self.previousTouchTime = CFAbsoluteTimeGetCurrent();
        
        if (self.pageViewController.currentPage == 0 && self.pageViewController.currentViewContainer.origin.x > self.pageViewController.borderPageMaxIndent) {
            self.pageViewController.currentViewContainer.origin = CGPointMake(self.pageViewController.borderPageMaxIndent, self.pageViewController.currentViewContainer.origin.y);
        } else if (self.pageViewController.currentPage == self.pageViewController.numberOfPages-1 && self.pageViewController.currentViewContainer.origin.x < -self.pageViewController.borderPageMaxIndent) {
            self.pageViewController.currentViewContainer.origin = CGPointMake(-self.pageViewController.borderPageMaxIndent, self.pageViewController.currentViewContainer.origin.y);
        }
        
        [self.pageViewController didScrollToOffset:self.pageViewController.currentViewContainer.frame.origin.x];
        
        self.state = UIGestureRecognizerStateChanged;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
        BOOL pageChanged = NO;
        
        UIView *curentVCView = self.pageViewController.currentViewContainer;
        if (curentVCView.origin.x > curentVCView.size.width / 2 && self.pageViewController.currentPage > 0) {
            [self.pageViewController shiftContainersLeft];
            pageChanged = YES;
        } else if (curentVCView.origin.x < -curentVCView.size.width / 2 && self.pageViewController.currentPage < self.pageViewController.numberOfPages-1) {
            [self.pageViewController shiftContainersRight];
            pageChanged = YES;
        } else if (ABS(self.velocity) > 1000) {
            if (self.velocity < 0) {
                if (self.pageViewController.currentPage < self.pageViewController.numberOfPages-1) {
                    [self.pageViewController shiftContainersRight];
                    pageChanged = YES;
                }
            } else if (self.pageViewController.currentPage > 0) {
                [self.pageViewController shiftContainersLeft];
                pageChanged = YES;
            }
        }
        
        [self.pageViewController animateToRestAndMakeAppearanceUpdates:^{
            self.state = UIGestureRecognizerStateEnded;
            if (pageChanged) {
                [self.pageViewController didScrollToPage:self.pageViewController.currentPage toController:self.pageViewController.currentViewContainer.viewController];
            }
        }];
    } else {
        self.state = UIGestureRecognizerStateCancelled;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
        return NO;
    } else {
        return YES;
    }
}

@end
