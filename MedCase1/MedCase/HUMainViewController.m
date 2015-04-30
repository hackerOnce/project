//
//  HUMainViewController.m
//  MedicalRecord
//
//  Created by ihefe-JF on 14/12/26.
//  Copyright (c) 2014年 JFAppHourse.app. All rights reserved.
//

#import "HUMainViewController.h"
#import "HUNavigationBarView.h"
#import "PersonTableViewController.h"
#import "HUDiseaseClassificationCollectionViewCell.h"
#import "SynchronizedUIActionSheet.h"
#import "NSArray+Extension.h"
#import "HUDiagnoseDetailVCCollectionViewController.h"
#import "HUPickerViewController.h"
#import "PersonInfo.h"
#import "KeyValueObserver.h"
#import "HUDSubViewController.h"
#import "WLKMultiTableView.h"
#import "Show3DViewController.h"
#import "ManualInputTextViewController.h"
#import "SaveViewController.h"
#import "ConstantVariable.h"
#import "MedicalCaseModelVC.h"
#import "RawDataProcess.h"

@interface HUMainViewController ()<HUNavigationBarViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,HUDiseaseClassificationCollectionViewCellDelegate,UIActionSheetDelegate,HUDiagnoseDetailVCCollectionViewControllerDelegate,UIAlertViewDelegate,MedicalCaseModeVCDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *classificationCollectionView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIButton *zoomInOut;
@property (weak, nonatomic) IBOutlet UIView *collectionContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailContainerViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *classCollectionVIewConstraint;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *show3DOrList;


@property (nonatomic,strong) HUDiseaseClassificationCollectionViewCell *classificationCell;

@property (nonatomic,strong) UIPopoverController *popover;

@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,strong) NSArray *actionSheetButtonTitles;

@property (nonatomic,strong) NSArray *allDiagnosis;

@property (nonatomic,strong) NSMutableArray *detailArray;


@property (nonatomic,strong) HUNavigationBarView *topBarView;
//key:@"现病史",value:"array" ...

@property (nonatomic,strong) UICollectionView *selectedDetailCollectionView;

@property (nonatomic,strong) HUDiagnoseDetailCollectionViewCell *detailCell;


@property (nonatomic) CGRect initContainerViewFrame;

@property (nonatomic,strong) PersonInfo *startPerson;//当第一页面出现时，选择该person
@property (nonatomic,strong) WLKCaseNode *personNode;
@property (nonatomic,strong) id personObserveToken;

@property (nonatomic,strong) WLKCaseNode *detailCellNode;

@property (nonatomic,strong) UIViewController *tempVC;

@property (nonatomic,strong) WLKMultiTableView *tableViews;

@property (nonatomic,strong) WLKCaseNode *saveNode;

@property (nonatomic,strong) WLKCaseNode *postNode;

@property (nonatomic,strong) HUDiseaseClassificationCollectionViewCell *currentCell;

@property (nonatomic,strong) NSIndexPath *currentIndexPath;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;

//@property (nonatomic,weak) MedicalCaseModelVC *modelVC;

@property (nonatomic,strong) id keyObserverTokenForNavigationBar;

@property (nonatomic,strong) CoreDataManager *saveCoreDataManager;


@end


static NSString *didSelectedCollectionViewCellNotificationName = @"DidSelectedCollectionViewCellNotificationName";

static BOOL show3DFlag = NO;
static NSString *show3DIDentifier = @"诱因";//show3D
static BOOL saveNodeDidCancel = NO;
@implementation HUMainViewController
- (IBAction)rules:(id)sender
{
    UIStoryboard *ruleManagerStoryboard = [UIStoryboard storyboardWithName:@"ModelManagement" bundle:nil];
    UIViewController *ruleVC = [ruleManagerStoryboard instantiateViewControllerWithIdentifier:@"ruleVC"];
    ruleVC.view.backgroundColor = [UIColor whiteColor];

    [self presentViewController:ruleVC animated:YES completion:^{
        
    }];
}

