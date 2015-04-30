//
//  ViewController.m
//  MedCase
//
//  Created by ihefe36 on 14/12/29.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    
//    WLKCaseNode *node = [[WLKCaseNode alloc] init];
//    for (int i = 5; i < 10; i++) {
//        WLKCaseNode *cNode = [[WLKCaseNode alloc] init];
//        for (int j = 10; j < 20; j++) {
//            WLKCaseNode *gNode = [[WLKCaseNode alloc] init];
//            for (int j = 10; j < 20; j++) {
//                WLKCaseNode *xNode = [[WLKCaseNode alloc] init];
//                [gNode.childNodes addObject:xNode];
//            }
//            [cNode.childNodes addObject:gNode];
//        }
//        [node.childNodes addObject:cNode];
//    }
//    WLKLog(@"%ld", (long)[node countOfChildNodesHierarchy]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnTapped:(UIButton *)sender {
    [KVNProgress showWithStatus:@"loading"];
}
@end
