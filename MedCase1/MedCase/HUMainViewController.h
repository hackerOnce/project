//
//  HUMainViewController.h
//  MedicalRecord
//
//  Created by ihefe-JF on 14/12/26.
//  Copyright (c) 2014年 JFAppHourse.app. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUMainViewController : UIViewController
@property (nonatomic,strong) NSMutableString *zoomInoutID;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *medicalCaseModelButton;
@property (nonatomic,strong) UIView *rightSideSlideView;

@property (nonatomic,strong) UIView *maskView;
@property (nonatomic) BOOL  rightSlideViewFlag;
@end
