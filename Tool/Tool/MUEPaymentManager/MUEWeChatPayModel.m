//
//  MUEWeChatPayModel.m
//  Pods
//
//  Created by Jekity on 2017/8/29.
//
//

#import "MUEWeChatPayModel.h"

@interface MUEWeChatPayModel()
@property (nonatomic,copy) void (^resultBlock)(PayResp * req);
@property (nonatomic,copy) void (^loginBlock)(SendAuthResp * req);
@end

static MUEWeChatPayModel *model = nil;
@implementation MUEWeChatPayModel

+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (model == nil) {
            model = [MUEWeChatPayModel new];
            
        }
        
    });
    return model;
    //    static __weak MUEWeChatPayModel * instance;
    //    MUEWeChatPayModel *strongInstance = instance;
    //    @synchronized (self) {
    //
    //        if (strongInstance == nil) {
    //
    //            strongInstance = [[[self class]alloc]init];
    //            instance = strongInstance;
    //            tempModel = instance;
    //        }
    //    }
    //    return strongInstance;
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
-(void)performWeChatPayment:(void (^)(PayReq *))req result:(void (^)(PayResp *))result{
    
    if (req) {
        
        PayReq *tempRep = [[PayReq alloc]init];
        req(tempRep);
        if ([self reviewsPaymentData:tempRep]) {
            
            NSURL *url = [NSURL URLWithString:@"weixin://"];
            if([[UIApplication sharedApplication] canOpenURL:url]){
                [WXApi sendReq:tempRep completion:^(BOOL success) {
                    
                }];
                [WXApi handleOpenURL:url delegate:self];
                _resultBlock = result;
            } else {
                
                UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有安装微信，请安装微信后重试。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                
            }
            
        }
        
    }else{
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有初始化微信的相关参数，无法进行支付" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
    }
    
}

-(BOOL)reviewsPaymentData:(PayReq *)payReq{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tips"
                                                    message:@"The 'partnerId' can not be nil!"
                                                   delegate:self
                                          cancelButtonTitle:@"Sure"
                                          otherButtonTitles:nil];
    if (payReq.partnerId.length == 0) {
        alert.message      = @"The 'partnerId' can not be nil!";
        [alert show];
        return NO;
    }else if (payReq.prepayId.length == 0){
        alert.message      = @"The 'prepayId' can not be nil!";
        [alert show];
        return NO;
        
    }else if (payReq.sign.length == 0){
        alert.message      = @"The 'sign' can not be nil!";
        [alert show];
        return NO;
        
    }else if (payReq.nonceStr.length == 0){
        
        alert.message      = @"The 'nonceStr' can not be nil!";
        [alert show];
        return NO;
    }else if (payReq.package.length == 0){
        
        alert.message      = @"The 'package' can not be nil!";
        [alert show];
        return NO;
    }
    else{
        alert = nil;
    }
    return YES;
}
- (void)performWeChatLogin:(void (^)(SendAuthReq *))req controller:(UIViewController *)controller result:(void (^)(SendAuthResp *))result{
    
    _loginBlock = result;
    if ([WXApi isWXAppInstalled]) {
        
        SendAuthReq *tempRep = [[SendAuthReq alloc] init];
        req(tempRep);
        
        [WXApi sendAuthReq:tempRep viewController:controller delegate:self completion:^(BOOL success) {
            
        }];
                
    }else{
        UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"提示" message:@"微信未安装" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [MHCurrentViewController presentViewController:alert animated:YES completion:nil];
    }
}
#pragma -mark 微信支付结果回调

- (void)onResp:(BaseResp *)resp
{
    
    if([resp isKindOfClass:[PayResp class]])
    {
        
        if (self.resultBlock) {
            _resultBlock((PayResp *)resp);
            
        }
    }else if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (self.loginBlock) {
            self.loginBlock((SendAuthResp *)resp);
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex==1) {
        NSString *weChatID = @"414478124";
        NSString *str      = [NSString stringWithFormat: @"itms-apps://itunes.apple.com/cn/app/wechat/id%@?mt=8",weChatID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    else
    {
        return;
    }
    
}
#pragma clang diagnostic pop

- (BOOL)muEWeChatPayApplication:(UIApplication *)application openURL:(NSURL *)url
              sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    [WXApi handleOpenURL:url delegate:[MUEWeChatPayModel sharedInstance]];
    return [self muEWeChatPayApplication:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}
- (BOOL)muEWeChatPayapplication:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    [WXApi handleOpenURL:url delegate:[MUEWeChatPayModel sharedInstance]];
    return [self muEWeChatPayapplication:application handleOpenURL:url];
}
- (BOOL)muDefalutEWeChatPayapplication:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return YES;
}
- (BOOL)muDefalutEWeChatPayApplication:(UIApplication *)application openURL:(NSURL *)url
                     sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return YES;
}
//iOS9以上调用
- (BOOL)muEWeChatPayApplication:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
    [WXApi handleOpenURL:url delegate:[MUEWeChatPayModel sharedInstance]];
    return [self muEWeChatPayApplication:app openURL:url options:options];
}
- (BOOL)muDefalutEWeChatPayApplication:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    return YES;
}

@end
