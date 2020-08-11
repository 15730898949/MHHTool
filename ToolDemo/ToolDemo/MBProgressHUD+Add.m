//
//  ArcView.m
//  HUD
//
//  Created by yangsq on 2017/4/24.
//  Copyright © 2017年 yangsq. All rights reserved.
//

#import "MBProgressHUD+Add.h"
#import <objc/runtime.h>
@implementation MBProgressHUD(Add)


+(MBProgressHUD *)show{
    return [self showRingInView:[[UIApplication sharedApplication].delegate window] Msg:@"" animation:YES];
}

+(void)hide{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [self HUDForView:[[UIApplication sharedApplication].delegate window]];
        if (hud != nil) {
            hud.removeFromSuperViewOnHide = YES;
            [hud hideAnimated:YES];
        }
    });
}


+(MBProgressHUD *)showRingInView:(UIView *)view Msg:(NSString *)msg animation:(BOOL)animation{
    
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeCustomView;
    [view addSubview:hud];
    
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [[UIColor blackColor]colorWithAlphaComponent:0.7];
    
    SVIndefiniteAnimatedView *arcview = [[SVIndefiniteAnimatedView alloc]initWithFrame:CGRectZero];
    arcview.strokeColor = [UIColor whiteColor];
    arcview.strokeThickness = 2;
    arcview.radius = msg.length?18.f:24.f;
    [arcview sizeToFit];
    hud.customView = arcview;

    NSLayoutConstraint *w_constraint = [NSLayoutConstraint constraintWithItem:arcview
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1
                                                                     constant:arcview.frame.size.width];
    NSLayoutConstraint *h_constraint = [NSLayoutConstraint constraintWithItem:arcview
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1
                                                                     constant:arcview.frame.size.height];
    [hud.customView addConstraints:@[w_constraint,h_constraint]];
    hud.margin = 13.f;
    hud.label.font = [UIFont systemFontOfSize:16];
    hud.label.textColor = [UIColor whiteColor];
    hud.label.text = msg;
    [MBProgressHUD setHudStyle:hud];

    [hud showAnimated:animation];

    return hud;

}




+(void)setHudStyle:(MBProgressHUD *)hud {

    for(UIView *view in hud.bezelView.subviews){
        
        if([view isKindOfClass:[UIActivityIndicatorView class]]){
            UIActivityIndicatorView *indicatorView = (UIActivityIndicatorView *) view;
            [indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        }
        if([view isKindOfClass:[MBRoundProgressView class]]){
            MBRoundProgressView *progressView = (MBRoundProgressView *)view;
            progressView.progressTintColor   = [UIColor whiteColor];
            progressView.backgroundTintColor = [UIColor grayColor];
        }
        
    }
}

+(void)showMsgInView:(UIView *)view msg:(NSString *)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:view];
        hud.removeFromSuperViewOnHide = YES;
        [view addSubview:hud];
        
        hud.mode=MBProgressHUDModeText;
        hud.label.text = msg;
        hud.label.textColor = [UIColor whiteColor];
        hud.label.numberOfLines = 0;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [[UIColor blackColor]colorWithAlphaComponent:0.7];
        
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:1.5];

    });

    
    
}

+(void)showMsg:(NSString *)msg{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:[[UIApplication sharedApplication].delegate window]];
        hud.removeFromSuperViewOnHide = YES;
        [[[UIApplication sharedApplication].delegate window] addSubview:hud];
        hud.mode=MBProgressHUDModeText;
        hud.label.text = msg;
        hud.label.textColor = [UIColor whiteColor];
        hud.label.numberOfLines = 0;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [[UIColor blackColor]colorWithAlphaComponent:0.7];
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:1.5];

    });
}


+(void)showMsg:(NSString *)msg andOffer:(CGFloat)offerset{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:[[UIApplication sharedApplication].delegate window]];
        hud.removeFromSuperViewOnHide = YES;
        [[[UIApplication sharedApplication].delegate window] addSubview:hud];
        
        hud.mode=MBProgressHUDModeText;
        hud.label.text = msg;
        hud.label.textColor = [UIColor whiteColor];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [[UIColor blackColor]colorWithAlphaComponent:0.7];
        hud.offset = CGPointMake(hud.offset.x, hud.offset.y+offerset);
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:1.5];

    });


}

+(MBProgressHUD *)showInView:(UIView *)view animation:(BOOL)animation {
    return [self showRingInView:view Msg:@"" animation:animation];
}

+(void)hideInView:(UIView *)view animation:(BOOL)animation{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [self HUDForView:view];
        if (hud != nil) {
            hud.removeFromSuperViewOnHide = YES;
            [hud hideAnimated:animation];
            
        }
        
        
    });
    
    
}



@end


#pragma -mark svpAnimatedView
@interface SVIndefiniteAnimatedView ()

