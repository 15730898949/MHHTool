//
//  TZPhotoPreviewController.m
//  TZImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import "TZPhotoPreviewController.h"
#import "TZImagePickerController.h"
#import "TZPhotoPreviewCell.h"
#import "TZAssetModel.h"
#import "UIView+Layout.h"
#import "TZImageManager.h"
#import "TZImageCropManager.h"

@interface TZPhotoPreviewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate> {
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *_layout;
    NSArray *_photosTemp;
    NSArray *_assetsTemp;
    
    UIView *_naviBar;
    UIButton *_backButton;
    UIButton *_selectButton;
    UILabel *_indexLabel;
    
    UIView *_toolBar;
    UIButton *_doneButton;
    UIImageView *_numberImageView;
    UILabel *_numberLabel;
    UIButton *_originalPhotoButton;
    UILabel *_originalPhotoLabel;
    
    CGFloat _offsetItemCount;
    
    BOOL _didSetIsSelectOriginalPhoto;
}
@property (nonatomic, assign) BOOL isHideNaviBar;
@property (nonatomic, strong) UIView *cropBgView;
@property (nonatomic, strong) UIView *cropView;

@property (nonatomic, assign) double progress;
@property (strong, nonatomic) UIAlertController *alertView;
@property (nonatomic, strong) UIView *iCloudErrorView;
@property (nonatomic, strong) TZImagePickerController *tzImagePickerVc;
@property (nonatomic, strong) NSArray *videoSuffixs;

@end

@implementation TZPhotoPreviewController

- (instancetype)initWithPhotos:(NSArray *)photos currentIndex:(NSInteger)currentIndex tzImagePickerVc:(TZImagePickerController *)tzImagePickerVc {
    self = [super init];
    if (self) {
        self.models = [NSMutableArray arrayWithArray:photos];
        self.currentIndex = currentIndex;
        if (!tzImagePickerVc) {
            tzImagePickerVc = [[TZImagePickerController alloc]initWithMaxImagesCount:9 columnNumber:4 delegate:nil];
            tzImagePickerVc.allowPickingMultipleVideo = YES;
            tzImagePickerVc.allowPickingOriginalPhoto = NO;
            tzImagePickerVc.showSelectedIndex = YES;
        }
        self.tzImagePickerVc = tzImagePickerVc;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.videoSuffixs = @[@"mov",@"mp4",@"rmvb",@"rm",@"flv",@"avi",@"3gp",@"wmv",@"mpeg1",@"mpeg2",@"mpeg4(mp4)",                                 @"asf",@"swf",@"vob",@"dat",@"m4v",@"f4v",@"mkv",@"mts",@"ts"];

    [TZImageManager manager].shouldFixOrientation = YES;
    if (!_didSetIsSelectOriginalPhoto) {
        _isSelectOriginalPhoto = _tzImagePickerVc.isSelectOriginalPhoto;
    }
    if (!self.models.count) {
        self.models = [NSMutableArray arrayWithArray:_tzImagePickerVc.selectedModels];
        _assetsTemp = [NSMutableArray arrayWithArray:_tzImagePickerVc.selectedAssets];
    }
    [self configCollectionView];
    [self configCustomNaviBar];
    [self configBottomToolBar];
    self.view.clipsToBounds = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)setIsSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    _didSetIsSelectOriginalPhoto = YES;
}