-(UIView *)rightSideSlideView
{
    if(!_rightSideSlideView){
        _rightSideSlideView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame),0,rightSideSlideViewWidth , CGRectGetHeight(self.view.frame) - 0 - 45)];
        _rightSideSlideView.backgroundColor = [UIColor yellowColor];
        
        UISwipeGestureRecognizer *recoginizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideRightSildeView:)];
        recoginizer.direction = UISwipeGestureRecognizerDirectionRight;
        
        [_rightSideSlideView addGestureRecognizer:recoginizer];
        
       // [self.view addSubview:_rightSideSlideView];
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        [keyWindow addSubview:self.rightSideSlideView];
        
        self.rightSlideViewFlag = YES;
    }
    
    return _rightSideSlideView;
}
-(UIView *)maskView
{
    if(!_maskView){
        CGRect tempRect = self.view.frame;
        tempRect.origin.y -= 44;
        _maskView = [[UIView alloc] initWithFrame:tempRect];
        _maskView.backgroundColor = [UIColor darkGrayColor];
        _maskView.alpha = 0;;
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        [keyWindow insertSubview:_maskView belowSubview:self.rightSideSlideView];
    }
    return _maskView;
}
-(CoreDataManager *)saveCoreDataManager
{
    if(!_saveCoreDataManager){
        _saveCoreDataManager = [[RawDataProcess sharedRawData] coreDataManager];
    }
    return _saveCoreDataManager;
}
-(void)hideRightSildeView:(UISwipeGestureRecognizer *)swipGesture
{
    
    CGRect tempRect = self.rightSideSlideView.frame;
    tempRect.origin.x += rightSideSlideViewWidth - 10;
    [UIView animateWithDuration:0.4 animations:^{
        self.rightSideSlideView.frame = tempRect;
        //[self performSegueWithIdentifier:@"MedicalCaseModel" sender:nil];
    } completion:^(BOOL finished) {
       [self performSegueWithIdentifier:@"MedicalCaseModel" sender:nil];
        //self.modelVC = nil;
//        [self.rightSideSlideView removeFromSuperview];
//        self.rightSideSlideView = nil;
    }];
    
}
- (IBAction)show3DOrListButtonClicked:(id)sender
{
    [self clearAllSubViewsFromView:self.containerView];
    [self addContainerViewForSelf:self.detailCell];
    
}
- (IBAction)leftButton:(UIButton *)sender
{
    CGPoint contentOffset = self.classificationCollectionView.contentOffset;
    if(!(contentOffset.x <= 10)){
        contentOffset.x -= 89;
    }else {
        contentOffset.x = 0;
    }
    [self.classificationCollectionView setContentOffset:contentOffset animated:YES];
}
- (IBAction)showMedicalCaseModel:(UIBarButtonItem *)sender
{
   //do nothing
  
    
}
- (IBAction)rightButton:(UIButton *)sender
{
    CGPoint contentOffset = self.classificationCollectionView.contentOffset;
    
    //if(!(self.currentIndexPath.row == self.array.count -1)){
    if(contentOffset.x <= 330){
        contentOffset.x += 89;
    }else {
        contentOffset.x = (self.array.count - 10) * 89;
    }
    
    [self.classificationCollectionView setContentOffset:contentOffset animated:YES];
}
- (IBAction)saveButton:(UIButton *)sender
{
    //save to core data
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存为模板",@"保存为病历", nil];
    [alert show];
}
#pragma mask - alert view delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"取消"]){
        
    }else if([title isEqualToString:@"保存为模板"]){
//         NSString *tempStr = [self.startPerson.rootNode jsonString];
//         NSDictionary *div = @{@"personInfo":self.startPerson,@"caseContent":tempStr};
//        [self.saveCoreDataManager insertNewObjectForEntityName:[ModelCase modelCaseEntityName] withDictionary:div];
        
    }else if([title isEqualToString:@"保存为病历"]){
        
//        NSString *tempStr = [self.startPerson.rootNode jsonString];
//        NSDictionary *div = @{@"personInfo":self.startPerson,@"caseContent":tempStr};
//        [self.saveCoreDataManager insertNewObjectForEntityName:[Person personEntityName] withDictionary:div];
    }
}
-(WLKCaseNode *)saveNode
{
    if(!_saveNode){
        
        _saveNode = [[WLKCaseNode alloc] init];
        
        for(NSString *tempName in self.array){
            WLKCaseNode *tempNode = [self.startPerson.rootNode getNodeFromNodeChildArrayWithNodeName:tempName];
    
            [_saveNode addChildNode:tempNode];
        }
        _saveNode.nodeName = @"trueRoot";
    }
    return _saveNode;
}
-(NSMutableString *)zoomInoutID
{
    if(!_zoomInoutID){
        _zoomInoutID = [NSMutableString stringWithFormat:@"ZoomInOut"];
    }
    return _zoomInoutID;
}

