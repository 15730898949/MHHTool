//
//  MUEPaymentManager.m
//  Pods
//
//  Created by Jekity on 2017/8/25.
//
//

#import "MUEPaymentManager.h"
#import "MUEAliPayModel.h"
#import "MUEWeChatPayModel.h"
#import <objc/runtime.h>
#import <objc/message.h>

void MUPayHookMethodDefalut(NSString * originalClassName ,SEL originalSEL ,SEL defalutSEL,NSString * newClassName ,SEL newSEL)//if 'originalSEL' method not found in original Class,then we auto add a 'defalutSEL' method to it;
{
    const char * originalName = [originalClassName UTF8String];
    const char * newName      = [newClassName UTF8String];

    Class originalClass = objc_getClass(originalName);//get a class through a string
    if (originalClass == 0) {
        NSLog(@"I can't find a class through a 'originalClassName'");
        return;
    }
    Class newClass     = objc_getClass(newName);
    if (newClass == 0) {
        NSLog(@"I can't find a class through a 'newClassName'");
        return;
    }
    class_addMethod(originalClass, newSEL, class_getMethodImplementation(newClass, newSEL), nil);//if newSEL not found in originalClass,it will auto add a method to this class;
    class_addMethod(originalClass, originalSEL, class_getMethodImplementation(newClass, defalutSEL), nil);///if 'originalSEL' method not found in original Class,then we auto add a 'defalutSEL' method to it;
    Method oldMethod = class_getInstanceMethod(originalClass, originalSEL);
    assert(oldMethod);
    Method newMethod = class_getInstanceMethod(originalClass, newSEL);
    assert(newMethod);
    method_exchangeImplementations(oldMethod, newMethod);
    
}


@implementation MUEPaymentManager
+(void)load{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wundeclared-selector"
        MUPayHookMethodDefalut(MUPayAppDelegateName, @selector(application:openURL:sourceApplication:annotation:), @selector(muDefalutEAlipayApplication:openURL:sourceApplication:annotation:), NSStringFromClass([MUEAliPayModel class]), @selector(muEAlipayApplication:openURL:sourceApplication:annotation:));
        
        MUPayHookMethodDefalut(MUPayAppDelegateName, @selector(application:openURL:options:), @selector(muDefalutEAlipayApplication:openURL:options:), NSStringFromClass([MUEAliPayModel class]), @selector(muEAlipayApplication:openURL:options:));
        
        //weChat
        [WXApi registerApp:MUPayWXAPPID universalLink:MUPayWXUniversalLink];//注册微信
        
        MUPayHookMethodDefalut(MUPayAppDelegateName, @selector(application:openURL:sourceApplication:annotation:), @selector(muDefalutEWeChatPayApplication:openURL:sourceApplication:annotation:), NSStringFromClass([MUEWeChatPayModel class]), @selector(muEWeChatPayApplication:openURL:sourceApplication:annotation:));
        
        MUPayHookMethodDefalut(MUPayAppDelegateName, @selector(application:openURL:options:), @selector(muDefalutEWeChatPayApplication:openURL:options:), NSStringFromClass([MUEWeChatPayModel class]), @selector(muEWeChatPayApplication:openURL:options:));
        
        MUPayHookMethodDefalut(MUPayAppDelegateName, @selector(application:handleOpenURL:), @selector(muDefalutEWeChatPayapplication: handleOpenURL:), NSStringFromClass([MUEWeChatPayModel class]), @selector(muEWeChatPayapplication:handleOpenURL:));
        
#pragma clang diagnostic pop
        
        
    });
    
}
#pragma mark -AliPay
+(void)muEPaymentManagerWithAliPay:(NSString *)privateKey result:(void(^)(NSDictionary *))result{
     [[MUEAliPayModel sharedInstance] performAliPayment:privateKey appScheme:MUPayAlipayScheme result:result];
}

#pragma mark -WeChat
+(void)muEPaymentManagerWithWeChatPay:(void (^)(PayReq *))req result:(void (^)(PayResp *))result{
    [[MUEWeChatPayModel sharedInstance] performWeChatPayment:req result:result];
}

+ (void)muEPaymentManagerWithWeChatLogin:(void (^)(SendAuthReq *))req controller:(UIViewController *)controller result:(void (^)(SendAuthResp *))result{

    [[MUEWeChatPayModel sharedInstance] performWeChatLogin:req controller:controller result:result];
}

@end