- (void)setPhotos:(NSMutableArray *)photos {
    _photos = photos;
    _photosTemp = [NSArray arrayWithArray:photos];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
    if (_currentIndex) {
        [_collectionView setContentOffset:CGPointMake((self.view.tz_width + 20) * self.currentIndex, 0) animated:NO];
    }
    [self refreshNaviBarAndBottomBarState];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_tzImagePickerVc.needShowStatusBar) {
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [TZImageManager manager].shouldFixOrientation = NO;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)configCustomNaviBar {
    
    _naviBar = [[UIView alloc] initWithFrame:CGRectZero];
    _naviBar.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:0.7];
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_backButton setImage:[UIImage tz_imageNamedFromMyBundle:@"navi_back"] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _selectButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_selectButton setImage:_tzImagePickerVc.photoDefImage forState:UIControlStateNormal];
    [_selectButton setImage:_tzImagePickerVc.photoSelImage forState:UIControlStateSelected];
    _selectButton.imageView.clipsToBounds = YES;
    _selectButton.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
    _selectButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_selectButton addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    _selectButton.hidden = !_tzImagePickerVc.showSelectBtn;
    
    _indexLabel = [[UILabel alloc] init];
    _indexLabel.adjustsFontSizeToFitWidth = YES;
    _indexLabel.font = [UIFont systemFontOfSize:14];
    _indexLabel.textColor = [UIColor whiteColor];
    _indexLabel.textAlignment = NSTextAlignmentCenter;
    
    [_naviBar addSubview:_selectButton];
    [_naviBar addSubview:_indexLabel];
    [_naviBar addSubview:_backButton];
    [self.view addSubview:_naviBar];
}

- (void)configBottomToolBar {
    _toolBar = [[UIView alloc] initWithFrame:CGRectZero];
    static CGFloat rgb = 34 / 255.0;
    _toolBar.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.7];
    
    if (_tzImagePickerVc.allowPickingOriginalPhoto) {
        _originalPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _originalPhotoButton.imageEdgeInsets = UIEdgeInsetsMake(0, [TZCommonTools tz_isRightToLeftLayout] ? 10 : -10, 0, 0);
        _originalPhotoButton.backgroundColor = [UIColor clearColor];
        [_originalPhotoButton addTarget:self action:@selector(originalPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _originalPhotoButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_originalPhotoButton setTitle:_tzImagePickerVc.fullImageBtnTitleStr forState:UIControlStateNormal];
        [_originalPhotoButton setTitle:_tzImagePickerVc.fullImageBtnTitleStr forState:UIControlStateSelected];
        [_originalPhotoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_originalPhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_originalPhotoButton setImage:_tzImagePickerVc.photoPreviewOriginDefImage forState:UIControlStateNormal];
        [_originalPhotoButton setImage:_tzImagePickerVc.photoOriginSelImage forState:UIControlStateSelected];
        
        _originalPhotoLabel = [[UILabel alloc] init];
        _originalPhotoLabel.textAlignment = NSTextAlignmentLeft;
        _originalPhotoLabel.font = [UIFont systemFontOfSize:13];
        _originalPhotoLabel.textColor = [UIColor whiteColor];
        _originalPhotoLabel.backgroundColor = [UIColor clearColor];
        if (_isSelectOriginalPhoto) [self showPhotoBytes];
    }
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_doneButton setTitle:_tzImagePickerVc.doneBtnTitleStr forState:UIControlStateNormal];
    [_doneButton setTitleColor:_tzImagePickerVc.oKButtonTitleColorNormal forState:UIControlStateNormal];
    
    _numberImageView = [[UIImageView alloc] initWithImage:_tzImagePickerVc.photoNumberIconImage];
    _numberImageView.backgroundColor = [UIColor clearColor];
    _numberImageView.clipsToBounds = YES;
    _numberImageView.contentMode = UIViewContentModeScaleAspectFit;
    _numberImageView.hidden = _tzImagePickerVc.selectedModels.count <= 0;
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.font = [UIFont systemFontOfSize:15];
    _numberLabel.adjustsFontSizeToFitWidth = YES;
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.text = [NSString stringWithFormat:@"%zd",_tzImagePickerVc.selectedModels.count];
    _numberLabel.hidden = _tzImagePickerVc.selectedModels.count <= 0;
    _numberLabel.backgroundColor = [UIColor clearColor];
    
    [_originalPhotoButton addSubview:_originalPhotoLabel];
    [_toolBar addSubview:_doneButton];
    [_toolBar addSubview:_originalPhotoButton];
    [_toolBar addSubview:_numberImageView];
    [_toolBar addSubview:_numberLabel];
    [self.view addSubview:_toolBar];
    
    if (_tzImagePickerVc.photoPreviewPageUIConfigBlock) {
        _tzImagePickerVc.photoPreviewPageUIConfigBlock(_collectionView, _naviBar, _backButton, _selectButton, _indexLabel, _toolBar, _originalPhotoButton, _originalPhotoLabel, _doneButton, _numberImageView, _numberLabel);
    }
}

