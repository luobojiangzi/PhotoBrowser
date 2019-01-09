//
//  PhotoBrowserView.h
//  PhotoBrowserView
//
//  Created by zhihuili on 2018/12/17.
//  Copyright © 2018 denghui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAlbumCell.h"

typedef void(^removeAction)(NSInteger index);

@interface PhotoBrowserView : UIView

+(void)showWithCGRect:(CGRect)rect imageUrlArr:(NSArray *)imageUrlArr currentIndex:(NSInteger)currentIndex photoCallback:(removeAction)removeBlock;

+(void)hidden;

@end
