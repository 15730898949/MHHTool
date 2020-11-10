//
//  LYInfoItemCell.m
//  LYInfoItemCell
//
//  Created by Teonardo on 2019/9/20.
//  Copyright © 2019 Teonardo. All rights reserved.
//

#import "MHInfoItemCell.h"

@interface MHInfoItemCell ()<UITextFieldDelegate>
@property (nonatomic, strong, readwrite) UITextField *titleTextField;
@property (nonatomic, strong, readwrite) UITextField *contentTextField;

@end

@implementation MHInfoItemCell{
    CGSize _accessoryViewSizeForSwitch;
}
@synthesize accessoryView = _accessoryView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleTextFieldLeftMargin = 16;
        _titleTextFieldRightMargin = 8;
        _accessoryViewLeftMargin = 8;
        _accessoryViewRightMargin = 16;
        _fixedTitleWidth = -1;
        self.titleTextField.text = @"";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];

    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - Override Method

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_contentTextField && !_titleTextField && !_accessoryView) {
        return;
    }
    [self.contentView removeConstraints:self.contentView.constraints];

    _titleTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _contentTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _accessoryView.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *view = nil;
    NSString *horizontalString = @"";
    NSDictionary *metrics = @{@"accessoryViewWidth":@([self accessoryViewSize].width),@"titleLeftSpacing":@(self.titleTextFieldLeftMargin),@"titleRightSpacing":@(self.titleTextFieldRightMargin),@"accessoryLeftSpacing":@(self.accessoryViewLeftMargin),@"accessoryRightSpacing":@(self.accessoryViewRightMargin),@"fixedTitleWidth":@(self.fixedTitleWidth),@"accessoryViewHeight":@([self accessoryViewSize].height)};
    
    if (_contentTextField == nil) {
        if (_accessoryView) {
            view =  NSDictionaryOfVariableBindings(_titleTextField,_accessoryView);
            horizontalString = @"H:|-titleLeftSpacing-[_titleTextField]-titleRightSpacing-[_accessoryView(accessoryViewWidth@1000)]-accessoryRightSpacing-|";
        } else {
            view =  NSDictionaryOfVariableBindings(_titleTextField);
            horizontalString = @"H:|-titleLeftSpacing-[_titleTextField]-titleRightSpacing-|";
        }
    }else{
        if (_accessoryView) {
            view =  NSDictionaryOfVariableBindings(_titleTextField,_contentTextField,_accessoryView);
            horizontalString =  @"H:|-titleLeftSpacing-[_titleTextField]-titleRightSpacing-[_contentTextField]-accessoryLeftSpacing-[_accessoryView(accessoryViewWidth@1000)]-accessoryRightSpacing-|";
        } else {
            view =  NSDictionaryOfVariableBindings(_titleTextField,_contentTextField);
            horizontalString =  @"H:|-titleLeftSpacing-[_titleTextField]-titleRightSpacing-[_contentTextField]-accessoryRightSpacing-|";
        }

    }
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:horizontalString options:0 metrics:metrics views:view];
    [self.contentView addConstraints:horizontalConstraints];
    
    if (self.fixedTitleWidth > 0) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_titleTextField(<=fixedTitleWidth)]" options:0 metrics:@{@"fixedTitleWidth":@(self.fixedTitleWidth)} views:view]];
    }

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_titleTextField]-0-|" options:0 metrics:nil views:view]];

    if (_contentTextField) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_contentTextField]-0-|" options:0 metrics:nil views:view]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_contentTextField(>=100@1000)]" options:0 metrics:nil views:view]];
    }
    
    if (_accessoryView) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[accessoryView(accessoryViewHeight@1000)]" options:0 metrics:@{@"accessoryViewHeight":@([self accessoryViewSize].height)} views:@{@"accessoryView":_accessoryView}]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_accessoryView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }



    
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, 50);
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    !self.didBeginEditing ? : self.didBeginEditing(self,textField);
    if ([self.delegate respondsToSelector:@selector(infoItemCell:didBeginEditing:)]) {
        [self.delegate infoItemCell:self didBeginEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    !self.didEndEditing ? : self.didEndEditing(self,textField);
    if ([self.delegate respondsToSelector:@selector(infoItemCell:didEndEditing:)]) {
        [self.delegate infoItemCell:self didEndEditing:textField];
    }
}

- (void)textFieldValueChanged:(NSNotification *)notification{
    UITextField *textField = (UITextField *)notification.object;
    if(textField != self.titleTextField && textField != self.contentTextField){
        return;
    }

    !self.textFieldValueChanged ? : self.textFieldValueChanged(self,textField);
    if ([self.delegate respondsToSelector:@selector(infoItemCell:textFieldValueChanged:)]) {
        [self.delegate infoItemCell:self textFieldValueChanged:textField];
    }

}



#pragma mark - Setter
- (void)setAccessoryView:(UIView *)accessoryView{
    if (_accessoryView != accessoryView) {
        [_accessoryView removeFromSuperview];
        [self.contentView addSubview:accessoryView];
        _accessoryView = accessoryView;
        [self setNeedsLayout];
    }

}

- (void)setImage:(UIImage *)image {
    if (_image != image) {
        _image = image;
        if (![_accessoryView isKindOfClass:[UIImageView class]]) {
            self.accessoryView = [UIImageView new];
        }
        [(UIImageView *)self.accessoryView setImage:image];
        [self setNeedsLayout];
    }
}

- (void)setTitleTextFieldLeftMargin:(CGFloat)titleTextFieldLeftMargin {
    if (titleTextFieldLeftMargin < 0) {
        return;
    }
    if (_titleTextFieldLeftMargin != titleTextFieldLeftMargin) {
        _titleTextFieldLeftMargin = titleTextFieldLeftMargin;
        [self setNeedsLayout];
    }
}

- (void)setTitleTextFieldRightMargin:(CGFloat)titleTextFieldRightMargin {
    if (titleTextFieldRightMargin < 0) {
        return;
    }
    if (_titleTextFieldRightMargin != titleTextFieldRightMargin) {
        _titleTextFieldRightMargin = titleTextFieldRightMargin;
        [self setNeedsLayout];
    }
}

- (void)setAccessoryViewLeftMargin:(CGFloat)accessoryViewLeftMargin {
    if (accessoryViewLeftMargin < 0) {
        return;
    }
    if (_accessoryViewLeftMargin != accessoryViewLeftMargin) {
        _accessoryViewLeftMargin = accessoryViewLeftMargin;
        [self setNeedsLayout];
    }
}

- (void)setAccessoryViewRightMargin:(CGFloat)accessoryViewRightMargin {
    if (accessoryViewRightMargin < 0) {
        return;
    }
    if (_accessoryViewRightMargin != accessoryViewRightMargin) {
        _accessoryViewRightMargin = accessoryViewRightMargin;
        [self setNeedsLayout];
    }
}

- (void)setFixedTitleWidth:(CGFloat)fixedTitleWidth {
    if (_fixedTitleWidth != fixedTitleWidth) {
        _fixedTitleWidth = fixedTitleWidth;
        [self setNeedsLayout];
    }
}

- (void)setAccessoryViewSizeMargin:(CGSize)accessoryViewSizeMargin{
    if (!CGSizeEqualToSize(_accessoryView.bounds.size, accessoryViewSizeMargin) && !CGSizeEqualToSize(_accessoryViewSizeMargin, accessoryViewSizeMargin)) {
        _accessoryViewSizeMargin = accessoryViewSizeMargin;
        [self setNeedsLayout];
    }
}


#pragma mark - Getter
- (UITextField *)titleTextField {
    if (!_titleTextField) {
        _titleTextField = [[UITextField alloc] init];
        _titleTextField.font = [UIFont systemFontOfSize:15.0];
        //_titleTextField.backgroundColor = [UIColor orangeColor];
        [_titleTextField setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
        [_titleTextField setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];

        _titleTextField.delegate = self;
        _titleTextField.enabled = NO;

        [self.contentView addSubview:_titleTextField];
    }
    return _titleTextField;
}

- (UITextField *)contentTextField {
    if (!_contentTextField) {
        _contentTextField = [[UITextField alloc] init];
        _contentTextField.textAlignment = NSTextAlignmentRight;
        //_contentTextField.backgroundColor = [UIColor cyanColor];
        _contentTextField.font = [UIFont systemFontOfSize:15.0];
        [_contentTextField setContentHuggingPriority:999 forAxis:UILayoutConstraintAxisHorizontal];
        [_contentTextField setContentCompressionResistancePriority:999 forAxis:UILayoutConstraintAxisHorizontal];

        _contentTextField.delegate = self;
        _contentTextField.enabled = NO;
        
        [self.contentView addSubview:_contentTextField];
    }
    return _contentTextField;
}

- (CGSize)accessoryViewSize {
    if (!_accessoryView) {
        return CGSizeZero;
    }
    
    // ???: 如果是 UISwitch, 必须记录第一获取到的size, 不然每次获取时 size 都会变大
    if ([_accessoryView isKindOfClass:[UISwitch class]]) {
        if (CGSizeEqualToSize(_accessoryViewSizeForSwitch, CGSizeZero)) {
            _accessoryViewSizeForSwitch = _accessoryView.bounds.size;
        }
        return _accessoryViewSizeForSwitch;
    }
    
    // 如果设置了大小(不为CGSizeZero), 直接取size
    if (!CGSizeEqualToSize(self.accessoryViewSizeMargin, CGSizeZero)) {
        return self.accessoryViewSizeMargin;
    }
    
    // 没有设置尺寸
    // 1> accessoryView 为 ImageView
    if ([_accessoryView isKindOfClass:[UIImageView class]]) {
        UIImage *image = [(UIImageView *)_accessoryView image];
        return image.size;
    }
    // 2> accessoryView 不为 ImageView
    else {
        return CGSizeMake(30, 30);
    }
}


@end
