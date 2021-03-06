//
//  ViewController.m
//  ToolDemo
//
//  Created by Mac on 2020/8/7.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "ViewController.h"
#import <Tool/MHCarousel.h>
#import <Tool/ToolMacro.h>
#import <Tool/UIImage+MUColor.h>
//#import <Tool/MHHTTPSessionManager.h>
#import <Masonry/Masonry.h>
#import <Tool/LYEmptyViewHeader.h>
//#import <Tool/MBProgressHUD+Add.h>
#import <Tool/UIView+MHCategory.h>
#import <Tool/ToolMacro.h>
//#import <Tool/MBProgressHUD.h>
#import <Tool/SPPageMenu.h>
#import "TestTableViewCell1.h"
#import "NSMutableAttributedString+SCRAttributedStringBuilder.h"
#import <Tool/Tool.h>
#import "BaseWebViewController.h"
#import "iCarousel.h"
#import <objc/runtime.h>
#import "AppDelegate.h"
@interface ViewController ()<iCarouselDelegate,iCarouselDataSource,UITableViewDelegate,UITableViewDataSource,SPPageMenuDelegate,MHInfoItemCellDelegate>{
    UIPageControl * _pageControl;
    MHCarousel *carousel;

}
//@property (nonatomic ,strong)UITableView *tableView;
//@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)UILabel *lable;
@property (nonatomic ,strong)SPPageMenu *pageMenu;

@end

@implementation ViewController

- (NSMutableArray *)dataArray{
//    if (!_dataArray) {
//        _dataArray = @[@{@"title":@"头像"},@{@"title":@"姓名"},@{@"title":@"性别"},@{@"title":@"年龄"},@{@"title":@"电话"},@{@"title":@"邮箱"},@{@"title":@"通知"}].mutableCopy;
//    }
    return @[@{@"title":@"头像"},@{@"title":@"姓名"},@{@"title":@"性别"},@{@"title":@"年龄"},@{@"title":@"电话"},@{@"title":@"邮箱"},@{@"title":@"通知"}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBar];
    
    BaseWebViewController *vc = [[BaseWebViewController alloc]init];
    vc.urlString = @"www.sdl96.com/onlineShop/index.html#/pages/index/index";
    [self.navigationController pushViewController:vc animated:YES];
        
//    self.view.backgroundColor = UIColorFromHex(@"#161b2f",1);
//    self.view.backgroundColor = UIColorFromHex1(0x161b2f, 1);
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
//    self.tableView.backgroundColor = UIColorFromHex(0x161b2f, 1);
    [self.tableView registerClass:[MHInfoItemCell class] forCellReuseIdentifier:@"cell"];
//    self.tableView.estimatedRowHeight = 100;
//    self.t
    self.tableView.ly_emptyView = [LYEmptyView emptyActionViewWithImage:nil titleStr:@"暂无数据" detailStr:nil btnTitleStr:@"点击重试" btnClickBlock:^{
//        [self.dataArray addObject:[NSString stringWithFormat:@"%ld",self.tableView.page]];
        [self.tableView reloadData];
//        [MBProgressHUD showRingInView:self.view Msg:nil animation:YES];
//        [MBProgressHUD showActivView:self.view Msg:@"加载中" animation:YES];
//        [MBHUD show];
        
    }];

    
    

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom);
    }];
    
    

    
    [self   textNetwork];

    

    self.titleLab.text = @"123333";
    
//    StepSlider *slider = [[StepSlider alloc]init];
//    [slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
//    slider.trackHeight = 4;
//    slider.trackCircleRadius = 0;
//    slider.sliderCircleRadius = 4;
//    slider.maxCount = 3;
//    slider.sliderBounces = NO;
//    [self.view addSubview:slider];
//    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(16);
//        make.right.offset(-16);
//        make.top.offset(100);
//    }];
    
    [self setBanner];
    [self setFooter];
}

///设置banner
- (void)setBanner{
    carousel = [[MHCarousel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_Width, 100)];
    carousel.pageControl.frame = CGRectMake(0, 70, SCREEN_Width, 20);
    carousel.delegate = self;
    carousel.dataSource = self;
    carousel.pagingEnabled = YES;
    carousel.type = iCarouselTypeLinear;
    carousel.timingSeconds = 2;
    [carousel reloadData];
    self.tableView.tableHeaderView = carousel;

}

- (void)setFooter{
    UIButton *commitBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 20, -15, 50)];
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    commitBtn.backgroundColor = [UIColor whiteColor];
    commitBtn.layer.cornerRadius = 5;
    self.tableView.tableFooterView = commitBtn;
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

