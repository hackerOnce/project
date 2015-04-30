//
//  SaveViewController.h
//  MedCase
//
//  Created by ihefe-JF on 15/1/23.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLKCaseNode.h"
#import "PersonInfo.h"


@interface SaveViewController : UIViewController <IHGCDSocketDelegate>



@property (nonatomic,strong)PersonInfo *saveInfo;
//- (IBAction)saveCase:(UIBarButtonItem *)sender;
- (IBAction)saveCase:(UIButton *)sender;

@property (nonatomic, strong) IHGCDSocket *socket;

@end
