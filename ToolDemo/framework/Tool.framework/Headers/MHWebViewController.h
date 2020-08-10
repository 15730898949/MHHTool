//
//  WHWebViewController.h
//  WHWebView
//
//  Created by 魏辉 on 2018/3/8.
//  Copyright © 2018年 魏辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

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

///跳转触发
- (void)mh_webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation;

///jsCallOC数组
@property (nonatomic,strong) NSArray<NSString *> *JSInteractionArray;

///jsCallOC
- (void)mh_userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

///网页加载完成
- (void)mh_webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;


@end

