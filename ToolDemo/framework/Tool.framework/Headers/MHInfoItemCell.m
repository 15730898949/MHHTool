//
//  LYInfoItemCell.m
//  LYInfoItemCell
//
//  Created by Teonardo on 2019/9/20.
//  Copyright © 2019 Teonardo. All rights reserved.
//

#import "MHInfoItemCell.h"
#import <objc/runtime.h>
@interface MHInfoItemCell ()<UITextFieldDelegate>
@property (nonatomic, strong, readwrite) UITextField *titleTextField;
@property (nonatomic, strong, readwrite) UITextField *contentTextField;
@property (nonatomic, strong, readwrite) UILabel *titleLab;
@property (nonatomic, strong, readwrite) UILabel *contentLab;

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
    [self layoutView];
}

- (void)layoutView{
    if (!_contentTextField && !_titleTextField && !_accessoryView) {
        return;
    }
    [self.contentView removeConstraints:self.contentView.constraints];
    _titleTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _contentTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _accessoryView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    NSDictionary *view = nil;
    NSString *horizontalString = @"";
    NSDictionary *metrics = @{@"accessoryViewWidth":@([self accessoryViewSize].width),
                              @"titleLeftSpacing":@(self.titleTextFieldLeftMargin),
                              @"titleRightSpacing":@(self.titleTextFieldRightMargin),
                              @"titleTopSpacing":@(self.titleTextFieldTopMargin),
                              @"titleBottomSpacing":@(self.titleTextFieldBottomMargin),
                              @"accessoryLeftSpacing":@(self.accessoryViewLeftMargin),
                              @"accessoryRightSpacing":@(self.accessoryViewRightMargin),
                              @"fixedTitleWidth":@(self.fixedTitleWidth),
                              @"accessoryViewHeight":@([self accessoryViewSize].height)};
    
    if (_contentTextField == nil) {
        if (_accessoryView) {
            view =  NSDictionaryOfVariableBindings(_titleTextField,_accessoryView);
            horizontalString = @"H:|-titleLeftSpacing-[_titleTextField(>=50@750)]-titleRightSpacing-[_accessoryView(accessoryViewWidth@1000)]-accessoryRightSpacing-|";
        } else {
            view =  NSDictionaryOfVariableBindings(_titleTextField);
            horizontalString = @"H:|-titleLeftSpacing-[_titleTextField(>=100@750)]-titleRightSpacing-|";
        }
    }else{
        if (_accessoryView) {
            view =  NSDictionaryOfVariableBindings(_titleTextField,_contentTextField,_accessoryView);
            horizontalString =  @"H:|-titleLeftSpacing-[_titleTextField(>=50@1000)]-titleRightSpacing-[_contentTextField(>=100@750)]-accessoryLeftSpacing-[_accessoryView(accessoryViewWidth@1000)]-accessoryRightSpacing-|";
        } else {
            view =  NSDictionaryOfVariableBindings(_titleTextField,_contentTextField);
            horizontalString =  @"H:|-titleLeftSpacing-[_titleTextField(>=50@1000)]-titleRightSpacing-[_contentTextField(>=100@750)]-accessoryRightSpacing-|";
        }

    }
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:horizontalString options:0 metrics:metrics views:view];
    [self.contentView addConstraints:horizontalConstraints];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-titleTopSpacing-[_titleTextField]-titleBottomSpacing@1000-|" options:0 metrics:@{@"titleTopSpacing":@(self.titleTextFieldTopMargin),@"titleBottomSpacing":@(self.titleTextFieldBottomMargin),} views:view]];

    if (self.fixedTitleHeight > 0 ) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleTextField(fixedTitleHeight@750)]" options:0 metrics:@{@"fixedTitleHeight":@(self.fixedTitleHeight)} views:view]];

    }
    if (_contentTextField && _contentTextField.superview) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_contentTextField]-0-|" options:0 metrics:nil views:view]];
