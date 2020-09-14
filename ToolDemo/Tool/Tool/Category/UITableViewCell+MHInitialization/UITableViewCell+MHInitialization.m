//
//  UITableViewCell+MHInitialization.m
//  Tool
//
//  Created by Mac on 2020/9/13.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "UITableViewCell+MHInitialization.h"

@implementation UITableViewCell(MHInitialization)

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

+ (void)registerWithTableView:(UITableView *)tableView {
    return [self registerWithTableView:tableView reuseIdentifier:[self reuseIdentifier]];
}

+ (void)registerWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier{
    if ([[NSBundle mainBundle] pathForResource:NSStringFromClass([self class]) ofType:@"nib"]) {
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    }else{
        [tableView registerClass:[self class] forCellReuseIdentifier:reuseIdentifier];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    return [self cellWithTableView:tableView indexPath:indexPath reuseIdentifier:[self reuseIdentifier]];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier{
    UITableViewCell *cell = nil;
    @try {
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    } @catch (NSException *exception) {
        [self registerWithTableView:tableView reuseIdentifier:reuseIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    } @finally {
        
        return cell;
    }
}




@end
