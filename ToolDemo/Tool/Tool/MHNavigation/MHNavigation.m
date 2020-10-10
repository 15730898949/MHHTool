//
//  MHNavigation.m
//  Tool
//
//  Created by 马海鸿 on 2020/10/10.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "MHNavigation.h"
#import <objc/runtime.h>
#import "Masonry.h"


//hook
void MUHookMethodSubDecrption(const char * originalClassName ,SEL originalSEL ,const char * newClassName ,SEL newSEL){
    
    Class originalClass = objc_getClass(originalClassName);//get a class through a string
    if (originalClass == 0) {
        NSLog(@"I can't find a class through a 'originalClassName'");
        return;
    }
    Class newClass     = objc_getClass(newClassName);
    if (newClass == 0) {
        NSLog(@"I can't find a class through a 'newClassName'");
        return;
    }
    class_addMethod(originalClass, newSEL, class_getMethodImplementation(newClass, newSEL), nil);//if newSEL not found in originalClass,it will auto add a method to this class;
    Method oldMethod = class_getInstanceMethod(originalClass, originalSEL);
    assert(oldMethod);
    Method newMethod = class_getInstanceMethod(originalClass, newSEL);
    assert(newMethod);
    method_exchangeImplementations(oldMethod, newMethod);
}
@interface UIViewController (MHNavigations)<UIScrollViewDelegate>
@property(nonatomic, copy)void(^leftItemByTapped)(UIBarButtonItem *item);
@property(nonatomic, copy)void(^rightItemByTapped)(UIBarButtonItem *item);
@property(nonatomic, strong)UILabel *titleLabel;//自定义标题
@end
@implementation UIViewController (MUNavigation)

- (void)mu_Dealloc{
#if DEBUG
    NSLog(@"%@ ---------------  dealloc",NSStringFromClass([self class]));
#endif
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"enterForeground" object:nil];
    
    [self mu_Dealloc];
}

- (UILabel *)titleLab{
    
    id object = objc_getAssociatedObject(self, @selector(titleLab));
    if (!object) {
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16.0];
        self.titleLab = label;
        return label;
    }

    return object;
}

- (void)setTitleLab:(UILabel *)titleLab{
    objc_setAssociatedObject(self, @selector(titleLab), titleLab, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)navBar{
    id object = objc_getAssociatedObject(self, @selector(navBar));
    if (!object) {
        UIView *nav = [UIView new];
        nav.hidden = YES;
        nav.backgroundColor = [UIColor whiteColor];
        self.navBar = nav;
        
        return nav;
    }
    return object;

}
-(void)setNavBar:(UIView *)navBar{
    objc_setAssociatedObject(self, @selector(navBar), navBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIButton *)backBtn{
    id object = objc_getAssociatedObject(self, @selector(backBtn));
    if (!object) {
        UIButton *btn = [UIButton new];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        self.backBtn = btn;
        return btn;
    }
    return object;

}
- (void)setBackBtn:(UIButton *)backBtn{
    objc_setAssociatedObject(self, @selector(backBtn), backBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

-(UIButton *)RightBtn{
    id object = objc_getAssociatedObject(self, @selector(RightBtn));
    if (!object) {
        UIButton *btn = [UIButton new];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.RightBtn = btn;
        return btn;
    }
    return object;

}

- (void)setRightBtn:(UIButton *)RightBtn{
    objc_setAssociatedObject(self, @selector(RightBtn), RightBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (UIView *)barline{
    id object = objc_getAssociatedObject(self, @selector(barline));
    if (!object) {
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor lightGrayColor];
        self.barline = line;
        return line;
    }
    return object;

}

- (void)setBarline:(UIView *)barline{
    objc_setAssociatedObject(self, @selector(barline), barline, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self muHookMethodViewController:NSStringFromClass([self class]) orignalSEL:@selector(viewWillAppear:) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_viewWillAppear:)];
        [self muHookMethodViewController:NSStringFromClass([self class]) orignalSEL:@selector(viewWillDisappear:) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_viewWillDisappear:)];
        [self muHookMethodViewController:NSStringFromClass([self class]) orignalSEL:@selector(viewDidAppear:) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_viewDidAppear:)];
        [self muHookMethodViewController:NSStringFromClass([self class]) orignalSEL:@selector(viewDidDisappear:) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_viewDidDisappear:)];
        [self muHookMethodViewController:NSStringFromClass([self class]) orignalSEL:@selector(viewDidLayoutSubviews) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_viewDidLayoutSubviews)];
        [self muHookMethodViewController:NSStringFromClass([self class]) orignalSEL:@selector(viewDidLoad) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_viewDidLoad)];
        
        [self muHookMethodViewController:NSStringFromClass([self class]) orignalSEL:NSSelectorFromString(@"dealloc") newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_Dealloc)];
        
        [self muHookMethodViewController:NSStringFromClass([self class]) orignalSEL:@selector(preferredStatusBarStyle) newClassName:NSStringFromClass([self class]) newSEL: @selector(mh_preferredStatusBarStyle)];
        
        [self muHookMethodViewController:NSStringFromClass([self class]) orignalSEL:@selector(prefersStatusBarHidden) newClassName:NSStringFromClass([self class]) newSEL: @selector(mh_prefersStatusBarHidden)];
        
        [self muHookMethodViewController:NSStringFromClass([self class]) orignalSEL:@selector(presentViewController:animated:completion:) newClassName:NSStringFromClass([self class]) newSEL: @selector(mh_presentViewController:animated:completion:)];

        
    });
}
+(void)muHookMethodViewController:(NSString *)originalClassName orignalSEL:(SEL)originalSEL newClassName:(NSString *)newClassName newSEL:(SEL)newSEL{
    
    const char * originalName = [originalClassName UTF8String];
    const char * newName      = [newClassName UTF8String];
    MUHookMethodSubDecrption(originalName, originalSEL, newName, newSEL);
}
-(void)mu_viewDidLoad{
    
    if ([self canUpdateNavigationBar]) {//判断当前控制器有无导航控制器
        //关闭自动设置边距
        self.edgesForExtendedLayout = UIRectEdgeNone;
        if (@available(iOS 11.0, *)) {
            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarFrame) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkStatusBarNormal) name:@"enterForeground" object:nil];
        
        //添加导航栏
        [self addNavBar];
    }
    
    [self mu_viewDidLoad];
}

