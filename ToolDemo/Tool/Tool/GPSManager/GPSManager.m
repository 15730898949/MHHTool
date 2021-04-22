//
//  GPSManager.m
//  Fplan
//
//  Created by 雷亮 on 16/6/29.
//  Copyright © 2016年 bikeLockTec. All rights reserved.
//

#import "GPSManager.h"

@interface GPSManager ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, copy) GPSCoorClosure coorClosure;

@end

@implementation GPSManager

+ (GPSManager *)instance {
    static GPSManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GPSManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 10;
        
        // 兼容iOS8.0版本
        /* Info.plist里面加上2项中的一项
         NSLocationAlwaysUsageDescription      String YES
         NSLocationWhenInUseUsageDescription   String YES
         */
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            // iOS8.0以上，使用应用程序期间允许访问位置数据
            [_locationManager requestWhenInUseAuthorization];
            // iOS8.0以上，始终允许访问位置信息
//            [_locationManager requestAlwaysAuthorization];
        }
        
        _geocoder = [[CLGeocoder alloc] init];
    }
    return self;
}

- (void)getGPS:(GPSCoorClosure)closure {
    if ([CLLocationManager locationServicesEnabled] == NO) {
        return;
    }
    _coorClosure = closure;
    // 停止上一次定位
    [_locationManager stopUpdatingLocation];
    // 开始新一次定位
    [_locationManager startUpdatingLocation];
}

- (void)stop {
    [_locationManager stopUpdatingLocation];
}

- (void)getPlacemarkWithCoor:(CLLocationCoordinate2D)coor closure:(GPSPlacemarkClosure)closure {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coor.latitude longitude:coor.longitude];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = placemarks.lastObject;
            Placemark *mark = [Placemark initWithCLPlacemark:placemark];
            if (closure) {
                closure(mark);
            }
        }
    }];
}

- (void)getGPSLocationWithAddress:(NSString *)address closure:(GPSCoorClosure)closure {
    [_geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = placemarks.lastObject;

            if (closure) {
                closure(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
            }
        }
    }];
}

#pragma mark -
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;
    CLLocationDegrees lat = location.coordinate.latitude;
    CLLocationDegrees lng = location.coordinate.longitude;
    NSLog(@"当前更新位置: 纬度: (%lf), 经度: (%lf)", lat, lng);
    
    if (_coorClosure) {
        _coorClosure(lat, lng);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    } else if (error.code == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
}

#pragma mark -
#pragma mark - 外部调用方法
+ (void)getGPSLocation:(GPSCoorClosure)closure {
    [[GPSManager instance] getGPS:closure];
}

+ (void)stop {
    [[GPSManager instance] stop];
}

+ (BOOL)locationServicesEnabled {
    return [CLLocationManager locationServicesEnabled];
}

+ (void)getPlacemarkWithLatitude:(NSString *)latitude longitude:(NSString *)longitude closure:(GPSPlacemarkClosure)closure {
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
    [[GPSManager instance] getPlacemarkWithCoor:coor closure:closure];
}

+ (void)getPlacemarkWithCoordinate2D:(CLLocationCoordinate2D)coor closure:(GPSPlacemarkClosure)closure {
    [[GPSManager instance] getPlacemarkWithCoor:coor closure:closure];    
}

+ (void)getGPSLocationWithAddress:(NSString *)address closure:(GPSCoorClosure)closure {
    [[GPSManager instance] getGPSLocationWithAddress:address closure:closure];
}

@end
