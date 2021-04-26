//
//  Placemark.m
//  Fplan
//
//  Created by 雷亮 on 16/6/29.
//  Copyright © 2016年 bikeLockTec. All rights reserved.
//

#import "Placemark.h"

@implementation Placemark

- (id)mutableCopyWithZone:(NSZone *)zone {
    Placemark *copy = [[[self class] allocWithZone:zone] init];
    copy->_country = [self.country mutableCopy];
    copy->_province = [self.province mutableCopy];
    copy->_city = [self.city mutableCopy];
    copy->_county = [self.county mutableCopy];
    copy->_address = [self.address mutableCopy];
    copy->_placemarkId = self.placemarkId;
    copy->_type = [self.type mutableCopy];
    return copy;
}

- (id)copyWithZone:(NSZone *)zone {
    Placemark *copy = [[[self class] allocWithZone:zone] init];
    copy->_country = [self.country copy];
    copy->_province = [self.province copy];
    copy->_city = [self.city copy];
    copy->_county = [self.county copy];
    copy->_address = [self.address copy];
    copy->_placemarkId = self.placemarkId;
    copy->_type = [self.type copy];
    return copy;
}

- (NSString *)city {
    NSString *cityName = _city;
    if ([cityName hasSuffix:@"市辖区"]) {
        cityName = [cityName substringToIndex:[cityName length] - 3];
    }
    if ([cityName hasSuffix:@"市"]) {
        cityName = [cityName substringToIndex:[cityName length] - 1];
    }
    if ([cityName isEqualToString:@"香港特別行政區"] || [cityName isEqualToString:@"香港特别行政区"]) {
        cityName = @"香港";
    }
    if ([cityName isEqualToString:@"澳門特別行政區"] || [cityName isEqualToString:@"澳门特别行政区"]) {
        cityName = @"澳门";
    }
    return cityName;
}

- (NSString *)province {
    NSString *provinceName = _province;
    if ([provinceName hasSuffix:@"省"]) {
        provinceName = [provinceName substringToIndex:[provinceName length] - 1];
    } else if ([provinceName hasSuffix:@"市"]) {
        provinceName = [provinceName substringToIndex:[provinceName length] - 1];
    }
    return provinceName;
}

- (NSString *)getProvinceAndCity {
    NSString *provinceName = _province ? : @"";
    NSString *cityName = _city ? : @"";
    if ([self.city isEqualToString:self.province]) {
        provinceName = @"";
    }
    if ([cityName hasSuffix:@"市辖区"]) {
        cityName = [cityName substringToIndex:[cityName length] - 3];
    }
    if ([cityName isEqualToString:@"香港特別行政區"] || [cityName isEqualToString:@"香港特别行政区"]) {
        cityName = @"香港";
    }
    if ([cityName isEqualToString:@"澳門特別行政區"] || [cityName isEqualToString:@"澳门特别行政区"]) {
        cityName = @"澳门";
    }
    return [provinceName stringByAppendingString:cityName];
}

+ (Placemark *)initWithCLPlacemark:(CLPlacemark *)placemark {
    Placemark *mark = [[Placemark alloc] init];
    mark.country = placemark.country ? placemark.country : @"";
    mark.province = placemark.administrativeArea ? placemark.administrativeArea : @"";
    mark.city = placemark.locality ? placemark.locality : mark.province;
    mark.county = placemark.subLocality ? placemark.subLocality : @"";
    NSString *formatAddress = [NSString stringWithFormat:@"%@%@", placemark.thoroughfare ? placemark.thoroughfare : @"",
                               placemark.subThoroughfare ? placemark.subThoroughfare:@""];
    mark.address = formatAddress;
    return mark;
}

@end
