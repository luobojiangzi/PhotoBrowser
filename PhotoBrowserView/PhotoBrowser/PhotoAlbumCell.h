//
//  TimePhotoAlbumCell.h
//  PhotoBrowserView
//
//  Created by zhihuili on 2018/12/17.
//  Copyright © 2018 denghui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^photoAction)(CGRect rect);

@interface PhotoAlbumCell : UICollectionViewCell

@property(copy,nonatomic)NSString *imageUrl;
@property(copy,nonatomic)photoAction photoBlock;

@end
