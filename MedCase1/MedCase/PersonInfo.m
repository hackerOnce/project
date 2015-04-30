//
//  PersonInfo.m
//  MedicalRecord
//
//  Created by ihefe-JF on 14/12/26.
//  Copyright (c) 2014年 JFAppHourse.app. All rights reserved.
//

#import "PersonInfo.h"
#import "RawDataProcess.h"

@implementation PersonInfo

-(WLKCaseNode *)rootNode
{
    if(!_rootNode){
        WLKCaseNode *tempNode = [WLKCaseNode nodeWithDictionary:[RawDataProcess sharedRawData].dic];
        
        WLKCaseNode *nodes = [tempNode getNodeFromNodeChildArrayWithNodeName:@"住院志"];
        _rootNode = [nodes getNodeFromNodeChildArrayWithNodeName:@"入院记录（可以做到各科专科内容）"];
        
    }
    return _rootNode;
}

-(NSString *)lowAge
{
    if(!_lowAge){
        _lowAge = [NSString stringWithFormat:@"%@",@(0)];
    }
    return _lowAge;
}
-(NSString *)highAge
{
    if(!_highAge){
        _highAge = [NSString stringWithFormat:@"%@",@(13)];
    }
    return _highAge;
}
-(NSString *)gender
{
    if(!_gender){
        _gender = @"女";
    }
    return _gender;
}
-(NSString *)allergicHistory
{
    if(!_allergicHistory){
        _allergicHistory = @"不🐘";
    }
    return _allergicHistory;
}
-(NSString *)medicalTreatment
{
    if(!_medicalTreatment){
        _medicalTreatment = @"冒烟";
    }
    return _medicalTreatment;
}
-(NSString *)admissionDiagnosis
{
    if(!_admissionDiagnosis){
        _admissionDiagnosis = @"熊吗";
    }
    return _admissionDiagnosis;
}



-(instancetype)initWithGender:(NSString *)gender lowAge:(NSString *)lowAge highAge:(NSString *)highAge admissionDiagnosis:(NSString *)admissionDiagnosis medicalTreatment:(NSString *)medicalTreatment allergicHistory:(NSString *)allergicHistory
{
    if([super self]){
        self.gender = gender;
        self.lowAge = lowAge;
        self.highAge = highAge;
        self.medicalTreatment = medicalTreatment;
        self.admissionDiagnosis = admissionDiagnosis;
        self.allergicHistory = allergicHistory;
    }
    return self;
}
-(instancetype)initWithName:(NSString*)name age:(NSString*)age gender:(NSString*)gender location:(NSString*)location admissionDiagnosis:(NSString *)admissionDiagnosis medicalTreatment:(NSString *)medicalTreatment allergicHistory:(NSString *)allergicHistory
{
    self = [super self];
    
    if(self){
        
        self.name = name;
        self.age = age;
        self.gender = gender;
        self.loction = location;
        self.admissionDiagnosis = admissionDiagnosis;
        self.medicalTreatment = medicalTreatment;
        self.allergicHistory = allergicHistory;
      
        
       // NSLog(@"gender is %@,age is %@, node child nodes is : %@",self.gender,self.age,[self getScreenInformationNodeWithConditionMode:1]);
    }
    
    return self;
}

