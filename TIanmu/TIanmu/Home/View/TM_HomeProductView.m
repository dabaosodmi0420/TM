//
//  TM_HomeProductView.m
//  TIanmu
//
//  Created by 郑连杰 on 2023/6/14.
//

#import "TM_HomeProductView.h"
#import "TM_ProductListCell.h"


#define KProductListCellId @"KProductListCellId"

@interface TM_HomeProductView()<UICollectionViewDelegate, UICollectionViewDataSource>
/* uicollectionView */
@property (strong, nonatomic) UICollectionView *collectionView;


@end
@implementation TM_HomeProductView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        
        [self createView];
    }
    return self;
}

#pragma mark - Activity
- (void)createView {
    [self addSubview:self.collectionView];
    [self.collectionView reloadData];
}

#pragma mark - collectionView 代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    TM_ProductListCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:KProductListCellId forIndexPath:indexPath];
    cell.model = self.datas[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView{
    if (!_collectionView){
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //定义每个cell的大小
        flowLayout.itemSize = CGSizeMake(self.width * 0.5 - 20, self.width * 0.5 - 20 + 40);
        //定义布局方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //定义每个cell纵向的间距
        flowLayout.minimumLineSpacing = 0;
        //定义每个cell的横向间距
        flowLayout.minimumInteritemSpacing = 10;
        //定义每个cell到容器边缘的距离
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        //注册cell
        [_collectionView registerClass:[TM_ProductListCell class] forCellWithReuseIdentifier:KProductListCellId];
        //设置代理
        _collectionView.delegate = self;
        //设置数据源
        _collectionView.dataSource = self;
    }
    return _collectionView;
}


@end
