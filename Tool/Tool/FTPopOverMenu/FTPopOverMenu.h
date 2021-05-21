//
//  FTPopOverMenu.h
//  FTPopOverMenu
//
//  Created by liufengting on 16/4/5.
//  Copyright © 2016年 liufengting ( https://github.com/liufengting ). All rights reserved.
//

/**
        FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
        configuration.menuRowHeight = 80;
        configuration.menuWidth = 120;
        configuration.textColor = [UIColor orangeColor];
        configuration.textFont = [UIFont boldSystemFontOfSize:14];
        configuration.tintColor = [UIColor whiteColor];
        configuration.borderColor = [UIColor blackColor];
        configuration.borderWidth = 0.5;
        configuration.textAlignment = NSTextAlignmentCenter;
        configuration.ignoreImageOriginalColor = YES;// set 'ignoreImageOriginalColor' to YES, images color will be same as textColor

        
        NSString *icomImageURLString = @"https://avatars1.githubusercontent.com/u/4414522?v=3&s=40";
        NSURL *icomImageURL = [NSURL URLWithString:icomImageURLString];

        [FTPopOverMenu showForSender:sender
                       withMenuArray:@[@"MenuOne", @"MenuTwo", @"MenuThree", @"MenuFour",]
                          imageArray:@[icomImageURLString, icomImageURL, [UIImage imageNamed:@"Pokemon_Go_03"], @"Pokemon_Go_04"]
    //                   configuration:configuration
                           doneBlock:^(NSInteger selectedIndex) {
                               
                               NSLog(@"done block. do something. selectedIndex : %ld", (long)selectedIndex);
                               
                           } dismissBlock:^{
                               
                               NSLog(@"user canceled. do nothing.");
                               
    //                           FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    //                           configuration.allowRoundedArrow = !configuration.allowRoundedArrow;
                               
                           }];
        

 */

#import <UIKit/UIKit.h>

@class FTPopOverMenuCell;
/**
 *  FTPopOverMenuDoneBlock
 *
 *  @param selectedIndex SlectedIndex
 */
typedef void (^FTPopOverMenuDoneBlock)(NSInteger selectedIndex);
/**
 *  FTPopOverMenuDismissBlock
 */
typedef void (^FTPopOverMenuDismissBlock)(void);


typedef FTPopOverMenuCell* (^FTPopOverMenuCellDataSourceBlock)(FTPopOverMenuCell *cell);


/**
 *  -----------------------FTPopOverMenuModel-----------------------
 */
@interface FTPopOverMenuModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) id image;
@property (nonatomic, assign) BOOL selected;

- (instancetype)initWithTitle:(NSString *)title image:(id)image selected:(BOOL)selected;

@end

/**
 *  -----------------------FTPopOverMenuConfiguration-----------------------
 */
@interface FTPopOverMenuConfiguration : NSObject

@property (nonatomic, assign) CGFloat menuTextMargin;// Default is 6.
@property (nonatomic, assign) CGFloat menuIconMargin;// Default is 6.
@property (nonatomic, assign) CGFloat menuRowHeight;
@property (nonatomic, assign) CGFloat menuWidth;
@property (nonatomic, assign) CGFloat menuCornerRadius;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) UIEdgeInsets separatorInset;
@property (nonatomic, assign) BOOL ignoreImageOriginalColor;// Default is 'NO', if sets to 'YES', images color will be same as textColor.
@property (nonatomic, assign) BOOL allowRoundedArrow;// Default is 'NO', if sets to 'YES', the arrow will be drawn with round corner.
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, strong) UIColor *selectedTextColor;
@property (nonatomic, strong) UIColor *selectedCellBackgroundColor;
@property (nonatomic, strong) UIColor *separatorColor;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, assign) CGFloat shadowOpacity;
@property (nonatomic, assign) CGFloat shadowRadius;
@property (nonatomic, assign) CGFloat shadowOffsetX;
@property (nonatomic, assign) CGFloat shadowOffsetY;
@property (nonatomic, strong) UIColor *coverBackgroundColor;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) CGFloat horizontalMargin;
/**
 *  defaultConfiguration
 *
 *  @return curren configuration
 */
+ (FTPopOverMenuConfiguration *)defaultConfiguration;

@end

/**
 *  -----------------------FTPopOverMenuCell-----------------------
 */
@interface FTPopOverMenuCell : UITableViewCell

@end
/**
 *  -----------------------FTPopOverMenuView-----------------------
 */
@interface FTPopOverMenuView : UIControl

@end

/**
 *  -----------------------FTPopOverMenu-----------------------
 */
@interface FTPopOverMenu : NSObject

//    menuArray supports following context:
//    1. image name (NSString, only main bundle),
//    2. image (UIImage),
//    3. image remote URL string (NSString),
//    4. image remote URL (NSURL),
//    5. model (FTPopOverMenuModel, select state support)

