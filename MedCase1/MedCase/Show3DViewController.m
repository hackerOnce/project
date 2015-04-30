//
//  Show3DViewController.m
//  MedCase
//
//  Created by ihefe-JF on 15/1/15.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import "Show3DViewController.h"
#import "KeyValueObserver.h"
#import "Show3DCollectionViewCell.h"
#import "KeyValueObserver.h"

@interface Show3DViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *shou3DView;
@property (weak, nonatomic) IBOutlet UICollectionView *showSeletedComponentsCollectionView;


@property (strong,nonatomic) WLKCaseNode *selectedNode;
@property (nonatomic,strong) NSArray *subNodesArray;

@property (nonatomic,strong) id show3DObserverToken;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *HSConstraint;

@end

@implementation Show3DViewController
- (IBAction)testButton:(UIButton *)sender
{
    self.selectedNode = self.show3DNode.childNodes[arc4random()%7];
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if([self.zoomInoutID isEqualToString:@"ClickedZoomInOut"]){
        self.HSConstraint.constant = 200;
    }else {
         self.HSConstraint.constant = 300;
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor  = [UIColor whiteColor];
    self.showSeletedComponentsCollectionView.layer.borderColor = [UIColor greenColor].CGColor;
    self.showSeletedComponentsCollectionView.layer.borderWidth = 1;
}
-(NSArray *)subNodesArray
{
    if(!_subNodesArray){
        _subNodesArray = [[NSArray alloc] init];
    }
    return _subNodesArray;
}

-(void)setSelectedNode:(WLKCaseNode *)selectedNode
{
    _selectedNode = selectedNode;
    self.show3DObserverToken = [KeyValueObserver observeObject:self.selectedNode keyPath:@"selectedNode" target:self selector:@selector(show3DNodeDidChange:) options:NSKeyValueObservingOptionInitial];
    
}

-(void)show3DNodeDidChange:(NSDictionary*)change
{
    self.subNodesArray = [WLKCaseNode getAllSubNodesFromParentNode:self.selectedNode];
    [self.showSeletedComponentsCollectionView reloadData];
}
#pragma mask - UICollection view delegate

#pragma mask - UIcollection view data source
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.subNodesArray.count + 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Show3DCollectionViewCell *reuseCell =(Show3DCollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];

    if(indexPath.row < self.subNodesArray.count){
        WLKCaseNode *tempNode = (WLKCaseNode*)(self.subNodesArray[indexPath.row]);
        reuseCell.show3DNode = tempNode;
        reuseCell.show3DCellLabel.text = tempNode.nodeName;
    }else {
        reuseCell.show3DCellLabel.text = @"添加";
    }
    
    return reuseCell;
}

#pragma mask - UIcollection view flowlayout

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
