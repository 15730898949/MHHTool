//
//  UIView+Category.m
//  GSJuZhang
//
//  Created by kiwi on 17/1/15.
//  Copyright (c) 2017年 kiwi All rights reserved.
//

#import "UIView+MHCategory.h"

@implementation UIView (mh_frame)

- (CGFloat)mh_left
{
    return self.frame.origin.x;
}
- (void)setMh_left:(CGFloat)mh_left
{
    CGRect frame = self.frame;
    frame.origin.x = mh_left;
    self.frame = frame;
}


- (CGFloat)mh_top
{
    return self.frame.origin.y;
}

- (void)setMh_top:(CGFloat)mh_top
{
    CGRect frame = self.frame;
    frame.origin.y = mh_top;
    self.frame = frame;
}

- (CGFloat)mh_right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setMh_right:(CGFloat)mh_right
{
    CGRect frame = self.frame;
    frame.origin.x = mh_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)mh_bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setMh_bottom:(CGFloat)mh_bottom
{
    CGRect frame = self.frame;
    frame.origin.y = mh_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)mh_centerX
{
    return self.center.x;
}

- (void)setMh_centerX:(CGFloat)mh_centerX
{
    self.center = CGPointMake(mh_centerX, self.center.y);
}

- (CGFloat)mh_centerY
{
    return self.center.y;
}

- (void)setMh_centerY:(CGFloat)mh_centerY
{
    self.center = CGPointMake(self.center.x, mh_centerY);
}

- (CGFloat)mh_width
{
    return self.frame.size.width;
}
- (void)setMh_width:(CGFloat)mh_width
{
    CGRect frame = self.frame;
    frame.size.width = mh_width;
    self.frame = frame;
}

- (CGFloat)mh_height
{
    return self.frame.size.height;
}

- (void)setMh_height:(CGFloat)mh_height
{
    CGRect frame = self.frame;
    frame.size.height = mh_height;
    self.frame = frame;
}

- (CGPoint)mh_origin
{
    return self.frame.origin;
}

- (void)setMh_origin:(CGPoint)mh_origin
{
    CGRect frame = self.frame;
    frame.origin = mh_origin;
    self.frame = frame;
}

- (CGSize)mh_size
{
    return self.frame.size;
}

- (void)setMh_size:(CGSize)mh_size
{
    CGRect frame = self.frame;
    frame.size = mh_size;
    self.frame = frame;
}

@end

#import <objc/runtime.h>

@implementation UIView (mh_extension)
static char extraDataKey;
///额外的数据 方便传递
- (id)extraData{
    return objc_getAssociatedObject(self, &extraDataKey);
}
- (void)setExtraData:(id)extraData{
    objc_setAssociatedObject(self, &extraDataKey, extraData, OBJC_ASSOCIATION_RETAIN);
}


- (void)addTapGestureWithTarget:(id)pTarget selector:(SEL)pSelector
{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:pTarget action:pSelector];
    self.exclusiveTouch=YES;
    tapGesture.numberOfTouchesRequired=1;
    tapGesture.numberOfTapsRequired=1;
    [self addGestureRecognizer:tapGesture];
    self.userInteractionEnabled = YES;
}

- (void)addDoubleTapGestureWithTarget:(id)pTarget selector:(SEL)pSelector
{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:pTarget action:pSelector];
    self.exclusiveTouch=YES;
    tapGesture.numberOfTouchesRequired=1;
    tapGesture.numberOfTapsRequired=2;
    [self addGestureRecognizer:tapGesture];
    self.userInteractionEnabled = YES;
}

- (UIViewController *)viewcontroller
{
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)removeAllSubviews
{
    while (self.subviews.count > 0) {
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

- (void)removeAllSubviewsExcludView:(UIView *)view
{
    while (self.subviews.count > 1) {
        UIView *child = self.subviews.lastObject;
        if (![child isEqual:view]) {
            [child removeFromSuperview];
        }
    }
}

- (void)addSubviews:(NSArray *)subviews
{
    for (UIView *subview in subviews) {
        [self addSubview:subview];
    }
}

- (void)removeSubviewForUIButton
{
    for (UIView *subview in self.subviews) {
        if ([subview isMemberOfClass:[UIButton class]]) {
            [subview removeFromSuperview];
        }
    }
}

- (void)setbackgroundImage:(UIImage *)img
{
    self.layer.contents = (id)[img CGImage];
}

- (void)bringToFront
{
	[self.superview bringSubviewToFront:self];
}

- (void)sendToBack
{
    [self.superview sendSubviewToBack:self];
}

- (UIImage *)imageByRenderingView
{
    CGRect frame = self.frame;
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, [UIScreen mainScreen].scale);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:contextRef];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;

}

