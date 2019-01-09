//
//  ViewController.m
//  PhotoBrowserView
//
//  Created by zhihuili on 2019/1/8.
//  Copyright © 2019 智慧  李. All rights reserved.
//

#import "ViewController.h"

#import "PhotoBrowserView.h"

static NSString *ViewControllerCellRI = @"ViewControllerCellRI";

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(weak,nonatomic)UICollectionView *collectionView;
@property(strong,nonatomic)NSMutableArray *imageUrlArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"SimplePhotoBrowser";
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 7);
    flowLayout.itemSize = CGSizeMake((kWidth-7)/4, (kWidth-7)/4);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NavBar_Height, kWidth,kHeight-NavBar_Height) collectionViewLayout:flowLayout];
    [collectionView registerClass:[PhotoAlbumCell class] forCellWithReuseIdentifier:ViewControllerCellRI];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;

}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageUrlArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ViewControllerCellRI forIndexPath:indexPath];
    cell.imageUrl = self.imageUrlArr[indexPath.item];
    @weakify(self)
    cell.photoBlock = ^(CGRect rect) {
        @strongify(self)
        [PhotoBrowserView showWithCGRect:rect imageUrlArr:self.imageUrlArr currentIndex:indexPath.item photoCallback:^(NSInteger index) {
            NSLog(@"index = %zd",index);
            [self.imageUrlArr removeObjectAtIndex:index];
            [collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
        }];
    };
    return cell;
}
-(NSMutableArray *)imageUrlArr{
    if (!_imageUrlArr) {
        _imageUrlArr = @[
                             @"http://pic15.nipic.com/20110727/8044451_163345277152_2.jpg",
                             @"http://img.zcool.cn/community/0199775a5203d3a8012180c54f2a65.jpg@2o.jpg",
                             @"http://img05.tooopen.com/images/20140404/sy_58241958989.jpg",
                             @"http://pic34.photophoto.cn/20150103/0030015284991808_b.jpg",
                             @"http://img4.imgtn.bdimg.com/it/u=2882284884,1913504836&fm=27&gp=0.jpg",
                             @"http://img07.tooopen.com/images/20170818/tooopen_sy_220999936848.jpg",
                             @"http://www.pptbz.com/pptpic/UploadFiles_6909/201211/2012111719294197.jpg",
                             @"http://img.bimg.126.net/photo/ZZ5EGyuUCp9hBPk6_s4Ehg==/5727171351132208489.jpg",
                             @"http://img.bimg.126.net/photo/V6nNeq8YN2xPBRxTz8w4VA==/5776429472056759812.jpg"
                             ].mutableCopy;
    }
    return _imageUrlArr;
}
@end
