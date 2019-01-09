//
//  PhotoBrowserView.m
//  PhotoBrowserView
//
//  Created by zhihuili on 2018/12/17.
//  Copyright © 2018 denghui. All rights reserved.
//

#import "PhotoBrowserView.h"
#import "AppDelegate.h"

@interface PhotoBrowserView ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
//保存图片的过程指示菊花
@property (nonatomic , strong) UIActivityIndicatorView  *indicatorView;
//保存图片的结果指示label
@property (nonatomic , strong) UILabel *savaImageTipLabel;

@property(nonatomic,weak)UIView *translucentView;
@property(strong,nonatomic)UIView *topView;
@property(weak,nonatomic)UILabel *indexLabel;
@property(strong,nonatomic)UIScrollView *scrollView;
@property(strong,nonatomic)UICollectionView *collectionView;
@property(nonatomic,copy)removeAction removeBlock;
@property(strong,nonatomic)NSMutableArray *imageUrlArr;
@property(strong,nonatomic)NSMutableArray *imageViewArr;
@property(assign,nonatomic)NSInteger currentIndex;
@end

static NSString *PhotoBrowserViewCellRI = @"PhotoBrowserViewCellRI";

#define imageRowCount 5

@implementation PhotoBrowserView

+(void)showWithCGRect:(CGRect)rect imageUrlArr:(NSArray *)imageUrlArr currentIndex:(NSInteger)currentIndex photoCallback:(removeAction)removeBlock{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    PhotoBrowserView *photoBrowserView = [[PhotoBrowserView alloc] initWithFrame:[UIScreen mainScreen].bounds CGRect:rect imageUrlArr:imageUrlArr currentIndex:currentIndex];
    photoBrowserView.removeBlock = removeBlock;
    [appDelegate.window addSubview:photoBrowserView];
}
+(void)hidden{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    for (UIView *view in appDelegate.window.subviews) {
        if ([view isKindOfClass:[PhotoBrowserView class]]) {
            PhotoBrowserView *photoBrowserView = (PhotoBrowserView *)view;
            [UIView animateWithDuration:0.3 animations:^{
                photoBrowserView.alpha = 0;
            } completion:^(BOOL finished) {
                [photoBrowserView removeFromSuperview];
            }];
            return;
        }
    }
}
-(void)tapClick{
    [PhotoBrowserView hidden];
}
-(void)back{
    [PhotoBrowserView hidden];
}
-(void)delete{
    //展示的最后一个
    NSLog(@"currentIndex = %zd",self.currentIndex);
    if (self.removeBlock) {
        self.removeBlock(self.currentIndex);
    }
    if (self.imageUrlArr.count==1) {
        [PhotoBrowserView hidden];
        return;
    }
    [self reloadScrollView];
    [self reloadCollectionView];
    self.indexLabel.text = [NSString stringWithFormat:@"%zd/%zd",self.currentIndex+1,self.imageUrlArr.count];
}
-(void)reloadScrollView{
    for (int i = 0; i<self.imageViewArr.count; ++i) {
        if (i==self.currentIndex) {
            UIImageView *currentImageView = self.imageViewArr[self.currentIndex];
            [currentImageView removeFromSuperview];
        }
        if (i>self.currentIndex) {
            UIImageView *imageView = self.imageViewArr[i];
            imageView.frame = CGRectMake(kWidth*(i-1), 0, kWidth, kWidth);
        }
    }
    [self.imageViewArr removeObjectAtIndex:self.currentIndex];
    if (self.currentIndex==self.imageUrlArr.count-1) {
        [self.scrollView setContentOffset:CGPointMake(kWidth*self.currentIndex-1, 0) animated:YES];
    }else{
        [self.scrollView setContentOffset:CGPointMake(kWidth*self.currentIndex, 0) animated:YES];
    }
    [self.scrollView setContentSize:CGSizeMake((self.imageUrlArr.count-1)*kWidth, 0)];
}
-(void)reloadCollectionView{
    if (self.currentIndex==self.imageUrlArr.count-1) {
        [self.imageUrlArr removeObjectAtIndex:self.currentIndex];
        self.currentIndex--;
    }else{
        [self.imageUrlArr removeObjectAtIndex:self.currentIndex];
    }
    [self.collectionView reloadData];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;{
    [self.indicatorView removeFromSuperview];
    self.savaImageTipLabel.center = self.center;
    [self addSubview:self.savaImageTipLabel];
    if (error) {
        self.savaImageTipLabel.text = @"保存失败";
    } else {
        self.savaImageTipLabel.text = @"保存成功";
    }
    [self.savaImageTipLabel performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}
-(void)save{
    NSURL *url = [NSURL URLWithString: self.imageUrlArr[self.currentIndex]];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    __block UIImage *img;
    [manager diskImageExistsForURL:url completion:^(BOOL isInCache) {
        if (isInCache) {
            img =  [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
        } else {
            //从网络下载图片
            NSData *data = [NSData dataWithContentsOfURL:url];
            img = [UIImage imageWithData:data];
        }
        // 保存图片到相册中
        UIImageWriteToSavedPhotosAlbum(img,self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
        self.indicatorView.center = self.center;
        [self addSubview:self.indicatorView];
        [self.indicatorView startAnimating];
    }];
}

-(instancetype)initWithFrame:(CGRect)frame CGRect:(CGRect)rect imageUrlArr:(NSArray *)imageUrlArr currentIndex:(NSInteger)currentIndex{
    if (self=[super initWithFrame:frame]) {
        self.currentIndex = currentIndex;
        self.imageUrlArr = imageUrlArr.mutableCopy;
//        self.alpha = 0;
        
        UIView *translucentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        translucentView.backgroundColor = [UIColor blackColor];
        translucentView.alpha = 0.0;
//        [translucentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)]];
        [self addSubview:translucentView];
        self.translucentView = translucentView;
        
        UIImageView *animationImageView = [[UIImageView alloc] initWithFrame:rect];
        [animationImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imageUrlArr[currentIndex]]] placeholderImage:[UIImage imageNamed:@"iconDefault_child"]];
        animationImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:animationImageView];
        
        [UIView animateWithDuration:0.3 animations:^{
            translucentView.alpha = 1.0;
            animationImageView.frame = CGRectMake(0, 48+NavBar_Height, kWidth, kWidth);
        } completion:^(BOOL finished) {
            [animationImageView removeFromSuperview];
            [self setupUI];
        }];
        
    }
    return self;
}

-(void)setupUI{
    [self addSubview:self.topView];
    [self addSubview:self.collectionView];
    [self addSubview:self.scrollView];
    [self.scrollView setContentOffset:CGPointMake(kWidth*self.currentIndex, 0) animated:NO];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView==self.collectionView) {
        return;
    }
    CGFloat pageWidth = scrollView.frame.size.width;
    
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    //右滑
    BOOL isLeftScroll;
    if (self.currentIndex>page) {
        isLeftScroll = NO;
    }else{
        isLeftScroll = YES;
    }
    
    NSLog(@"page=%ld  isLeftScroll=%d ",page,isLeftScroll);
    
    self.currentIndex = page;
    self.indexLabel.text = [NSString stringWithFormat:@"%zd/%zd",self.currentIndex+1,self.imageUrlArr.count];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
//    if (isLeftScroll) {
//        if (page%imageRowCount==0) {
//            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
//        }
//    } else {
//        if ((page+1)%imageRowCount==0||page%imageRowCount==0) {
//            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:page-3 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
//        }
//    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageUrlArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoBrowserViewCellRI forIndexPath:indexPath];
    cell.imageUrl = self.imageUrlArr[indexPath.item];
    @weakify(self)
    cell.photoBlock = ^(CGRect rect) {
        @strongify(self)
        self.currentIndex = indexPath.item;
        self.indexLabel.text = [NSString stringWithFormat:@"%zd/%zd",indexPath.item+1,self.imageUrlArr.count];
        [self.scrollView setContentOffset:CGPointMake(kWidth*indexPath.item, 0) animated:YES];
        if (indexPath.item==self.imageUrlArr.count-1&&self.imageUrlArr.count%imageRowCount) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
    };
    return cell;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 7);
        flowLayout.itemSize = CGSizeMake((kWidth)/imageRowCount, (kWidth)/imageRowCount);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat marginx = (kHeight-48-NavBar_Height-kWidth-((kWidth)/imageRowCount))*0.5;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 48+NavBar_Height+kWidth+marginx, kWidth,(kWidth)/imageRowCount) collectionViewLayout:flowLayout];
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[PhotoAlbumCell class] forCellWithReuseIdentifier:PhotoBrowserViewCellRI];
        _collectionView.delegate = self;//和self.scrollView冲突
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 48+NavBar_Height, kWidth, kWidth)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.imageUrlArr.count*kWidth, 0);
        _scrollView.scrollEnabled = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:self.imageUrlArr.count];
        UIView *relyView = _scrollView;
        for (int i = 0; i<self.imageUrlArr.count; ++i) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth*i, 0, kWidth, kWidth)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imageUrlArr[i]]] placeholderImage:[UIImage imageNamed:@"iconDefault_child"]];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [_scrollView addSubview:imageView];
            [tempArr addObject:imageView];
            relyView = imageView;
        }
        self.imageViewArr = tempArr;
    }
    return _scrollView;
}

