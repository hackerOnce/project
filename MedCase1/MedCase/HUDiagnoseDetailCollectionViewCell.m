//
//  HUDiagnoseDetailCollectionViewCell.m
//  MedCase
//
//  Created by ihefe-JF on 15/1/4.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import "HUDiagnoseDetailCollectionViewCell.h"



@implementation HUDiagnoseDetailCollectionViewCell


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    //self.autoresizesSubviews = YES;
   
//    self.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    self.layer.borderWidth = 1;
    if(!(floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1)){
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    
    //_detailLabel.layer.borderWidth =1;
    //_detailLabel.layer.borderColor = [UIColor greenColor].CGColor;
    self.layer.masksToBounds = YES;
//    UIView *BJView = [[UIView alloc] initWithFrame:self.bounds];
//    BJView.backgroundColor = [UIColor redColor];
//    self.selectedBackgroundView = BJView;
    self.detailLabel.font = [UIFont systemFontOfSize:17];
    
//   UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
//    selectedBackgroundView.backgroundColor = [UIColor redColor];
//    self.selectedBackgroundView = selectedBackgroundView;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.detailLabel.preferredMaxLayoutWidth = self.bounds.size.width - 2 * 8;
   // self.detailLabel.preferredMaxLayoutWidth = 1000;
}
-(void)configCell
{
    if(self.detailCellNode){
        self.detailLabel.text = self.detailCellNode.nodeContent;
    }else {
       self.detailLabel.text = @"添加";
    }
    UILabel *tempLabel =(UILabel*) [self viewWithTag:1001];
    if(self.detailCellNode.nodeChangeStatus){
        tempLabel.textColor =  [UIColor colorWithRed:74.0/255 green:144.0/255 blue:226.0/255 alpha:1];
    }else {
        tempLabel.textColor = [UIColor colorWithRed:108.0/255 green:106.0/255 blue:106.0/255 alpha:1];
    }

    [self setNeedsLayout];
    [self layoutIfNeeded];
   // [self updateConstraints];
}
@end
