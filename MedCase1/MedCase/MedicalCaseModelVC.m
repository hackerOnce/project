//
//  MedicalCaseModelVC.m
//  MedCase
//
//  Created by ihefe-JF on 15/1/28.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import "MedicalCaseModelVC.h"
#import "CaseModelCell.h"

@interface MedicalCaseModelVC () <UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate,UISearchControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBarView;

@property (nonatomic,strong) UISearchDisplayController *strongSearchDisplayController;
@property (nonatomic,strong) NSMutableArray *filterMedicalCaseModels;
@property (nonatomic) CGRect searchBarFrame;

@property (nonatomic,strong) UIView *viewForSearchBar;

@property (nonatomic,strong) NSMutableArray *medicalCaseModels;

@property (nonatomic) BOOL modelFlag;
@end

@implementation MedicalCaseModelVC

#pragma mask - property
-(NSMutableArray *)medicalCaseModels
{
    if(!_medicalCaseModels){
        _medicalCaseModels = [[NSMutableArray alloc] init];
        
        [_medicalCaseModels  addObject:@"女   30 - 40  糖尿病"];
        [_medicalCaseModels  addObject:@"女   100 - 120  糖尿病"];
        [_medicalCaseModels  addObject:@"女   30 - 40  糖尿病"];
        [_medicalCaseModels  addObject:@"女   120 - 150  没有病"];
    }
    
   return  _medicalCaseModels;
}
-(NSMutableArray *)filterMedicalCaseModels
{
    if(!_filterMedicalCaseModels){
        _filterMedicalCaseModels = [[NSMutableArray alloc] init];
    }
    return _filterMedicalCaseModels;
}

#pragma  mask - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTableViewStyle];
    self.modelFlag = YES;
    
    
//    self.edgesForExtendedLayout = UIRectEdgeTop;
//    self.extendedLayoutIncludesOpaqueBars = YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(self.modelFlag){
        [self setSearchDisplayController];
        self.modelFlag = NO;
    }
    self.searchBarFrame = self.searchBar.frame;
   
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationBarView setBarTintColor:[UIColor lightGrayColor]];
    self.navigationController.navigationBar.translucent = YES;
}
#pragma mask - set table view style

-(void)setTableViewStyle
{
   [self.tableView setTableFooterView:[[UIView alloc] init]];
    if(SYSTEM_VERSION_GREATER_THAN(@"8.0")){
       self.tableView.estimatedRowHeight = 45;
    }
}
#pragma mask - set search display controller
-(void)setSearchDisplayController
{
    UIViewController *viewVC = [[UIViewController alloc] init];
    viewVC.view.autoresizingMask = UIViewAutoresizingNone;
    viewVC.view.autoresizesSubviews = NO;
    viewVC.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    CGRect tempRect = self.tableView.frame;
    //tempRect = [self.view convertRect:tempRect fromView:self.tableView];
    tempRect.origin.y -= 0;
    tempRect.size.height += 22;
    [viewVC.view setFrame:tempRect];
    self.viewForSearchBar = viewVC.view;
    self.viewForSearchBar.frame = tempRect;
    self.viewForSearchBar.alpha = 0;
   // viewVC.view.layer.borderWidth = 1;
    [self addChildViewController:viewVC];
   
    self.strongSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:viewVC];
    self.strongSearchDisplayController.searchResultsDataSource = self;
    self.strongSearchDisplayController.searchResultsDelegate = self;
    self.strongSearchDisplayController.delegate = self;
    
    [self.strongSearchDisplayController.searchResultsTableView setTableFooterView:[[UIView alloc] init]];
    [self.strongSearchDisplayController.searchResultsTableView setBackgroundColor:[UIColor clearColor]];
    self.searchBar.autoresizingMask = UIViewAutoresizingNone;
   
    [self.view addSubview:viewVC.view];
    [viewVC didMoveToParentViewController:self];
}
#pragma mask - table view delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tableView){
       return  self.medicalCaseModels.count;
    }else {
      return self.filterMedicalCaseModels.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(tableView == self.tableView){
     
        cell = [tableView dequeueReusableCellWithIdentifier:@"modelCell"];
         UILabel *cellLabel = (UILabel*) [cell viewWithTag:1002];
        cellLabel.text = [self.medicalCaseModels objectAtIndexedSubscript:indexPath.row];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CaseModelCell"];
        
        if(cell == nil){
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"CaseModelCell" owner:self options:nil];
            for (id obj  in nibs) {
                if([obj isKindOfClass:[CaseModelCell class]]){
                    cell = (CaseModelCell*)obj;
                }
            }
        }
        UILabel *cellLabel1 = (UILabel*) [cell viewWithTag:1002];
        cellLabel1.text = [self.filterMedicalCaseModels objectAtIndexedSubscript:indexPath.row];
    }
  
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableView){
        WLKCaseNode *tempNode = [[WLKCaseNode alloc] init];
        [self.delegate didSelectedModelWithNode:tempNode];
    }else {
        //for search results
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableView){
        return YES;
    }else {
        return NO;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableView){
        //update table view
        
        if(editingStyle == UITableViewCellEditingStyleDelete){
            
            //remove data
            [self.medicalCaseModels removeObjectAtIndex:indexPath.row];
            
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            
           
        }
    }
}

#pragma mask - search bar delegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.viewForSearchBar.alpha = 1;
    return YES;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
   
    [self.filterMedicalCaseModels removeAllObjects];
    self.filterMedicalCaseModels = nil;
}

#pragma mask - searchDisplayController delegate and other methods
-(void)filiterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.filterMedicalCaseModels removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText];
    self.filterMedicalCaseModels = [NSMutableArray arrayWithArray:[self.medicalCaseModels filteredArrayUsingPredicate:predicate]];
    
}

// delegate
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    self.viewForSearchBar.alpha = 1;
    
    if([searchString isEqualToString:@""]){
        self.viewForSearchBar.alpha = 1;
    }
    [self filiterContentForSearchText:searchString scope:[[self.searchBar scopeButtonTitles] objectAtIndex:[self.searchBar selectedScopeButtonIndex]]];
    return YES;
}
-(void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView
{
    CGRect tempRect = tableView.frame;
    tempRect.origin.y += 22;
    tempRect.size.width += 100;
    tableView.frame = tempRect;
}
-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    CGRect tempRect = tableView.frame;
    tempRect.origin.y -= 22;
    tempRect.size.width -= 100;
    tableView.frame = tempRect;
    self.viewForSearchBar.alpha = 1;
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    self.viewForSearchBar.alpha = 0;
}

#pragma mask - remove subviewcontroller


-(void)dealloc
{
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    
    self.viewForSearchBar = nil;
    self.medicalCaseModels = nil;
    self.strongSearchDisplayController = nil;
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
