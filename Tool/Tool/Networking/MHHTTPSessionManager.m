//
//  MUHTTPSessionManager.m
//  MUKit
//
//  Created by Jekity on 2017/9/15.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MHHTTPSessionManager.h"


@interface MHHTTPSessionManager()
@property(nonatomic, strong)AFHTTPSessionManager *sessionManager;
@end

@implementation MHHTTPSessionManager

static  MHHTTPSessionManager * instance;

#pragma mark - init
+(instancetype)sharedInstance{
    MHHTTPSessionManager * strongInstance = instance;
    @synchronized (self) {
        if (strongInstance == nil) {
            strongInstance                = [[[self class]alloc]init];
            instance                      = strongInstance;
        }
    }
    return strongInstance;
    
}
-(AFHTTPSessionManager *)httpsManager{
    return self.sessionManager;
}
#pragma mark -images


- (void)POSTImage:(NSString *)URLString parameters:(NSDictionary *)parameters images:(NSArray *)images formData:(void (^)(id<AFMultipartFormData> formData))block progress:(void (^)(NSProgress *progress))progress success:(void (^)(id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure{
    
    if (!URLString) {
        return;
    }
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",domainMU?:@"",URLString];
    //内置参数
    NSMutableDictionary *mDict = [self dictionaryWitParameters:parameters];
#ifdef DEBUG
//    NSLog(@"URL=%@",requestURL);
//    NSLog(@"parameters======%@",mDict);
     NSLog(@"URL=%@\n parameters======%@\n",requestURL,mDict);
#endif
    if (headerMU) {
       [self headeWithDictionary:headerMU];
    }
    if(timeoutMu>0){
        
        self.sessionManager.requestSerializer.timeoutInterval = timeoutMu;
    }else{
        self.sessionManager.requestSerializer.timeoutInterval = 10.;;
    }
    // 在parameters里存放照片以外的对象
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.sessionManager POST:requestURL parameters:mDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        if (block) {
            block(formData);
        }
        if (images) {
            for (int i = 0; i < images.count; i++) {
                
                UIImage *image = images[i];
                NSData *imageData = UIImageJPEGRepresentation(image, 1.);
                // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
                // 要解决此问题，
                // 可以在上传时使用当前的系统事件作为文件名
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                [formatter setDateFormat:@"yyyyMMddHHmmss"];
                NSString *dateString = [formatter stringFromDate:[NSDate date]];
                NSString *name = [NSString stringWithFormat:@"image%d", i + 1];
                NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg", dateString, i + 1];
                
                /*
                 *该方法的参数
                 1. appendPartWithFileData：要上传的照片[二进制流]
                 2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
                 3. fileName：要保存在服务器上的文件名
                 4. mimeType：上传的文件的类型
                 */
                [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpeg"];
            }
        }
        
    } progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self modelWithDictionary:responseObject requestURL:URLString success:success failure:failure];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        if (networkingStatusMU) {
            networkingStatusMU(responses.statusCode);
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        failure(task,error,error.localizedDescription);
    }];
    
}
- (void)POSTImage:(NSString *)URLString parameters:(NSDictionary *)parameters images:(NSMutableArray *)images formData:(void (^)(id<AFMultipartFormData> formData))block success:(void (^)(id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure{

    [self POSTImage:URLString parameters:parameters images:images formData:block progress:nil success:success failure:failure];
}

#pragma mark -GET
-(void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters progress:(void (^)(NSProgress *))progress success:(void (^)(id))success failure:(void (^)(NSURLSessionDataTask *, NSError *, NSString *))failure{
    if (!URLString) {
        return;
    }
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",domainMU?:@"",URLString];
    //内置参数
    NSMutableDictionary *mDict = [self dictionaryWitParameters:parameters];
#ifdef DEBUG
//    NSLog(@"URL=%@",requestURL);
    NSLog(@"URL=%@\n parameters======%@\n",requestURL,mDict);
#endif
    if (headerMU) {
        [self headeWithDictionary:headerMU];
    }
    if(timeoutMu>0){
        
        self.sessionManager.requestSerializer.timeoutInterval = timeoutMu;
        
    }else{
        self.sessionManager.requestSerializer.timeoutInterval = 10.;;
    }
    

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.sessionManager GET:requestURL parameters:mDict progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self modelWithDictionary:responseObject requestURL:URLString success:success failure:failure];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        if (networkingStatusMU) {
            networkingStatusMU(responses.statusCode);
        }
        failure(task,error,error.localizedDescription);
    }];
}
-(void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSURLSessionDataTask *, NSError *, NSString *))failure{
    [self GET:URLString parameters:parameters progress:nil success:success failure:failure];
}
#pragma mark-POST
-(void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters progress:(void (^)(NSProgress *))progress success:(void (^)(id))success failure:(void (^)(NSURLSessionDataTask *, NSError *, NSString *))failure{
    
    if (!URLString) {
        return;
    }
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",domainMU?:@"",URLString];
    //内置参数
    NSMutableDictionary *mDict = [self dictionaryWitParameters:parameters];
#ifdef DEBUG
     NSLog(@"URL=%@\n parameters======%@\n",requestURL,mDict);
#endif
    if (headerMU) {
        [self headeWithDictionary:headerMU];
    }
    if(timeoutMu>0){
        
        self.sessionManager.requestSerializer.timeoutInterval = timeoutMu;
    }else{
        self.sessionManager.requestSerializer.timeoutInterval = 10.;;
    }
    [self.sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.sessionManager POST:requestURL parameters:mDict progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self modelWithDictionary:responseObject requestURL:URLString success:success failure:failure];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (networkingStatusMU) {
                networkingStatusMU(responses.statusCode);
            }
            failure(task,error,@"网络差，请稍后重试");
        });

    }];
    
}

