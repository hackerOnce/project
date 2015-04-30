//
//  ModelNameVC.h
//  MedCase
//
//  Created by ihefe-JF on 15/2/28.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import "ViewController.h"

@interface ModelNameVC : ViewController <IHGCDSocketDelegate>
@property (nonatomic,strong) NSMutableArray *modelsArray;

@property (nonatomic, strong) IHGCDSocket *socket;

@end
