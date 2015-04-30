//
//  ModelNameVC.m
//  MedCase
//
//  Created by ihefe-JF on 15/2/28.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import "ModelNameVC.h"
#import "PersonInfo.h"

@interface ModelNameVC ()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate,UISearchControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *modelTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong) UISearchDisplayController *strongSearchDisplayController;
@property (nonatomic,strong) NSMutableArray *filterArray;

@property (strong,nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic,strong) NSMutableArray *tableData;

@property (nonatomic) BOOL loadMoreFlag;
@property (nonatomic) BOOL searchBarEnable;

@property (nonatomic) NSInteger operationStatus;

@property (nonatomic,strong) NSIndexPath *deleteIndexPath;
@end

@implementation ModelNameVC
/*
-(NSMutableArray *)modelsArray
{
    if(!_modelsArray){
        _modelsArray = [[NSMutableArray alloc] init];
//        [_modelsArray addObject:@"男性      40-50      肺结核  咳嗽  胸痛  胸部诊断疼痛  湿罗音      2014.1.5  张医生"];
//        [_modelsArray addObject:@"男性      12-23      肺结核  咳嗽  胸痛  胸部诊断疼痛  湿罗音      2015.1.5  孙医生"];
//        [_modelsArray addObject:@"男性      13-60      肺结核  咳嗽  胸痛  胸部诊断疼痛  湿罗音      2016.1.5  宏医生"];
//        [_modelsArray addObject:@"男性      46-50      肺结核  咳嗽  胸痛  胸部诊断疼痛  湿罗音      2017.1.5  行医生"];
//        [_modelsArray addObject:@"男性      20-50      肺结核  咳嗽  胸痛  胸部诊断疼痛  湿罗音      2018.1.5  下医生"];
    }
    return _modelsArray;
}
*/
- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadMoreFlag = NO;
    // Do any additional setup after loading the view.
    self.modelsArray = [[NSMutableArray alloc] init];
    //hide status bar
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    [self setSearchDisplayController];
    [self setTableView];
    [self setSearchBarBackground];
    //[self setUpSocket];
    [self setUpRefreshControl];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];

    self.loadMoreFlag = NO;
    [self.refreshControl beginRefreshing];
    [self.modelTableView setContentOffset:CGPointMake(0, 44) animated:YES];
    [self setUpSocket];

    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:120.0];
}


#pragma mask - set search display controller
-(void)setSearchDisplayController
{
    self.strongSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.strongSearchDisplayController.searchResultsDataSource = self;
    self.strongSearchDisplayController.searchResultsDelegate = self;
    self.strongSearchDisplayController.delegate = self;
    
    [self.strongSearchDisplayController.searchResultsTableView setTableFooterView:[[UIView alloc] init]];
    [self.strongSearchDisplayController.searchResultsTableView setBackgroundColor:[UIColor whiteColor]];
    self.searchBar.autoresizingMask = UIViewAutoresizingNone;
}

