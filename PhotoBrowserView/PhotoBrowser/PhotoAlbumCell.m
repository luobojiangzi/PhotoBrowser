//
//  TimePhotoAlbumCell.m
//  PhotoBrowserView
//
//  Created by zhihuili on 2018/12/17.
//  Copyright © 2018 denghui. All rights reserved.
//

#import "PhotoAlbumCell.h"

@interface PhotoAlbumCell ()

@property(weak,nonatomic)UIButton *photoBtn;

@end

@implementation PhotoAlbumCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor blackColor];
        UIButton *photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(7, 0, frame.size.width, frame.size.height)];
        [photoBtn addTarget:self action:@selector(photo:) forControlEvents:UIControlEventTouchUpInside];
        photoBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:photoBtn];
        self.photoBtn = photoBtn;
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];

}
-(void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    [self.photoBtn sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"iconDefault_child"]];
}
-(void)photo:(UIButton *)sender{
    CGRect rect = [self convertRect:sender.frame toView:[UIApplication sharedApplication].keyWindow];
    NSLog(@"rect=%@",NSStringFromCGRect(rect));
    
    if (self.photoBlock) {
        self.photoBlock(rect);
    }
}
@end
