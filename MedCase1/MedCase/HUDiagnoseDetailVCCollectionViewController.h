//
//  HUDiagnoseDetailVCCollectionViewController.h
//  MedCase
//
//  Created by ihefe-JF on 15/1/4.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUDiagnoseDetailCollectionViewCell.h"

@class HUDiagnoseDetailCollectionViewCell;

@protocol HUDiagnoseDetailVCCollectionViewControllerDelegate <NSObject>

-(void)didSelectedDetailCollectionViewCell:(HUDiagnoseDetailCollectionViewCell*)cell  collectionView:(UICollectionView*)collectionView atIndexPath:(NSIndexPath*)indexPath;


@end

@interface HUDiagnoseDetailVCCollectionViewController : UICollectionViewController


@property (nonatomic,weak) id<HUDiagnoseDetailVCCollectionViewControllerDelegate>  delegate;
@end
