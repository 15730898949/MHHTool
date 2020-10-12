//
//  BaseWebViewController.m
//  ToolDemo
//
//  Created by 马海鸿 on 2020/10/12.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "BaseWebViewController.h"
#import <Tool/ToolMacro.h>
@interface BaseWebViewController ()

@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    NSLog(@"12312312313");
    [self addScriptMessageHandlerWithName:@[@"setTitle",@"setBackgroundColor",@"getToken"] observeValue:^(WKUserContentController *userContentController, WKScriptMessage *message) {
        if([message.name isEqualToString:@"setTitle"]){
            self.titleLab.text = message.body;
        }else if([message.name isEqualToString:@"setBackgroundColor"]){
            self.navBar.backgroundColor = [self colorWithHexString:message.body alpha:1];
        }else if([message.name isEqualToString:@"getToken"]){
            [self callJS:[NSString stringWithFormat:@"getToken('%@')",@"123123"]];

        }

    }];
    

}

- (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha {
    //删除字符串中的空格
    NSString *cString =
        [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6) {
        return [UIColor clearColor];
    }

    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    // r
    NSString *rString = [cString substringWithRange:range];
    // g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    // b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];

    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
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