- (void)configCollectionView {
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _collectionView.contentSize = CGSizeMake(self.models.count * (self.view.tz_width + 20), 0);
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[TZPhotoPreviewCell class] forCellWithReuseIdentifier:@"TZPhotoPreviewCell"];
    [_collectionView registerClass:[TZVideoPreviewCell class] forCellWithReuseIdentifier:@"TZVideoPreviewCell"];
    [_collectionView registerClass:[TZGifPreviewCell class] forCellWithReuseIdentifier:@"TZGifPreviewCell"];
    
    if (_tzImagePickerVc.scaleAspectFillCrop && _tzImagePickerVc.allowCrop) {
        _collectionView.scrollEnabled = NO;
    }
}

- (void)configCropView {
    if (_tzImagePickerVc.maxImagesCount <= 1 && _tzImagePickerVc.allowCrop && _tzImagePickerVc.allowPickingImage) {
        [_cropView removeFromSuperview];
        [_cropBgView removeFromSuperview];
        
        _cropBgView = [UIView new];
        _cropBgView.userInteractionEnabled = NO;
        _cropBgView.frame = self.view.bounds;
        _cropBgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_cropBgView];
        [TZImageCropManager overlayClippingWithView:_cropBgView cropRect:_tzImagePickerVc.cropRect containerView:self.view needCircleCrop:_tzImagePickerVc.needCircleCrop];
        
        _cropView = [UIView new];
        _cropView.userInteractionEnabled = NO;
        _cropView.frame = _tzImagePickerVc.cropRect;
        _cropView.backgroundColor = [UIColor clearColor];
        _cropView.layer.borderColor = [UIColor whiteColor].CGColor;
        _cropView.layer.borderWidth = 1.0;
        if (_tzImagePickerVc.needCircleCrop) {
            _cropView.layer.cornerRadius = _tzImagePickerVc.cropRect.size.width / 2;
            _cropView.clipsToBounds = YES;
        }
        [self.view addSubview:_cropView];
        if (_tzImagePickerVc.cropViewSettingBlock) {
            _tzImagePickerVc.cropViewSettingBlock(_cropView);
        }
        
        [self.view bringSubviewToFront:_naviBar];
        [self.view bringSubviewToFront:_toolBar];
    }
}