-(void)setUpRefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"正在更新数据,请稍候"];
    [self.refreshControl addTarget:self action:@selector(handData) forControlEvents:UIControlEventValueChanged];
    
    [self.modelTableView addSubview:self.refreshControl];
}
-(void)handData
{
    self.loadMoreFlag = NO;
    [self setUpSocket];
}
#pragma mask - socket
-(void)setUpSocket
{
    self.socket = [[IHGCDSocket alloc] init];
    self.socket.hostName = Server_IP;
    self.socket.hostPort = Server_Port;
    [self.socket setDelegate:self];
    [self.socket connectToHost:Server_IP onPort:Server_Port];
}
-(void)ihSocket:(IHGCDSocket *)ihGcdSock didReceive:(NSData *)data
{
  //  self.modelsArray = nil;
    NSData *zipData = [[NSData alloc] initWithBase64EncodedData:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *string = [[NSString alloc] initWithData:[zipData uncompress] encoding:NSUTF8StringEncoding];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    id receiveData = [parser objectWithString:string];
    
    switch (self.operationStatus) {
        case 0: {
            [self receiveDataFrom1999:receiveData];
            break;
        }
        case 1:{
            [self receiveDataFrom2001:receiveData];
            break;
        }
        case 2:{
            [self receiveSearchDataFrom1999:receiveData];
            break;
        }
        default:
            break;
    }
   
    
}
-(void)receiveDataFrom2001:(id)receiveData
{
    
    NSInteger sucessflag = (NSInteger)receiveData[@"sync_resp"];
    if(sucessflag == 0){
        
    }else {
        
    }
    
}
-(void)receiveSearchDataFrom1999:(id)receiveData
{
    if([receiveData isKindOfClass:[NSDictionary class]]){
        id guessArray =receiveData[@"sync_data"];
        if([guessArray isKindOfClass:[NSArray class]]){
            NSArray *array = (NSArray*)guessArray;
            
            for (NSDictionary *aDic in array) {
                PersonInfo *personInfo = [[PersonInfo alloc] init];
                personInfo.receiveNode = [WLKCaseNode nodeWithDictionary:aDic];
                personInfo.patientString = aDic[@"patientString"];
                personInfo.ModelID = aDic[@"_id"];
               
                [self.filterArray addObject:personInfo];
                
            }
            //[self endRefreshControl];
            [self.strongSearchDisplayController.searchResultsTableView reloadData];
        }
    }
}
-(void)receiveDataFrom1999:(id)receiveData
{
    if([receiveData isKindOfClass:[NSDictionary class]]){
        id guessArray =receiveData[@"sync_data"];
        if([guessArray isKindOfClass:[NSArray class]]){
            NSArray *array = (NSArray*)guessArray;
            
            for (NSDictionary *aDic in array) {
                PersonInfo *personInfo = [[PersonInfo alloc] init];
                personInfo.receiveNode = [WLKCaseNode nodeWithDictionary:aDic];
                personInfo.patientString = aDic[@"patientString"];
                personInfo.ModelID = aDic[@"_id"];
                if(!self.loadMoreFlag){
                    [self.modelsArray addObject:personInfo];
                }
            }
            [self endRefreshControl];
            [self reloadTableView];
        }
    }
}
-(void)reloadTableView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.modelTableView reloadData];
    });
}
-(void)endRefreshControl
{
    self.searchBarEnable = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
    });
}
-(void)connectServerSucceed:(IHGCDSocket *)ihGcdSock
{
    self.operationStatus = 0;
    [self loadModelFromServer:1 searchString:@""];
}
-(void)deleteModelWithID:(id)IDArray
{
    MessageObject *obj = [[MessageObject alloc] init];
    NSMutableDictionary *aDic = [[NSMutableDictionary alloc] init];
    [aDic setObject:IDArray forKey:@"_id"];
    obj.sync_usrStr = @"1";
    obj.sync_pwdStr = @"test";
    // obj.sync_data = @{@"Data":@"DATA"};
    obj.sync_data = aDic;
    obj.sync_optInt = 2001;
    obj.sync_snStr = @"1234";
    obj.sync_appStr = @"com.ihefe.health.notebook";
    obj.sync_versionInt = 1;
    
    self.operationStatus = 1;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj.jsonDic options:NSJSONWritingPrettyPrinted error:nil];
    NSData *data = [[jsonData compress] base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [self.socket sendDataToServer:data];

}
-(void)loadModelFromServer:(NSInteger)pageNumber searchString:(NSString*)searchString
{
    MessageObject *obj = [[MessageObject alloc] init];
    
    NSMutableDictionary *selector = [[NSMutableDictionary alloc] init];
    //[selector setObject:@"头疼" forKey:@"noteContent"];
    [selector setObject:@(pageNumber) forKey:@"skip"];
    [selector setObject:searchString forKey:@"selector"];
    obj.sync_usrStr = @"1";
    obj.sync_pwdStr = @"test";
    // obj.sync_data = @{@"Data":@"DATA"};
    obj.sync_data = selector;
    obj.sync_optInt = 1999;
    obj.sync_snStr = @"1234";
    obj.sync_appStr = @"com.ihefe.health.notebook";
    obj.sync_versionInt = 1;
    
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj.jsonDic options:NSJSONWritingPrettyPrinted error:nil];
    NSData *data = [[jsonData compress] base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [self.socket sendDataToServer:data];
    
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:60.0];
}
#pragma mask - deleay method
-(void)delayMethod
{
    self.searchBarEnable = YES;
    NSLog(@"服务器无返回值或返回时间超过了30秒");
    if(self.refreshControl.isRefreshing){
        [self.refreshControl endRefreshing];
    }
}
//连接失败调用
- (void)connectServerDefeat:(IHGCDSocket *)ihGcdSock error:(NSError *)error
{
    [self.refreshControl endRefreshing];
    WLKLog(@"%@", error);
}
//发送成功
- (void)ihSocket:(IHGCDSocket *)ihGcdSock  total:(long )total
{
    WLKLog(@"发送成功");
}

- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock
{
    WLKLog(@"");
}
//与服务器断开
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)error
{
    WLKLog(@"%@", error);
}
//在socket成功完成ssl/tls协商时调用
- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
    [self.refreshControl endRefreshing];
    WLKLog(@"");
}
//当产生一个socket去处理连接时调用
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    WLKLog(@"");
}
//  当一个socket写入一些数据，但还没有完成整个写入时调用，它可以用来更新进度条等东西
- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    WLKLog(@"");
}
// 当一个socket读取数据，但尚未完成读操作的时候调用，如果使用 readToData: or readToLength: 方法 会发生,可以被用来更新进度条等东西
- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    WLKLog(@"");
}


#pragma mask - set search bar
-(void)setSearchBarBackground
{
    self.searchBar.backgroundColor = [UIColor clearColor];
    
    UIView *searchBarView = [self.searchBar.subviews objectAtIndex:0];
    for (UIView *searchBarSubView in searchBarView.subviews) {
        if([searchBarSubView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]){
         
            [searchBarSubView removeFromSuperview];
            break;
        }
        if([searchBarSubView isKindOfClass:NSClassFromString(@"UISearchBarTextField")]){
          //  searchBarSubView.backgroundColor = [UIColor colorWithRed:234.0/255 green:234.0/255 blue:234.0/255 alpha:1];
            searchBarSubView.backgroundColor = [UIColor clearColor];
        }
    }
}
#pragma mask - set table view
-(void)setTableView
{
    self.modelTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
#pragma mask - table view delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.modelTableView){
        return self.modelsArray.count;
    }else {
        return self.filterArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.modelTableView){
        NSString * const cellIdentifier = @"ModelManagementCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        PersonInfo *personInfo = [self.modelsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = personInfo.patientString;
       
        return  cell;
    }else {
        NSString * const resultID = @"resultCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resultID];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resultID];
        }
     
        PersonInfo *personInfo = [self.filterArray objectAtIndex:indexPath.row];
        cell.textLabel.text = personInfo.patientString;
        
        return cell;
    }
}

//table view 删除
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.modelTableView){
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
    if(editingStyle == UITableViewCellEditingStyleDelete){
        self.deleteIndexPath = indexPath;
        PersonInfo *personInfo = [self.modelsArray objectAtIndex:indexPath.row];
        [self deleteModelWithID:personInfo.ModelID];
        
        [self.modelsArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    if(editingStyle == UITableViewCellEditingStyleInsert){
        
    }
}
//tableview selected row
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.modelTableView){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
//table view load more data
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // cell.selectionStyle = UITableViewCellSelectionStyleNone;

//    NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
//    NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex];
//    
//    NSInteger pageNumber = self.modelsArray.count / 2;
//    if(pageNumber == 0){
//        pageNumber = 1;
//    }
//    if(self.modelsArray.count >= 8  &&lastSectionIndex == indexPath.section && lastRowIndex - 1 == indexPath.row){
//        self.loadMoreFlag = YES;
//        [self loadModelFromServer:pageNumber];
//    }
}

#pragma mask - search bar
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.filterArray = [[NSMutableArray alloc] init];
    return self.searchBarEnable;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.filterArray removeAllObjects];
    self.filterArray = nil;
}

#pragma mask - searchDisplayController delegate and other methods
-(void)filiterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.filterArray removeAllObjects];
    
    self.operationStatus = 2;
    [self loadModelFromServer:1 searchString:searchText];
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.patientString contains[c] %@",searchText];
   // self.filterArray = [NSMutableArray arrayWithArray:[self.modelsArray filteredArrayUsingPredicate:predicate]];
#warning 查询
    
}

// delegate
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
   // self.viewForSearchBar.alpha = 1;
    
    if([searchString isEqualToString:@""]){
        //self.viewForSearchBar.alpha = 1;
    }
    [self filiterContentForSearchText:searchString scope:[[self.searchBar scopeButtonTitles] objectAtIndex:[self.searchBar selectedScopeButtonIndex]]];
    return YES;
}
-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
  //  self.viewForSearchBar.alpha = 1;
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
   // self.viewForSearchBar.alpha = 0;
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
