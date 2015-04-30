//
//  WriteCaseShowTemplateViewController.h
//  WriteMedicalCase
//
//  Created by ihefe-JF on 15/4/30.
//  Copyright (c) 2015年 GK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WriteCaseShowTemplateViewControllerDelegate <NSObject>
-(void)didSelectedTemplateWithNode:(Template*)templated;
-(void)didSelectedTemplateWithString:(NSString*)str;

@end

@interface WriteCaseShowTemplateViewController : UIViewController
@property (nonatomic,strong) NSString *templateName;
@property (nonatomic) id <WriteCaseShowTemplateViewControllerDelegate> showTemplateDelegate;
@end