#pragma mark - Layout

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    BOOL isFullScreen = self.view.tz_height == [UIScreen mainScreen].bounds.size.height;
    CGFloat statusBarHeight = isFullScreen ? [TZCommonTools tz_statusBarHeight] : 0;
    CGFloat statusBarHeightInterval = isFullScreen ? (statusBarHeight - 20) : 0;
    CGFloat naviBarHeight = statusBarHeight + _tzImagePickerVc.navigationBar.tz_height;
    _naviBar.frame = CGRectMake(0, 0, self.view.tz_width, naviBarHeight);
    _backButton.frame = CGRectMake(10, 10 + statusBarHeightInterval, 44, 44);
    _selectButton.frame = CGRectMake(self.view.tz_width - 56, 10 + statusBarHeightInterval, 44, 44);
    _indexLabel.frame = _selectButton.frame;
    
    _layout.itemSize = CGSizeMake(self.view.tz_width + 20, self.view.tz_height);
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing = 0;
    _collectionView.frame = CGRectMake(-10, 0, self.view.tz_width + 20, self.view.tz_height);
    [_collectionView setCollectionViewLayout:_layout];
    if (_offsetItemCount > 0) {
        CGFloat offsetX = _offsetItemCount * _layout.itemSize.width;
        [_collectionView setContentOffset:CGPointMake(offsetX, 0)];
    }
    if (_tzImagePickerVc.allowCrop) {
        [_collectionView reloadData];
    }
    
    CGFloat toolBarHeight = 44 + [TZCommonTools tz_safeAreaInsets].bottom;
    CGFloat toolBarTop = self.view.tz_height - toolBarHeight;
    _toolBar.frame = CGRectMake(0, toolBarTop, self.view.tz_width, toolBarHeight);
    if (_tzImagePickerVc.allowPickingOriginalPhoto) {
        CGFloat fullImageWidth = [_tzImagePickerVc.fullImageBtnTitleStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.width;
        _originalPhotoButton.frame = CGRectMake(0, 0, fullImageWidth + 56, 44);
        _originalPhotoLabel.frame = CGRectMake(fullImageWidth + 42, 0, 80, 44);
    }
    [_doneButton sizeToFit];
    _doneButton.frame = CGRectMake(self.view.tz_width - _doneButton.tz_width - 12, 0, _doneButton.tz_width, 44);
    _numberImageView.frame = CGRectMake(_doneButton.tz_left - 24 - 5, 10, 24, 24);
    _numberLabel.frame = _numberImageView.frame;
    
    [self configCropView];
    
    if (_tzImagePickerVc.photoPreviewPageDidLayoutSubviewsBlock) {
        _tzImagePickerVc.photoPreviewPageDidLayoutSubviewsBlock(_collectionView, _naviBar, _backButton, _selectButton, _indexLabel, _toolBar, _originalPhotoButton, _originalPhotoLabel, _doneButton, _numberImageView, _numberLabel);
    }
}

#pragma mark - Notification

- (void)didChangeStatusBarOrientationNotification:(NSNotification *)noti {
    _offsetItemCount = _collectionView.contentOffset.x / _layout.itemSize.width;
}

#pragma mark - Click Event

- (void)select:(UIButton *)selectButton {
    TZAssetModel *model = _models[self.currentIndex];
    if (!selectButton.isSelected) {
        // 1. select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
        if (_tzImagePickerVc.selectedModels.count >= _tzImagePickerVc.maxImagesCount) {
            NSString *title = [NSString stringWithFormat:[NSBundle tz_localizedStringForKey:@"Select a maximum of %zd photos"], _tzImagePickerVc.maxImagesCount];
            [_tzImagePickerVc showAlertWithTitle:title];
            return;
            // 2. if not over the maxImagesCount / 如果没有超过最大个数限制
        } else {
            [_tzImagePickerVc addSelectedModel:model];
            if (self.photos) {
                [_tzImagePickerVc.selectedAssets addObject:_assetsTemp[self.currentIndex]];
                [self.photos addObject:_photosTemp[self.currentIndex]];
            }
            if (model.type == TZAssetModelMediaTypeVideo && !_tzImagePickerVc.allowPickingMultipleVideo) {
                [_tzImagePickerVc showAlertWithTitle:[NSBundle tz_localizedStringForKey:@"Select the video when in multi state, we will handle the video as a photo"]];
            }
        }
    } else {
        NSArray *selectedModels = [NSArray arrayWithArray:_tzImagePickerVc.selectedModels];
        for (TZAssetModel *model_item in selectedModels) {
            if ([model.asset.localIdentifier isEqualToString:model_item.asset.localIdentifier]) {
                // 1.6.7版本更新:防止有多个一样的model,一次性被移除了
                NSArray *selectedModelsTmp = [NSArray arrayWithArray:_tzImagePickerVc.selectedModels];
                for (NSInteger i = 0; i < selectedModelsTmp.count; i++) {
                    TZAssetModel *model = selectedModelsTmp[i];
                    if ([model isEqual:model_item]) {
                        [_tzImagePickerVc removeSelectedModel:model];
                        // [_tzImagePickerVc.selectedModels removeObjectAtIndex:i];
                        break;
                    }
                }
                if (self.photos) {
                    // 1.6.7版本更新:防止有多个一样的asset,一次性被移除了
                    NSArray *selectedAssetsTmp = [NSArray arrayWithArray:_tzImagePickerVc.selectedAssets];
                    for (NSInteger i = 0; i < selectedAssetsTmp.count; i++) {
                        id asset = selectedAssetsTmp[i];
                        if ([asset isEqual:_assetsTemp[self.currentIndex]]) {
                            [_tzImagePickerVc.selectedAssets removeObjectAtIndex:i];
                            break;
                        }
                    }
                    // [_tzImagePickerVc.selectedAssets removeObject:_assetsTemp[self.currentIndex]];
                    [self.photos removeObject:_photosTemp[self.currentIndex]];
                }
                break;
            }
        }
    }
    model.isSelected = !selectButton.isSelected;
    [self refreshNaviBarAndBottomBarState];
    if (model.isSelected) {
        [UIView showOscillatoryAnimationWithLayer:selectButton.imageView.layer type:TZOscillatoryAnimationToBigger];
    }
    [UIView showOscillatoryAnimationWithLayer:_numberImageView.layer type:TZOscillatoryAnimationToSmaller];
}

