//
//  PersonInfo.h
//  MedicalRecord
//
//  Created by ihefe-JF on 14/12/26.
//  Copyright (c) 2014年 JFAppHourse.app. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLKCaseNode.h"

@interface PersonInfo : NSObject

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *age;
@property(nonatomic,strong) NSString *loction;
@property(nonatomic,strong) NSString *gender;

@property(nonatomic,strong) NSString *admissionDiagnosis;
@property(nonatomic,strong) NSString *allergicHistory;
@property(nonatomic,strong) NSString *medicalTreatment;

@property(nonatomic) NSString *lowAge;
@property(nonatomic) NSString *highAge;

@property(nonatomic,strong) NSString *ID;
@property(nonatomic,strong) WLKCaseNode *rootNode;
@property(nonatomic,strong) WLKCaseNode *saveNode;

@property(nonatomic,strong) id ModelID;
@property(nonatomic,strong) NSString *patientString;
@property(nonatomic,strong) WLKCaseNode *receiveNode;
//筛选个人史和产科检查 仅个人史：mode =2,仅产科检查:mode=3;都有mode=1;
-(NSMutableArray *)getScreenInformationNodeFromSunNodeNames:(NSMutableArray*)nodeNames withConditionMode:(NSInteger)modeIndex;
//根据年龄和性别筛选 仅年龄：mode =1,仅性别:mode=2;都有mode=3;
-(NSMutableArray *)getScreenInformationNodeWithConditionMode:(NSInteger)modeIndex;

//for model
-(instancetype)initWithGender:(NSString *)gender lowAge:(NSString *)lowAge highAge:(NSString *)highAge admissionDiagnosis:(NSString *)admissionDiagnosis medicalTreatment:(NSString *)medicalTreatment allergicHistory:(NSString *)allergicHistory;

-(instancetype)initWithName:(NSString*)name age:(NSString*)age gender:(NSString*)gender location:(NSString*)location admissionDiagnosis:(NSString*)admissionDiagnosis medicalTreatment:(NSString*)medicalTreatment allergicHistory:(NSString*)allergicHistory;

-(instancetype)initPersonInfoWithPersonInfo:(PersonInfo*)personInfo;

@end
