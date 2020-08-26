//
//  WHWebViewController.m
//  WHWebViewController
//
//  Created by 魏辉 on 2018/3/7.
//  Copyright © 2018年 魏辉. All rights reserved.
//

#import "MHWebViewController.h"
#import "Masonry.h"
#define NAV_HEIGHT (CGRectGetHeight(self.navigationController.navigationBar.bounds) +CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))

@interface MHWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,UIGestureRecognizerDelegate>{
    BOOL navigationBarHidden;
}
@property(nonatomic , strong)id delegate;

@property (nonatomic,strong) UIRefreshControl *refreshControl;  //刷新
@property (nonatomic,strong) UIProgressView *progress;  //进度条
@property (nonatomic,strong) UIButton *reloadBtn;  //重新加载按钮


@end

@implementation MHWebViewController


#pragma mark lazy load
- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        // 设置WKWebView基本配置信息
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.preferences = [[WKPreferences alloc] init];
        configuration.allowsInlineMediaPlayback = YES;
        configuration.selectionGranularity = YES;
        
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        [userContentController addScriptMessageHandler:self name:@"jsCallOC"];
        
        if (self.jsString) {
            WKUserScript *jsString = [[WKUserScript alloc] initWithSource:self.jsString injectionTime:(WKUserScriptInjectionTimeAtDocumentStart) forMainFrameOnly:NO];
            [userContentController addUserScript:jsString];
        }
        configuration.userContentController = userContentController;

        self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-NAV_HEIGHT) configuration:configuration];
        // 设置代理
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
        
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        // 是否开启下拉刷新
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0 && _canDownRefresh) {
            if (@available(iOS 10.0, *)) {
                _wkWebView.scrollView.refreshControl = self.refreshControl;
            } else {
                // Fallback on earlier versions
            }
        }
        // 添加进度监听
        [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:(NSKeyValueObservingOptionNew) context:nil];
        
        
    }
    return _wkWebView;
}

- (UIRefreshControl *)refreshControl{
    if (!_refreshControl) {
        self.refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(wkWebViewReload) forControlEvents:(UIControlEventValueChanged)];
    }
    return _refreshControl;
}

- (UIProgressView* )progress {
    if (!_progress) {
        self.progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, [UIScreen mainScreen].bounds.size.width, 2)];
        _progress.progressTintColor = _loadingProgressColor?_loadingProgressColor:[UIColor orangeColor];
    }
    return _progress;
}

- (void)setLoadingProgressColor:(UIColor *)loadingProgressColor{
    _loadingProgressColor = loadingProgressColor;
    self.progress.progressTintColor = loadingProgressColor;
}

- (void)setCanDownRefresh:(BOOL)canDownRefresh{
    _canDownRefresh = canDownRefresh;
    if (@available(iOS 10.0, *)) {
        // 是否开启下拉刷新
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0 && _canDownRefresh) {
            _wkWebView.scrollView.refreshControl = self.refreshControl;
            
        }else{
            _wkWebView.scrollView.refreshControl = nil;
            
        }
    } else {
        // Fallback on earlier versions
    }


}


- (UIButton *)reloadBtn{
    if (!_reloadBtn) {
        self.reloadBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _reloadBtn.frame = CGRectMake(0, 0, 200, 140);
        [_reloadBtn setTitle:@"网络异常" forState:UIControlStateNormal];
        [_reloadBtn addTarget:self action:@selector(wkWebViewReload) forControlEvents:(UIControlEventTouchUpInside)];
        [_reloadBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _reloadBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//        [_reloadBtn setTitleEdgeInsets:UIEdgeInsetsMake(200, -50, 0, -50)];
        _reloadBtn.titleLabel.numberOfLines = 0;
        _reloadBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_reloadBtn sizeToFit];
        _reloadBtn.center = self.view.center;
        CGRect rect = _reloadBtn.frame;
        rect.origin.y -= 100;
        _reloadBtn.frame = rect;
        _reloadBtn.hidden = YES;
    }
    return _reloadBtn;
}


- (UIButton *)closeBarButton {
    if (!_closeBarButton) {
        _closeBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBarButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _closeBarButton.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:15.f];
        [_closeBarButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
//        [self.navBar addSubview:_closeBarButton];
//        [_closeBarButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.backBtn);
//            make.left.equalTo(self.backBtn.mas_right).offset(10);
//        }];
        
        
    }
    return _closeBarButton;
}
- (void)setJSInteractionArray:(NSArray<NSString *> *)JSInteractionArray{
    _JSInteractionArray = JSInteractionArray;
    [[self.wkWebView configuration].userContentController removeAllUserScripts];
    for (NSString *nameStr in _JSInteractionArray) {
        [[self.wkWebView configuration].userContentController addScriptMessageHandler:self name:nameStr];

    }
}

- (void)setProgressHide:(BOOL)progressHide{
    _progressHide = progressHide;
    self.progress.hidden = _progressHide;
}

