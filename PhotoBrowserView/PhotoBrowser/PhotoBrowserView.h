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
/*  
*   rect 点击图片在屏幕上的位置
*   imageUrlArr 网络图片数组
*   currentIndex 点击的第几个
*   removeBlock 删除的回调
*/
+(void)showWithCGRect:(CGRect)rect imageUrlArr:(NSArray *)imageUrlArr currentIndex:(NSInteger)currentIndex photoCallback:(removeAction)removeBlock;

+(void)hidden;

@end
