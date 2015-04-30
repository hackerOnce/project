//
//  MedicalCaseModelVC.h
//  MedCase
//
//  Created by ihefe-JF on 15/1/28.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MedicalCaseModeVCDelegate <NSObject>

-(void)didSelectedModelWithNode:(WLKCaseNode*)node;;

@end
@interface MedicalCaseModelVC : UIViewController

@property (nonatomic,weak) id <MedicalCaseModeVCDelegate> delegate;
@end
