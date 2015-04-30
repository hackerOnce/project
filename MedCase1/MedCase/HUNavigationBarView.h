//
//  HUNavigationBarView.h
//  MedicalRecord
//
//  Created by ihefe-JF on 14/12/26.
//  Copyright (c) 2014年 JFAppHourse.app. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonInfo.h"

@protocol HUNavigationBarViewDelegate <NSObject>

//-(void)barViewButtonClicked:(UIButton*)sender;

@end

@interface HUNavigationBarView : UIView

//@property(nonatomic) NSUInteger lowAge;
//@property(nonatomic) NSUInteger highAge;
//@property(nonatomic,strong) NSString *gender;
//
//@property(nonatomic,strong) NSString *admissionDiagnosis;
//@property(nonatomic,strong) NSString *allergicHistory;
//@property(nonatomic,strong) NSString *medicalTreatment;

@property(nonatomic,strong) UIButton *button;
@property(nonatomic,strong)PersonInfo *personInfo;
@property(nonatomic,weak) id <HUNavigationBarViewDelegate> delegate;

@property(nonatomic,strong) NSArray *datas;

@property(nonatomic) bool changeViewFlag;
-(void)buildNavigationBarViewUI;
-(void)showData;
@end
