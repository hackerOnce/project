//
//  SaveViewController.m
//  MedCase
//
//  Created by ihefe-JF on 15/1/23.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import "SaveViewController.h"
#import "RawDataProcess.h"
#import "PersonInfo.h"

@interface SaveViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) CoreDataManager *saveCoreDataManager;
@property (nonatomic,strong) WLKCaseNode *saveNode;

@property (nonatomic,strong) NSString *patientString;
@end

@implementation SaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(WLKCaseNode *)saveNode
{
    if(!_saveNode){
        _saveNode = self.saveInfo.saveNode;
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        
        self.patientString = [NSString stringWithFormat:@"%@      %@-%@      %@  %@  %@      %@  张医生",self.saveInfo.gender,self.saveInfo.lowAge,self.saveInfo.highAge,self.saveInfo.admissionDiagnosis,self.saveInfo.allergicHistory,self.saveInfo.medicalTreatment,[formatter stringFromDate:date]];
    }
    return _saveNode;
}
-(CoreDataManager *)saveCoreDataManager
{
    if(!_saveCoreDataManager){
        _saveCoreDataManager = [[RawDataProcess sharedRawData] coreDataManager];
    }
    return _saveCoreDataManager;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

   return  self.saveNode.childNodes.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SaveCell"];
    
    WLKCaseNode *tempNode = [self.saveNode.childNodes objectAtIndex:indexPath.row];
    
    UILabel *cellLabel =(UILabel*) [cell viewWithTag:1001];
    UITextView *cellTextView = (UITextView*)[cell viewWithTag:1002];
    
    cellLabel.text = tempNode.nodeName;
    cellTextView.text = [tempNode selectedChildNodeContents];
    
    return cell;
}
-(void)dealloc
{
    self.saveNode = nil;
    self.saveInfo = nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (IBAction)saveCase:(UIBarButtonItem *)sender {
//    
//    
//}

- (IBAction)saveCase:(UIButton *)sender {
    
//    NSString *tempString = [self.saveNode jsonString];
//    NSDictionary *div = @{@"personInfo":self.saveInfo,@"caseContent":tempString};
//    [self.saveCoreDataManager insertNewObjectForEntityName:[Person personEntityName] withDictionary:div];
//    NSString *nodeString = [self.saveNode jsonString];
  //[[NSUserDefaults standardUserDefaults] setObject:nodeString forKey:@"saveNodeString"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.saveNode dictionaryForJson]];
    NSString *path = [NSString stringWithFormat:@"%@json.txt", NSTemporaryDirectory()];
    
//    NSMutableDictionary *finalDic = [NSMutableDictionary dictionary];
//    for (NSDictionary *dic in dic[@"trueRoot"]) {
//        for (NSString *d in dic.allKeys) {
//            fin
//        }
//    }
    
    NSData *jData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jData encoding:NSUTF8StringEncoding];
    //    NSDictionary *dica = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONWritingPrettyPrinted error:nil];
    
    NSLog(@"path = %@", path);
    [jsonStr writeToFile:[NSString stringWithFormat:@"%@json.txt", NSTemporaryDirectory()] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    return;
    
    self.socket = [[IHGCDSocket alloc] init];
    self.socket.hostName = Server_IP;
    self.socket.hostPort = Server_Port;
    [self.socket setDelegate:self];
    [self.socket connectToHost:Server_IP onPort:Server_Port];
}
//-(PersonInfo*)productPersonInfoWithPersonInfo    PersonInfo*)info{
//    PersonInfo *tempInfo = [[PersonInfo alloc] initWithName:info.name age:info.age gender:info.gender location:info.loction admissionDiagnosis:info.admissionDiagnosis medicalTreatment:info.medicalTreatment allergicHistory:info.allergicHistory];
//    tempInfo.rootNode = self.saveNode;
//    return tempInfo;
//}
//接收数据
- (void)ihSocket:(IHGCDSocket *)ihGcdSock didReceive:(NSData *)data
{
    NSData *zipData = [[NSData alloc] initWithBase64EncodedData:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *string = [[NSString alloc] initWithData:[zipData uncompress] encoding:NSUTF8StringEncoding];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *dataDic = [parser objectWithString:string];
//    NSDictionary *syncData = [dataDic objectForKey:@"sync_data"];
//    self.saveInfo.ModelID = [syncData objectForKey:@"_id"];
    WLKLog(@"收到数据：%@", dataDic);
}

//连接服务器成功
- (void)connectServerSucceed:(IHGCDSocket *)ihGcdSock
{
    WLKLog(@"");
   // NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    MessageObject *obj = [[MessageObject alloc] init];
    obj.sync_usrStr = @"1";
    obj.sync_pwdStr = @"test";
   // obj.sync_data = @{@"Data":@"DATA"};
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.saveNode dictionaryForJson]];
    NSString *path = [NSString stringWithFormat:@"%@json.txt", NSTemporaryDirectory()];
    
    NSData *jData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jData encoding:NSUTF8StringEncoding];
//    NSDictionary *dica = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONWritingPrettyPrinted error:nil];
    
    NSLog(@"path = %@", path);
    [jsonStr writeToFile:[NSString stringWithFormat:@"%@json.txt", NSTemporaryDirectory()] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    //[dic setObject:[self.saveNode dictionaryForJson] forKey:@"modelData"];
    [dic setObject:self.patientString forKey:@"patientString"];
    [dic setObject:@(0) forKey:@"deleteFlag"];
//    [dic setObject:self.saveInfo.gender forKey:@"gender"];
//    [dic setObject:self.saveInfo.lowAge forKey:@"lowAge"];
//    [dic setObject:self.saveInfo.highAge forKey:@"highAge"];
//    [dic setObject:self.saveInfo.admissionDiagnosis forKey:@"admissionDiagnosis"];
//    [dic setObject:self.saveInfo.allergicHistory forKey:@"allergicHistory"];
//    [dic setObject:self.saveInfo.medicalTreatment forKey:@"medicalTreatment"];
    
    obj.sync_data = dic;
    obj.sync_optInt = 2000;
    obj.sync_snStr = @"sync_sn";
    obj.sync_appStr = @"com.ihefe.health.a";
    obj.sync_versionInt = 1;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj.jsonDic options:NSJSONWritingPrettyPrinted error:nil];
    NSData *data = [[jsonData compress] base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [self.socket sendDataToServer:data];
    
    self.saveNode = nil;
}
//连接失败调用
- (void)connectServerDefeat:(IHGCDSocket *)ihGcdSock error:(NSError *)error
{
    self.saveNode = nil;
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

@end
