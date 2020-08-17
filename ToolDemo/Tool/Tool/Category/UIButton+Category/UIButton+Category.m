//
//  UIButton+Category.m
//  Tool
//
//  Created by Mac on 2020/8/17.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "UIButton+Category.h"
#import <objc/runtime.h>

@implementation UIButton(Category)

- (void)layoutButtonWithEdgeInsetsStyle:(MHButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space {
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    switch (style) {
        case MHButtonEdgeInsetsStyleTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        }
            break;
        case MHButtonEdgeInsetsStyleLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case MHButtonEdgeInsetsStyleBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }
            break;
        case MHButtonEdgeInsetsStyleRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
            break;
        default:
            break;
    }
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}
-(void)setSwapPositionMu:(BOOL)swapPositionMu{
    if (swapPositionMu) {
        [self.titleLabel sizeToFit];
        UIImage *image = self.currentImage;
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width, 0, -self.titleLabel.bounds.size.width)];
    }
    objc_setAssociatedObject(self, @selector(swapPositionMu), @(swapPositionMu), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BOOL)swapPositionMu{
    
    return [objc_getAssociatedObject(self, @selector(swapPositionMu)) boolValue];
}

-(void)startCountDownWithSeconds:(NSInteger)seconds{
    __block NSInteger timeOut = seconds;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //设置定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(timer, ^{
        
        if (timeOut <=0 ) {//倒计时结束
            
            dispatch_source_cancel(timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{//设置显示
                
                self.userInteractionEnabled = YES;
                [self setTitle:@" 重新获取 " forState:UIControlStateNormal];
                [self setTitle:@" 重新获取 " forState:UIControlStateDisabled];
                
            });
            
            
        }else{
            
            NSString *string = [NSString stringWithFormat:@" %lds ",(long)timeOut];
            
            dispatch_async(dispatch_get_main_queue(), ^{//设置显示
                
                self.userInteractionEnabled = NO;
                [self setTitle:string forState:UIControlStateNormal];
                //                self.titleLabel.text = string;
                [self setTitle:string forState:UIControlStateDisabled];
            });
            timeOut --;
        }
    });
    
    dispatch_resume(timer);
}

-(void)countDownWithSeconds:(NSInteger)seconds callback:(void (^)(NSString *))callback{
    __block NSInteger timeOut = seconds;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //设置定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(timer, ^{
        
        NSString *string = [NSString stringWithFormat:@"%ld",(long)timeOut];

        if (timeOut <=0 ) {//倒计时结束
            
            dispatch_source_cancel(timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{//设置显示
                
                self.userInteractionEnabled = YES;
                [self setTitle:@" 重新获取 " forState:UIControlStateNormal];
                [self setTitle:@" 重新获取 " forState:UIControlStateDisabled];
                
            });
            
            
        }else{
            
            
            dispatch_async(dispatch_get_main_queue(), ^{//设置显示
                self.userInteractionEnabled = NO;
                [self setTitle:string forState:UIControlStateNormal];
                //                self.titleLabel.text = string;
                [self setTitle:string forState:UIControlStateDisabled];
            });
            timeOut --;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                callback(string);
            }
        });

    });
    
    dispatch_resume(timer);
}

@end