- (void)backButtonClick {
    if (self.navigationController.childViewControllers.count < 2) {
        [self dismissViewControllerAnimated:YES completion:nil];
        if (_tzImagePickerVc) {
            if (_tzImagePickerVc.imagePickerControllerDidCancelHandle) {
                _tzImagePickerVc.imagePickerControllerDidCancelHandle();
            }
        }
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    if (self.backButtonClickBlock) {
        self.backButtonClickBlock(_isSelectOriginalPhoto);
    }
}

- (void)doneButtonClick {
    // 如果图片正在从iCloud同步中,提醒用户
    if (_progress > 0 && _progress < 1 && (_selectButton.isSelected || !_tzImagePickerVc.selectedModels.count )) {
        _alertView = [_tzImagePickerVc showAlertWithTitle:[NSBundle tz_localizedStringForKey:@"Synchronizing photos from iCloud"]];
        return;
    }
    
    // 如果没有选中过照片 点击确定时选中当前预览的照片
    if (_tzImagePickerVc.selectedModels.count == 0 && _tzImagePickerVc.minImagesCount <= 0 && _tzImagePickerVc.autoSelectCurrentWhenDone) {
        [self select:_selectButton];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    TZPhotoPreviewCell *cell = (TZPhotoPreviewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    if (_tzImagePickerVc.allowCrop && [cell isKindOfClass:[TZPhotoPreviewCell class]]) { // 裁剪状态
        _doneButton.enabled = NO;
        [_tzImagePickerVc showProgressHUD];
        UIImage *cropedImage = [TZImageCropManager cropImageView:cell.previewView.imageView toRect:_tzImagePickerVc.cropRect zoomScale:cell.previewView.scrollView.zoomScale containerView:self.view];
        if (_tzImagePickerVc.needCircleCrop) {
            cropedImage = [TZImageCropManager circularClipImage:cropedImage];
        }
        _doneButton.enabled = YES;
        [_tzImagePickerVc hideProgressHUD];
        if (self.doneButtonClickBlockCropMode) {
            TZAssetModel *model = _models[self.currentIndex];
            self.doneButtonClickBlockCropMode(cropedImage,model.asset);
        }
    } else if (self.doneButtonClickBlock) { // 非裁剪状态
        self.doneButtonClickBlock(_isSelectOriginalPhoto);
    }
    if (self.doneButtonClickBlockWithPreviewType) {
        self.doneButtonClickBlockWithPreviewType(self.photos,_tzImagePickerVc.selectedAssets,self.isSelectOriginalPhoto);
    }
}

- (void)originalPhotoButtonClick {
    _originalPhotoButton.selected = !_originalPhotoButton.isSelected;
    _isSelectOriginalPhoto = _originalPhotoButton.isSelected;
    _originalPhotoLabel.hidden = !_originalPhotoButton.isSelected;
    if (_isSelectOriginalPhoto) {
        [self showPhotoBytes];
        if (!_selectButton.isSelected) {
            // 如果当前已选择照片张数 < 最大可选张数 && 最大可选张数大于1，就选中该张图
            if (_tzImagePickerVc.selectedModels.count < _tzImagePickerVc.maxImagesCount && _tzImagePickerVc.showSelectBtn) {
                [self select:_selectButton];
            }
        }
    }
}

- (void)didTapPreviewCell {
    self.isHideNaviBar = !self.isHideNaviBar;
    _naviBar.hidden = self.isHideNaviBar;
    _toolBar.hidden = self.isHideNaviBar;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetWidth = scrollView.contentOffset.x;
    offSetWidth = offSetWidth +  ((self.view.tz_width + 20) * 0.5);
    
    NSInteger currentIndex = offSetWidth / (self.view.tz_width + 20);
    if (currentIndex < _models.count && _currentIndex != currentIndex) {
        _currentIndex = currentIndex;
        [self refreshNaviBarAndBottomBarState];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"photoPreviewCollectionViewDidScroll" object:nil];
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    id photo = _models[indexPath.item];
    TZAssetPreviewCell *cell;
    __weak typeof(self) weakSelf = self;
    
    if ([photo isKindOfClass:[PHAsset class]] || [photo isKindOfClass:[TZAssetModel class]]) {
        TZAssetModel *model;
        if ([photo isKindOfClass:[PHAsset class]]) {
            PHAsset *asset = (PHAsset *)photo;
            model = [[TZImageManager manager] createModelWithAsset:asset];
        }else{
            model = photo;
        }
        if (_tzImagePickerVc.allowPickingMultipleVideo && model.type == TZAssetModelMediaTypeVideo) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZVideoPreviewCell" forIndexPath:indexPath];
            TZVideoPreviewCell *currentCell = (TZVideoPreviewCell *)cell;
            currentCell.iCloudSyncFailedHandle = ^(id asset, BOOL isSyncFailed) {
                model.iCloudFailed = isSyncFailed;
                [weakSelf didICloudSyncStatusChanged:model];
                [weakSelf.models replaceObjectAtIndex:indexPath.item withObject:model];
            };
        } else if (_tzImagePickerVc.allowPickingMultipleVideo && model.type == TZAssetModelMediaTypePhotoGif && _tzImagePickerVc.allowPickingGif) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZGifPreviewCell" forIndexPath:indexPath];
            TZGifPreviewCell *currentCell = (TZGifPreviewCell *)cell;
            currentCell.previewView.iCloudSyncFailedHandle = ^(id asset, BOOL isSyncFailed) {
                model.iCloudFailed = isSyncFailed;
                [weakSelf didICloudSyncStatusChanged:model];
                [weakSelf.models replaceObjectAtIndex:indexPath.item withObject:model];
            };
        } else {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZPhotoPreviewCell" forIndexPath:indexPath];
            TZPhotoPreviewCell *photoPreviewCell = (TZPhotoPreviewCell *)cell;
            photoPreviewCell.cropRect = _tzImagePickerVc.cropRect;
            photoPreviewCell.allowCrop = _tzImagePickerVc.allowCrop;
            photoPreviewCell.scaleAspectFillCrop = _tzImagePickerVc.scaleAspectFillCrop;
            __weak typeof(_tzImagePickerVc) weakTzImagePickerVc = _tzImagePickerVc;
            __weak typeof(_collectionView) weakCollectionView = _collectionView;
            __weak typeof(photoPreviewCell) weakCell = photoPreviewCell;
            [photoPreviewCell setImageProgressUpdateBlock:^(double progress) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                __strong typeof(weakTzImagePickerVc) strongTzImagePickerVc = weakTzImagePickerVc;
                __strong typeof(weakCollectionView) strongCollectionView = weakCollectionView;
                __strong typeof(weakCell) strongCell = weakCell;
                strongSelf.progress = progress;
                if (progress >= 1) {
                    if (strongSelf.isSelectOriginalPhoto) [strongSelf showPhotoBytes];
                    if (strongSelf.alertView && [strongCollectionView.visibleCells containsObject:strongCell]) {
                        [strongTzImagePickerVc hideAlertView:strongSelf.alertView];
                        strongSelf.alertView = nil;
                        [strongSelf doneButtonClick];
                    }
                }
            }];
            photoPreviewCell.previewView.iCloudSyncFailedHandle = ^(id asset, BOOL isSyncFailed) {
                model.iCloudFailed = isSyncFailed;
                [weakSelf didICloudSyncStatusChanged:model];
                [weakSelf.models replaceObjectAtIndex:indexPath.item withObject:model];
            };
        }
        
        cell.model = model;

    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZPhotoPreviewCell" forIndexPath:indexPath];
        TZPhotoPreviewCell *photoPreviewCell = (TZPhotoPreviewCell *)cell;
        photoPreviewCell.previewView.imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        if ([photo isKindOfClass:[UIImage class]]) {
            photoPreviewCell.previewView.imageView.image = (UIImage *)photo;
        } else if ([photo isKindOfClass:[NSURL class]]) {
            NSURL *URL = (NSURL *)photo;
            NSString *suffix = [[URL.absoluteString.lowercaseString componentsSeparatedByString:@"."] lastObject];
            if (suffix && [self.videoSuffixs containsObject:suffix]) {
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZVideoPreviewCell" forIndexPath:indexPath];
                TZVideoPreviewCell *videoCell = (TZVideoPreviewCell *)cell;
                videoCell.videoURL = URL;
            } else if (self.setImageWithURLBlock) {
                self.setImageWithURLBlock(URL, photoPreviewCell.previewView.imageView, ^{
                    [photoPreviewCell recoverSubviews];
                });
            } else {
                photoPreviewCell.previewView.imageView.image = nil;
                NSLog(@"【TZImagePreviewController】传入的photos有NSURL对象且不是视频，请参照Demo实现setImageWithURLBlock！");
            }
        } else {
            photoPreviewCell.previewView.imageView.image = nil;
            NSLog(@"【TZImagePreviewController】photos数组内元素只支持PHAsset、UIImage、NSURL类型！不支持%@类型！", [photo class]);
        }

    }
    [cell setSingleTapGestureBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf didTapPreviewCell];
    }];

    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[TZPhotoPreviewCell class]]) {
        [(TZPhotoPreviewCell *)cell recoverSubviews];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[TZPhotoPreviewCell class]]) {
        [(TZPhotoPreviewCell *)cell recoverSubviews];
    } else if ([cell isKindOfClass:[TZVideoPreviewCell class]]) {
        TZVideoPreviewCell *videoCell = (TZVideoPreviewCell *)cell;
        if (videoCell.player && videoCell.player.rate != 0.0) {
            [videoCell pausePlayerAndShowNaviBar];
        }
    }
}

