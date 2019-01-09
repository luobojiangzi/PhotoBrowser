//
//  UIView+ZHFrame.m
//  PhotoBrowserView
//
//  Created by zhihuili on 2019/1/8.
//  Copyright © 2019 智慧  李. All rights reserved.
//

#import "UIView+ZHFrame.h"

@implementation UIView (ZHFrame)

- (CGFloat)zh_x {
    return self.frame.origin.x;
}

- (void)setZh_x:(CGFloat)zh_x {
    CGRect newFrame   = self.frame;
    newFrame.origin.x = zh_x;
    self.frame        = newFrame;
}

- (CGFloat)zh_y {
    return self.frame.origin.y;
}

- (void)setZh_y:(CGFloat)zh_y {
    CGRect newFrame   = self.frame;
    newFrame.origin.y = zh_y;
    self.frame        = newFrame;
}

- (CGFloat)zh_width {
    return CGRectGetWidth(self.bounds);
}

- (void)setZh_width:(CGFloat)zh_width {
    CGRect newFrame     = self.frame;
    newFrame.size.width = zh_width;
    self.frame          = newFrame;
}

- (CGFloat)zh_height {
    return CGRectGetHeight(self.bounds);
}

- (void)setZh_height:(CGFloat)zh_height {
    CGRect newFrame      = self.frame;
    newFrame.size.height = zh_height;
    self.frame           = newFrame;
}

- (CGFloat)zh_top {
    return self.frame.origin.y;
}

- (void)setZh_top:(CGFloat)zh_top {
    CGRect newFrame   = self.frame;
    newFrame.origin.y = zh_top;
    self.frame        = newFrame;
}

- (CGFloat)zh_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setZh_bottom:(CGFloat)zh_bottom {
    CGRect newFrame   = self.frame;
    newFrame.origin.y = zh_bottom - self.frame.size.height;
    self.frame        = newFrame;
}

- (CGFloat)zh_left {
    return self.frame.origin.x;
}

- (void)setZh_left:(CGFloat)zh_left {
    CGRect newFrame   = self.frame;
    newFrame.origin.x = zh_left;
    self.frame        = newFrame;
}

- (CGFloat)zh_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setZh_right:(CGFloat)zh_right {
    CGRect newFrame   = self.frame;
    newFrame.origin.x = zh_right - self.frame.size.width;
    self.frame        = newFrame;
}

- (CGFloat)zh_centerX {
    return self.center.x;
}

- (void)setZh_centerX:(CGFloat)zh_centerX {
    CGPoint newCenter = self.center;
    newCenter.x       = zh_centerX;
    self.center       = newCenter;
}

- (CGFloat)zh_centerY {
    return self.center.y;
}

- (void)setZh_centerY:(CGFloat)zh_centerY {
    CGPoint newCenter = self.center;
    newCenter.y       = zh_centerY;
    self.center       = newCenter;
}

- (CGPoint)zh_origin {
    return self.frame.origin;
}

- (void)setZh_origin:(CGPoint)zh_origin {
    CGRect newFrame = self.frame;
    newFrame.origin = zh_origin;
    self.frame      = newFrame;
}

- (CGSize)zh_size {
    return self.frame.size;
}

- (void)setZh_size:(CGSize)zh_size {
    CGRect newFrame = self.frame;
    newFrame.size   = zh_size;
    self.frame      = newFrame;
}

@end
