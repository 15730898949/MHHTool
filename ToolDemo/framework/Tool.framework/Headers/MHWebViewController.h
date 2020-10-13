//
//  WHWebViewController.h
//  WHWebView
//
//  Created by 魏辉 on 2018/3/8.
//  Copyright © 2018年 魏辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <Tool/MHNavigation.h>

typedef void (^MessageBlock)(WKUserContentController *userContentController,WKScriptMessage *message);

@interface MHWebViewController : UIViewController

@property (nonatomic,strong) WKWebView *wkWebView;  //  WKWebView

/**
 请求的url
 */
@property (nonatomic,copy) NSString *urlString;

/**
 要注入的js方法
 */
@property (nonatomic,copy) NSString *jsString;


/**
 进度条颜色
 */
@property (nonatomic,strong) UIColor *loadingProgressColor;

/**
 是否下拉重新加载
 */
@property (nonatomic, assign) BOOL canDownRefresh;

@property (nonatomic, assign) BOOL progressHide;



@property (nonatomic, strong) UIButton *closeBarButton;  //关闭按钮


/** JS调用OC方法 */
- (void)addScriptMessageHandlerWithName:(NSArray<NSString *> *)nameArr observeValue:(MessageBlock)callback;


/** OC调用JS方法 */
- (void)callJS:(NSString *)jsMethod;
- (void)callJS:(NSString *)jsMethod handler:(void (^)(id response, NSError *error))handler;

@end

