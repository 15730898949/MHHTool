//
//  SortNameTool.m
//  YouYouBao
//
//  Created by Funny on 2017/6/16.
//  Copyright © 2017年 Funny. All rights reserved.
//

#import "SortNameTool.h"


#define NULLString(string) ((![string isKindOfClass:[NSString class]])||[string isEqualToString:@""] || (string == nil) || [string isEqualToString:@""] || [string isKindOfClass:[NSNull class]]||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)

@implementation NameModel

- (void)setChineseCharacter:(NSString *)chineseCharacter {
    _chineseCharacter = chineseCharacter;
    if (NULLString(_chineseCharacter)) {
        return;
    }
    NSString *pinyin = [self transformToPinyinWithString:_chineseCharacter];
    
    self.pinyin = pinyin;
    
}

- (NSString *)transformToPinyinWithString:(NSString *)string {
    
    NSMutableString *mutableString = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    
    return [self checkSpecialString:mutableString];
}

#pragma mark - 检查特殊字符 返回#
- (NSString *)checkSpecialString:(NSString *)spacialString {
    
    NSString *upperString = [[spacialString substringToIndex:1] uppercaseString];
    
    if ([CharacatorNumberArray containsObject:upperString]) {
        self.initialString = upperString;
        return spacialString;
    }else{
        self.initialString = @"#";
        return @"#";
    }
}

@end




@interface SortNameTool ()

@property(nonatomic)NSMutableArray *nameModels;


@end

@implementation SortNameTool


- (NSArray *)getTableArrayWithNames:(NSArray *)names {

    NSMutableArray *nameModels = [self sortToNameModelsWithAllNames:names];
    
    NSMutableArray *endModels = [self sortNameModelsWithsortedNameModels:nameModels];
    
    return endModels;
}

#pragma mark - 把名字数组的model按照ABCD分成 块model
- (NSMutableArray *)sortNameModelsWithsortedNameModels:(NSMutableArray *)sortedNameModels {
    
    NSMutableArray *namesArray = [NSMutableArray arrayWithCapacity:10];
    
    for (int i = 0; i < self.initialArray.count; i ++ ) {
        
        NSMutableArray *numbers = [NSMutableArray arrayWithCapacity:5];
    
        for (int j = 0; j < sortedNameModels.count; j ++ ) {
            
//            BOOL flag = NO;
            
            NameModel *nameModel = sortedNameModels[j];
            if ([nameModel.initialString isEqualToString:self.initialArray[i]]) {
                [numbers addObject:nameModel];
//                flag = YES;
            }
            
//            if (flag == NO) {
//                break;
//            }
        }
        
        [sortedNameModels removeObjectsInArray:numbers];
        
        NSMutableDictionary *numberDic = [NSMutableDictionary dictionaryWithCapacity:10];
        [numberDic setValue:self.initialArray[i] forKey:@"key"];
        [numberDic setValue:numbers forKey:@"values"];

        
        [namesArray addObject:numberDic];
    }

    return namesArray;
}



#pragma mark - 将所有的名字按首字母排序 返回 model
- (NSMutableArray *)sortToNameModelsWithAllNames:(NSArray<NameModel *> *)names {
    
    NSMutableArray *nameModels = [NSMutableArray arrayWithCapacity:100];
    NSMutableSet *upperset = [NSMutableSet setWithCapacity:5];
    
    for (NameModel *nameModel in names) {
        if(nameModel.initialString){
            [upperset addObject:nameModel.initialString];
            [nameModels addObject:nameModel];
        }
    }
    
    //对去重后的首字母数组排序,因为排序后的字符串特殊字符在最前面，所以先移除再排序之后再追加上
    BOOL special = NO;
    if ([upperset containsObject:@"#"]) {
        [upperset removeObject:@"#"];
        special = YES;
    }
    NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:nil ascending:YES]];
    self.initialArray = [upperset sortedArrayUsingDescriptors:sortDesc];
    if (special == YES) {
       self.initialArray = [self.initialArray arrayByAddingObject:@"#"];
    }
    
    //自带的排序规则
    NSArray *ssortDesc = @[[[NSSortDescriptor alloc] initWithKey:@"pinyin" ascending:YES]];
    NSArray *models = [nameModels sortedArrayUsingDescriptors:ssortDesc];
    NSMutableArray *endModels = [NSMutableArray arrayWithArray:models];
    
    return endModels;
    
    
    
}
@end