- (void)addNavBar{
    self.navigationController.navigationBar.hidden = YES;
    [self.navBar addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.navBar);
        make.left.equalTo(self.navBar).offset(50);
        make.right.equalTo(self.navBar).offset(-50);
        make.height.offset(44);
    }];
    
    //    [self.backBtn setImage:[UIImage imageNamed:@"backImage"] forState:UIControlStateNormal];
    self.backBtn.hidden = YES;
    //        [self.backBtn setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e644", 20, [UIColor whiteColor])] forState:UIControlStateNormal];
    [self.backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar  addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navBar.mas_left).offset(10);
        make.centerY.equalTo(self.titleLab.mas_centerY);
    }];
    
    
    //    [self.backBtn setImage:[UIImage imageNamed:@"backImage"] forState:UIControlStateNormal];
//    [self.RightBtn setTitle:@"设置" forState:UIControlStateNormal];
    [self.RightBtn addTarget:self action:@selector(RightAction) forControlEvents:UIControlEventTouchUpInside];
    self.RightBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    
    [self.navBar  addSubview:self.RightBtn];
    
    [self.RightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(44);
        make.right.equalTo(self.navBar.mas_right).offset(-15);
        make.centerY.equalTo(self.titleLab.mas_centerY);
    }];
    
    [self.navBar addSubview:self.barline];
    [self.barline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.bottom.right.left.equalTo(self.navBar);
    }];
    
    [self.view addSubview:self.navBar];
    [self.view bringSubviewToFront:self.navBar];

    self.navBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [self navigationBarAndStatusBarHeight]);
    
//    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.left.right.equalTo(self.view);
//        make.height.offset([self navigationBarAndStatusBarHeight]);
//        make.width.offset([UIScreen mainScreen].bounds.size.width);
//
//    }];
    


}

- (void)backAction{
//    NSLog(@"点击返回");
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)RightAction{
    NSLog(@"点击右按钮");
}

- (void)checkStatusBarNormal {

}

- (void)didChangeStatusBarFrame {
    
    [self setNeedsStatusBarAppearanceUpdate];       // 调用导航栏的 preferredStatusBarStyle 方法
//
//    [self.navBar mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.bottom.equalTo(self.navigationController.navigationBar);
////        make.top.equalTo(self.navigationController.navigationBar).offset(- CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]));
//    }];

    
}

- (void)mh_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
    
    if ([viewControllerToPresent isKindOfClass:[UIImagePickerController class]]) {
        UIImagePickerController *imagePicker = (UIImagePickerController *)viewControllerToPresent;
        imagePicker.navigationBar.translucent = NO;//将导航条的毛玻璃效果去除掉就可以了,解决上移问题
    }
    
    [self mh_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)mu_viewWillAppear:(BOOL)animated {
    
    [self mu_viewWillAppear:animated];
    if ([self canUpdateNavigationBar]) {//判断当前控制器有无导航控制器
    }
    
    if (self.navigationController.childViewControllers.count >1) {
        self.backBtn.hidden = NO;
    }else{
        self.backBtn.hidden = YES;
    }
    

    
}
- (void)mu_viewDidAppear:(BOOL)animated {
    [self mu_viewDidAppear:animated];
    
}
// 交换方法 - 将要消失
- (void)mu_viewWillDisappear:(BOOL)animated {
    
    [self mu_viewWillDisappear:animated];
    if ([self canUpdateNavigationBar]) {//判断当前控制器有无导航控制器
        if (self.navigationBarTranslationY > 0) {
            self.navBar.transform = CGAffineTransformIdentity;
            self.navigationBarTranslationY = 0;
        }
    }
}
// 交换方法 - 已经消失
- (void)mu_viewDidDisappear:(BOOL)animated {
    
    [self mu_viewDidDisappear:animated];
}
//控制器布局结束
-(void)mu_viewDidLayoutSubviews{
    [self mu_viewDidLayoutSubviews];
}

