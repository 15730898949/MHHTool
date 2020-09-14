//
//  TestTableViewCell1.m
//  ToolDemo
//
//  Created by 马海鸿 on 2020/9/14.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "TestTableViewCell1.h"

@implementation TestTableViewCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor redColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