-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, NavBar_Height)];
        
        UIButton *backBtn = [[UIButton alloc] init];
        backBtn.zh_size = CGSizeMake(22, 22);
        backBtn.zh_centerY = _topView.zh_centerY;
        backBtn.zh_left = 17;
        [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:backBtn];
        
        UILabel *indexLabel = [[UILabel alloc] init];
        indexLabel.textColor = [UIColor whiteColor];
        indexLabel.font = [UIFont boldSystemFontOfSize:16];
        indexLabel.text = [NSString stringWithFormat:@"%zd/%zd",self.currentIndex+1,self.imageUrlArr.count];
        indexLabel.textAlignment = NSTextAlignmentCenter;
        indexLabel.bounds = CGRectMake(0, 0, 150, 30);
        indexLabel.center = _topView.center;
        [_topView addSubview:indexLabel];
        self.indexLabel = indexLabel;
   
        UIButton *deleteBtn = [[UIButton alloc] init];
        [deleteBtn setImage:[UIImage imageNamed:@"shanchu"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.zh_size = CGSizeMake(19, 19);
        deleteBtn.zh_centerY = _topView.zh_centerY;
        deleteBtn.zh_right = kWidth-17;
        [_topView addSubview:deleteBtn];
   
        UIButton *saveBtn = [[UIButton alloc] init];
        [saveBtn setImage:[UIImage imageNamed:@"xiazai"] forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        saveBtn.zh_size = CGSizeMake(18, 20);
        saveBtn.zh_centerY = _topView.zh_centerY;
        saveBtn.zh_right = deleteBtn.zh_left-30;
        [_topView addSubview:saveBtn];

    }
    return _topView;
}
- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] init];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    }
    return _indicatorView;
}

- (UILabel *)savaImageTipLabel{
    if (_savaImageTipLabel == nil) {
        _savaImageTipLabel = [[UILabel alloc] init];
        _savaImageTipLabel.textColor = [UIColor whiteColor];
        _savaImageTipLabel.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
        _savaImageTipLabel.textAlignment = NSTextAlignmentCenter;
        _savaImageTipLabel.font = [UIFont boldSystemFontOfSize:17];
        _savaImageTipLabel.bounds = CGRectMake(0, 0, 150, 30);
    }
    return _savaImageTipLabel;
}

@end