-(NSArray *)allDiagnosis
{
    if(!_allDiagnosis){
        _allDiagnosis = [NSMutableArray arrayWithObjects:@"主诉",@"现病史",@"既往史",@"系统回顾",@"个人史",@"月经史",@"婚育史",@"家族史",@"体格检查",@"专科检查",@"辅助检查",@"初步诊断",@"入院诊断",@"补充诊断", nil];
    }
    return _allDiagnosis;
}
-(void)setZoomInOut:(UIButton *)zoomInOut
{
    
    zoomInOut.layer.cornerRadius = 5;
    zoomInOut.layer.borderColor = [UIColor redColor].CGColor;
    zoomInOut.layer.borderWidth = 1;
    [zoomInOut addTarget:self action:@selector(didSelectedZoomInOutButton:) forControlEvents:UIControlEventTouchUpInside];
    _zoomInOut = zoomInOut;
    
}

//-(void)setArray:(NSMutableArray *)array
//{
//    
//  
//    if((array.count <= 14) && ([array containsObject:@"添加"])){
//        [array addObject:@"添加"];
//    }
//    _array = array;
//    
//}
- (IBAction)changeTitleBar:(UIBarButtonItem *)sender
{
    NSLog(@"title view 将要进行切换");
    HUNavigationBarView *tempbarView =(HUNavigationBarView*)self.navigationItem.titleView;
    tempbarView.changeViewFlag = !tempbarView.changeViewFlag;
    [tempbarView buildNavigationBarViewUI];
    [tempbarView showData];
    if(tempbarView.changeViewFlag){
        [tempbarView.button addTarget:self action:@selector(popMorePerson:) forControlEvents:UIControlEventTouchUpInside];
        
        PersonInfo *p1 = [[PersonInfo alloc] initWithName:@"张三" age:@"22" gender:@"女" location:@"102床" admissionDiagnosis:@"熊猫眼" medicalTreatment:@"不知" allergicHistory:@"青霉素霍敏"];
        self.startPerson =  p1;
        self.topBarView.personInfo = p1;
        [self.topBarView showData];
    }else {
        
        self.startPerson = [[PersonInfo alloc] init];
        self.topBarView.personInfo = self.startPerson;
        [self.topBarView showData];
//       self.keyObserverTokenForNavigationBar = [KeyValueObserver observeObject:tempbarView keyPath:@"" target:self selector:@selector(genderDidChange:) options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew];
        
    }
}


static NSUInteger selectedZoominOutCount = 0;
-(void)didSelectedZoomInOutButton:(UIButton*)button
{
   
    if((selectedZoominOutCount %2) == 0 ){
         [self.zoomInoutID insertString:@"Clicked" atIndex:0];
        selectedZoominOutCount = 1;
        self.navigationController.navigationBarHidden = YES;
        
        self.show3DOrList.enabled = NO;
        self.show3DOrList.title = @" ";
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.classCollectionVIewConstraint.constant = -120;
            [self.view layoutIfNeeded];
           
        }  completion:^(BOOL finished) {
            [self scrollDetailCollectionViewToPosition];
        }];
        
        
    }else {
        [self show3DCollectionViewFrameBackToInit];
    }
    
}
-(void)show3DCollectionViewFrameBackToInit
{
    selectedZoominOutCount = 0;
    
    self.show3DOrList.enabled = YES;
    self.show3DOrList.title = @"3D/L";
    
    NSRange range = [self.zoomInoutID rangeOfString:@"Clicked"];
    [self.zoomInoutID deleteCharactersInRange:range];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBarHidden = NO;
        self.classCollectionVIewConstraint.constant = 0;
        [self.view layoutIfNeeded];
        
    }  completion:^(BOOL finished) {
        
        [self scrollDetailCollectionViewToPosition];
        
    }] ;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.containerView.alpha = 0;
    self.containerView.autoresizesSubviews = YES;
    self.containerView.autoresizesSubviews = YES;
  
   
    //当第一页面出现时，选择该person
    if(self.topBarView.changeViewFlag && !saveNodeDidCancel){
        PersonInfo *p1 = [[PersonInfo alloc] initWithName:@"张三" age:@"22" gender:@"女" location:@"102床" admissionDiagnosis:@"熊猫眼" medicalTreatment:@"不知" allergicHistory:@"青霉素霍敏"];
        self.startPerson =  p1;
        self.topBarView.personInfo = p1;
    }
  
   
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    self.initContainerViewFrame = self.collectionContainerView.frame;
    
}

