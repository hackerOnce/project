//
//  WriteCaseShowTemplateCell.m
//  WriteMedicalCase
//
//  Created by ihefe-JF on 15/4/30.
//  Copyright (c) 2015年 GK. All rights reserved.
//

#import "WriteCaseShowTemplateCell.h"

@implementation WriteCaseShowTemplateCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle =  UITableViewCellSelectionStyleNone;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.textView layoutIfNeeded];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
