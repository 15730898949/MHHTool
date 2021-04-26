//
//  ArcView.m
//  HUD
//
//  Created by yangsq on 2017/4/24.
//  Copyright © 2017年 yangsq. All rights reserved.
//

#import "MBProgressHUD+Add.h"
#import <objc/runtime.h>

static MBProgressHUD * _MBHUD = nil;

@implementation MBProgressHUD(Add)


+(MBProgressHUD *)sharedMBHUD{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _MBHUD = [[self alloc]init];
        _MBHUD.removeFromSuperViewOnHide = YES;
        _MBHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        _MBHUD.bezelView.color = [[UIColor blackColor]colorWithAlphaComponent:0.7];
        _MBHUD.margin = 10.f;
        _MBHUD.label.font = [UIFont systemFontOfSize:16];
        _MBHUD.label.textColor = [UIColor whiteColor];
        _MBHUD.label.numberOfLines = 0;
        _MBHUD.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.f].CGColor;
        _MBHUD.layer.shadowOffset = CGSizeMake(3,3);//阴影偏移的位置
        _MBHUD.layer.shadowOpacity = 0.6;//阴影透明度
        _MBHUD.layer.shadowRadius = 5;//阴影圆角
        [_MBHUD setHudStyle];
    });
    return _MBHUD;

}

#pragma -mark 显示加载中

- (void)hide{
    [self hideAnimated:YES];
}

- (void)show{
    [self showRingInView:[[UIApplication sharedApplication].delegate window] Msg:@"" animation:YES];
}
-(void)showLoadingInView:(UIView *)view animation:(BOOL)animation {
    [self showRingInView:view Msg:@"" animation:animation];
}
-(void)showLoadingMsg:(NSString *)msg{
    [self showRingInView:[[UIApplication sharedApplication].delegate window] Msg:msg animation:YES];
}


-(void)showRingInView:(UIView *)view Msg:(NSString *)msg animation:(BOOL)animation{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = self;
        if (hud.superview != view) {
            [self hideAnimated:NO];
            [view addSubview:hud];
        }
        hud.mode = MBProgressHUDModeCustomView;
        hud.backgroundView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];
        hud.userInteractionEnabled = YES;
        SVIndefiniteAnimatedView *arcview = [[SVIndefiniteAnimatedView alloc]initWithFrame:CGRectZero];
        arcview.strokeColor = [UIColor whiteColor];
        arcview.strokeThickness = 2;
        arcview.radius = 18.f;
        [arcview sizeToFit];
        if (msg.length) {
            CGRect rect = arcview.frame;
            rect.origin.x += 8;
            rect.size.width += 16;
            arcview.frame = rect;
        }
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
        hud.label.textColor = [UIColor whiteColor];
        hud.label.text = msg;
        hud.offset = CGPointMake(0, 0);


        [hud showAnimated:animation];

    });

}


//+(void)hideInView:(UIView *)view animation:(BOOL)animation{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        do {
//            MBProgressHUD *hud = [self HUDForView:view];
//            if (hud != nil) {
//                hud.removeFromSuperViewOnHide = YES;
//                [hud hideAnimated:animation];
//            }
//        } while ([self HUDForView:view]);
//    });
//
//
//}

- (void)showProgress:(float)progress{
    [self showProgress:progress inView:[[UIApplication sharedApplication].delegate window] animation:YES];
}

- (void)showProgress:(float)progress inView:(UIView *)view animation:(BOOL)animation{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = self;
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.userInteractionEnabled = YES;
        [hud setHudStyle];
        hud.backgroundView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];
        if (self.superview != view) {
            [self hideAnimated:NO];
            [view addSubview:self];
        }
        [hud showAnimated:animation];
        hud.label.textColor = [UIColor whiteColor];
        hud.progress = progress;
        hud.offset = CGPointMake(0, 0);

    });

}

#pragma -mark 设置样式
-(void)setHudStyle{
    for(UIView *view in self.bezelView.subviews){

        if([view isKindOfClass:[UIActivityIndicatorView class]]){
            UIActivityIndicatorView *indicatorView = (UIActivityIndicatorView *) view;
            [indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [indicatorView setColor:[UIColor whiteColor]];

        }
        if([view isKindOfClass:[MBRoundProgressView class]]){
            MBRoundProgressView *progressView = (MBRoundProgressView *)view;
            progressView.progressTintColor   = [UIColor whiteColor];
            progressView.backgroundTintColor = [UIColor grayColor];
        }

    }
    self.bezelView.color = [UIColor colorWithRed:41/255.f green:42/255.f blue:47/255.f alpha:0.7f];
    self.backgroundView.backgroundColor  = [[UIColor blackColor]colorWithAlphaComponent:0.1];

}
#pragma -mark 显示text
-(void)showMsg:(NSString *)msg{
    [self showInView:[[UIApplication sharedApplication].delegate window] Msg:msg andOffer:0 andDelay:1.5];
}

-(void)showMsgInView:(UIView *)view msg:(NSString *)msg {
    [self showInView:view Msg:msg andOffer:0 andDelay:1.5];
}

-(void)showMsg:(NSString *)msg andOffer:(CGFloat)offerset{
    [self showInView:[[UIApplication sharedApplication].delegate window] Msg:msg andOffer:offerset andDelay:1.5];
}
-(void)showMsg:(NSString *)msg andDelay:(float)delay{
    [self showInView:[[UIApplication sharedApplication].delegate window] Msg:msg andOffer:0 andDelay:delay];
}

-(void)showInView:(UIView *)view Msg:(NSString *)msg andOffer:(CGFloat)offerset andDelay:(float)delay{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = self;
        hud.userInteractionEnabled = NO;
        if (hud.superview != view) {
            [self hideAnimated:NO];
            [view addSubview:hud];
        }

        hud.mode=MBProgressHUDModeText;
        hud.label.text = msg;
        hud.label.textColor = [UIColor whiteColor];
        hud.offset = CGPointMake(0, offerset);
        self.backgroundView.backgroundColor  = [[UIColor blackColor]colorWithAlphaComponent:0.0];

        [hud showAnimated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });


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