-(void)collectionViewSelectedFirstCell
{
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.classificationCollectionView selectItemAtIndexPath:firstIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionLeft];
    
    HUDiseaseClassificationCollectionViewCell *tempCell = (HUDiseaseClassificationCollectionViewCell*)[self.classificationCollectionView cellForItemAtIndexPath:firstIndexPath];
   // tempCell.selected = YES;
    tempCell.buttonState = ButtonStateKeepSelected;
   
    [self didSelectedCell:tempCell includeButton:[UIButton buttonWithType:UIButtonTypeCustom]];
   // [self.classificationCollectionView ]
}
- (void)viewDidLoad
{
    [super viewDidLoad];

     [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:244.0/255 alpha:1]];
    //self.extendedLayoutIncludesOpaqueBars = YES;
    
    CGRect tempRect = self.navigationController.navigationBar.frame;
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, tempRect.origin.y + CGRectGetHeight(tempRect), CGRectGetWidth(tempRect), 1)];
    borderView.backgroundColor = [UIColor colorWithRed:220.0/255 green:222.0/255 blue:224.0/255 alpha:1];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:borderView];
    [keyWindow bringSubviewToFront:borderView];
    
    [self addObserverForSelf];
    [self addTopBarView];
   
     self.personObserveToken  =[KeyValueObserver observeObject:self.topBarView keyPath:@"personInfo" target:self selector:@selector(personDidChange:) options:NSKeyValueObservingOptionInitial];
}
-(void)personDidChange:(NSDictionary*)change
{
    [self.topBarView showData];
    
    self.array =[[NSMutableArray alloc] initWithArray:[self.startPerson getScreenInformationNodeWithConditionMode:3]];
    if(self.array.count < 14){
        [self.array addObject:@"添加"];
    }
    self.saveNode = nil;
    self.selectedIndexPath= nil;
    self.currentIndexPath = nil;
    
    [self.classificationCollectionView reloadData];
    
    [self performSelector:@selector(collectionViewSelectedFirstCell) withObject:nil afterDelay:0.1];
}
-(void)addObserverForSelf
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectedPerson:) name:didSelectedRowNotificationName object:nil];
}
#pragma mask 屏幕旋转

