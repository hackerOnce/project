//
//  PickerViewController.h
//  MedCase
//
//  Created by ihefe-JF on 15/3/5.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PickerViewControllerDelegate <NSObject>

@required
-(void)getSelectedItems:(NSArray*)items withString:(NSString*)str;
-(void)disappearPopoverViewController;

@end

@interface PickerViewController : UIViewController
@property (nonatomic,weak) id<PickerViewControllerDelegate> PickerVCDelegate;

@property (nonatomic,strong) NSMutableArray *defaultArray;

@property (nonatomic,strong) NSString *defaultPickerString;

@end
