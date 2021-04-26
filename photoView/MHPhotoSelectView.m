//
//  MHPhotoSelectView.m
//  PeanutBusiness
//
//  Created by Mac on 2020/12/10.
//  Copyright © 2020 因联科技. All rights reserved.
//


#import "MHPhotoSelectView.h"
#import "LxGridViewFlowLayout.h"
#import "TZTestCell.h"
#import <SDWebImage/UIImage+GIF.h>
#import <SDWebImage/SDWebImageDownloader.h>

@interface MHPhotoSelectView()<UICollectionViewDataSource,UICollectionViewDelegate>{
    CGFloat _itemWH;
    CGFloat _margin;
}
@property (strong, nonatomic) LxGridViewFlowLayout *layout;
@property (strong, nonatomic) CLLocation *location;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) NSArray *videoSuffixs;
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;


@end

@implementation MHPhotoSelectView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];

    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        

        [self initUI];
        
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    _margin = 4;
    _itemWH = (self.bounds.size.width-20 - (_rowCount - 1) * _margin - _rowCount) / _rowCount - _margin;
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    _layout.minimumInteritemSpacing = _margin;
    _layout.minimumLineSpacing = _margin;
    [self.collectionView setCollectionViewLayout:_layout];
    self.collectionView.frame = CGRectMake(10, 5, self.bounds.size.width-20, self.bounds.size.height-10);
    [self.collectionView layoutIfNeeded];
    [self.collectionView setNeedsLayout];
    [self invalidateIntrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(self.collectionView.contentSize.width+20, self.collectionView.contentSize.height+20);
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(self.collectionView.contentSize.width+20, self.collectionView.contentSize.height+30);
}

- (void)reloadData{
    [self.collectionView reloadData];
}

- (CGSize )contentSize{
    [self.collectionView layoutIfNeeded];
    [self.collectionView setNeedsLayout];
    return self.collectionView.contentSize;
}


- (void)initUI{
    _rowCount = 4;
    _isAdd = YES;
    _isDelete = YES;
    _isMove = YES;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    _selectedPhotos = [NSMutableArray array];
    self.maxCount = 9;
    [self addSubview:self.collectionView];

    CGFloat rgb = 244 / 255.0;
    self.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];

    [self.collectionView addObserver:self
                                forKeyPath:@"contentSize"
                                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                   context:nil];
    

}

- (void)setSelectedPhotos:(NSMutableArray *)selectedPhotos{
    _selectedPhotos = selectedPhotos;
    [self.collectionView reloadData];
}

- (void)dealloc{
    [self.collectionView removeObserver:self forKeyPath:@"contentSize"];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"contentSize"]) {
        NSValue *newSizeValue = change[@"new"];
        NSValue *oldSizeValue = change[@"old"];
        if (![newSizeValue isEqualToValue:oldSizeValue]) {
//            self.collectionView.frame = CGRectMake(10, 10, self.frame.size.width-20, self.collectionView.contentSize.height);
            [self invalidateIntrinsicContentSize];
        }
    }

}




#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isMove) {
        return NO;
    }
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    if (self.changeSortBlock) {
        self.changeSortBlock(self.selectedPhotos);
    }
    
    [_collectionView reloadData];
    [self invalidateIntrinsicContentSize];

}
#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_selectedPhotos.count >= self.maxCount) {
        return _selectedPhotos.count;
    }
    return _selectedPhotos.count + (self.isAdd?1:0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    cell.videoURL = nil;
    cell.imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
    if (indexPath.item == _selectedPhotos.count) {
        cell.imageView.image = MHPhotoViewImage(@"mh_photo_add") ;
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
    } else {
        id photo = _selectedPhotos[indexPath.item];
        if ([photo isKindOfClass:[UIImage class]]) {
            cell.imageView.image = photo;
        } else if ([photo isKindOfClass:[NSURL class]]) {
            NSURL *URL = (NSURL *)photo;
            NSString *suffix = [[URL.absoluteString.lowercaseString componentsSeparatedByString:@"."] lastObject];
            if (suffix && [self.videoSuffixs containsObject:suffix]) {
                cell.videoURL = URL;
            } else {
                [self configImageView:cell.imageView URL:(NSURL *)photo completion:nil];
            }
        }else if ([photo isKindOfClass:[NSString class]]){
            [self configImageView:cell.imageView URL:[NSURL URLWithString:(NSString *)photo] completion:nil];
        }
        cell.asset = _selectedPhotos[indexPath.item];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.item;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    if (!self.isDelete) {
        cell.deleteBtn.hidden = YES;
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == _selectedPhotos.count) { // 选择
        [self addBtnClick];
    } else { // 预览
    }
}

- (void)configImageView:(UIImageView *)imageView URL:(NSURL *)URL completion:(void (^)(void))completion{
    if ([URL.absoluteString.lowercaseString hasSuffix:@"gif"]) {
        // 先显示静态图占位
        [[SDWebImageManager sharedManager] downloadImageWithURL:URL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!imageView.image) {
                imageView.image = image;
            }

        }];
        // 动图加载完再覆盖掉
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:URL options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            imageView.image = [UIImage sd_animatedGIFWithData:data];
            if (completion) {
                completion();
            }
        }];
    } else {
        [imageView sd_setImageWithURL:URL completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (completion) {
                completion();
            }
        }];
    }
}


#pragma -mark click

- (void)addBtnClick{
    if (self.addClickBlock) {
        self.addClickBlock(self.selectedPhotos);
    }
}

- (void)deleteBtnClik:(UIButton *)sender {
    if ([self collectionView:self.collectionView numberOfItemsInSection:0] <= _selectedPhotos.count) {
        [_selectedPhotos removeObjectAtIndex:sender.tag];
        [self.collectionView reloadData];
        return;
    }
    
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [self->_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self->_collectionView reloadData];
    }];
    
    if (self.deleteClickBlock) {
        self.deleteClickBlock(self.selectedPhotos);
    }
    
}

#pragma -mark 懒加载

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
        _layout = [[LxGridViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];

    }
    return _collectionView;
}

@end