//-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//
//    if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
//        Width = MAX(CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame));
//    }else {
//        Width = MIN(CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame));
//    }
//   [UIView animateWithDuration:duration animations:^{
//      // self.navigationItem.titleView.frame =CGRectMake(0, 7, Width-80, 40);
//      // [self.topBarView setNeedsDisplayInRect:CGRectMake(0, 7, Width-80, 40)];
//   }];
//    
//}
-(void)addTopBarView
{
    CGFloat tempWidth;
    
    if(floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1){
        tempWidth = CGRectGetWidth(self.view.frame);
    }else {
        if([self isLandScape]){
            tempWidth = CGRectGetHeight(self.view.frame);
        }else {
            tempWidth = CGRectGetWidth(self.view.frame);
        }
    }
   
    self.topBarView = [[HUNavigationBarView alloc] initWithFrame:CGRectMake(0, 0,  tempWidth, 40)];
    self.topBarView.delegate = self;
    
    [self.topBarView.button addTarget:self action:@selector(popMorePerson:) forControlEvents:UIControlEventTouchUpInside];

    [self.navigationItem setTitleView:self.topBarView];
    
    
}
-(void)didSelectedPerson:(NSNotification*)info
{
    [self.popover dismissPopoverAnimated:NO];
    id tempPerson = [info object];
    if([tempPerson isKindOfClass:[PersonInfo class]]){
        PersonInfo *tempP = (PersonInfo*)tempPerson;
        self.startPerson = tempP;
        self.topBarView.personInfo = tempP;
    }
}
#pragma mask - 点击topbar按钮之后，popover 所有病人的基本信息
-(void)popMorePerson:(UIButton*)sender
{
   // UIBarButtonItem *button = (UIBarButtonItem*)sender;
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonTableViewController *personVC = [storyBoard instantiateViewControllerWithIdentifier:@"PersonTableViewVC"];
   
    self.popover = [[UIPopoverController alloc] initWithContentViewController:personVC];
    self.popover.popoverContentSize = personVC.preferredContentSize;
    
    CGRect tempFrame = sender.frame;
    tempFrame.origin.y += tempFrame.size.height;
   
    [self.popover presentPopoverFromRect:tempFrame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mask - collection view delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HUDiseaseClassificationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DiseaseClassificationCell" forIndexPath:indexPath];
    cell.delegate = self;
    
   
    cell.cellNode = [self.startPerson.rootNode getNodeFromNodeChildArrayWithNodeName:[self.array objectAtIndex:indexPath.row]];
    
    
    cell.tag = indexPath.row;
  
   // cell.buttonState = ButtonStateUnKnow;
    
    self.currentIndexPath = indexPath;
    
    if(self.selectedIndexPath.row == indexPath.row){
        cell.buttonState = ButtonStateKeepSelected;
    }else {
        if(cell.cellNode.nodeChangeStatus){
            cell.buttonState = ButtonStateSelected;
        }else {
            cell.buttonState = ButtonStateUnKnow;
        }
    }
    
    if(!cell.cellNode)
    {
        cell.cellButton.text = @"添加";
       
    }else {
         [cell configCell];
    }
   
 
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
  HUDiseaseClassificationCollectionViewCell *cell =(HUDiseaseClassificationCollectionViewCell*) [collectionView cellForItemAtIndexPath:indexPath];
    if(cell.cellNode.nodeChangeStatus){
        cell.buttonState = ButtonStateSelected;
    }else {
        cell.buttonState = ButtonStateUnKnow;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HUDiseaseClassificationCollectionViewCell *cell =(HUDiseaseClassificationCollectionViewCell*) [collectionView cellForItemAtIndexPath:indexPath];
    UILabel *cellButton = (UILabel*) [cell viewWithTag:1000];
    
    cell.buttonState  = ButtonStateKeepSelected;

    self.selectedIndexPath = indexPath;
    
    if([cellButton.text isEqualToString:@"添加"]){
        
        NSArray *tempArray =[NSArray arrayWithArray:[self.allDiagnosis difference:self.array]];
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        for(NSString *tempStr in tempArray){
            [actionSheet addButtonWithTitle:tempStr];
        }
        CGRect tempRect = [cellButton convertRect:cellButton.frame toView:self.view];
        [actionSheet showFromRect:tempRect inView:self.view animated:YES];
        self.actionSheetButtonTitles = [[NSMutableArray alloc] initWithArray:tempArray];
        
        return;
    }else {
         [[NSNotificationCenter defaultCenter] postNotificationName:didSelectedCollectionViewCellNotificationName object:cell.cellNode];
    }
    
    [self clearContainerView];
    [self.selectedDetailCollectionView setContentOffset:CGPointZero animated:NO];
    
    self.currentCell = cell;
}

//#pragma mask - collection view cell delegate
-(void)didSelectedCell:(HUDiseaseClassificationCollectionViewCell *)cell includeButton:(UIButton *)button
{

    [[NSNotificationCenter defaultCenter] postNotificationName:didSelectedCollectionViewCellNotificationName object:cell.cellNode];
}

#pragma mask - action sheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex >= self.actionSheetButtonTitles.count){
        return;
    }
    NSString *tempButtonTitle = (NSString*)self.actionSheetButtonTitles[buttonIndex];
    self.array = [self.array insert:tempButtonTitle];
    
    [self.classificationCollectionView reloadData];
    [self.classificationCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.array.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    NSLog(@"selected button index is %@,button title is %@",@(buttonIndex),tempButtonTitle);
}

#pragma mask - 当屏幕旋转时，detail collection view 选择正确的位置
static NSInteger  parentCellIndex = -1;
static NSString *kDidSelectedCollectionViewElements = @"DidSelectedCollectionViewElements";
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    [self scrollDetailCollectionViewToPosition];
    
}
-(void)scrollDetailCollectionViewToPosition
{
   
    [self.selectedDetailCollectionView setContentOffset:CGPointMake(0, self.detailCell.frame.origin.y - 10)];
}


