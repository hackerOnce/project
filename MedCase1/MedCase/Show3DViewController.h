//
//  Show3DViewController.h
//  MedCase
//
//  Created by ihefe-JF on 15/1/15.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLKCaseNode.h"

@interface Show3DViewController : UIViewController

@property (nonatomic,strong) WLKCaseNode *show3DNode;
@property (nonatomic,strong) NSMutableString *zoomInoutID;
@end
