//
//  DetailViewController.m
//  MedCase
//
//  Created by ihefe-JF on 15/3/5.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import "DetailViewController.h"


@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *showSelectedItems;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *strArr;

@property (nonatomic,strong) NSMutableSet *selectedNode;

@property (nonatomic,strong) NSMutableSet *removeItems;

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpTableView];
    self.strArr = [[NSMutableArray alloc] init];
    self.removeItems = [[NSMutableSet alloc] init];
}
-(NSMutableArray *)dataArray
{
    if(!_dataArray){
        _dataArray = [[NSMutableArray alloc] init];
        for (WLKCaseNode *tempNode in self.detailNode.childNodes) {
            [_dataArray addObject:tempNode.nodeName];
        }
    }
    return _dataArray;
}

-(NSMutableSet *)selectedNode
{
    self.selectedNode = [[NSMutableSet alloc] initWithArray:self.detailNode.selectedChildNodes];    return _selectedNode;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationItem.title = self.titleString;
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    [self.strArr removeAllObjects];
   
    for (WLKCaseNode *cellNode in self.detailNode.selectedChildNodes) {
        [self.strArr addObject:cellNode.nodeName];
    }
    self.showSelectedItems.text = [self.strArr componentsJoinedByString:@","];
   // self.showSelectedItems.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"TextFieldText"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    
    [self.detailDelegate selectedDetailItems:self.strArr withSring:self.showSelectedItems.text withSelectedIndexPath:self.detailSelectedIndexPath withRemoveItems:self.dataArray];
   //[[NSUserDefaults standardUserDefaults] setObject:self.showSelectedItems.text forKey:@"TextFieldText"];
}

#pragma mask - set tableview
- (void)setUpTableView
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
#pragma mask - tableview delegate / data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detailNode.childNodes.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"detailCell";
    WLKCaseNode *cellNode = self.detailNode.childNodes[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *cellLabel = (UILabel*)[cell viewWithTag:1002];
    
    UIImageView *tapView = (UIImageView*)[cell viewWithTag:1001];
    
    cellLabel.text = cellNode.nodeName;
    cell.tag = 0;
    
    if([self.selectedNode containsObject:cellNode]){
        [tapView setImage:[UIImage imageNamed:@"delete"]];
        cell.tag =1;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WLKCaseNode *cellNode = self.detailNode.childNodes[indexPath.row];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *tapView = (UIImageView*)[cell viewWithTag:1001];
    UILabel *cellLabel = (UILabel*)[cell viewWithTag:1002];
    if(cell.tag == 0){
        [tapView setImage:[UIImage imageNamed:@"delete"]];
        cell.tag =1;
        [self.strArr addObject:cellLabel.text];
        self.showSelectedItems.text = [self.strArr componentsJoinedByString:@","];
        [self.detailNode selectChildNode:cellNode];
    }else {
        [tapView setImage:[UIImage imageNamed:@"Unselected"]];
        [self.strArr removeObject:cellLabel.text];
        [self.removeItems addObject:cellLabel.text];
        cell.tag = 0;
        self.showSelectedItems.text = [self.strArr componentsJoinedByString:@","];
        [self.detailNode deselectChildNode:cellNode];
    }
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
