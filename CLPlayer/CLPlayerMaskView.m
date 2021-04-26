//
//  CLPlayerMaskView.m
//  CLPlayerDemo
//
//  Created by JmoVxia on 2017/2/24.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CLPlayerMaskView.h"
#import "CLSlider.h"
#import "CLImageHelper.h"

//间隙
#define Padding        5
//顶部底部工具条高度
#define ToolBarHeight     40

@interface CLPlayerMaskView ()


@end

@implementation CLPlayerMaskView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initViews];
    }
    return self;
}
- (void)initViews{
    [self addSubview:self.topToolBar];
    [self addSubview:self.bottomToolBar];
    [self addSubview:self.loadingView];
    [self addSubview:self.failButton];
    [self.topToolBar addSubview:self.backButton];
    [self.bottomToolBar addSubview:self.playButton];
    [self.bottomToolBar addSubview:self.fullButton];
    [self.bottomToolBar addSubview:self.currentTimeLabel];
    [self.bottomToolBar addSubview:self.totalTimeLabel];
    [self.bottomToolBar addSubview:self.progress];
    [self.bottomToolBar addSubview:self.slider];
    self.topToolBar.backgroundColor    = [UIColor colorWithRed:0.00000f green:0.00000f blue:0.00000f alpha:0.20000f];
    self.bottomToolBar.backgroundColor = [UIColor colorWithRed:0.00000f green:0.00000f blue:0.00000f alpha:0.20000f];
}
#pragma mark - 约束
- (void)layoutSubviews{
    [super layoutSubviews];
    //顶部工具条
    self.topToolBar.frame = CGRectMake(0, 0, self.bounds.size.width, ToolBarHeight);
    //底部工具条
    self.bottomToolBar.frame = CGRectMake(0, self.bounds.size.height-ToolBarHeight, self.bounds.size.width, ToolBarHeight);
    //转子
    self.loadingView.frame = CGRectMake((self.bounds.size.width-40)/2.f, (self.bounds.size.height-40)/2.f, 40, 40);
    //返回按钮
    self.backButton.frame = CGRectMake(Padding, Padding, self.topToolBar.bounds.size.height-Padding*2, self.topToolBar.bounds.size.height-Padding*2);
    
    //播放按钮
    self.playButton.frame = CGRectMake(Padding, Padding, self.bottomToolBar.bounds.size.height-Padding*2, self.bottomToolBar.bounds.size.height-Padding*2);
    
    //全屏按钮
    self.fullButton.frame =CGRectMake(self.bottomToolBar.bounds.size.width-Padding-(self.bottomToolBar.bounds.size.height-Padding*2), Padding, self.bottomToolBar.bounds.size.height-Padding*2, self.bottomToolBar.bounds.size.height-Padding*2);
    
    //当前播放时间
    self.currentTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.playButton.frame)+Padding, (self.bottomToolBar.bounds.size.height-20)/2.f, 45, 20);
    
    
    //总时间
    self.totalTimeLabel.frame = CGRectMake(CGRectGetMinX(self.fullButton.frame)-45-Padding, (self.bottomToolBar.bounds.size.height-20)/2.f, 45, 20);
    
    
    //缓冲条
    self.progress.frame = CGRectMake(CGRectGetMaxX(self.currentTimeLabel.frame)+Padding, (self.bottomToolBar.bounds.size.height-2)/2.f, (CGRectGetMinX(self.totalTimeLabel.frame)- Padding)- (CGRectGetMaxX(self.currentTimeLabel.frame)+Padding), 2);
    
    //滑杆
    self.slider.frame = self.progress.frame;
    //失败按钮
    [self.failButton sizeToFit];
    self.failButton.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.f);
}
#pragma mark -- 设置颜色
-(void)setProgressBackgroundColor:(UIColor *)progressBackgroundColor{
    _progressBackgroundColor = progressBackgroundColor;
    _progress.trackTintColor = progressBackgroundColor;
}
-(void)setProgressBufferColor:(UIColor *)progressBufferColor{
    _progressBufferColor        = progressBufferColor;
    _progress.progressTintColor = progressBufferColor;
}
-(void)setProgressPlayFinishColor:(UIColor *)progressPlayFinishColor{
    _progressPlayFinishColor      = progressPlayFinishColor;
    _slider.minimumTrackTintColor = _progressPlayFinishColor;
}
#pragma mark - 懒加载
//顶部工具条
- (UIView *) topToolBar{
    if (_topToolBar == nil){
        _topToolBar = [[UIView alloc] init];
        _topToolBar.userInteractionEnabled = YES;
    }
    return _topToolBar;
}
//底部工具条
- (UIView *) bottomToolBar{
    if (_bottomToolBar == nil){
        _bottomToolBar = [[UIView alloc] init];
        _bottomToolBar.userInteractionEnabled = YES;
    }
    return _bottomToolBar;
}
//转子
- (CLRotateAnimationView *) loadingView{
    if (_loadingView == nil){
        _loadingView = [[CLRotateAnimationView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_loadingView startAnimation];
    }
    return _loadingView;
}
//返回按钮
- (UIButton *) backButton{
    if (_backButton == nil){
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[CLImageHelper imageWithName:@"CLBackBtn"] forState:UIControlStateNormal];
        [_backButton setImage:[CLImageHelper imageWithName:@"CLBackBtn"] forState:UIControlStateHighlighted];
        [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
//播放按钮
- (UIButton *) playButton{
    if (_playButton == nil){
        _playButton = [[UIButton alloc] init];
        [_playButton setImage:[CLImageHelper imageWithName:@"CLPlayBtn"] forState:UIControlStateNormal];
        [_playButton setImage:[CLImageHelper imageWithName:@"CLPauseBtn"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}
//全屏按钮
- (UIButton *) fullButton{
    if (_fullButton == nil){
        _fullButton = [[UIButton alloc] init];
        [_fullButton setImage:[CLImageHelper imageWithName:@"CLMaxBtn"] forState:UIControlStateNormal];
        [_fullButton setImage:[CLImageHelper imageWithName:@"CLMinBtn"] forState:UIControlStateSelected];
        [_fullButton addTarget:self action:@selector(fullButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullButton;
}
//当前播放时间
- (UILabel *) currentTimeLabel{
    if (_currentTimeLabel == nil){
        _currentTimeLabel                           = [[UILabel alloc] init];
        _currentTimeLabel.font                      = [UIFont systemFontOfSize:14];
        _currentTimeLabel.textColor                 = [UIColor whiteColor];
        _currentTimeLabel.adjustsFontSizeToFitWidth = YES;
        _currentTimeLabel.text                      = @"00:00";
        _currentTimeLabel.textAlignment             = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}
//总时间
- (UILabel *) totalTimeLabel{
    if (_totalTimeLabel == nil){
        _totalTimeLabel                           = [[UILabel alloc] init];
        _totalTimeLabel.font                      = [UIFont systemFontOfSize:14];
        _totalTimeLabel.textColor                 = [UIColor whiteColor];
        _totalTimeLabel.adjustsFontSizeToFitWidth = YES;
        _totalTimeLabel.text                      = @"00:00";
        _totalTimeLabel.textAlignment             = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}
//缓冲条
- (UIProgressView *) progress{
    if (_progress == nil){
        _progress = [[UIProgressView alloc] init];
    }
    return _progress;
}
//滑动条
- (CLSlider *) slider{
    if (_slider == nil){
        _slider = [[CLSlider alloc] init];
        // slider开始滑动事件
        [_slider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [_slider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [_slider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
        //右边颜色
        _slider.maximumTrackTintColor = [UIColor clearColor];
    }
    return _slider;
}
//加载失败按钮
- (UIButton *) failButton
{
    if (_failButton == nil) {
        _failButton        = [[UIButton alloc] init];
        _failButton.hidden = YES;
        [_failButton setTitle:@"加载失败,点击重试" forState:UIControlStateNormal];
        [_failButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _failButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
        _failButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _failButton.backgroundColor = [UIColor colorWithRed:0.00000f green:0.00000f blue:0.00000f alpha:0.50000f];
        [_failButton addTarget:self action:@selector(failButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _failButton;
}
#pragma mark - 按钮点击事件
//返回按钮
- (void)backButtonAction:(UIButton *)button{
    if (_delegate && [_delegate respondsToSelector:@selector(cl_backButtonAction:)]) {
        [_delegate cl_backButtonAction:button];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}
//播放按钮
- (void)playButtonAction:(UIButton *)button{
    button.selected = !button.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(cl_playButtonAction:)]) {
        [_delegate cl_playButtonAction:button];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}
//全屏按钮
- (void)fullButtonAction:(UIButton *)button{
    button.selected = !button.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(cl_fullButtonAction:)]) {
        [_delegate cl_fullButtonAction:button];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}
//失败按钮
- (void)failButtonAction:(UIButton *)button{
    self.failButton.hidden = YES;
    self.loadingView.hidden   = NO;
    if (_delegate && [_delegate respondsToSelector:@selector(cl_failButtonAction:)]) {
        [_delegate cl_failButtonAction:button];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}
#pragma mark - 滑杆
//开始滑动
- (void)progressSliderTouchBegan:(CLSlider *)slider{
    if (_delegate && [_delegate respondsToSelector:@selector(cl_progressSliderTouchBegan:)]) {
        [_delegate cl_progressSliderTouchBegan:slider];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}
//滑动中
- (void)progressSliderValueChanged:(CLSlider *)slider{
    if (_delegate && [_delegate respondsToSelector:@selector(cl_progressSliderValueChanged:)]) {
        [_delegate cl_progressSliderValueChanged:slider];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}
//滑动结束
- (void)progressSliderTouchEnded:(CLSlider *)slider{
    if (_delegate && [_delegate respondsToSelector:@selector(cl_progressSliderTouchEnded:)]) {
        [_delegate cl_progressSliderTouchEnded:slider];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}
@end
