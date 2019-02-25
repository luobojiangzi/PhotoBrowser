//
//  UIView+ZHFrame.h
//  PhotoBrowserView
//
//  Created by zhihuili on 2019/1/8.
//  Copyright © 2019 智慧  李. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIView (ZHFrame)

@property (nonatomic) CGFloat zh_x;
@property (nonatomic) CGFloat zh_y;
@property (nonatomic) CGFloat zh_width;
@property (nonatomic) CGFloat zh_height;

@property (nonatomic) CGFloat zh_top;
@property (nonatomic) CGFloat zh_bottom;
@property (nonatomic) CGFloat zh_left;
@property (nonatomic) CGFloat zh_right;

@property (nonatomic) CGFloat zh_centerX;
@property (nonatomic) CGFloat zh_centerY;

@property (nonatomic) CGPoint zh_origin;
@property (nonatomic) CGSize  zh_size;

@end
