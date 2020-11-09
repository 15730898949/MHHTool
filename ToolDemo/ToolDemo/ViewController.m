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
#import <Tool/LYEmptyViewHeader.h>
#import <Tool/MBProgressHUD+Add.h>
#import <Tool/UIView+Category.h>
#import <Tool/ToolMacro.h>
#import <Tool/MBProgressHUD.h>
#import <Tool/SPPageMenu.h>
#import "TestTableViewCell.h"
#import "TestTableViewCell1.h"
#import "SFAttributedString.h"
#import "NSMutableAttributedString+SCRAttributedStringBuilder.h"
#import <Tool/Tool.h>
#import "BaseWebViewController.h"
@interface ViewController ()<CWCarouselDelegate,CWCarouselDatasource,UITableViewDelegate,UITableViewDataSource,SPPageMenuDelegate,MHInfoItemCellDelegate>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)UILabel *lable;
@property (nonatomic ,strong)SPPageMenu *pageMenu;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBar];

//    NSMutableAttributedString *textFont = [[NSMutableAttributedString alloc] initWithString:@"NSAttributedString设置字体大小"];
    [SFAtStringCore registerAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]} forLabel:@"LABEL"];
    [SFAtStringCore registerAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forLabel:@"RED"];
    
    
    

    self.view.backgroundColor = UIColorFromHex(0x161b2f, 1);
    self.dataArray = [NSMutableArray array];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = UIColorFromHex(0x161b2f, 1);
    [self.tableView registerClass:[MHInfoItemCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.ly_emptyView = [LYEmptyView emptyActionViewWithImage:nil titleStr:@"暂无数据" detailStr:nil btnTitleStr:@"点击重试" btnClickBlock:^{
//        [self.dataArray addObject:[NSString stringWithFormat:@"%ld",self.tableView.page]];
        [self.tableView reloadData];
//        [MBProgressHUD showRingInView:self.view Msg:nil animation:YES];
//        [MBProgressHUD showActivView:self.view Msg:@"加载中" animation:YES];
        [MBHUD show];
        
    }];
//    [MHCurrentViewController.navigationController pushViewController:[ViewController new] animated:YES];

    
    WeakSelf(self)
//    [self.tableView addHeaderRefreshWithBlock:^{
//        [weakself   textNetwork];
//
//    }];
 
    
    [self.dataArray addObjectsFromArray:@[@"123",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213",@"213"]];

    
//    [self.tableView addFooterRefreshWithBlock:^{
//        [weakself.dataArray addObject:[NSString stringWithFormat:@"%ld",weakself.tableView.page]];
//        [weakself.tableView reloadData];
//        [weakself.tableView endRefreshing];
////        [MBProgressHUD showRingInView:UIApplication.sharedApplication.delegate.window Msg:@"加载中" animation:YES];
//    }];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom);
    }];
    self.lable = [[UILabel alloc]init];
    self.lable.textColor = [UIColor redColor];
    [self.view addSubview:self.lable];
    [self.lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(100);
        make.top.offset(100);
        make.height.offset(30);
        make.width.offset(100);
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
    [self   textNetwork ];

    // Do any additional setup after loading the view.
//    self.pageMenu.frame = CGRectMake(0, 300, SCREEN_Width, 100);
//    [self.view addSubview:self.pageMenu];
//    NSArray *colorArr = @[[UIColor redColor],[UIColor blueColor],[UIColor orangeColor],[UIColor grayColor],[UIColor blackColor],[UIColor brownColor],[UIColor purpleColor]];
//    NSMutableArray *arr = [NSMutableArray array];
//    for (UIColor *color in colorArr) {
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//        view.backgroundColor = color;
//        view.userInteractionEnabled = NO;
//        [arr addObject:view];
//    }
//    [self.pageMenu setItems:arr selectedItemIndex:0];
////    [self.pageMenu setItems:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"] selectedItemIndex:0];
    

    self.titleLab.text = @"123333";
    
    
    StepSlider *slider = [[StepSlider alloc]init];
    [slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    slider.trackHeight = 4;
    slider.trackCircleRadius = 0;
    slider.sliderCircleRadius = 4;
    slider.maxCount = 3;
    slider.sliderBounces = NO;
    [self.view addSubview:slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.right.offset(-16);
        make.top.offset(100);
    }];

}

- (void)sliderChange:(StepSlider *)slider{
//    NSLog(@"******%lu",slider.index);
}

- (void)textNetwork{
    
//    NSArray *dataArr = @[@"123",@"234",@"345",[NSNull null]];
//    for (NSString*str in dataArr) {
//        NSLog(@"%@",str);
//        NSLog(@"isnull = %d",isNullString(str));
//
//        self.lable.text = str;
//    }
//    
//    
//    [MBProgressHUD show];
//    WeakSelf(self)
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [weakself.dataArray removeAllObjects];
//        [weakself.tableView reloadData];
//        [weakself.tableView endRefreshing];
//        [MBProgressHUD hide];
//    });
}

- (NSInteger)numbersForCarousel{
    return 1;
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
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MHInfoItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.titleTextField.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.contentTextField.enabled = YES;
    if (indexPath.row == 0) {
        cell.accessoryViewSizeMargin = CGSizeMake(50, 50);
    }else{
        cell.accessoryViewSizeMargin = CGSizeMake(30, 30);
    }
    if (indexPath.row == 2) {
        cell.titleTextField.leftView = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 50)];
            UIImageView *imgView = [UIImageView new];
            imgView.contentMode = UIViewContentModeCenter;
            imgView.image = [UIImage imageNamed:@"add_wechat"];
            imgView.frame = CGRectMake(0, 0, 50, 50);
            imgView.layer.cornerRadius = 15;
            imgView.layer.masksToBounds = YES;
            [view addSubview:imgView];
            
            view;
        });
        cell.titleTextField.leftViewMode = UITextFieldViewModeAlways;
        cell.fixedTitleWidth = 160;
        
        cell.accessoryView = [UISwitch new];

    }else{
        cell.titleTextField.leftView = nil;
        cell.fixedTitleWidth = 100;
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"add_wechat"]]];
    }

    cell.titleTextFieldLeftMargin = 16;
    [cell setDidEndEditing:^(MHInfoItemCell * _Nonnull cell, UITextField * _Nonnull textField) {
        NSLog(@"%ld--%@",[tableView indexPathForCell:cell].row,textField.text);
    }];

    return cell;
}

