//
//  MHBaseTableViewController.m
//  ToolDemo
//
//  Created by Mac on 2020/12/25.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "MHBaseTableViewController.h"
@interface MHBaseTableViewController ()

@end

@implementation MHBaseTableViewController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width, SCREEN_Height - NavgationBar_Height) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.mh_width, 20)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    self.emptyView = [LYEmptyView emptyViewWithImage:nil titleStr:@"暂无数据" detailStr:@""];
    self.tableView.ly_emptyView = self.emptyView;
    

}

- (void)setRefreshHeaderBlock:(void (^)(void))refreshHeaderBlock{
    _refreshHeaderBlock = refreshHeaderBlock;
    __unsafe_unretained typeof(self) weakSelf = self;
    __unsafe_unretained UITableView *tableView = self.tableView;

    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.refreshHeaderBlock) {
            weakSelf.refreshHeaderBlock();
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0/*延迟执行时间*/ * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tableView.mj_header endRefreshing];
        });

    }];
    tableView.mj_header.automaticallyChangeAlpha = YES;

    [tableView bringSubviewToFront:tableView.mj_header];

}



- (void)setRefreshFooterBlock:(void (^)(void))refreshFooterBlock {
    _refreshFooterBlock = refreshFooterBlock;
    
    __unsafe_unretained typeof(self) weakSelf = self;
    __unsafe_unretained UITableView *tableView = self.tableView;

    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.refreshFooterBlock) {
            weakSelf.refreshFooterBlock();
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0/*延迟执行时间*/ * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tableView.mj_footer endRefreshing];
        });

    }];
    tableView.mj_footer.hidden = YES;
    [tableView bringSubviewToFront:tableView.mj_footer];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
