//
//  HUDiagnoseDetailVCCollectionViewController.m
//  MedCase
//
//  Created by ihefe-JF on 15/1/4.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import "HUDiagnoseDetailVCCollectionViewController.h"
#import "HUDiagnoseDetailCollectionViewCell.h"
#import "HUDetailCollectionViewLayout.h"
#import "HUDetailCollectionViewHeaderView.h"
#import "HUPickerViewController.h"
#import "ConstantVariable.h"
#import "KeyValueObserver.h"

@interface HUDiagnoseDetailVCCollectionViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) NSMutableArray *detailArray;

@property (nonatomic,strong) NSMutableArray *moreDetailArray;//选择cell元素之后，根据元素的title得到该数组，用来作为将要呈现的数据源
//@property (nonatomic,strong) UIPopoverController *popover;
@property (nonatomic,strong) UIView *containerView;

@property (nonatomic,strong)NSMutableDictionary *offscreenCells;

@property (nonatomic,strong) WLKCaseNode *selectedDetailNode;
@property (nonatomic,strong) WLKCaseNode *rowNode;
@property (nonatomic,strong) WLKCaseNode *sectionNode;

@property (nonatomic,strong) HUDiagnoseDetailCollectionViewCell *selectedCell;

@property (nonatomic,strong) NSIndexPath *currentIndexpath;
@property (nonatomic,strong) id cellObsevrToken;

@property (nonatomic,strong) HUDiagnoseDetailCollectionViewCell *previousSelectedCell;
@property (nonatomic,strong) NSIndexPath *previousIndexPath;

@property (nonatomic,strong) NSMutableArray *sectionArray;

@end

@implementation HUDiagnoseDetailVCCollectionViewController

static NSInteger  parentCellIndex = -1;

static NSString * const reuseIdentifier = @"DetailCell";
static NSString *didSelectedCollectionViewCellNotificationName = @"DidSelectedCollectionViewCellNotificationName";

