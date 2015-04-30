//
//  HUDiagnoseDetailCollectionViewCell.h
//  MedCase
//
//  Created by ihefe-JF on 15/1/4.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLKCaseNode.h"

@class HUDiagnoseDetailCollectionViewCell;

@protocol HUDiagnoseDetailCollectionViewCellDelegate <NSObject>

-(void)didSelectedDetailCollectionViewCell:(HUDiagnoseDetailCollectionViewCell*)cell includeButton:(UIButton*)button section:(NSInteger)section;

@end

@interface HUDiagnoseDetailCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) id <HUDiagnoseDetailCollectionViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *detailCellButton;
@property (nonatomic) NSInteger section;

-(void)configCell;

@property (nonatomic,strong) WLKCaseNode *detailCellNode;
@end