/**
 show method with sender without images
 
 @param sender sender
 @param menuArray menuArray
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (FTPopOverMenu *)showForSender:(UIView *)sender
                   withMenuArray:(NSArray *)menuArray
                       doneBlock:(FTPopOverMenuDoneBlock)doneBlock
                    dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;

/**
 show method with sender and image resouce Array
 
 @param sender sender
 @param menuArray menuArray
 @param imageArray imageArray
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (FTPopOverMenu *)showForSender:(UIView *)sender
                   withMenuArray:(NSArray *)menuArray
                      imageArray:(NSArray *)imageArray
                       doneBlock:(FTPopOverMenuDoneBlock)doneBlock
                    dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;

+ (FTPopOverMenu *)showForSender:(UIView *)sender
                   withMenuArray:(NSArray *)menuArray
                      imageArray:(NSArray *)imageArray
                       doneBlock:(FTPopOverMenuDoneBlock)doneBlock
                    dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock
                    cellDataSourceBlock:(FTPopOverMenuCellDataSourceBlock)cellDataSourceBlock;


/**
 show method with sender, image resouce Array and configuration
 
 @param sender sender
 @param menuArray menuArray
 @param imageArray imageArray
 @param configuration configuration
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (FTPopOverMenu *)showForSender:(UIView *)sender
                   withMenuArray:(NSArray *)menuArray
                      imageArray:(NSArray *)imageArray
                   configuration:(FTPopOverMenuConfiguration *)configuration
                       doneBlock:(FTPopOverMenuDoneBlock)doneBlock
                    dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;

/**
 show method for barbuttonitems with event without images
 
 @param event event
 @param menuArray menuArray
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (FTPopOverMenu *)showFromEvent:(UIEvent *)event
                   withMenuArray:(NSArray *)menuArray
                       doneBlock:(FTPopOverMenuDoneBlock)doneBlock
                    dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;

/**
 show method for barbuttonitems with event and imageArray
 
 @param event event
 @param menuArray menuArray
 @param imageArray imageArray
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (FTPopOverMenu *)showFromEvent:(UIEvent *)event
                   withMenuArray:(NSArray *)menuArray
                      imageArray:(NSArray *)imageArray
                       doneBlock:(FTPopOverMenuDoneBlock)doneBlock
                    dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;


/**
 show method for barbuttonitems with event, imageArray and configuration
 
 @param event event
 @param menuArray menuArray
 @param imageArray imageArray
 @param configuration configuration
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (FTPopOverMenu *)showFromEvent:(UIEvent *)event
                   withMenuArray:(NSArray *)menuArray
                      imageArray:(NSArray *)imageArray
                   configuration:(FTPopOverMenuConfiguration *)configuration
                       doneBlock:(FTPopOverMenuDoneBlock)doneBlock
                    dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;
/**
 show method with SenderFrame without images
 
 @param senderFrame senderFrame
 @param menuArray menuArray
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (FTPopOverMenu *)showFromSenderFrame:(CGRect )senderFrame
                         withMenuArray:(NSArray *)menuArray
                             doneBlock:(FTPopOverMenuDoneBlock)doneBlock
                          dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;

/**
 show method with SenderFrame and image resouce Array
 
 @param senderFrame senderFrame
 @param menuArray menuArray
 @param imageArray imageArray
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (FTPopOverMenu *)showFromSenderFrame:(CGRect )senderFrame
                         withMenuArray:(NSArray *)menuArray
                            imageArray:(NSArray *)imageArray
                             doneBlock:(FTPopOverMenuDoneBlock)doneBlock
                          dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;

/**
 show method with SenderFrame, image resouce Array and configuration
 
 @param senderFrame senderFrame
 @param menuArray menuArray
 @param imageArray imageArray
 @param configuration configuration
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (FTPopOverMenu *)showFromSenderFrame:(CGRect )senderFrame
                         withMenuArray:(NSArray *)menuArray
                            imageArray:(NSArray *)imageArray
                         configuration:(FTPopOverMenuConfiguration *)configuration
                             doneBlock:(FTPopOverMenuDoneBlock)doneBlock
                          dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;
/**
 *  dismiss method
 */
+ (void)dismiss;

- (FTPopOverMenu *)showForSender:(UIView *)sender
                          window:(UIWindow*)window
                     senderFrame:(CGRect )senderFrame
                        withMenu:(NSArray *)menuArray
                  imageNameArray:(NSArray *)imageNameArray
                          config:(FTPopOverMenuConfiguration *)config
                       doneBlock:(FTPopOverMenuDoneBlock)doneBlock
                    dismissBlock:(FTPopOverMenuDismissBlock)dismissBlock;

- (void)dismiss;

@end

