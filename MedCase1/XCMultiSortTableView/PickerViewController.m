//
//  PickerViewController.m
//  MedCase
//
//  Created by ihefe-JF on 15/3/5.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import "PickerViewController.h"
#import "DetailViewController.h"
#import "WLKCaseNode.h"

@interface PickerViewController ()<UITableViewDataSource,UITableViewDelegate,DetailViewCOntrollerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *TextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//@property (nonatomic,strong) NSMutableDictionary *detailEnable;

@property (nonatomic,strong) NSMutableArray *detailArray;
@property (nonatomic,strong) NSString *titleStr;

@property (nonatomic,strong) NSIndexPath *selectedIndexPath;

@property (nonatomic,strong) WLKCaseNode *dataNode;
@property (nonatomic,strong) WLKCaseNode *detailNode;

@property (nonatomic,strong) NSMutableSet *selectedNode;

@property (nonatomic,strong) NSMutableArray *strArry;
@property (nonatomic) NSInteger strArryCount;

@end

@implementation PickerViewController

- (IBAction)addButtonClicked:(UIBarButtonItem *)sender
{
    if(![self.TextField.text isEqualToString:@""]){
        [self.PickerVCDelegate getSelectedItems:self.strArry withString:self.TextField.text];
        [self.PickerVCDelegate disappearPopoverViewController];
    }
}
- (IBAction)cancelButtonClicked:(UIBarButtonItem *)sender
{
    [self.PickerVCDelegate disappearPopoverViewController];
}
-(NSMutableArray *)defaultArray
{
    if(!_defaultArray){
        _defaultArray = [[NSMutableArray alloc] init];
    }
    return _defaultArray;
}
-(NSMutableSet *)selectedNode
{
    _selectedNode = [[NSMutableSet alloc] initWithArray:self.dataNode.selectedChildNodes];
    
    return _selectedNode;
}
-(void)setStrArryCount:(NSInteger)strArryCount
{
    if(strArryCount == 0){
        self.TextField.text = @"";
    }
    NSString *strTextField = @"";
//    if([self.TextField.text isEqualToString:@""]){
//        strTextField = [self.strArry componentsJoinedByString:@","];
//    }else {
//        strTextField = [strTextField stringByAppendingString:self.TextField.text];
//        strTextField = [strTextField stringByAppendingString:@","];
//        strTextField = [strTextField stringByAppendingString:[self.strArry componentsJoinedByString:@","]];
//    }
    self.TextField.text = [self.strArry componentsJoinedByString:@","];
    
    _strArryCount = strArryCount;
}