@property (nonatomic, strong) CAGradientLayer *indefiniteAnimatedGradientLayer;

@end

@implementation SVIndefiniteAnimatedView

- (void)willMoveToSuperview:(UIView*)newSuperview {
    if (newSuperview) {
        [self layoutAnimatedLayer];
    } else {
        [_indefiniteAnimatedGradientLayer removeFromSuperlayer];
        _indefiniteAnimatedGradientLayer = nil;
    }
}

- (void)layoutAnimatedLayer {
    CALayer *layer = self.indefiniteAnimatedGradientLayer;
    [self.layer addSublayer:layer];

    CGFloat widthDiff = CGRectGetWidth(self.bounds) - CGRectGetWidth(layer.bounds);
    CGFloat heightDiff = CGRectGetHeight(self.bounds) - CGRectGetHeight(layer.bounds);
    layer.position = CGPointMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(layer.bounds) / 2 - widthDiff / 2, CGRectGetHeight(self.bounds) - CGRectGetHeight(layer.bounds) / 2 - heightDiff / 2);
}

- (CAGradientLayer *)indefiniteAnimatedGradientLayer {
    if (!_indefiniteAnimatedGradientLayer) {
        CGPoint arcCenter = CGPointMake(self.radius+self.strokeThickness/2+5, self.radius+self.strokeThickness/2+5);
        UIBezierPath* smoothedPath = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:self.radius startAngle:(CGFloat) (M_PI*3/2) endAngle:(CGFloat) (-0.5 * M_PI) clockwise:NO];

        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.contentsScale = [[UIScreen mainScreen] scale];
        shapeLayer.frame = CGRectMake(0.0f, 0.0f, arcCenter.x*2, arcCenter.y*2);
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor = self.strokeColor.CGColor;
        shapeLayer.lineWidth = self.strokeThickness;
        shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.path = smoothedPath.CGPath;
        shapeLayer.strokeStart = 0.4f;
        shapeLayer.strokeEnd = 1.0f;

        _indefiniteAnimatedGradientLayer = [CAGradientLayer layer];
        _indefiniteAnimatedGradientLayer.startPoint = CGPointMake(0.5f, 0.0f);
        _indefiniteAnimatedGradientLayer.endPoint = CGPointMake(0.5f, 1.0f);
        _indefiniteAnimatedGradientLayer.frame = shapeLayer.bounds;
        _indefiniteAnimatedGradientLayer.colors = [NSArray arrayWithObjects:
                                                   (id)[self.strokeColor colorWithAlphaComponent:0.0f].CGColor,
                                                   (id)[self.strokeColor colorWithAlphaComponent:0.5f].CGColor,
                                                   (id)self.strokeColor.CGColor,
                                                   nil];
        _indefiniteAnimatedGradientLayer.locations = [NSArray arrayWithObjects:
                                                      @(0.25f),
                                                      @(0.5f),
                                                      @(1.0f),
                                                      nil];
        _indefiniteAnimatedGradientLayer.mask = shapeLayer;

        NSTimeInterval animationDuration = 1;
        CAMediaTimingFunction *linearCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animation.fromValue = (id) 0;
        animation.toValue = @(M_PI*2);
        animation.duration = animationDuration;
        animation.timingFunction = linearCurve;
        animation.removedOnCompletion = NO;
        animation.repeatCount = INFINITY;
        animation.fillMode = kCAFillModeForwards;
        animation.autoreverses = NO;
        [_indefiniteAnimatedGradientLayer addAnimation:animation forKey:@"rotate"];
    }
    return _indefiniteAnimatedGradientLayer;
}

- (void)setFrame:(CGRect)frame {

    if (!CGRectEqualToRect(frame, super.frame)) {
        [super setFrame:frame];

        if (self.superview) {
            [self layoutAnimatedLayer];
        }
    }

}

- (void)setRadius:(CGFloat)radius {
    if(radius != _radius) {
        _radius = radius;

        [_indefiniteAnimatedGradientLayer removeFromSuperlayer];
        _indefiniteAnimatedGradientLayer = nil;

        if (self.superview) {
            [self layoutAnimatedLayer];
        }
    }
}

- (void)setStrokeColor:(UIColor*)strokeColor {
    _strokeColor = strokeColor;

    [_indefiniteAnimatedGradientLayer removeFromSuperlayer];
    _indefiniteAnimatedGradientLayer = nil;

    if (self.superview) {
        [self layoutAnimatedLayer];
    }
}

- (void)setStrokeThickness:(CGFloat)strokeThickness {
    _strokeThickness = strokeThickness;

    [_indefiniteAnimatedGradientLayer removeFromSuperlayer];
    _indefiniteAnimatedGradientLayer = nil;

    if (self.superview) {
        [self layoutAnimatedLayer];
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake((self.radius+self.strokeThickness/2+5)*2, (self.radius+self.strokeThickness/2+5)*2);
}

@end