#pragma mark -public method

- (BOOL)canUpdateNavigationBar {
    // 如果当前有导航栏//且没有手动设置隐藏导航栏
    if (self.navigationController && ([NSStringFromClass([self.navigationController class]) isEqualToString:NSStringFromClass([UINavigationController class])]) && self.navBar.hidden == NO) {//如果有自定义的导航栏则过滤掉
        return YES;
    }
    return NO;
}


//电池电量
//* 设置当前状态栏样式 白色/黑色


- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle{
    objc_setAssociatedObject(self, @selector(statusBarStyle), @(statusBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    [self setNeedsStatusBarAppearanceUpdate];       // 调用导航栏的 preferredStatusBarStyle 方法

}

-(UIStatusBarStyle)statusBarStyle{
    id style = objc_getAssociatedObject(self, @selector(statusBarStyle));
    UIStatusBarStyle barStyle = UIStatusBarStyleDefault;
    if (style) {
        barStyle = [style integerValue] == 0 ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
    }else{
        barStyle = self.navigationController.statusBarStyle;
    }
    return barStyle;

}

- (BOOL)statusBarHidden{
    id style = objc_getAssociatedObject(self, @selector(statusBarHidden));
    if (style) {
        return [style integerValue] == 0 ? NO : YES;
    }else{
        return  self.navigationController.statusBarHidden;
    }
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden{
    objc_setAssociatedObject(self, @selector(statusBarHidden), @(statusBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [self setNeedsStatusBarAppearanceUpdate];       // 调用导航栏的 preferredStatusBarStyle 方法

}


- (UIStatusBarStyle )mh_preferredStatusBarStyle {
    return self.statusBarStyle;
}

- (BOOL)mh_prefersStatusBarHidden {
    return self.statusBarHidden;
}




//导航栏偏移距离
-(CGFloat)navigationBarTranslationY{
    id object = objc_getAssociatedObject(self, @selector(navigationBarTranslationY));
    CGFloat y = object?[object doubleValue]:0;
    return y;
}
-(void)setNavigationBarTranslationY:(CGFloat)navigationBarTranslationY{
    if (navigationBarTranslationY > 0) {
        self.navBar.transform = CGAffineTransformMakeTranslation(0, -navigationBarTranslationY);
    }else{
        self.navBar.transform = CGAffineTransformIdentity;
    }
    
    objc_setAssociatedObject(self, @selector(navigationBarTranslationY), @(navigationBarTranslationY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


/** 获取导航栏加状态栏高度*/
- (CGFloat)navigationBarAndStatusBarHeight {
    return 44.f +
        CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
}


@end


@implementation UINavigationController (Navigation)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        [self muHookMethodViewController:NSStringFromClass([self class]) orignalSEL:@selector(pushViewController:animated:) newClassName:NSStringFromClass([self class]) newSEL: @selector(mh_pushViewController:animated:)];
        [self muHookMethodViewController:NSStringFromClass([self class]) orignalSEL:@selector(popViewControllerAnimated:) newClassName:NSStringFromClass([self class]) newSEL: @selector(mh_popViewControllerAnimated:)];
        [self muHookMethodViewController:NSStringFromClass([self class]) orignalSEL:@selector(setViewControllers:animated:) newClassName:NSStringFromClass([self class]) newSEL: @selector(mh_setViewControllers:animated:)];


        
    });
}


- (void)mh_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated{
    if (self.viewControllers.count == 0) {
        [self mh_setViewControllers:viewControllers animated:animated];
        return;
    }else if (self.viewControllers.count > 0) {
        for (int i = 0; i < viewControllers.count; i++) {
            if (i > 0) {
                viewControllers[i].hidesBottomBarWhenPushed=YES;
            }
        }
    }
    [self mh_setViewControllers:viewControllers animated:animated];

}

- (void)mh_pushViewController:(UIViewController *)viewController animated:(BOOL)animated{

    if (self.viewControllers.count == 0) {
        [self mh_pushViewController:viewController animated:animated];
        return;
    }else if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed=YES;
    }
    [self mh_pushViewController:viewController animated:animated];


}

- (UIViewController *)mh_popViewControllerAnimated:(BOOL)animated{
    return [self mh_popViewControllerAnimated:animated];
}





@end


//@implementation UIImagePickerController (Navigation)
//+(void)load{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//
//        [self muHookMethodViewController:NSStringFromClass([self class]) orignalSEL:@selector(viewDidLoad) newClassName:NSStringFromClass([self class]) newSEL: @selector(mh_viewDidLoad)];
//
//
//    });
//}
//
//-(void)mh_viewDidLoad{
////    self.edgesForExtendedLayout = UIRectEdgeNone;
//
//    [self mh_viewDidLoad];
//}
//
//
//@end