-(NSMutableArray *)strArry
{
    if(!_strArry){
        _strArry = [[NSMutableArray alloc] init];
    }
    return _strArry;
}
#pragma mask - items
-(WLKCaseNode *)dataNode
{
    if(!_dataNode){
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Items" ofType:@"plist"];
        NSMutableDictionary *itemsDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        _dataNode = [[WLKCaseNode alloc] initWithDictionary:itemsDic];
    }
    return _dataNode;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self setUpTableView];
    
    UIBarButtonItem *tempBarButton = [[UIBarButtonItem alloc] init];
    tempBarButton.title = @" ";
    self.navigationItem.backBarButtonItem = tempBarButton;
    
    [self.navigationItem setBackBarButtonItem:tempBarButton];
    
    if([self.defaultPickerString containsString:@","]){
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[self.defaultPickerString componentsSeparatedByString:@","]];
        [tempArray removeLastObject];
        
        NSMutableArray *tempDefaultArray = [[NSMutableArray alloc] initWithArray:tempArray];
        
        for (WLKCaseNode *tempCase in self.dataNode.childNodes) {
            if(tempCase.childNodes.count != 0){
                for (WLKCaseNode *tempNode in tempCase.childNodes) {
                    if([tempArray containsObject:tempNode.nodeName]){
                        [tempCase selectChildNode:tempNode];
                        [tempDefaultArray addObject:tempCase.nodeName];
                    }
                }
            }
        }
        if([[self.dataNode childNodeNames] containsObject:tempArray[0]]){
            self.defaultArray = [[NSMutableArray alloc] initWithArray:tempDefaultArray];
            
            self.strArry = [[NSMutableArray alloc] initWithArray:tempArray];
            self.strArryCount =  self.strArry.count;
        }
    }

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
#pragma mask - set tableview
-(void)setUpTableView
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
#pragma mask - table view delegate / data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataNode.childNodes.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSString *cellID = @"PickerCell";
    
    WLKCaseNode *cellNode = self.dataNode.childNodes[indexPath.row];
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    UILabel *cellLabel = (UILabel*)[cell viewWithTag:1002];
    cellLabel.text = cellNode.nodeName;
    cell.tag = 0;
 
    UIImageView *tapView = (UIImageView*)[cell viewWithTag:1001];
    if([self.dataNode.selectedChildNodes containsObject:cellNode] || [self.defaultArray containsObject:cellNode.nodeName] || cellNode.nodeChangeStatus){
        [tapView setImage:[UIImage imageNamed:@"delete"]];
        cell.tag = 1;
    }else {
        [tapView setImage:[UIImage imageNamed:@"Unselected"]];
    }
    UIImageView *cellImageView = (UIImageView*)[cell viewWithTag:1001];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
    if(!cellNode.childNodes.count){
        cellImageView.userInteractionEnabled = YES;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cellImageView.userInteractionEnabled = NO;
    }
    [cellImageView addGestureRecognizer:tap];
    
    return cell;
}
-(void)tapImageView:(UITapGestureRecognizer*)recognizer
{
    UIImageView *tapView = (UIImageView*)recognizer.view;
   
    if([tapView.superview.superview isKindOfClass:[UITableViewCell class]]){
        UITableViewCell *cell = (UITableViewCell*)tapView.superview.superview;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        WLKCaseNode *cellNode = [self.dataNode.childNodes objectAtIndex:indexPath.row];
        [self.dataNode selectChildNode:cellNode];
        
        UILabel *cellLabel = (UILabel*)[cell viewWithTag:1002];
        if(cell.tag == 0){
            [tapView setImage:[UIImage imageNamed:@"delete"]];
             cell.tag =1;
            [self.dataNode selectChildNode:cellNode];
            if(![self.strArry containsObject:cellLabel.text]){
                [self.strArry addObject:cellLabel.text];
                self.strArryCount = self.strArry.count;
            }
            
        }else {
            [tapView setImage:[UIImage imageNamed:@"Unselected"]];
            cell.tag = 0;

            [self.dataNode deselectChildNode:cellNode];
           
            
            [self.strArry removeObject:cellLabel.text];
            self.strArryCount = self.strArry.count;
        }
    }
}
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *cellImageView = (UIImageView*)[cell viewWithTag:1001];
    UILabel *cellLabel = (UILabel*)[cell viewWithTag:1002];
      self.selectedIndexPath = indexPath;
    
    WLKCaseNode *cellNode = [self.dataNode.childNodes objectAtIndex:indexPath.row];
   
    if(cellImageView.userInteractionEnabled){
        if(cell.tag == 0){
            [cellImageView setImage:[UIImage imageNamed:@"delete"]];
            cell.tag = 1;
            [self.dataNode selectChildNode:cellNode];
            
            if(![self.strArry containsObject:cellLabel.text]){
                [self.strArry addObject:cellLabel.text];
                self.strArryCount = self.strArry.count;
            }
        }else {
            
//            if([self.defaultArray containsObject:cellLabel.text]){
//                [self.defaultArray removeObject:cellLabel.text];
//            }
            [cellImageView setImage:[UIImage imageNamed:@"Unselected"]];
            cell.tag = 0;
             [self.dataNode deselectChildNode:cellNode];
         
            [self.strArry removeObject:cellLabel.text];
            self.strArryCount = self.strArry.count;
        }
        return nil;
    }else {
    
        UILabel *cellLabel = (UILabel*)[cell viewWithTag:1002];
        self.titleStr = cellLabel.text;
        
        self.detailNode = self.dataNode.childNodes[indexPath.row];

        return indexPath;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WLKCaseNode *cellNode = [self.dataNode.childNodes objectAtIndex:indexPath.row];
    [self.dataNode selectChildNode:cellNode];
  
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    DetailViewController *detailVC =(DetailViewController*)segue.destinationViewController;
    detailVC.titleString = self.titleStr;
    detailVC.detailDelegate = self;
    detailVC.detailSelectedIndexPath = self.selectedIndexPath;
    
    detailVC.detailNode = self.detailNode;
}
#pragma mask - detail view controller delegate

-(void)selectedDetailItems:(NSArray *)arr withSring:(NSString *)str withSelectedIndexPath:(NSIndexPath *)indexPath withRemoveItems:(NSArray *)items
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    WLKCaseNode *cellNode = [self.dataNode.childNodes objectAtIndex:indexPath.row];
    UIImageView *cellImageView = (UIImageView*)[cell viewWithTag:1001];
    if(cellNode.nodeChangeStatus){
        [cellImageView setImage:[UIImage imageNamed:@"delete"]];
    }else {
        [cellImageView setImage:[UIImage imageNamed:@"Unselected"]];
    }
    [self.strArry  removeObjectsInArray:items];
    [self.strArry addObjectsFromArray:arr];
    self.strArryCount = self.strArry.count;
}
@end