#pragma mark viewDidload
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    [self loadRequest];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 记录系统返回手势的代理
    _delegate = self.navigationController.interactivePopGestureRecognizer.delegate;
    // 设置系统返回手势的代理为当前控制器
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 设置系统返回手势的代理为我们刚进入控制器的时候记录的系统的返回手势代理
    self.navigationController.interactivePopGestureRecognizer.delegate = _delegate;
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([_wkWebView canGoBack]) {
        return NO;
    } else {
        return self.navigationController.childViewControllers.count > 1;
    }

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([_wkWebView canGoBack]) {
        return NO;
    } else {
        return self.navigationController.childViewControllers.count > 1;
    }
}



#pragma mark private Methods
- (void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self showLeftBarButtonItem];
    [self.view addSubview:self.wkWebView];
    [self.view addSubview:self.progress];
    [self.view addSubview:self.reloadBtn];
}

- (void)loadRequest {
    if (![self.urlString hasPrefix:@"http"]) {//容错处理 不要忘记plist文件中设置http可访问 App Transport Security Settings
        self.urlString = [NSString stringWithFormat:@"http://%@",self.urlString];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:20];
    NSDictionary *cachedHeaders = [[NSUserDefaults standardUserDefaults] objectForKey:_urlString];
    //设置request headers (带上上次的请求头下面两参数一种就可以，也可以两个都带上)
    if (cachedHeaders) {
        NSString *etag = [cachedHeaders objectForKey:@"Etag"];
        if (etag) {
            [request setValue:etag forHTTPHeaderField:@"If-None-Match"];
        }
        NSString *lastModified = [cachedHeaders objectForKey:@"Last-Modified"];
        if (lastModified) {
            [request setValue:lastModified forHTTPHeaderField:@"If-Modified-Since"];
        }
    }
    [_wkWebView loadRequest:request];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"httpResponse == %@", httpResponse);
        // 根据statusCode设置缓存策略
        if (httpResponse.statusCode == 304 || httpResponse.statusCode == 0) {
            [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
        } else {
            [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
            // 保存当前的NSHTTPURLResponse
            [[NSUserDefaults standardUserDefaults] setObject:httpResponse.allHeaderFields forKey:self.urlString];
        }
        // 重新刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_wkWebView reload];
        });
    }] resume];
    
    
    
}

- (void)wkWebViewReload{
    [_wkWebView reload];
}

- (void)showLeftBarButtonItem {
    if ([_wkWebView canGoBack]) {
        self.self.closeBarButton.hidden = NO;
    } else {
        self.self.closeBarButton.hidden = YES;
    }
}
#pragma mark 导航按钮
-(void)backAction{
    if ([_wkWebView canGoBack]) {
        [_wkWebView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}


- (void)close:(UIButton*)item {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object == self.wkWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        self.progress.alpha = 1.0f;
        [self.progress setProgress:newprogress animated:YES];
        if (newprogress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.progress.alpha = 0.0f;
                             }
                             completion:^(BOOL finished) {
                                 [self.progress setProgress:0 animated:NO];
                             }];
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }

    
}

#pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    if (!self.progressHide) {
        _progress.hidden = NO;
    }
    _wkWebView.hidden = NO;
    _reloadBtn.hidden = YES;
    // 看是否加载空网页
    if ([webView.URL.scheme isEqual:@"about"]) {
        webView.hidden = YES;
    }
    [self mh_webView:webView didStartProvisionalNavigation:navigation];
}

- (void)mh_webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    //执行JS方法获取导航栏标题
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        self.title = title;
    }];
    
    [self showLeftBarButtonItem];
    [_refreshControl endRefreshing];
    [self mh_webView:webView didFinishNavigation:navigation];
    self.progress.alpha = 0.0f;

}

- (void)mh_webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
}

#pragma mark - WKNavigationDelegate method
// 如果不添加这个，那么wkwebview跳转不了AppStore
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}




// 返回内容是否允许加载
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

//页面加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    webView.hidden = YES;
    _reloadBtn.hidden = NO;
}

#pragma mark UIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];

}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];

}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark WKScriptMessageHandler js 拦截 调用OC方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
    NSLog(@"方法名:%@", message.name);
    NSLog(@"参数:%@", message.body);
    //    // 方法名
    //    NSString *methods = [NSString stringWithFormat:@"%@:", message.name];
    //    SEL selector = NSSelectorFromString(methods);
    //    // 调用方法
    //    if ([self respondsToSelector:selector]) {
    //        [self performSelector:selector withObject:message.body];
    //    } else {
    //        NSLog(@"未实行方法：%@", methods);
    //    }
    
    if([message.name isEqualToString:@"jsCallOc"]){
        // do something
    }
    
    [self mh_userContentController:userContentController didReceiveScriptMessage:message];
    
}

- (void)mh_userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
}





#pragma mark Dealloc
- (void)dealloc{
    [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_wkWebView stopLoading];
    _wkWebView.UIDelegate = nil;
    _wkWebView.navigationDelegate = nil;
    
    [[self.wkWebView configuration].userContentController removeAllUserScripts];
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