#pragma mask - 当在detail collection view中选择某个cell后，弹出container view，load对应的view controller里的view到container view
-(void)didSelectedDetailCollectionViewCell:(HUDiagnoseDetailCollectionViewCell *)cell collectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath
{
    
   // [self.delegate didSelectedDetailCollectionViewCell:cell includeButton:button section:section];
    self.selectedDetailCollectionView = collectionView;
    self.detailCell = cell;
    
   // NSString *tempStr =cell.detailCellNode.nodeName;
    
    if(parentCellIndex == -1){
        parentCellIndex = cell.tag;
        [UIView animateWithDuration:0.5 animations:^{
       
             [collectionView setContentOffset:CGPointMake(0, cell.frame.origin.y -10)];
        } completion:^(BOOL finished) {
            [self addContainerViewForSelf:cell];
        }];
    }else {
        if(parentCellIndex == cell.tag){
            
            if(self.containerView.alpha == 0){
                
                [UIView animateWithDuration:0.3 animations:^{
               
                    [collectionView setContentOffset:CGPointMake(0, cell.frame.origin.y -10)];

                } completion:^(BOOL finished) {
                    [self addContainerViewForSelf:cell];
                }];
                
            }else {
                
                [UIView animateWithDuration:0.3 animations:^{
                    //[self.containerView removeFromSuperview];
                    [self clearContainerView];
                    
                } completion:^(BOOL finished) {
                   // [collectionView setContentOffset:CGPointMake(0, 0)];
                    UILabel *tempDetailLabel = (UILabel*)[cell viewWithTag:1001];
                    tempDetailLabel.textColor = [UIColor colorWithRed:108.0/255 green:106.0/255 blue:106.0/255 alpha:1];
                    
                    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
                    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
                    //[collectionView scrollRectToVisible:cell.frame animated:YES];
                }];
            }
        }else {
            [UIView animateWithDuration:0.3 animations:^{

               // [collectionView setContentOffset:CGPointMake(0, ((cell.tag/cellFlag)*60)+ (section+1) * 21)];
                [collectionView setContentOffset:CGPointMake(0, cell.frame.origin.y-10)];

            } completion:^(BOOL finished) {
                
                if(self.containerView.alpha == 0){
                    [self addContainerViewForSelf:cell];
                }else {
                    [self clearAllSubViewsFromView:self.containerView];
                    //[self addContainerViewForSelf:tempStr];
                    [self addViewDependOnSelectedCell:cell];
                }
            }];
        }
        parentCellIndex = cell.tag;
    }
    //准备数据
    //self.moreDetailArray = [[NSMutableArray alloc] initWithArray:self.detailArray];
    //[[NSNotificationCenter defaultCenter] postNotificationName:kDidSelectedCollectionViewElements object:self.det];
   // ;
}
-(void)clearContainerView
{
   
    
   // self.detailCell.selected = NO;
    [self removeControllerView:self.tempVC];
    [self clearAllSubViewsFromView:self.containerView];
    self.containerView.alpha = 0;
    self.zoomInOut.alpha = 0;
    self.zoomInOut.enabled = NO;
    show3DFlag = NO;
    self.show3DOrList.enabled = NO;
    self.show3DOrList.title = @" ";
    self.zoomInoutID = nil;
    
    selectedZoominOutCount = 0;
    
}
-(void)clearAllSubViewsFromView:(UIView*)superView
{
    for (UIView *tempView in superView.subviews){
        [tempView removeFromSuperview];
    }
    
}
-(void)addContainerViewForSelf:(HUDiagnoseDetailCollectionViewCell*)cell
{
   // self.detailCell.selected = YES;
    
    self.containerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
   // self.containerView.layer.borderColor = [UIColor redColor].CGColor;
   // self.containerView.layer.borderWidth =2;
    
    [self addViewDependOnSelectedCell:cell];

    self.containerView.alpha = 1;
    [self.view bringSubviewToFront:self.containerView];
    [self.view bringSubviewToFront:self.zoomInOut];
}

