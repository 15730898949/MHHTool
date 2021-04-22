//
//  GPSManager.h
//  Fplan
//
//  Created by 雷亮 on 16/6/29.
//  Copyright © 2016年 bikeLockTec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Placemark.h"

typedef void (^GPSCoorClosure) (CLLocationDegrees latitude, CLLocationDegrees longitude);
typedef void (^GPSPlacemarkClosure) (Placemark *placemark);

@interface GPSManager : NSObject <CLLocationManagerDelegate>

/// 定位回调
+ (void)getGPSLocation:(GPSCoorClosure)closure;

/// 停止定位
+ (void)stop;

/// 是否启用定位服务
+ (BOOL)locationServicesEnabled;

/// 反向地理编码获取地址信息
+ (void)getPlacemarkWithLatitude:(NSString *)latitude longitude:(NSString *)longitude closure:(GPSPlacemarkClosure)closure;

/// 反向地理编码获取地址信息
+ (void)getPlacemarkWithCoordinate2D:(CLLocationCoordinate2D)coor closure:(GPSPlacemarkClosure)closure;

/// 地理编码获取经纬度
+ (void)getGPSLocationWithAddress:(NSString *)address closure:(GPSCoorClosure)closure;

@end
