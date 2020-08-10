//
//  ViewController.m
//  ToolDemo
//
//  Created by Mac on 2020/8/7.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "ViewController.h"
#import <Tool/CWCarousel.h>
#import <Tool/ToolMacro.h>
#import <Tool/UIImage+MUColor.h>
#import <Tool/MHHTTPSessionManager.h>
#import <Masonry/Masonry.h>
#import <Tool/UIScrollView+Emm.h>
#import <Tool/LYEmptyViewHeader.h>
@interface ViewController ()<CWCarouselDatasource,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableCell"];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.ly_emptyView = [LYEmptyView emptyActionViewWithImage:nil titleStr:@"暂无数据" detailStr:nil btnTitleStr:@"点击重试" btnClickBlock:^{
        [self.dataArray addObject:[NSString stringWithFormat:@"%ld",self.tableView.page]];
        [self.tableView reloadData];
    }];
    
    WeakSelf(self)
    [self.tableView addHeaderRefreshWithBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself.dataArray removeAllObjects];
            [weakself.tableView reloadData];
            [weakself.tableView endRefreshing];
        });

    }];
 
    [self.tableView addFooterRefreshWithBlock:^{
        [weakself.dataArray addObject:[NSString stringWithFormat:@"%ld",weakself.tableView.page]];
        [weakself.tableView reloadData];
        [weakself.tableView endRefreshing];

    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    
    CWFlowLayout *layout = [[CWFlowLayout alloc]initWithStyle:CWCarouselStyle_Normal];
    CWCarousel *banner = [[CWCarousel alloc]initWithFrame:CGRectMake(0, 100, SCREEN_Width, 100) delegate:nil datasource:self flowLayout:layout];
    [banner.carouselView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    banner.backgroundColor = [UIColor redColor];
    self.tableView.tableHeaderView = banner;
    // Do any additional setup after loading the view.
}

- (void)textNetwork{
    [[MHHTTPSessionManager sharedInstance] POST:@"" parameters:nil success:^(id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg) {
        
    }];
}

- (NSInteger)numbersForCarousel{
    return 5;
}

- (UICollectionViewCell *)viewForCarousel:(CWCarousel *)carousel indexPath:(NSIndexPath *)indexPath index:(NSInteger)index{
    UICollectionViewCell *cell = [carousel.carouselView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_Width, 100)];
    imageV.image = [UIImage imageFromColorMu:UIColorFromRGB(arc4random()%255, arc4random()%255, arc4random()%255, 1)];
    [cell.contentView addSubview:imageV];
    return cell;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    cell.textLabel.text  = self.dataArray[indexPath.row];
    
    return cell;
}


@end
