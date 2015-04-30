//
//  HUDiseaseClassificationCollectionViewCell.h
//  MedicalRecord
//
//  Created by ihefe-JF on 14/12/31.
//  Copyright (c) 2014年 JFAppHourse.app. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLKCaseNode.h"

typedef enum ButtonState
{
    ButtonStateUnKnow = 0,
    ButtonStateSelected,
    ButtonStateKeepSelected
    
} ButtonState;

@class HUDiseaseClassificationCollectionViewCell;

@protocol HUDiseaseClassificationCollectionViewCellDelegate <NSObject>

-(void)didSelectedCell:(HUDiseaseClassificationCollectionViewCell*)cell includeButton:(UIButton*)button;

@end
@interface HUDiseaseClassificationCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellButton;
@property (weak,nonatomic) id<HUDiseaseClassificationCollectionViewCellDelegate> delegate;

@property (strong,nonatomic) NSString *buttonTitle;

@property (strong,nonatomic) WLKCaseNode *cellNode;

@property (nonatomic) ButtonState buttonState;

-(void)configCell;
@end