//        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_contentTextField(>=100@1000)]" options:0 metrics:nil views:view]];
    }

    
    if (_accessoryView && _accessoryView.superview) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[accessoryView(accessoryViewHeight@1000)]" options:0 metrics:@{@"accessoryViewHeight":@([self accessoryViewSize].height)} views:@{@"accessoryView":_accessoryView}]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_accessoryView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }

    if (_titleLab && _titleLab.superview) {
        NSLog(@"%f-------",_titleTextField.rightView.frame.size.width);
        [_titleTextField removeConstraints:_titleTextField.constraints];
        _titleLab.translatesAutoresizingMaskIntoConstraints = NO;
        [_titleTextField addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_titleLab]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLab)]];
        [_titleTextField addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLeftViewWidth-[_titleLab]-titleRightViewWidth-|" options:0 metrics:@{@"titleLeftViewWidth":@(_titleTextField.leftView.frame.size.width),@"titleRightViewWidth":@(_titleTextField.rightView.frame.size.width)} views:NSDictionaryOfVariableBindings(_titleLab)]];
    }
    
    if (_contentLab && _contentLab.superview) {
        [_contentTextField removeConstraints:_contentTextField.constraints];
        _contentLab.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentTextField addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_contentLab]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentLab)]];
        [_contentTextField addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-contentLeftViewWidth-[_contentLab]-contentRightViewWidth-|" options:0 metrics:@{@"contentLeftViewWidth":@(_contentTextField.leftView.frame.size.width),@"contentRightViewWidth":@(_contentTextField.rightView.frame.size.width)} views:NSDictionaryOfVariableBindings(_contentLab)]];
    }

    if (self.fixedTitleWidth > 0) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_titleTextField(fixedTitleWidth)]" options:0 metrics:@{@"fixedTitleWidth":@(self.fixedTitleWidth)} views:view]];
    }

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

- (void)setTitleTextFieldTopMargin:(CGFloat)titleTextFieldTopMargin{
    if (titleTextFieldTopMargin < 0) {
        return;
    }
    if (_titleTextFieldTopMargin != titleTextFieldTopMargin) {
        _titleTextFieldTopMargin = titleTextFieldTopMargin;
        [self setNeedsLayout];
    }
}

- (void)setTitleTextFieldBottomMargin:(CGFloat)titleTextFieldBottomMargin{
    if (titleTextFieldBottomMargin < 0) {
        return;
    }
    if (_titleTextFieldBottomMargin != titleTextFieldBottomMargin) {
        _titleTextFieldBottomMargin = titleTextFieldBottomMargin;
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

- (void)setFixedTitleHeight:(CGFloat)fixedTitleHeight{
    if (_fixedTitleHeight != fixedTitleHeight) {
        _fixedTitleHeight = fixedTitleHeight;
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
        [_titleTextField setContentHuggingPriority:999 forAxis:UILayoutConstraintAxisHorizontal];
        [_titleTextField setContentCompressionResistancePriority:999 forAxis:UILayoutConstraintAxisHorizontal];
        [_titleTextField setContentCompressionResistancePriority:999 forAxis:UILayoutConstraintAxisVertical];

        _titleTextField.delegate = self;
        _titleTextField.enabled = NO;

        [self.contentView addSubview:_titleTextField];
    }
    return _titleTextField;
}

- (UILabel *)titleLab{
    if (!_titleLab){
        _titleLab = [[UILabel alloc]init];
        _titleLab.textAlignment = self.titleTextField.textAlignment;
        _titleLab.font = self.titleTextField.font;
        _titleLab.textColor = self.titleTextField.textColor;
        _titleLab.numberOfLines = 0;
        [self.titleTextField addSubview:_titleLab];
        self.titleTextField.enabled = NO;
        self.titleTextField.text = @"";
        self.titleTextField.placeholder = @"";
        [_titleLab setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
        [_titleLab setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];

    }
    return _titleLab;
}

- (UITextField *)contentTextField {
    if (!_contentTextField) {
        _contentTextField = [[UITextField alloc] init];
        _contentTextField.textAlignment = NSTextAlignmentRight;
        //_contentTextField.backgroundColor = [UIColor cyanColor];
        _contentTextField.font = [UIFont systemFontOfSize:15.0];
        [_contentTextField setContentHuggingPriority:998 forAxis:UILayoutConstraintAxisHorizontal];
        [_contentTextField setContentCompressionResistancePriority:998 forAxis:UILayoutConstraintAxisHorizontal];
        [_contentTextField setContentCompressionResistancePriority:998 forAxis:UILayoutConstraintAxisVertical];

        _contentTextField.delegate = self;
        _contentTextField.enabled = NO;

        
        [self.contentView addSubview:_contentTextField];
    }
    return _contentTextField;
}
- (UILabel *)contentLab{
    if (!_contentLab){
        _contentLab = [[UILabel alloc]init];
        _contentLab.textAlignment = self.contentTextField.textAlignment;
        _contentLab.font = self.contentTextField.font;
        _contentLab.textColor = self.contentTextField.textColor;
        _contentLab.numberOfLines = 0;
        [self.contentTextField addSubview:_contentLab];
        self.contentTextField.enabled = NO;
        self.contentTextField.text = @"";
        self.contentTextField.placeholder = @"";
    }
    return _contentLab;
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