- (BOOL)hasGesture:(id)gestureObjClass
{
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        if ([gesture isMemberOfClass:gestureObjClass]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)removeGesture:(id)gestureObjClass
{
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        if ([gesture isMemberOfClass:gestureObjClass]) {
            [self removeGestureRecognizer:gesture];
            return YES;
        }
    }
    return NO;
}

- (BOOL)removeAllGestures
{
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        [self removeGestureRecognizer:gesture];
    }
    if (self.gestureRecognizers.count == 0) {
        return YES;
    }
    return NO;
}

@end


static char alertKey, alertLableKey;

@implementation UIView (mh_alert)

- (void)setAlertLable:(UILabel *)alertLable
{
    objc_setAssociatedObject(self, &alertLableKey, alertLable, OBJC_ASSOCIATION_RETAIN);
}

- (UILabel *)alertLable
{
    if (objc_getAssociatedObject(self, &alertLableKey) == nil) {
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.mh_width, 35)];
        lable.font = [UIFont systemFontOfSize:15];
        lable.textColor = [UIColor redColor];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.backgroundColor = [UIColor clearColor];
        lable.numberOfLines = 0;
        lable.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        self.alertLable = lable;
        [self addSubview:lable];
    }
    return objc_getAssociatedObject(self, &alertLableKey);
}

- (void)setAlert:(NSString *)alert
{
    objc_setAssociatedObject(self, &alertKey, alert, OBJC_ASSOCIATION_RETAIN);
    self.alertLable.text = alert;
    self.alertLable.mh_height = [self.alertLable sizeThatFits:CGSizeMake(self.alertLable.mh_width, self.mh_height)].height;
    self.alertLable.mh_centerY = self.mh_height / 2;
    self.alertLable.mh_centerX = self.mh_width / 2;
    if (alert == nil) {
        [self.alertLable removeFromSuperview];
        self.alertLable = nil;
    }
}

- (NSString *)alert
{
    return objc_getAssociatedObject(self, &alertKey);
}

@end


@implementation UIView (mh_line)

- (UIView *)addtionHoriaontalLineWithSross:(CGFloat)sross withLeft:(CGFloat)left withTop:(CGFloat)top withWidth:(CGFloat)width withColor:(UIColor *)color
{
    UIView *underLine = [[UIView alloc]initWithFrame:CGRectMake(left, top, width, sross)];
    [underLine bringToFront];
    underLine.backgroundColor = color;
    [self addSubview:underLine];
    return underLine;
}

- (UIView *)addtionVerticalLineWithSross:(CGFloat)sross withLeft:(CGFloat)left withTop:(CGFloat)top withHeight:(CGFloat)height withColor:(UIColor *)color
{
    UIView *underLine = [[UIView alloc]initWithFrame:CGRectMake(left, top, sross, height)];
    [underLine bringToFront];
    underLine.backgroundColor = color;
    [self addSubview:underLine];
    return underLine;
}

@end

@implementation UIView (mh_help)

- (void)printViewHierarchy:(UIView *)superView
{
    static uint level = 0;
    for (uint i = 0; i < level; i++) {
        printf("\t");
    }
    
    const char *className = NSStringFromClass([superView class]).UTF8String;
    const char *frame = NSStringFromCGRect(superView.frame).UTF8String;
    printf("%s:%s\n", className, frame);
    
    ++level;
    for (UIView *view in superView.subviews) {
        [self printViewHierarchy:view];
    }
    --level;
}

@end

@implementation UIView (mh_image)

- (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(self.mh_size, NO, 0.0);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return img;
}

@end

@implementation UIView (mh_keyboard)

