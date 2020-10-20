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
#import "TZImagePickerController.h"
@interface ViewController ()<CWCarouselDelegate,CWCarouselDatasource,UITableViewDelegate,UITableViewDataSource,SPPageMenuDelegate>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)UILabel *lable;
@property (nonatomic ,strong)SPPageMenu *pageMenu;

@end

@implementation ViewController

- (void)viewDidLoad {

    [super viewDidLoad];

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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.ly_emptyView = [LYEmptyView emptyActionViewWithImage:nil titleStr:@"暂无数据" detailStr:nil btnTitleStr:@"点击重试" btnClickBlock:^{
        [self.dataArray addObject:[NSString stringWithFormat:@"%ld",self.tableView.page]];
        [self.tableView reloadData];
//        [MBProgressHUD showRingInView:self.view Msg:nil animation:YES];
//        [MBProgressHUD showActivView:self.view Msg:@"加载中" animation:YES];
        [MBProgressHUD showMsg:@"暂无数据"];
        
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
        make.edges.equalTo(self.view);
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
    
    [self addNavBar];

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
    NSLog(@"******%lu",slider.index);
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text  = self.dataArray[indexPath.row];
//    cell.textLabel.sf_text = @"[LABEL]Give  to  [RED]SFAttri[[!]timg_1,0,0,20,20][LABEL]butedString[asdad]";
//    TestTableViewCell1*cell  =[TestTableViewCell1 cellWithTableView:tableView indexPath:indexPath];
//    cell.backgroundColor = [UIColor redColor];
    
    NSString *str = @"123";
    NSMutableAttributedString *attstr =  str.attributedBuild
    .appendSizeImage([UIImage imageNamed:@"timg_1"],CGSizeMake(20, 20))
    .append(@"123")
    .appendSizeImage([UIImage imageNamed:@"timg_1"],CGSizeMake(10, 10)).baselineOffset(10)
    .append(@"123")
    .appendSizeImage([UIImage imageNamed:@"timg_1"],CGSizeMake(20, 20))
    .append(@"123123");
    cell.textLabel.attributedText = attstr;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    ViewController * vc = [[ViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//    BaseWebViewController *vc = [[BaseWebViewController alloc]init];
//    vc.urlString = @"http://47.116.75.232:23341/";
//    [self.navigationController pushViewController:vc animated:YES];
    //初始化 TZImagePickerController  MaxImagerCount 相片最大可选数量  columnNumber 相册选择器中 一行显示cell的数量
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc]initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
    imagePickerVc.isSelectOriginalPhoto = NO;//是否显示原图
    
    imagePickerVc.allowTakePicture = YES;//是否允许显示拍照按钮  本次已关闭 如果有需要可自行赋值
    imagePickerVc.allowTakeVideo = YES;//同上
    
    imagePickerVc.videoMaximumDuration = 10;//视频的最大拍摄时间
    //拍摄视频质量
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    
    imagePickerVc.autoSelectCurrentWhenDone = NO;// 如果用户未选择任何图片，在点击完成按钮时自动选中当前图片，默认YES
    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    imagePickerVc.showPhotoCannotSelectLayer = YES;//如果超过最大选择图片数据  其他照片会显示 模糊图层
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    //是否可以多种类选择  此处 全部设置成NO  可以根据需要 动态设置
    imagePickerVc.allowPickingVideo = YES;//是否允许选择视频
    imagePickerVc.allowPickingImage = YES;//是否允许选择图片
    imagePickerVc.allowPickingOriginalPhoto = NO;//默认为YES，如果设置为NO,原图按钮将隐藏，用户不能选择发送原图
    imagePickerVc.allowPickingGif = YES;//单选是否允许选择gif
    
//    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
//    imagePickerVc.sortAscendingByModificationDate = YES;//照片排列按修改时间升序 默认YES

    imagePickerVc.allowCrop = YES;
        
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.navigationBarTranslationY =  scrollView.contentOffset.y;
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
