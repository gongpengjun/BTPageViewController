//
//  UIView+Position.m
//  BTPageViewControllerDemo
//
//  Created by 巩 鹏军 on 13-12-10.
//  Copyright (c) 2013年 巩 鹏军. All rights reserved.
//

#import "UIView+Position.h"

@implementation UIView (Position)
- (void)setSize:(CGSize)size { self.frame = CGRectMake(self.origin.x, self.origin.y, size.width, size.height); }
- (CGSize)size { return self.frame.size; }
- (void)setOrigin:(CGPoint)origin { self.frame = CGRectMake(origin.x, origin.y, self.size.width, self.size.height); }
- (CGPoint)origin { return self.frame.origin; }
@end
