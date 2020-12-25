//
//  MHBaseTableViewController.h
//  ToolDemo
//
//  Created by Mac on 2020/12/25.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "MHBaseViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import <MJRefresh/MJRefresh.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHBaseTableViewController : MHBaseViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) LYEmptyView *emptyView;//



@property (nonatomic, copy) void(^refreshHeaderBlock)(void);
@property (nonatomic, copy) void(^refreshFooterBlock)(void);

@end

NS_ASSUME_NONNULL_END