-(NSMutableDictionary *)offscreenCells
{
    if(!_offscreenCells){
        _offscreenCells = [[NSMutableDictionary alloc] init];
    }
    return _offscreenCells;
}
-(HUDiagnoseDetailCollectionViewCell *)previousSelectedCell
{
    if(!_previousSelectedCell){
        _previousSelectedCell = self.selectedCell;
    }
    return _previousSelectedCell;
}
-(void)setSelectedCell:(HUDiagnoseDetailCollectionViewCell *)selectedCell
{
    _selectedCell = selectedCell;
    
    _selectedCell.backgroundView.backgroundColor = [UIColor redColor];
}
//-(NSMutableArray *)sectionArray
//{
//    if(_)
//}
//-(NSIndexPath *)currentIndexpath
//{
//    if(!_currentIndexpath){
//        _currentIndexpath = nil;
//    }
//  return  _currentIndexpath;
//}
-(NSMutableArray *)sectionArray
{
    if(!_sectionArray){
        _sectionArray = [[NSMutableArray alloc] initWithArray:self.sectionNode.childNodes];
    }
    return _sectionArray;
}
-(NSIndexPath *)previousIndexPath
{
    if(!_previousIndexPath){
        _previousIndexPath = self.currentIndexpath;
    }
    return _previousIndexPath;
}
//-(void)setMultiTables:(WLKMultiTableView *)multiTables
//{
//    _multiTables = multiTables;
//    _multiTables.caseNode = self.detailCaseNode;
//    self.multiTablesObsevToken = [KeyValueObserver observeObject:self.multiTables keyPath:@"selectedStr" target:self selector:@selector(selectedTextDidChange:) options:NSKeyValueObservingOptionInitial];
//    
//}
//-(void)setSelectedCell:(HUDiagnoseDetailCollectionViewCell *)selectedCell
//{
//    _selectedCell = selectedCell;
//
//    self.cellObsevrToken = [KeyValueObserver observeObject:self.selectedCell.detailCellNode keyPath:@"nodeContent" target:self selector:@selector(cellNodeContentDidChange:)];
//}
//-(void)cellNodeContentDidChange:(NSDictionary*)change
//{
//    
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserverForSelf];
    
    self.collectionView.autoresizesSubviews = YES;
    [self.collectionView sizeToFit];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HUDiagnoseDetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
}
-(void)dealloc
{
    [self removeObserverForSelf];
}
-(void)removeObserverForSelf
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)addObserverForSelf
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectedCollectionViewCellWithButtonTitleText:) name:didSelectedCollectionViewCellNotificationName object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetInputViewText:) name:kInputTextCompleted object:nil];
}
-(void)didGetInputViewText:(NSNotification*)info
{
    id textStr = [info object];
    BOOL nodeChildsDidAdd = NO;
    if([textStr isKindOfClass:[NSString class]]){
        NSString *tempStr = (NSString*)textStr;
        
        if(self.previousSelectedCell.detailCellNode){
            self.previousSelectedCell.detailCellNode.nodeContent = tempStr;
        }else {
            //for 手动添加的字段
            if([self.previousSelectedCell.detailLabel.text isEqualToString:@"添加"]){
                WLKCaseNode *insertNode = [WLKCaseNode nodeWithSourceType:NodeSourceTypeCustom];
                insertNode.nodeContent = tempStr;
                insertNode.nodeName = tempStr;
                
                NSMutableArray *tempNodes = self.sectionNode.childNodes;
                WLKCaseNode *tempNode = tempNodes[self.previousIndexPath.section];
                nodeChildsDidAdd  = YES;
                
                [tempNode addChildNode:insertNode];
                [tempNode selectChildNode:insertNode];
            }else {
                self.previousSelectedCell.detailCellNode.nodeContent = tempStr;
            }
            
        }
        
        if(nodeChildsDidAdd){
            [self.collectionView insertItemsAtIndexPaths:@[self.previousIndexPath]];
        }else {
           [self.collectionView reloadItemsAtIndexPaths:@[self.previousIndexPath]];
        }
       
        
        NSLog(@"将要添加的字符串是%@",tempStr);
    }
}
-(void)didSelectedCollectionViewCellWithButtonTitleText:(NSNotification*)notificationInfo
{

    id tempNode = [notificationInfo object];
    if([tempNode isKindOfClass:[WLKCaseNode class]]){
        self.sectionNode = nil;
        [self.sectionArray removeAllObjects];
        self.sectionArray = nil;
        self.sectionNode = (WLKCaseNode*)tempNode;
        [self.collectionView reloadData];
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    
    return self.sectionArray.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    //NSMutableArray *tempNodes = self.sectionNode.childNodes;
    self.rowNode = self.sectionArray[section];

    return self.rowNode.childNodes.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HUDiagnoseDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
   
   // NSMutableArray *tempNodes = self.sectionNode.childNodes;
    WLKCaseNode *tempNode = self.sectionArray[indexPath.section];
    if(indexPath.row == tempNode.childNodes.count){
        cell.detailCellNode = nil;
    }else {
        cell.detailCellNode = tempNode.childNodes[indexPath.row];
        
    }
    [cell configCell];
    cell.tag = indexPath.row;
    cell.section = indexPath.section;
    
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat tempFloat = self.collectionView.bounds.size.width;
    CGFloat targetWidth = (tempFloat - 2 * 8)/4;
    NSString *reuseId = reuseIdentifier;
    HUDiagnoseDetailCollectionViewCell *cell =(HUDiagnoseDetailCollectionViewCell*)self.offscreenCells[reuseId];
    if(cell == nil){
        cell =(HUDiagnoseDetailCollectionViewCell*) [[[NSBundle mainBundle] loadNibNamed:@"HUDiagnoseDetailCollectionViewCell" owner:self options:nil]objectAtIndex:0];
        self.offscreenCells[reuseId] = cell;
    }
   // NSMutableArray *tempNodes = self.sectionNode.childNodes;
   
    CGSize size = CGSizeMake(targetWidth, 44);
     WLKCaseNode *tempNode = self.sectionArray[indexPath.section];
    if(tempNode.nodeChangeStatus){
        
       
        if(indexPath.row == tempNode.childNodes.count){
            cell.detailCellNode = nil;
        }else {
            cell.detailCellNode = tempNode.childNodes[indexPath.row];
            
        }
        
        [cell configCell];
        
        cell.bounds = CGRectMake(0, 0, collectionView.frame.size.width, cell.bounds.size.height);
        cell.contentView.bounds = cell.bounds;
        
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        
        size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
        NSUInteger inht =(int) size.width/targetWidth;
        
        size.width = (inht + 1) * targetWidth;// + inht * 30;
        
        if(size.width >= 988){
            size.width = tempFloat - 2 * 8;
        }

    }
    return size;
}


-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 8, 10, 8);
    //return UIEdgeInsetsMake(10, 1, 5, 1);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{

    UILabel *label =(UILabel*) [cell viewWithTag:1002];
    
    CGFloat cellTailX = CGRectGetWidth(cell.frame) + cell.frame.origin.x;
    
    if(cellTailX >= (CGRectGetWidth(self.view.frame) - 20)){
        label.hidden = YES;
    }else {
        label.hidden = NO;
    }
}
#pragma mark <UICollectionViewDelegate>

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if(kind == UICollectionElementKindSectionHeader){
        HUDetailCollectionViewHeaderView *detailHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"DetailHeader" forIndexPath:indexPath];
        WLKCaseNode *tempNode = self.sectionNode.childNodes[indexPath.section];
        detailHeaderView.headerLabel.text = tempNode.nodeContent;
        reusableview = detailHeaderView;
    }
    return reusableview;
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HUDiagnoseDetailCollectionViewCell *cell =(HUDiagnoseDetailCollectionViewCell*) [collectionView cellForItemAtIndexPath:indexPath];
    UILabel *label =(UILabel*) [cell viewWithTag:1001];
    label.textColor = [UIColor colorWithRed:108.0/255 green:106.0/255 blue:106.0/255 alpha:1];
    self.previousSelectedCell = self.selectedCell;
    self.previousIndexPath = self.currentIndexpath;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HUDiagnoseDetailCollectionViewCell *cell =(HUDiagnoseDetailCollectionViewCell*) [collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *tempImageView = (UIImageView*)[cell viewWithTag:1003];
     UILabel *label =(UILabel*) [cell viewWithTag:1001];
    if(tempImageView.isHighlighted){
           label.textColor = [UIColor colorWithRed:11.0/255 green:106.0/255 blue:255.0/255 alpha:1];
    }else {
           label.textColor = [UIColor colorWithRed:108.0/255 green:106.0/255 blue:106.0/255 alpha:1];
    }
    
    self.selectedCell = cell;

    if(self.currentIndexpath){
        if(self.currentIndexpath.section == indexPath.section && self.currentIndexpath.row == indexPath.row){
            self.previousIndexPath = nil;
            self.previousSelectedCell = nil;
        }
    }
    self.currentIndexpath = indexPath;
    
    [self.delegate didSelectedDetailCollectionViewCell:cell collectionView:collectionView atIndexPath:indexPath ];

}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.collectionView.collectionViewLayout invalidateLayout];
}
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
     [self.collectionView.collectionViewLayout invalidateLayout];
}
/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/


//// Uncomment this method to specify if the specified item should be selected
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//
//
//
//// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
//	return YES;
//}
//
//- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
//	return YES;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
//	
//}


@end
