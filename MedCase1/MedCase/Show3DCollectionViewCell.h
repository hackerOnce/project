//
//  Show3DCollectionViewCell.h
//  MedCase
//
//  Created by ihefe-JF on 15/1/16.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLKCaseNode.h"

@interface Show3DCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *show3DCellLabel;
@property (nonatomic,strong) WLKCaseNode *show3DNode;
@end
