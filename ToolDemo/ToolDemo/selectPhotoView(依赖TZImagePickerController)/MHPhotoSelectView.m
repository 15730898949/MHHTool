//
//  MHPhotoSelectView.m
//  PeanutBusiness
//
//  Created by Mac on 2020/12/10.
//  Copyright © 2020 因联科技. All rights reserved.
//

///当前控制器
#define MHPhotoSelectView_CurrentViewController \
^(){\
{\
UIViewController* currentViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;\
BOOL runLoopFind = YES;\
while (runLoopFind) {\
    if (currentViewController.presentedViewController) {\
        currentViewController = currentViewController.presentedViewController;\
    } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {\
        UINavigationController* navigationController = (UINavigationController* )currentViewController;\
        currentViewController = [navigationController.childViewControllers lastObject];\
    } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {\
        UITabBarController* tabBarController = (UITabBarController* )currentViewController;\
        currentViewController = tabBarController.selectedViewController;\
    } else {\
        NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;\
        if (childViewControllerCount > 0) {\
            currentViewController = currentViewController.childViewControllers.lastObject; \
            return currentViewController;\
        } else {\
            return currentViewController;\
        }\
    }\
}\
return currentViewController;\
}\
}()


#import "MHPhotoSelectView.h"
#import "LxGridViewFlowLayout.h"
#import "TZTestCell.h"


@interface MHPhotoSelectView()<UICollectionViewDataSource,UICollectionViewDelegate,TZImagePickerControllerDelegate>{
    CGFloat _itemWH;
    CGFloat _margin;
    NSMutableArray *_selectedAssets;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) LxGridViewFlowLayout *layout;
@property (strong, nonatomic) CLLocation *location;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;


@end

@implementation MHPhotoSelectView

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
    _itemWH = (self.bounds.size.width-20 - 3 * _margin - 4) / 4 - _margin;
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    _layout.minimumInteritemSpacing = _margin;
    _layout.minimumLineSpacing = _margin;
    [self.collectionView setCollectionViewLayout:_layout];
    self.collectionView.frame = CGRectMake(10, 10, self.bounds.size.width-20, self.bounds.size.height-20);
//    [self invalidateIntrinsicContentSize];
}

- (void)initUI{
    _selectedAssets = [NSMutableArray array];
    _selectedPhotos = [NSMutableArray array];
    self.allowPickingImage = YES;
    self.showTakePhoto = YES;
    self.showTakeVideo = YES;
    self.showSelectedIndex = YES;
    self.columnNumber = 4;
    [self configCollectionView];
    
    CGFloat rgb = 244 / 255.0;
    self.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];

    [self.collectionView addObserver:self
                                forKeyPath:@"contentSize"
                                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                   context:nil];

}