+ (UIView *)findKeyboard
{
    UIView *keyboardView = nil;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    
    if (@available(iOS 13.0, *))
    {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes)
        {
            if (windowScene.activationState == UISceneActivationStateForegroundActive)
            {
                windows = windowScene.windows;

                break;
            }
        }
    }

    for (UIWindow *window in [windows reverseObjectEnumerator])//逆序效率更高，因为键盘总在上方
    {
        keyboardView = [self findKeyboardInView:window];
        if (keyboardView)
        {
            return keyboardView;
        }
    }
    return nil;
}

+ (UIView *)findKeyboardInView:(UIView *)view
{
    for (UIView *subView in [view subviews])
    {
        if (strstr(object_getClassName(subView), "UIKeyboard"))
        {
            return subView;
        }
        else
        {
            UIView *tempView = [self findKeyboardInView:subView];
            if (tempView)
            {
                return tempView;
            }
        }
    }
    return nil;
}

@end

@implementation UIView (mh_normal)

+(instancetype)viewForXibMu{
    return [self viewForXibMuWithIndex:0];
}
+(instancetype)viewForXibMuWithIndex:(NSUInteger)index{
    UIView *tempView = [[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][index];
    //    tempView.translatesAutoresizingMaskIntoConstraints = NO;
    tempView.autoresizingMask = NO;
    CGFloat maxY  = 0;
    UIView *tempSubView = nil;
    for (UIView *subView in tempView.subviews) {
        CGRect temprect2             =  [subView convertRect:subView.bounds toView:tempView];
        CGFloat tempY               = CGRectGetMaxY(temprect2);
        if (tempY > maxY) {
            maxY = tempY;
            tempSubView = subView;
        }
    }
    NSLayoutConstraint *bottomFenceConstraint = nil;
    NSLayoutConstraint *widthFenceConstraint = nil;
    if (tempSubView) {
        
        widthFenceConstraint.priority = UILayoutPriorityRequired ;
        widthFenceConstraint = [NSLayoutConstraint constraintWithItem:tempView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[UIScreen mainScreen].bounds.size.width];
        [tempView addConstraint:widthFenceConstraint];
        
        bottomFenceConstraint.priority = UILayoutPriorityRequired - 1;
        bottomFenceConstraint = [NSLayoutConstraint constraintWithItem:tempSubView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        [tempView addConstraint:bottomFenceConstraint];
    }
    
    CGSize size = [tempView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    [tempView removeConstraint:bottomFenceConstraint];
    [tempView removeConstraint:widthFenceConstraint];
    
    tempView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, size.height);
    return tempView;
}
-(void)refreshViewLayout{
    
    CFRetain((__bridge CFTypeRef)(self));
    [self updateConstraints];
    UIView *tempView = self;
    //    tempView.translatesAutoresizingMaskIntoConstraints = NO;
    tempView.autoresizingMask = NO;
    CGFloat maxY  = 0;
    UIView *tempSubView = nil;
    for (UIView *subView in tempView.subviews) {
        CGRect temprect2             =  [subView convertRect:subView.bounds toView:tempView];
        CGFloat tempY               = CGRectGetMaxY(temprect2);
        if (tempY > maxY) {
            maxY = tempY;
            tempSubView = subView;
        }
    }
    NSLayoutConstraint *bottomFenceConstraint = nil;
    NSLayoutConstraint *widthFenceConstraint = nil;
    if (tempSubView) {
        
        widthFenceConstraint.priority = UILayoutPriorityRequired;
        widthFenceConstraint = [NSLayoutConstraint constraintWithItem:tempView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[UIScreen mainScreen].bounds.size.width];
        [tempView addConstraint:widthFenceConstraint];
        
        bottomFenceConstraint.priority = UILayoutPriorityRequired - 1;
        bottomFenceConstraint = [NSLayoutConstraint constraintWithItem:tempSubView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        [tempView addConstraint:bottomFenceConstraint];
    }
    
    CGSize size = [tempView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    [tempView removeConstraint:bottomFenceConstraint];
    [tempView removeConstraint:widthFenceConstraint];
    
    CGPoint orginal = tempView.frame.origin;
    tempView.frame = CGRectMake(orginal.x, orginal.y, [UIScreen mainScreen].bounds.size.width, size.height);
    [tempView setNeedsLayout];
     CFRelease((__bridge CFTypeRef)(self));
}



@end
