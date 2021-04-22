//
//  Placemark.h
//  Fplan
//
//  Created by 雷亮 on 16/6/29.
//  Copyright © 2016年 bikeLockTec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Placemark : NSObject

@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *county;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) int placemarkId;
@property (nonatomic, strong) NSString *type;

- (NSString *)getProvinceAndCity;

+ (Placemark *)initWithCLPlacemark:(CLPlacemark *)placemark;

@end
