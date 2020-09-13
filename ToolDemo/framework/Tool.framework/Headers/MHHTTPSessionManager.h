//
//  MUHTTPSessionManager.h
//  MUKit
//
//  Created by Jekity on 2017/9/15.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface MHHTTPSessionManager : NSObject
+(instancetype)sharedInstance;
@property (nonatomic,weak,readonly) AFHTTPSessionManager *httpsManager;


///post请求有进度NSProgress
- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters progress:(void (^)(NSProgress *progress))progress success:(void (^)(id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;
///post请求
- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;

#pragma mark -GET
///get请求有进度NSProgress
- (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters progress:(void (^)(NSProgress *progress))progress success:(void (^)(id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;

///get请求
- (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;


/// post images有进度NSProgress
- (void)POSTImage:(NSString *)URLString parameters:(NSDictionary *)parameters images:(NSMutableArray *)images formData:(void (^)(id<AFMultipartFormData> formData))block progress:(void (^)(NSProgress *progress))progress success:(void (^)(id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;
/// post images
- (void)POSTImage:(NSString *)URLString parameters:(NSDictionary *)parameters images:(NSMutableArray *)images formData:(void (^)(id<AFMultipartFormData> formData))block success:(void (^)(id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;


//@param statusBlock a block object to be excuted when the requesting responsed.如果你设置了‘Status’，响应数据有这个字段时，就会返回响应的数据
//@param networkingStatus a block object to be excuted when the requesting failure.当请求失败时(404、400、500....),就会执行这个block
//这个方法只需设置一次，可作为全局状态监控。处理相应业务
-(void)GlobalStatus:(void(^)(NSUInteger status,NSString *message))statusBlock networkingStatus:(void(^)(NSUInteger status))networkingStatus;


///参数配置第一个参数为域名，第二个为证书名称，第三个为数据格式@{@"Success":@"Success"} 第四个为等待请求时间
+(void)GlobalConfigurationWithDomain:(NSString *)domain Certificates:(NSString *)certificates dataFormat:(NSDictionary *)dataFormat timeout:(NSUInteger)timeout;
///参数配置第一个参数为域名，第二个为证书名称，第三个为数据格式@{@"Success":@"Success"}
+(void)GlobalConfigurationWithDomain:(NSString *)domain Certificates:(NSString *)certificates dataFormat:(NSDictionary *)dataFormat;
///公共参数
+(void)publicParameters:(NSDictionary *)parameters;
///设置请求头
+(void)requestHeader:(NSDictionary *)parameters;
@end