-(void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSURLSessionDataTask *, NSError *, NSString *))failure{
    [self POST:URLString parameters:parameters progress:nil success:success failure:failure];
}


#pragma -mark 初始化参数
-(NSMutableDictionary *)dictionaryWitParameters:(NSDictionary *)parameters{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    if (parametersMU) {
        [mDict addEntriesFromDictionary:parametersMU];
    }
    //外部参数
    [mDict addEntriesFromDictionary:(NSMutableDictionary *)parameters];

    return mDict;
}

-(void)modelWithDictionary:(id )responseObject requestURL:(NSString *)urlString success:(void (^)(id responseObjects))success failure:(void (^)(NSURLSessionDataTask *, NSError *, NSString *))failure{
    NSDictionary *resultDict = responseObject;
    NSString *statusKey       = dataFormatMU[@"Status"];//请求数据的状态码字段
    NSString *messageKey      = dataFormatMU[@"Message"];//请求数据的提示消息
    id message = [self getValueWithKeyString:messageKey inDictionary:resultDict];//取消息
    id status = [self getValueWithKeyString:statusKey inDictionary:resultDict];//取返回数据的状态值
    
    if (StatusBlockMU) {
        StatusBlockMU([status integerValue] , message);
    }
    NSLog(@"URL=%@\n Data=%@\n",urlString,[self dictionaryToJson:responseObject]);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (success) {
            success(resultDict);
        }
    });
//    failure(nil,nil,@"网络差，请稍后重试");
}
//根据key取值
-(id)getValueWithKeyString:(NSString *)keyString inDictionary:(NSDictionary *)dictonary
{
    @autoreleasepool {
        __block id temp;
        [[keyString componentsSeparatedByString:@"/"] enumerateObjectsUsingBlock:^(NSString * path, NSUInteger idx, BOOL * _Nonnull stop) {
            if (path.length>0) {
                temp = dictonary[path];
            }
        }];
        return temp;
    }
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    if(dic){
        NSError *parseError = nil;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
        
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    }else{
        return @"";
    }
    
}

//懒加载
- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        //需要在网络请求中添加的字段
        AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
        response.removesKeysWithNullValues = YES;
        _sessionManager.responseSerializer = response;
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];

        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/octet-stream", @"image/jpeg",@"multipart/form-data",nil];
        //有证书
        if (certificatesMU.length > 0) {
            [_sessionManager setSecurityPolicy:[self customSecurityPolicy:certificatesMU]];
        }
    }
    return _sessionManager;
}

//拼接请求头
-(void)headeWithDictionary:(NSDictionary *)dict{
    
    
    [dict.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *key = obj;
        NSString *value = dict[key];
        if (value) {
            [self.sessionManager.requestSerializer setValue:value forHTTPHeaderField:key];

        }
        //        NSLog(@"key==%@,value==%@\n",key,value);
    }];
}
//添加证书,Https必需需要
- (AFSecurityPolicy *)customSecurityPolicy:(NSString *)name {
//    self.sessionManager.baseURL
    //先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:name ofType:nil]; //证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    // validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:certData, nil];
    return securityPolicy;
}

static void(^StatusBlockMU)(NSUInteger status,NSString * message);
static void(^networkingStatusMU)(NSUInteger status);
static NSDictionary *dataFormatMU;
static NSMutableDictionary *headerMU;
static NSString *certificatesMU;
static NSString *domainMU;
static NSMutableDictionary *parametersMU;
static NSUInteger timeoutMu;

+(void)GlobalConfigurationWithDomain:(NSString *)domain Certificates:(NSString *)certificates dataFormat:(NSDictionary *)dataFormat{

    [self GlobalConfigurationWithDomain:domain Certificates:certificates dataFormat:dataFormat timeout:timeoutMu];
}
+(void)GlobalConfigurationWithDomain:(NSString *)domain Certificates:(NSString *)certificates dataFormat:(NSDictionary *)dataFormat timeout:(NSUInteger)timeout{
    dataFormatMU = dataFormat;
    certificatesMU = certificates;
    domainMU = domain;
    timeoutMu = timeout;
}
-(void)GlobalStatus:(void (^)(NSUInteger, NSString *))statusBlock networkingStatus:(void (^)(NSUInteger))networkingStatus{
    StatusBlockMU = statusBlock;
    networkingStatusMU = networkingStatus;
}
+(void)publicParameters:(NSDictionary *)parameters{
    if (parametersMU) {
        [parametersMU addEntriesFromDictionary:parameters];
    }else{
        parametersMU = [parameters mutableCopy];
    }
}
//qing
+(void)requestHeader:(NSDictionary *)parameters{
    if (headerMU) {
        [headerMU addEntriesFromDictionary:parameters];
    }else{
        headerMU = [parameters mutableCopy];
    }
}
@end
