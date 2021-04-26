//
//  MHOnePhotoImageView.m
//  sdl
//
//  Created by 马海鸿 on 2021/4/12.
//  Copyright © 2021 马海鸿. All rights reserved.
//

#import "MHOnePhotoImageView.h"
#import "MHPhotoSelectView.h"
@implementation MHOnePhotoImageView

- (instancetype)init
{
    self = [super init];
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

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initUI];
    }
    return self;
}



- (void)addBtnClick{
    !self.selectImageBlock?:self.selectImageBlock(self);
}

- (void)deleteBtnClick{
    self.image = nil;
    !self.deleteImageBlock?:self.deleteImageBlock(self);

}

- (void)initUI{
    self.userInteractionEnabled = YES;
    
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_addBtn setImage:MHPhotoViewImage(@"mh_photo_add") forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addBtn];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setImage:MHPhotoViewImage(@"mh_photo_delete") forState:UIControlStateNormal];
    _deleteBtn.hidden = YES;
    _deleteBtn.alpha = 0.6;
    [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:_deleteBtn];

    [self addObserver:self
                                forKeyPath:@"image"
                                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                   context:nil];
}

- (void)dealloc{

    [self removeObserver:self forKeyPath:@"image"];
}
    

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

        if ([keyPath isEqualToString:@"image"]) {
            if (self.image) {
                self.deleteBtn.hidden = NO;
                self.addBtn.hidden = YES;
            }else{
                self.deleteBtn.hidden = YES;
                self.addBtn.hidden = NO;
            }
        }

}




- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat deleteWidth = self.bounds.size.width*0.3>30?30:self.bounds.size.width*0.3;
    _deleteBtn.frame = CGRectMake(self.bounds.size.width - deleteWidth, 0, deleteWidth, deleteWidth);
    
    _addBtn.frame = self.bounds;


}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