#pragma mark - Private Method

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // NSLog(@"%@ dealloc",NSStringFromClass(self.class));
}

- (void)refreshNaviBarAndBottomBarState {
    id photo = _models[self.currentIndex];
    _numberLabel.text = [NSString stringWithFormat:@"%zd",_tzImagePickerVc.selectedModels.count];
    _numberImageView.hidden = (_tzImagePickerVc.selectedModels.count <= 0 || _isHideNaviBar || _isCropImage);
    _numberLabel.hidden = (_tzImagePickerVc.selectedModels.count <= 0 || _isHideNaviBar || _isCropImage);
    
    _originalPhotoButton.selected = _isSelectOriginalPhoto;
    _originalPhotoLabel.hidden = !_originalPhotoButton.isSelected;
    if (_isSelectOriginalPhoto) [self showPhotoBytes];
    
    // If is previewing video, hide original photo button
    // 如果正在预览的是视频，隐藏原图按钮
    if (!_isHideNaviBar) {
        if ([photo isKindOfClass:[PHAsset class]]) {
            PHAsset *asset = (PHAsset *)photo;
            TZAssetModelMediaType type = [[TZImageManager manager] getAssetType:asset];
            if (type == TZAssetModelMediaTypeVideo) {
                _originalPhotoButton.hidden = YES;
                _originalPhotoLabel.hidden = YES;
            } else {
                _originalPhotoButton.hidden = NO;
                if (_isSelectOriginalPhoto)  _originalPhotoLabel.hidden = NO;
            }
        } else {
            _originalPhotoButton.hidden = YES;
            _originalPhotoLabel.hidden = YES;
        }
    }
    
    _doneButton.hidden = NO;
    _selectButton.hidden = !_tzImagePickerVc.showSelectBtn;
    // 让宽度/高度小于 最小可选照片尺寸 的图片不能选中
    // iCloud同步失败的UI刷新
    if ([photo isKindOfClass:[TZAssetModel class]]) {
        TZAssetModel *model = _models[self.currentIndex];
        _selectButton.selected = model.isSelected;
        [self refreshSelectButtonImageViewContentMode];
        if (_selectButton.isSelected && _tzImagePickerVc.showSelectedIndex && _tzImagePickerVc.showSelectBtn) {
            NSString *index = [NSString stringWithFormat:@"%d", (int)([_tzImagePickerVc.selectedAssetIds indexOfObject:model.asset.localIdentifier] + 1)];
            _indexLabel.text = index;
            _indexLabel.hidden = NO;
        } else {
            _indexLabel.hidden = YES;
        }

        if (![[TZImageManager manager] isPhotoSelectableWithAsset:model.asset]) {
            _numberLabel.hidden = YES;
            _numberImageView.hidden = YES;
            _selectButton.hidden = YES;
            _originalPhotoButton.hidden = YES;
            _originalPhotoLabel.hidden = YES;
            _doneButton.hidden = YES;
        }
        if (model.type == TZAssetModelMediaTypeVideo) {
            _originalPhotoButton.hidden = YES;
            _originalPhotoLabel.hidden = YES;
        } else {
            _originalPhotoButton.hidden = NO;
            if (_isSelectOriginalPhoto)  _originalPhotoLabel.hidden = NO;
        }

        [self didICloudSyncStatusChanged:model];
        


    }
    if (_tzImagePickerVc.photoPreviewPageDidRefreshStateBlock) {
        _tzImagePickerVc.photoPreviewPageDidRefreshStateBlock(_collectionView, _naviBar, _backButton, _selectButton, _indexLabel, _toolBar, _originalPhotoButton, _originalPhotoLabel, _doneButton, _numberImageView, _numberLabel);
    }
}

