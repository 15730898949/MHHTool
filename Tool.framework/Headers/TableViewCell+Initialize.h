//
//  TableViewCell+Initialize.h
//  FaZhiChun
//
//  Created by iOS on 2018/6/19.
//  Copyright © 2018年 YHKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Initialize)

/**
 *  @author god~long, 16-04-03 15:04:19
 *
 *  初始化Cell的方法
 *
 *  @param tableView 对应的TableView
 * 
 *
 *  @return TempTableViewCell
 */

+ (instancetype)tempCellWithTable:(UITableView *)tableView;

+ (instancetype)tempXIBCellWithTable:(UITableView *)tableView;

+ (instancetype)tempXIBCellWithTableWithIndex:(NSInteger)index tableView:(UITableView *)tableView;

@end



@interface UICollectionViewCell (Initialize)

+ (instancetype)tempcollectionViewCellWith:(UICollectionView *)collectionView AndIdentifier:(NSString *)identifier AndindexPath:(NSIndexPath *)indexPath;



@end