- (void)dealloc{
    [self.collectionView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    NSValue *newSizeValue = change[@"new"];
    NSValue *oldSizeValue = change[@"old"];
    CGSize newsize = [newSizeValue CGSizeValue];
    if (![newSizeValue isEqualToValue:oldSizeValue]) {
        if (self.contentSizeChanged) {
            self.contentSizeChanged(CGSizeMake(newsize.width, newsize.height+20));
        }
        [self layoutSubviews];
    }

}

- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    _layout = [[LxGridViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_selectedPhotos.count >= self.maxCount) {
        return _selectedPhotos.count;
    }
    if (!self.allowPickingMuitlpleVideo) {
        for (PHAsset *asset in _selectedAssets) {
            if (asset.mediaType == PHAssetMediaTypeVideo) {
                return _selectedPhotos.count;
            }
        }
    }
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.item == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"release_selectPhoto"];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.item];
        cell.asset = _selectedAssets[indexPath.item];
        cell.deleteBtn.hidden = NO;
    }
    if (!self.allowPickingGif) {
        cell.gifLable.hidden = YES;
    }
    cell.deleteBtn.tag = indexPath.item;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == _selectedPhotos.count) {
        [self pushTZImagePickerController];
    } else { // preview photos or video / 预览照片或者视频
        PHAsset *asset = _selectedAssets[indexPath.item];
        BOOL isVideo = NO;
        isVideo = asset.mediaType == PHAssetMediaTypeVideo;
        if ([[asset valueForKey:@"filename"] containsString:@"GIF"] && self.allowPickingGif && !self.allowPickingMuitlpleVideo) {
            TZGifPhotoPreviewController *vc = [[TZGifPhotoPreviewController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypePhotoGif timeLength:@""];
            vc.model = model;
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [MHPhotoSelectView_CurrentViewController presentViewController:vc animated:YES completion:nil];
        } else if (isVideo && !self.allowPickingMuitlpleVideo) { // perview video / 预览视频
            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
            vc.model = model;
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [MHPhotoSelectView_CurrentViewController presentViewController:vc animated:YES completion:nil];
        } else { // preview photos / 预览照片
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.item];
            imagePickerVc.maxImagesCount = self.maxCount;
            imagePickerVc.allowPickingGif = self.allowPickingGif;
//            imagePickerVc.autoSelectCurrentWhenDone = NO;
            imagePickerVc.allowPickingOriginalPhoto = self.allowPickingOriginalPhoto;
            imagePickerVc.allowPickingMultipleVideo = self.allowPickingMuitlpleVideo;
            imagePickerVc.showSelectedIndex = self.showSelectedIndex;
            imagePickerVc.isSelectOriginalPhoto = self.allowPickingOriginalPhoto;
            imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                self->_selectedPhotos = [NSMutableArray arrayWithArray:photos];
                self->_selectedAssets = [NSMutableArray arrayWithArray:assets];
                [self->_collectionView reloadData];
//                self->_collectionView.contentSize = CGSizeMake(0, ((self->_selectedPhotos.count + 2) / 3 ) * (self->_margin + self->_itemWH));
            }];
            [MHPhotoSelectView_CurrentViewController presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [_collectionView reloadData];
    [self invalidateIntrinsicContentSize];

}

#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    if ([self collectionView:self.collectionView numberOfItemsInSection:0] <= _selectedPhotos.count) {
        [_selectedPhotos removeObjectAtIndex:sender.tag];
        [_selectedAssets removeObjectAtIndex:sender.tag];
        [self.collectionView reloadData];
        [self invalidateIntrinsicContentSize];
        return;
    }
    
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [self->_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self->_collectionView reloadData];
        [self invalidateIntrinsicContentSize];

    }];
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [MHPhotoSelectView_CurrentViewController presentViewController:alertController animated:YES completion:nil];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhoto];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [MHPhotoSelectView_CurrentViewController presentViewController:alertController animated:YES completion:nil];
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    }
}


- (void)pushTZImagePickerController {
    if (self.maxCount <= 0) {
        return;
    }
    // 设置languageBundle以使用其它语言，必须在TZImagePickerController初始化前设置 / Set languageBundle to use other language
    // [TZImagePickerConfig sharedInstance].languageBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"tz-ru" ofType:@"lproj"]];

    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxCount columnNumber:self.columnNumber delegate:self pushPhotoPickerVc:YES];
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = self.allowPickingOriginalPhoto;
    
    if (self.maxCount > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    }
    imagePickerVc.allowTakePicture = self.showTakePhoto; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = self.showTakeVideo;   // 在内部显示拍视频按
    imagePickerVc.videoMaximumDuration = 10; // 视频最大拍摄时间
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = self.allowPickingVideo;
    imagePickerVc.allowPickingImage = self.allowPickingImage;
    imagePickerVc.allowPickingOriginalPhoto = self.allowPickingOriginalPhoto;
    imagePickerVc.allowPickingGif = self.allowPickingGif;
    imagePickerVc.allowPickingMultipleVideo = self.allowPickingMuitlpleVideo; // 是否可以多选视频
    
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = self.allowCrop;
    imagePickerVc.needCircleCrop = self.needCircleCrop;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = SCREEN_WIDTH - 2 * left;
    NSInteger top = (SCREEN_HEIGHT - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    imagePickerVc.scaleAspectFillCrop = YES;
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = self.showSelectedIndex;
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (self.didFinishPickingPhotosHandle) {
            self.didFinishPickingPhotosHandle(photos, assets, isSelectOriginalPhoto);
        }
    }];
    
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [MHPhotoSelectView_CurrentViewController presentViewController:imagePickerVc animated:YES completion:nil];
}




#pragma mark - TZImagePickerControllerDelegate


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    [self invalidateIntrinsicContentSize];

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
