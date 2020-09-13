//
//  UITableViewCell+MHInitialization.h
//  Tool
//
//  Created by Mac on 2020/9/13.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell(MHInitialization)
+ (void)registerWithTableView:(UITableView *)tableView;
+ (void)registerWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier;

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