-(instancetype)initPersonInfoWithPersonInfo:(PersonInfo*)personInfo
{
    return [self initWithName:personInfo.name age:personInfo.age gender:personInfo.gender location:personInfo.loction admissionDiagnosis:personInfo.admissionDiagnosis medicalTreatment:personInfo.medicalTreatment allergicHistory:personInfo.allergicHistory];
}
//根据年龄和性别筛选 仅年龄：mode =1,仅性别:mode=2;都有mode=3;
-(NSMutableArray *)getScreenInformationNodeWithConditionMode:(NSInteger)modeIndex
{
    NSMutableArray *nodeNameArray;
    NSMutableArray *childNodesNamesArray = [NSMutableArray arrayWithArray:[self.rootNode childNodeNames]];
   // [childNodesNamesArray removeObjectAtIndex:0];
    switch (modeIndex) {
        case 1:{
            if([self.age integerValue] < 14){
                [childNodesNamesArray removeObjectsInArray:@[@"月经史",@"婚育史",@"生育史"]];
            }else if([self.age integerValue] >=14 && [self.age integerValue] <18) {
                [childNodesNamesArray removeObjectsInArray:@[@"婚育史",@"生育史"]];
            }
            nodeNameArray = [NSMutableArray arrayWithArray:childNodesNamesArray];
            break;
        }
        case 2:{
            if([self.gender isEqualToString:@"男"]){
                [childNodesNamesArray removeObjectsInArray:@[@"月经史",@"生育史"]];
                if([self.age integerValue] < 22){
                    [childNodesNamesArray removeObject:@"婚育史"];
                }
            }
            nodeNameArray = childNodesNamesArray;
            break;
        }
        case 3:{
            if([self.age integerValue] < 14){
                [childNodesNamesArray removeObjectsInArray:@[@"月经史",@"婚育史",@"生育史"]];
            }else if([self.age integerValue] >=14 && [self.age integerValue] <18) {
                [childNodesNamesArray removeObjectsInArray:@[@"婚育史",@"生育史"]];
            }
            
            if([self.gender isEqualToString:@"男"]){
                [childNodesNamesArray removeObjectsInArray:@[@"月经史",@"生育史"]];
                if([self.age integerValue] < 22){
                    [childNodesNamesArray removeObject:@"婚育史"];
                }
            }
            nodeNameArray = childNodesNamesArray;
        }
        default:
            break;
    }
    return nodeNameArray;
}
//筛选个人史和产科检查 仅个人史：mode =2,仅产科检查:mode=3;都有mode=1;
-(NSMutableArray *)getScreenInformationNodeFromSunNodeNames:(NSMutableArray*)nodeNames withConditionMode:(NSInteger)modeIndex
{
    NSMutableArray *nodeNameArray;
    NSMutableArray *childNodesNamesArray = [NSMutableArray arrayWithArray:nodeNames];
   [childNodesNamesArray removeObjectAtIndex:0];
    switch (modeIndex) {
        case 1:{
            if([self.age integerValue] < 18){
                [childNodesNamesArray removeObject:@"成人个人史"];
            }
            if([self.age integerValue] >=14){
                [childNodesNamesArray removeObject:@"儿科个人史"];
            }
            
            if([self.gender isEqualToString:@"男"] ){
                [childNodesNamesArray removeObjectsInArray:@[@"产科",@"妇科"]];
                
            }else {
                if([self.age integerValue] < 18){
                    [childNodesNamesArray removeObject:@"产科"];
                    
                    if([self.age integerValue] < 14){
                        [childNodesNamesArray removeObject:@"妇科"];
                    }
                }
            }
            if([self.age integerValue] >=18){
                [childNodesNamesArray removeObject:@"儿科"];
            }

            break;
        }
        case 2:{
            if([self.age integerValue] < 18){
                [childNodesNamesArray removeObject:@"成人个人史"];
            }
            if([self.age integerValue] >= 14){
                [childNodesNamesArray removeObject:@"儿科个人史"];
            }
            break;
        }
        case 3:{
            if([self.gender isEqualToString:@"男"] ){
                [childNodesNamesArray removeObjectsInArray:@[@"产科",@"妇科"]];
              
            }else {
                if([self.age integerValue] < 18){
                    [childNodesNamesArray removeObject:@"产科"];
                    
                    if([self.age integerValue] < 14){
                        [childNodesNamesArray removeObject:@"妇科"];
                    }
                }
            }
            if([self.age integerValue] >=18){
                [childNodesNamesArray removeObject:@"儿科"];
            }
            
          break;
        }
        default:
            break;
    }
    return nodeNameArray;
}
//-(NSMutableDictionary *)diagnosisDictionary
//{
//    if(!_diagnosisDictionary){
//        
//        _diagnosisDictionary = [NSMutableDictionary di]
//    }
//    return _diagnosisDictionary;
//}
@end