-(void)addViewDependOnSelectedCell:(HUDiagnoseDetailCollectionViewCell*)cell
{
   // UIViewController *tempVC;
    UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if(cell.detailCellNode.nodeType == 2){
      
        HUPickerViewController *pickerView = [myStoryboard instantiateViewControllerWithIdentifier:@"PickerView"];
        self.tempVC = pickerView;
        
        [self addViewControllerView:pickerView ToSelfContainerView:self.containerView];
        
    }else if(cell.detailCellNode.nodeSourceType == NodeSourceTypeCustom || [cell.detailLabel.text isEqualToString:@"添加"]){
        
        ManualInputTextViewController *inputVC = [myStoryboard instantiateViewControllerWithIdentifier:@"InputTextVC"];
        if(cell.detailCellNode){
             inputVC.textStrng = cell.detailCellNode.nodeContent;
        }
        self.tempVC = inputVC;
        [self addViewControllerView:inputVC ToSelfContainerView:self.containerView];
    }else {
        if([cell.detailCellNode.nodeName isEqualToString:show3DIDentifier]){
            
            
            self.show3DOrList.enabled = YES;
            self.show3DOrList.title = @"3D/L";
            
            if(show3DFlag){
               
                Show3DViewController *threeDVC  = [myStoryboard instantiateViewControllerWithIdentifier:@"show3DVC"];
                threeDVC.show3DNode = cell.detailCellNode.parentNode.parentNode.parentNode;
                threeDVC.zoomInoutID = self.zoomInoutID;
                self.tempVC = threeDVC;
                [self addViewControllerView:threeDVC ToSelfContainerView:self.containerView];
                show3DFlag = NO;
                
                self.zoomInOut.alpha = 1;
                self.zoomInOut.enabled = YES;
            }else {
                self.zoomInOut.alpha = 0;
                self.zoomInOut.enabled = NO;
                HUDSubViewController *subVC = [myStoryboard instantiateViewControllerWithIdentifier:@"SubVC"];
                subVC.detailCaseNode = cell.detailCellNode;
                self.tempVC = subVC;
                [self addViewControllerView:subVC ToSelfContainerView:self.containerView];
                show3DFlag = YES;
            }
        } else {
            HUDSubViewController *subVC = [myStoryboard instantiateViewControllerWithIdentifier:@"SubVC"];
            subVC.detailCaseNode = cell.detailCellNode;
            self.tempVC = subVC;
            [self addViewControllerView:subVC ToSelfContainerView:self.containerView];
        }
      
       
    }
}

-(void)addViewControllerView:(UIViewController*)tempVC ToSelfContainerView:(UIView*)containerView
{
    [self addChildViewController:tempVC];
    CGRect tempframe = CGRectMake(5, 5, CGRectGetWidth(containerView.frame)-10, CGRectGetHeight(containerView.bounds)-10);
    tempVC.preferredContentSize = containerView.bounds.size;
    tempVC.view.frame = tempframe;
    [containerView addSubview:tempVC.view];
    //[containerView insertSubview:tempVC.view belowSubview:self.zoomInOut];
    [self.view bringSubviewToFront:self.zoomInOut];
  
   
}
-(void)removeControllerView:(UIViewController*)tempVC
{
    if([tempVC isKindOfClass:[HUDSubViewController class]]){
        
    }
   // self.detailCell.selected = NO;
    
    [tempVC removeFromParentViewController];
    [tempVC.view removeFromSuperview];
    self.zoomInOut.alpha = 0;
    self.zoomInOut.enabled = NO;
}
-(BOOL)isLandScape
{
    return UIInterfaceOrientationIsLandscape(self.interfaceOrientation);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"CollectionView"]){
        HUDiagnoseDetailVCCollectionViewController *tempVC =(HUDiagnoseDetailVCCollectionViewController*) segue.destinationViewController;
        tempVC.delegate = self;
    }
    
    if([segue.identifier isEqualToString:@"SaveSegue"]){
       
        if(self.rightSlideViewFlag){
            
            [self performSegueWithIdentifier:@"MedicalCaseModel" sender:nil];
            
        }
        UINavigationController *NAVC = (UINavigationController*)segue.destinationViewController;
        SaveViewController *saveVC = (SaveViewController*)[[NAVC viewControllers] lastObject];
        PersonInfo *saveInfo = [[PersonInfo alloc] initPersonInfoWithPersonInfo:self.startPerson];
        saveInfo.saveNode = self.saveNode;
        saveVC.saveInfo = saveInfo;
        //saveVC.saveNode = self.saveNode;
    }
   
    if([segue.identifier isEqualToString:@"MedicalCaseModel"]){
        MedicalCaseModelVC *modelVC = (MedicalCaseModelVC*)segue.destinationViewController;
        modelVC.delegate = self;
       // self.modelVC = modelVC;
    }
}
#pragma mask - model delegate
-(void)didSelectedModelWithNode:(WLKCaseNode *)node
{
    self.rightSlideViewFlag = NO;
    [self performSegueWithIdentifier:@"MedicalCaseModel" sender:nil];
}
-(IBAction)fromSaveVCBack:(UIStoryboardSegue*)unwindSegue
{
    saveNodeDidCancel = YES;
}
-(IBAction)fromCreateRuleBack:(UIStoryboardSegue*)unwindSeue
{
    
}
@end
