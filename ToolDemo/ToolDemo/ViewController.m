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
@interface ViewController ()<CWCarouselDelegate,CWCarouselDatasource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CWFlowLayout *layout = [[CWFlowLayout alloc]initWithStyle:CWCarouselStyle_H_1];
    CWCarousel *banner = [[CWCarousel alloc]initWithFrame:CGRectMake(0, 100, SCREEN_Width, 100) delegate:self datasource:self flowLayout:layout];
    [banner.carouselView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    banner.backgroundColor = [UIColor redColor];
    [self.view addSubview:banner];
    // Do any additional setup after loading the view.
}

- (NSInteger)numbersForCarousel{
    return 5;
}

- (UICollectionViewCell *)viewForCarousel:(CWCarousel *)carousel indexPath:(NSIndexPath *)indexPath index:(NSInteger)index{
    UICollectionViewCell *cell = [carousel.carouselView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_Width, 30)];
    imageV.image = [UIImage imageFromColorMu:[UIColor orangeColor]];
    [cell.contentView addSubview:imageV];
    return cell;
}

@end
