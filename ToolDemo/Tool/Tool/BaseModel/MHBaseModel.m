//
//  GOModel.m
//  MJExtensionExample
//
//  Created by nia_wei on 14-12-18.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MHBaseModel.h"

#import <objc/runtime.h>// 导入运行时文件

@interface MHBaseModel()<NSCopying,NSMutableCopying>

@end

@implementation MHBaseModel

/**
 *  归档实现
 */

+ (id)loadFromFile:(NSString *)path {
    id obj = nil;
    @try {
        obj = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    @catch (NSException *exception) {
        obj = nil;
        NSLog(@"Exception : %@", exception);
    }
    @finally {
        
    }
    return obj;
}

//进行编码的协议方法
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    for (int i = 0; i < self.AllKey.allKeys.count; i++) {
        NSString *name = self.AllKey.allKeys[i];
        [aCoder encodeObject:[self valueForKey:name] forKey:name];
    }
}

//进行解码的协议方法
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    //解码
    if (self = [super init])
    {        
        for (int i = 0; i < self.AllKey.allKeys.count; i++) {
            NSString *name = self.AllKey.allKeys[i];
            id value = [aDecoder decodeObjectForKey:name];
            if (value) {
                [self setValue:value forKey:name];
            }
        }

    }
    
    return self;
}


- (BOOL)saveToFile:(NSString *)path {
    return [NSKeyedArchiver archiveRootObject:self toFile:path];
}

+ (id)loadFromData:(NSData *)data {
    id obj = nil;
    @try {
        obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *exception) {
        obj = nil;
        NSLog(@"Exception : %@", exception);
    }
    @finally {
        
    }
    return obj;
}

- (NSData *)dataFromModel {
    id obj = nil;
    @try {
        obj = [NSKeyedArchiver archivedDataWithRootObject:self];
    }
    @catch (NSException *exception) {
        obj = nil;
        NSLog(@"Exception : %@", exception);
    }
    @finally {
        
    }
    return obj;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        for (int i = 0; i < self.AllKey.allKeys.count; i++) {
            NSString * name = self.AllKey.allKeys[i];
            if ([self.AllKey[name] containsString:@"String"]) {
                [self setValue:@"" forKey:name];
            }

        }

        
        
    }
    return self;
}

- (NSDictionary *)AllKey{
    
    // 获取当前类的所有属性
    unsigned int outCount = 0;
    Ivar *varList = class_copyIvarList([self class], &outCount);
    NSMutableDictionary *nameTypeDic = [NSMutableDictionary dictionary];
    
    
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = varList[i];
        // 1.获取成员变量名称
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        if ([ivarName hasPrefix:@"_"]) {
            ivarName = [ivarName substringFromIndex:1];
        }
        
        
        // 2.获取成员变量类型 @\"
        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        
        type = [type stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]];
        
        
        [nameTypeDic setValue:type forKey:ivarName];
    }
    return  nameTypeDic;

}


//- (id)copyWithZone:(NSZone *)zone{
//     id p = [[[self class] allocWithZone:zone] init];
//
//    for (int i = 0; i < self.AllKey.allKeys.count; i++) {
//        NSString * name = self.AllKey.allKeys[i];
//        [p setValue:[[self valueForKey:name] copy] forKey:name];
//    }
//
//    return p;
//
//}
//
//- (id)mutableCopyWithZone:(NSZone *)zone{
//    id p = [[[self class] allocWithZone:zone] init];
//
//    for (int i = 0; i < self.AllKey.allKeys.count; i++) {
//        NSString * name = self.AllKey.allKeys[i];
//        [p setValue:[[self valueForKey:name] mutableCopy] forKey:name];
//    }
//
//    return p;
//
//}
//
-(id)copyWithZone:(NSZone *)zone{
    id  model = [[[self class] allocWithZone:zone] init];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:propertyName];
        if (value) {
            [model setValue:value forKey:propertyName];
        }
    }
    free(properties);
    return model;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    id model = [[[self class] allocWithZone:zone] init];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:propertyName];
        if (value) {
            [model setValue:value forKey:propertyName];
        }
    }
    free(properties);
    return model;
}


+ (NSArray *)mj_ignoredPropertyNames{
    return @[@"AllKey"];
}


@end
