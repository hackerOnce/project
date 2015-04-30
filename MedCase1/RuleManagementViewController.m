//
//  RuleManagementViewController.m
//  MedCase
//
//  Created by ihefe-JF on 15/3/4.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import "RuleManagementViewController.h"
#import "XCMultiSortTableView.h"

@interface RuleManagementViewController () <XCMultiTableViewDataSource>

@end

@implementation RuleManagementViewController{
    BOOL tableViewCanEdit;
    NSMutableArray *headData;
    NSMutableArray *leftTableData;
    NSMutableArray *rightTableData;
}
- (IBAction)cancel:(UIBarButtonItem *)sender
{
    
}
- (IBAction)editORSave:(UIButton *)sender
{
    NSString *buttonTitle = sender.titleLabel.text;
    
    if([buttonTitle isEqualToString:@"编辑"]){
        tableViewCanEdit = YES;
        [sender setTitle:@"保存" forState:UIControlStateNormal];
    }
    if([buttonTitle isEqualToString:@"保存"]){
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        tableViewCanEdit = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
      tableViewCanEdit = NO;
     [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    [self initData];
    
    XCMultiTableView *tableView = [[XCMultiTableView alloc] initWithFrame:CGRectMake(0, 44, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 44)];
    tableView.leftHeaderEnable = NO;
    tableView.datasource = self;
    [self.view addSubview:tableView];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];

}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];

}
- (void)initData {
    headData = [NSMutableArray arrayWithCapacity:10];
    [headData addObject:@"姓别"];
    [headData addObject:@"年龄段"];
    [headData addObject:@"病历类型"];
    [headData addObject:@"显示项目"];
    leftTableData = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *one = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < 3; i++) {
        [one addObject:[NSString stringWithFormat:@"ki-%d", i]];
    }
    [leftTableData addObject:one];
    
    rightTableData = [NSMutableArray arrayWithCapacity:10];
    
    NSMutableArray *oneR = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < 3; i++) {
        NSMutableArray *ary = [NSMutableArray arrayWithCapacity:10];
        for (int j = 0; j < headData.count; j++) {
            if (j == 1) {
                [ary addObject:[NSNumber numberWithInt:random() % 5]];
            }else if (j == 2) {
                [ary addObject:[NSNumber numberWithInt:random() % 10]];
            }
            else {
                [ary addObject:[NSString stringWithFormat:@"column %d %d", i, j]];
            }
        }
        [oneR addObject:ary];
    }
    [rightTableData addObject:oneR];
}

#pragma mark - XCMultiTableViewDataSource

-(BOOL)gestureEnable
{
    return  tableViewCanEdit;
}
- (NSArray *)arrayDataForTopHeaderInTableView:(XCMultiTableView *)tableView {
    return [headData copy];
}
- (NSArray *)arrayDataForLeftHeaderInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section {
    return [leftTableData objectAtIndex:section];
}

- (NSArray *)arrayDataForContentInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section {
    return [rightTableData objectAtIndex:section];
}


- (NSUInteger)numberOfSectionsInTableView:(XCMultiTableView *)tableView {
    return [leftTableData count];
}

- (CGFloat)tableView:(XCMultiTableView *)tableView contentTableCellWidth:(NSUInteger)column {
    
    if (column == headData.count-1) {
        return self.view.frame.size.width - 540;
    }
    return 180.0f;
}

- (CGFloat)tableView:(XCMultiTableView *)tableView cellHeightInRow:(NSUInteger)row InSection:(NSUInteger)section {
    //    if (section == 0) {
    //        return 60.0f;
    //    }else {
    //        return 44.0f;
    //    }
    return 44.0;
}

- (UIColor *)tableView:(XCMultiTableView *)tableView bgColorInSection:(NSUInteger)section InRow:(NSUInteger)row InColumn:(NSUInteger)column {
    if (row == 1 && section == 0) {
        return [UIColor clearColor];
    }
    return [UIColor clearColor];
}

- (UIColor *)tableView:(XCMultiTableView *)tableView headerBgColorInColumn:(NSUInteger)column {
    if (column == -1) {
        return [UIColor clearColor];
    }else if (column == 1) {
        return [UIColor clearColor];
    }
    return [UIColor clearColor];
}


@end
