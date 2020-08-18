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
#import "MBProgressHUD+Add.h"
#import <Tool/UIView+Category.h>
#import <Tool/ToolMacro.h>
@interface ViewController ()<CWCarouselDelegate,CWCarouselDatasource,UITableViewDelegate,UITableViewDataSource>
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

      MBProgressHUD*hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
      hud.label.text = @"正在加载";
        
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
    CWCarousel *banner = [[CWCarousel alloc]initWithFrame:CGRectMake(0, 100, SCREEN_Width, 100) delegate:self datasource:self flowLayout:layout];
    banner.isAuto = YES;
    banner.autoTimInterval = 2;
    banner.endless = YES;
    [banner.carouselView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    banner.backgroundColor = [UIColor whiteColor];
    [banner freshCarousel];

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
    UIImageView *imgView = [cell.contentView viewWithTag:10001];
    if(!imgView) {
        imgView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        imgView.tag = 10001;
        imgView.backgroundColor = [UIColor redColor];
        imgView.contentMode =  UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:imgView];
        cell.layer.masksToBounds = YES;
    }
//    imageV.image = [UIImage imageFromColorMu:UIColorFromRGB(arc4random()%255, arc4random()%255, arc4random()%255, 1)];
    imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"timg-%ld",index+1]];
    
    UILabel *lab = [cell.contentView viewWithTag:10002];
    if (!lab) {
        lab = [[UILabel alloc]initWithFrame:CGRectMake(20, cell.contentView.bottom - 30, 200, 20)];
        lab.tag = 10002;
        lab.textColor = [UIColor whiteColor];
        lab.backgroundColor =UIColorFromRGB(0, 0, 0, 0.5);
        [cell.contentView addSubview:lab];
    }
    lab.text = [NSString stringWithFormat:@" 这是第%ld张图片 ",index+1];
    [lab sizeToFit];

    return cell;
}
- (void)CWCarousel:(CWCarousel *)carousel didSelectedAtIndex:(NSInteger)index{
    
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
