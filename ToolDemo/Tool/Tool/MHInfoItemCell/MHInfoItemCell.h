//
//  LYInfoItemCell.h
//  LYInfoItemCell
//
//  Created by Teonardo on 2019/9/20.
//  Copyright © 2019 Teonardo. All rights reserved.
//

/**
    //设置左图片
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

 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MHInfoItemCell;
@protocol MHInfoItemCellDelegate <NSObject>
@optional
- (void)infoItemCell:(MHInfoItemCell *)cell didBeginEditing:(UITextField *)textField;
- (void)infoItemCell:(MHInfoItemCell *)cell didEndEditing:(UITextField *)textField;
- (void)infoItemCell:(MHInfoItemCell *)cell textFieldValueChanged:(UITextField *)textField;


@end

@interface MHInfoItemCell : UITableViewCell

@property (nonatomic, strong, readonly) UITextField *titleTextField;
@property (nonatomic, strong, readonly) UITextField *contentTextField;

@property (nonatomic, strong, readonly) UILabel *titleLab;
@property (nonatomic, strong, readonly) UILabel *contentLab;

/**
 最右边的"附件"视图.
 默认懒加载为ImageView, 也可以赋值成自定义视图.
 */
@property (nonatomic, strong, null_resettable) UIView *accessoryView;

/**
 两种情况:
 1 accessoryView 为UIImageView 类型: 直接将 image 赋值給 accessoryView 的 image 属性.
 2 accessoryView 不为UIImageView 类型: 先初始化一个ImageView对象将其赋值給 accessoryView 属性, 然后再将 image 赋值給 accessoryView 的 image 属性.
 */
@property (nonatomic, strong, nullable) UIImage *image;

@property (nonatomic, assign) CGFloat titleTextFieldLeftMargin;
@property (nonatomic, assign) CGFloat titleTextFieldRightMargin;
@property (nonatomic, assign) CGFloat titleTextFieldTopMargin;
@property (nonatomic, assign) CGFloat titleTextFieldBottomMargin;
@property (nonatomic, assign) CGFloat accessoryViewLeftMargin;
@property (nonatomic, assign) CGFloat accessoryViewRightMargin;
@property (nonatomic, assign) CGSize accessoryViewSizeMargin;

@property (nonatomic, assign) UIEdgeInsets cellFrameSpace;

/**
 如果设置大于零的值, 则标题的宽度固定;
 如果设置小于零的值(如-1), 则表示标题宽度自适应
 */
@property (nonatomic, assign) CGFloat fixedTitleWidth;
@property (nonatomic, assign) CGFloat fixedTitleHeight;

/**
 在 ly_accessoryView.hide == YES 时, 是否将 contentTextField 的右边与ly_accessoryView对齐.
 */
@property (nonatomic, assign) BOOL autoAlignment;

@property (nonatomic, weak) id<MHInfoItemCellDelegate> delegate;
@property (nonatomic, copy) void (^didBeginEditing)(MHInfoItemCell *cell,UITextField *textField);
@property (nonatomic, copy) void (^didEndEditing)(MHInfoItemCell *cell,UITextField *textField);
@property (nonatomic, copy) void (^textFieldValueChanged)(MHInfoItemCell *cell,UITextField *textField);


///需要自动计算行高调用
- (void)layoutView;

@end


NS_ASSUME_NONNULL_END
