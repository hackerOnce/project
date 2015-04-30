//
//  ManualInputTextViewController.h
//  MedCase
//
//  Created by ihefe-JF on 15/1/22.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManualInputTextViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (nonatomic,strong) NSString *textStrng;
@end
