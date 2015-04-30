//
//  RecordNavagationViewController.h
//  MedicalCase
//
//  Created by ihefe-JF on 15/4/23.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RecordNavagationViewController;

@protocol RecordNavagationViewControllerDelegate <NSObject>
-(void)didSelectedPatient:(Patient*)patient;
@end

@interface RecordNavagationViewController : UIViewController
@property(nonatomic, strong) NSMutableArray* headViewArray;
@property (nonatomic,weak) id <RecordNavagationViewControllerDelegate> delegate;
@property (nonatomic) NSInteger currentSection;
@property (nonatomic) NSInteger currentRow;
@end
