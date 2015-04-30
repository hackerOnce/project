//
//  TestViewController.m
//  MedCase
//
//  Created by ihefe36 on 15/1/6.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//  http://nshipster.cn/nscharacterset/

#import "TestViewController.h"
#import "ParseXML.h"

#import "NSString+ExtensionMethod.h"
@interface TestViewController ()


@end


@implementation TestViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ParseXML *pa = [[ParseXML alloc] initWithXMLName:@"病历" extendName:@"opml"];
    
    WLKCaseNode *caseNode = [pa getNodeWithKey:@"入院记录（可以做到各科专科内容）"];
//    caseNode = nil;
    self.multiTableView.caseNode = caseNode;
    
    NSString *tempString = @"   this is    a   test    ";
    
    tempString = [tempString removeWhitespaceAtHeadAndTail];
    NSString *tempString2 = [tempString ExtrusionBlankBetweenWords];
    NSLog(@"%@  , tempSTring 2:%@",tempString,tempString2);
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"plist"]];
    WLKCaseNode *node = [WLKCaseNode nodeWithDictionary:dic];
//    WLKCaseNode *node = [[WLKCaseNode alloc] init];
//    node.nodeName = @"测试";
//    node.tableViewConfig.shouldAddVerticalSeparatorLine = YES;
//    node.tableViewConfig.cellBackgroundColor = [UIColor greenColor];
//    node.tableViewConfig.cellSelectedBackgroundColor = [UIColor redColor];
//    node.tableViewConfig.shouldSelectFirstCellDefault = YES;
//    for (int i = 5; i < 10; i++) {
//        WLKCaseNode *cNode = [[WLKCaseNode alloc] init];
//        cNode.nodeName = [NSString stringWithFormat:@"一级%d", i];
//        cNode.tableViewConfig.normalAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cNode.tableViewConfig.labelTextSelectedColor = [UIColor blueColor];
//        cNode.tableViewConfig.shouldSelectFirstCellDefault = YES;
//        cNode.tableViewConfig.cellSelectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 600, 500)];
//        cNode.allowChangeContentByChild = YES;
//        for (int j = 0; j < 50; j++) {
//            WLKCaseNode *gNode = [[WLKCaseNode alloc] init];
//            gNode.nodeName = [NSString stringWithFormat:@"二级%d", j];
//            gNode.tableViewConfig.cellSeparatorShouldShow = NO;
//            gNode.tableViewConfig.shouldSelectFirstCellDefault = NO;
//            gNode.tableViewConfig.selectedAccessoryType = UITableViewCellAccessoryCheckmark;
//            gNode.tableViewConfig.cellSelectionStyle = UITableViewCellSelectionStyleNone;
//            gNode.tableViewConfig.allowMultiSelected = YES;
//            for (int k = 0; k < 20; k++) {
//                WLKCaseNode *xNode = [[WLKCaseNode alloc] init];
//                xNode.nodeName = [NSString stringWithFormat:@"三级%d", k];
//                [gNode addChildNode:xNode];
//            }
//        }
//        cNode.nodeImageName = @"image";
//        [node addChildNode:cNode];
//    }
    self.multiTableView.caseNode = node;
    [self.multiTableView buildUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