- (void)infoItemCell:(MHInfoItemCell *)cell didEndEditing:(UITextField *)textField{
    NSLog(@"--%ld--%@",[self.tableView indexPathForCell:cell].row,textField.text);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [MBHUD show];
        [MBHUD hideAnimated:YES afterDelay:3];
    }else if (indexPath.row == 1){
        [MBHUD showMsg:@"111" andOffer:100];
        
    } else{
        [MBHUD showMsg:[NSString stringWithFormat:@"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$%ld",indexPath.row]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.navigationBarTranslationY =  scrollView.contentOffset.y;
    
    [MBHUD showProgress:scrollView.contentOffset.y/(scrollView.contentSize.height - scrollView.height) inView:self.tableView.tableHeaderView animation:YES];
    MBHUD.userInteractionEnabled = NO;
//    MBHUD.progress = scrollView.contentOffset.y/(scrollView.contentSize.height - scrollView.height);
//    MBHUD.label.text = [NSString stringWithFormat:@"%.0f%%",MBHUD.progress*100];
//    [MBHUD.button setTitle:@"111" forState:UIControlStateNormal];

}


#pragma mark - 懒加载

- (SPPageMenu *)pageMenu{
    if (!_pageMenu) {
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0,300, SCREEN_Width, 40) trackerStyle:SPPageMenuTrackerStyleNothing];
        _pageMenu.permutationWay = SPPageMenuPermutationWayScrollAdaptContent;
        _pageMenu.delegate = self;
        _pageMenu.dividingLineHeight = 0.2;
        _pageMenu.isClickItemSlide = NO;
        _pageMenu.spacing = 0;
        [_pageMenu setTrackerHeight:0.3 cornerRadius:0];
    }
    return _pageMenu;
}


@end