- (NSInteger)numberOfItemsInCarousel:(MHCarousel *)carousel{
    carousel.pageControl.numberOfPages = 2;
    return 2;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (view == nil) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_Width, 100)];
        view.layer.masksToBounds = YES;
        view.clipsToBounds = YES;
    }
    
    [view addSubview:({
        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_Width-20, 100)];
        imgView.tag = 10001;
        imgView.backgroundColor = [UIColor redColor];
        imgView.contentMode =  UIViewContentModeScaleAspectFill;
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"timg-%ld",index+1]];
        imgView;
    })];
    
    [view addSubview:({
        UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(20, view.mh_bottom - 30, 200, 20)];
        lab.tag = 10002;
        lab.textColor = [UIColor whiteColor];
        lab.backgroundColor =UIColorFromRGB(0, 0, 0, 0.5);
        lab.text = [NSString stringWithFormat:@" 这是第%ld张图片 ",index+1];
        [lab sizeToFit];
        lab;
    })];
    
    return view;

}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    if (option == iCarouselOptionWrap) {
        return YES;
    }
    return value;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"iCarousel点击%ld",index);
    
}





- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [tableView fd_heightForCellWithIdentifier:@"cell" cacheByIndexPath:indexPath configuration:^(id cell) {
//        [self configCell:cell indexPath:indexPath];
//    }];

    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MHInfoItemCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[MHInfoItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [self configCell:cell indexPath:indexPath];

    return cell;
}


- (void)configCell:(MHInfoItemCell *)cell indexPath:(NSIndexPath *)indexPath{
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *title = self.dataArray[indexPath.row][@"title"];
    cell.titleTextField.text = title;
    cell.contentTextField.enabled = YES;
    cell.contentTextField.text = self.dataArray[indexPath.row][@"content"];
//    cell.contentTextField.attributedText = [[NSAttributedString alloc]initWithString:@"qweqe\ndasdasdasda"];;
    cell.contentTextField.placeholder = [NSString stringWithFormat:@"请输入%@",title];
    cell.accessoryView = nil;
    if ([title isEqualToString:@"头像"]) {
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"add_wechat"]];
        cell.accessoryViewSizeMargin = CGSizeMake(30, 30);
        cell.contentTextField.enabled = NO;
        cell.contentTextField.placeholder = @"";
        cell.contentTextField.text = @"";

    }else if ([title isEqualToString:@"性别"]){
        cell.contentTextField.enabled = NO;
        cell.contentTextField.placeholder = @"";
        cell.contentTextField.text = @"";

    }else if ([title isEqualToString:@"通知"]){
        UISwitch *sw = [UISwitch new];
        [sw addTarget:self action:@selector(changeSW:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = sw;
        cell.contentTextField.enabled = NO;
        cell.contentTextField.placeholder = @"";
//        cell.contentTextField.text = @"";

    }

//    if (indexPath.row == 2) {
//        cell.titleTextField.leftView = ({
//            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 50)];
//            UIImageView *imgView = [UIImageView new];
//            imgView.contentMode = UIViewContentModeCenter;
//            imgView.image = [UIImage imageNamed:@"add_wechat"];
//            imgView.frame = CGRectMake(0, 0, 50, 50);
//            imgView.layer.cornerRadius = 15;
//            imgView.layer.masksToBounds = YES;
//            [view addSubview:imgView];
//
//            view;
//        });
//        cell.titleTextField.leftViewMode = UITextFieldViewModeAlways;
////        cell.fixedTitleWidth = 160;
//
//        cell.accessoryView = [UISwitch new];
//
//    }else{
//        cell.titleTextField.leftView = nil;
////        cell.titleTextField.text = @"";
//        cell.titleTextField.leftViewMode = UITextFieldViewModeAlways;
//    }
    
//    cell.titleLab.text = @"1231";
//    cell.contentTextField.placeholder = @"请输入";
//    cell.contentTextField.enabled = YES;
//    cell.fixedTitleHeight = 50;
    
    
    [cell setTextFieldValueChanged:^(MHInfoItemCell * _Nonnull cell, UITextField * _Nonnull textField) {
        NSIndexPath *index = indexPath;
        NSInteger row =index.row;
        NSLog(@"----%ld--%@",row,textField.text);
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[row]];
        [dic setValue:textField.text forKey:@"content"];
        [self.dataArray replaceObjectAtIndex:row withObject:dic];

    }];

//    [cell layoutView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
//        [MBHUD show];
//        [MBHUD hideAnimated:YES afterDelay:3];
//        NSLog(@"%@",self.dataArray);
//        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        delegate.window.rootViewController = [UIViewController new];
//         [delegate.window makeKeyAndVisible];
        [self.navigationController pushViewController:[ViewController new] animated:YES];
        
    }
//    else if (indexPath.row == 1){
//        [MBHUD showMsg:@"111" andOffer:100];
//
//    } else{
//        [MBHUD showMsg:[NSString stringWithFormat:@"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$%ld",indexPath.row]];
//    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    self.navigationBarTranslationY =  scrollView.contentOffset.y;
//    [self.view endEditing:YES];

    
//    MBHUD.progress = scrollView.contentOffset.y/(scrollView.contentSize.height - scrollView.height);
//    MBHUD.label.text = [NSString stringWithFormat:@"%.0f%%",MBHUD.progress*100];
//    [MBHUD.button setTitle:@"111" forState:UIControlStateNormal];

}

- (void)changeSW:(UISwitch *)sw{
    NSLog(@"%@", [NSString stringWithFormat:@"通知%@",sw.isOn?@"开":@"关"]);
    
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