- (void)refreshSelectButtonImageViewContentMode {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self->_selectButton.imageView.image.size.width <= 27) {
            self->_selectButton.imageView.contentMode = UIViewContentModeCenter;
        } else {
            self->_selectButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
    });
}

- (void)didICloudSyncStatusChanged:(TZAssetModel *)model{
    id currentobj = self.models[self.currentIndex];
    if (![currentobj isKindOfClass:[TZAssetModel class]] || ![model isKindOfClass:[TZAssetModel class]]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        // onlyReturnAsset为NO时,依赖TZ返回大图,所以需要有iCloud同步失败的提示,并且不能选择,
        if (self->_tzImagePickerVc.onlyReturnAsset) {
            return;
        }
        TZAssetModel *currentModel = self.models[self.currentIndex];
        if (self->_tzImagePickerVc.selectedModels.count <= 0) {
            self->_doneButton.enabled = !currentModel.iCloudFailed;
        } else {
            self->_doneButton.enabled = YES;
        }
        self->_selectButton.hidden = currentModel.iCloudFailed || !self->_tzImagePickerVc.showSelectBtn;
        self->_originalPhotoButton.hidden = currentModel.iCloudFailed;
        self->_originalPhotoLabel.hidden = currentModel.iCloudFailed;
    });
}

- (void)showPhotoBytes {
    [[TZImageManager manager] getPhotosBytesWithArray:@[_models[self.currentIndex]] completion:^(NSString *totalBytes) {
        self->_originalPhotoLabel.text = [NSString stringWithFormat:@"(%@)",totalBytes];
    }];
}

- (NSInteger)currentIndex {
    return [TZCommonTools tz_isRightToLeftLayout] ? self.models.count - _currentIndex - 1 : _currentIndex;
}

@end