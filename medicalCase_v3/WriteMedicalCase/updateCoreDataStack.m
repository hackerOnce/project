//
//  updateCoreDataStack.m
//  WriteMedicalCase
//
//  Created by GK on 15/5/1.
//  Copyright (c) 2015年 GK. All rights reserved.
//

#import "updateCoreDataStack.h"


@implementation updateCoreDataStack

///create patient NSmanagedObject
-(void)createPatientManagedObjectWithDataDic:(NSMutableDictionary*)dataDic failedToCreated:(void (^)(NSError *error,NSString * errorInfo))failure successfulCreated:(void (^)())successfully
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName: [Patient entityName]inManagedObjectContext:self.managedObjectContext];
    Patient *patient = [[Patient alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:self.managedObjectContext];
    
    [self updatePatient:patient WithDictionary:dataDic];
    
    [self saveContextFailToSave:^(NSError *error, NSString *errorInfo) {
        failure(error,errorInfo);
    } successfulCreated:^{
        successfully();
    }];
}
///update patient info
-(void)updatePatientInContext:(NSManagedObjectContext*)context ManagedObjectWithDataDic:(NSMutableDictionary*)dataDic successfulUpdated:(void (^)())successfully failedToUpdated:(void (^)(NSError *error,NSString * errorInfo))failure
{
    NSPredicate *predicate;

    NSString *pID,*pName;
    
        if([dataDic.allKeys containsObject:@"pID"]){
            pID = dataDic[@"pID"];
        }
        if([dataDic.allKeys containsObject:@"pName"]){
            pName = dataDic[@"pName"];
        }
        if (pID != nil && pName!=nil) {
            predicate = [NSPredicate predicateWithFormat:@"pName = %@,pID = %@",pName,pID];
        }else {
            abort();
        }
        if(pName == nil){
            predicate = [NSPredicate predicateWithFormat:@"pID = %@",pID];
        }
        if (pID == nil) {
            predicate = [NSPredicate predicateWithFormat:@"pName = %@",pName];
        }

    [self fetchManagedObjectInContext:context WithEntityName:[Patient entityName] withPredicate:predicate successfulFetched:^(NSArray *resultArray) {
        
        if (resultArray.count == 1) {
            if ([[resultArray firstObject] isMemberOfClass:[Patient class]]) {
                Patient *patient = (Patient*)[resultArray firstObject];
                
                [self updatePatient:patient WithDictionary:dataDic];
                
                [self saveContextFailToSave:^(NSError *error, NSString *errorInfo) {
                    failure(error,errorInfo);
                } successfulCreated:^{
                    successfully();
                }];
            }
        }else {
            NSLog(@"存在多个医生对应相同的名字或ID 或着不存在该医生");
        }
        
    } failedToFetched:^(NSError *error, NSString *errorInfo) {
        failure(error,errorInfo);
    }];
    
    
}




///create template nsmanagedObject required : content, dId,dName
-(void)createTemplateManagedObjectWithDataDic:(NSMutableDictionary*)dic  successfulCreated:(void (^)())successfully failedToCreated:(void (^)(NSError *error,NSString * errorInfo))failure
{
    NSEntityDescription *templateDesc = [NSEntityDescription entityForName: [Template entityName]inManagedObjectContext:self.managedObjectContext];
    Template *template = [[Template alloc] initWithEntity:templateDesc insertIntoManagedObjectContext:self.managedObjectContext];
    
    if ([dic.allKeys containsObject:@"condition"]) {
        template.condition = dic[@"condition"];
    }
    if ([dic.allKeys containsObject:@"content"] && !([dic[@"content"] isEqualToString:@""])) {
        template.content = dic[@"content"];
    }else {
        [self showAlertViewWithTitle:@"创建模板必须有内容"];
        failure(nil,@"创建模板必须有内容");
        abort();
    }
    if ([dic.allKeys containsObject:@"gender"]) {
        template.gender = dic[@"gender"];
    }
    if ([dic.allKeys containsObject:@"ageHigh"]) {
        template.ageHigh = dic[@"ageHigh"];
    }
    if ([dic.allKeys containsObject:@"admittingDiagnosis"]) {
        template.admittingDiagnosis = dic[@"admittingDiagnosis"];
    }
    if ([dic.allKeys containsObject:@"simultaneousPhenomenon"]) {
        template.simultaneousPhenomenon  = dic[@"simultaneousPhenomenon"];
    }
    if ([dic.allKeys containsObject:@"ageLow"]) {
        template.ageLow = dic[@"ageLow"];
    }
    if ([dic.allKeys containsObject:@"cardinalSymptom"]) {
        template.cardinalSymptom = dic[@"cardinalSymptom"];
    }
    
    if ([dic.allKeys containsObject:@"nodeID"]) {
        template.nodeID = dic[@"nodeID"];
    }
    if ([dic.allKeys containsObject:@"updatedTime"]) {
        template.nodeID = dic[@"updatedTime"];
    }
    if ([dic.allKeys containsObject:@"section"]) {
        template.section = dic[@"section"];
    }
    if ([dic.allKeys containsObject:@"dName"] && ![dic[@"dName"] isEqualToString:@""]) {
        template.nodeID = dic[@"dName"];
    }else{
        [self showAlertViewWithTitle:@"创建模板必须包含医生姓名"];
        failure(nil,@"创建模板必须包含医生姓名");

        //abort();
    }
    if ([dic.allKeys containsObject:@"dID"] && (![dic[@"dID"] isEqualToString:@""])) {
        template.section = dic[@"dID"];
    }else {
        [self showAlertViewWithTitle:@"创建模板必须包含医生ID"];
        failure(nil,@"创建模板必须包含医生ID");

       // abort();
    }
    [self saveContextFailToSave:^(NSError *error, NSString *errorInfo) {
        failure(error,errorInfo);
    } successfulCreated:^{
        successfully();
    }];
}
-(void)updateTemplateInContext:(NSManagedObjectContext*)context ManagedObjectWithDataDic:(NSMutableDictionary*)dic  successfulCreated:(void (^)())successfully failedToCreated:(void (^)(NSError *error,NSString * errorInfo))failure
{
    NSPredicate *predicate;
    NSString *templateID;
    
    if ([dic.allKeys containsObject:@"templateID"]) {
        templateID = dic[@"templateID"];
        
        if ([templateID isEqualToString:@""]) {
            abort();
        }
        predicate = [NSPredicate predicateWithFormat:@"templateID = %@",templateID];
        
        [self fetchManagedObjectInContext:context WithEntityName:[Template entityName] withPredicate:predicate successfulFetched:^(NSArray *resultArray) {
            
            if (resultArray.count == 1) {
                if ([[resultArray firstObject] isMemberOfClass:[Template class]]) {
                    Template *template = (Template*)[resultArray firstObject];
                    if ([dic.allKeys containsObject:@"content"]) {
                        NSString *content = dic[@"content"];
                        
                        template.content = content;
                        
                        [self saveContextFailToSave:^(NSError *error, NSString *errorInfo) {
                            failure(error,errorInfo);
                        } successfulCreated:^{
                            successfully();
                        }];
                    }
                }
            }
        } failedToFetched:^(NSError *error, NSString *errorInfo) {
            failure(error,errorInfo);
        }];
    }else {
        abort();
    }
    
    
}
///create medical case managedObject
-(void)createMedicalCaseManagedObjectWithDataDic:(NSMutableDictionary*)dataDic failedToCreated:(void (^)(NSError *error,NSString * errorInfo))failure successfulCreated:(void (^)())successfully
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName: [RecordBaseInfo entityName]inManagedObjectContext:self.managedObjectContext];
    RecordBaseInfo *recordBaseInfo = [[RecordBaseInfo alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:self.managedObjectContext];
    
    if ([dataDic.allKeys containsObject:@"caseType"]) {
        recordBaseInfo.caseType = [dataDic objectForKey:@"caseType"];
    }
    if ([dataDic.allKeys containsObject:@"caseState"]) {
        recordBaseInfo.caseState = [dataDic objectForKey:@"caseState"];
    }

    
    if ([dataDic.allKeys containsObject:@"caseContent"]) {
        recordBaseInfo.caseType = [dataDic objectForKey:@"caseContent"];
    }
        if ([dataDic.allKeys containsObject:@"archivedTime"]) {
        recordBaseInfo.caseState = [dataDic objectForKey:@"archivedTime"];
    }

    if ([dataDic.allKeys containsObject:@"casePresenter"]) {
        recordBaseInfo.caseType = [dataDic objectForKey:@"casePresenter"];
    }
    if ([dataDic.allKeys containsObject:@"createdTime"]) {
        recordBaseInfo.caseState = [dataDic objectForKey:@"createdTime"];
    }
    
    if ([dataDic.allKeys containsObject:@"isCompleted"]) {
        recordBaseInfo.caseType = [dataDic objectForKey:@"isCompleted"];
    }
    if ([dataDic.allKeys containsObject:@"lastModifyTime"]) {
        recordBaseInfo.caseState = [dataDic objectForKey:@"lastModifyTime"];
    }
    
    if ([dataDic.allKeys containsObject:@"dID"]) {
        recordBaseInfo.caseType = [dataDic objectForKey:@"dID"];
    }else{
        [self showAlertViewWithTitle:@"创建病例必须要有医生ID"];
        failure(nil,@"创建病例必须要有医生ID");
    }

    if ([dataDic.allKeys containsObject:@"dName"]) {
        recordBaseInfo.caseState = [dataDic objectForKey:@"dName"];
    }else{
        [self showAlertViewWithTitle:@"创建病例必须要有医生姓名"];
        failure(nil,@"创建病例必须要有医生姓名");
    }
    
    if ([dataDic.allKeys containsObject:@"pID"]) {
        recordBaseInfo.caseType = [dataDic objectForKey:@"pID"];
    }else {
        [self showAlertViewWithTitle:@"创建病例必须要有病人ID"];
        failure(nil,@"创建病例必须要有病人ID");
    }
    if ([dataDic.allKeys containsObject:@"pName"]) {
        recordBaseInfo.caseState = [dataDic objectForKey:@"pName"];
    }else {
        [self showAlertViewWithTitle:@"创建病例必须要有病姓名"];
        failure(nil,@"创建病例必须要有病人姓名");

    }
    [self saveContextFailToSave:^(NSError *error, NSString *errorInfo) {
        failure(error,errorInfo);
    } successfulCreated:^{
        successfully();
    }];
}
-(void)updateMedicalCaseInContext:(NSManagedObjectContext*)context ManagedObjectWithDataDic:(NSMutableDictionary*)dataDic failedToUpdated:(void (^)(NSError *error,NSString * errorInfo))failure successfulUpdated:(void (^)())successfully
{
    NSPredicate *predicate;
    
    NSString *pID,*pName,*dID,*dName;
    if ([dataDic.allKeys containsObject:@"pID"]) {
        pID = dataDic[@"pID"];
    }
    if ([dataDic.allKeys containsObject:@"pName"]) {
        pName = dataDic[@"pName"];
    }

    if ([dataDic.allKeys containsObject:@"dID"]) {
        dID = dataDic[@"dID"];
    }
    if ([dataDic.allKeys containsObject:@"dName"]) {
        dName = dataDic[@"dName"];
    }
    if (dID == nil && dName == nil) {
        abort();
    }
    if (pID == nil && pName == nil) {
        abort();
    }
    
    if (dID != nil && dName != nil && pID != nil && pName != nil) {
        predicate = [NSPredicate predicateWithFormat:@"dName = %@,dID = %@,pName = %@,pID = %@",dName,dID,pName,pID];
    }
    
    if (dID != nil && pID != nil) {
        predicate = [NSPredicate predicateWithFormat:@"dID = %@,pID = %@",dID,pID];
    }
    
    if (dName != nil && pName != nil) {
        predicate = [NSPredicate predicateWithFormat:@"dName = %@,pName = %@",dName,pName];
    }
    
    [self fetchManagedObjectInContext:context WithEntityName:[RecordBaseInfo entityName] withPredicate:predicate successfulFetched:^(NSArray *resultArray) {
        
        if (resultArray.count == 1) {
            if ([[resultArray firstObject] isMemberOfClass:[RecordBaseInfo class]]) {
                
                RecordBaseInfo *recordBaseInfo = (RecordBaseInfo*)[resultArray firstObject];
                [self updateCaseInfo:recordBaseInfo withDic:dataDic];
                
                [self saveContextFailToSave:^(NSError *error, NSString *errorInfo) {
                    failure(error,errorInfo);
                } successfulCreated:^{
                    successfully();
                }];
            }
        }else {
            abort();
        }
        
    } failedToFetched:^(NSError *error, NSString *errorInfo) {
        failure(error,errorInfo);
    }];
}
-(void)updateCaseInfo:(RecordBaseInfo*)recordBaseInfo withDic:(NSDictionary*)dataDic
{
    if ([dataDic.allKeys containsObject:@"caseState"]) {
        recordBaseInfo.caseState = [dataDic objectForKey:@"caseState"];
    }
    
    
    if ([dataDic.allKeys containsObject:@"caseContent"]) {
        recordBaseInfo.caseType = [dataDic objectForKey:@"caseContent"];
    }
    if ([dataDic.allKeys containsObject:@"archivedTime"]) {
        recordBaseInfo.caseState = [dataDic objectForKey:@"archivedTime"];
    }
    
    if ([dataDic.allKeys containsObject:@"casePresenter"]) {
        recordBaseInfo.caseType = [dataDic objectForKey:@"casePresenter"];
    }
    if ([dataDic.allKeys containsObject:@"createdTime"]) {
        recordBaseInfo.caseState = [dataDic objectForKey:@"createdTime"];
    }
    
    if ([dataDic.allKeys containsObject:@"isCompleted"]) {
        recordBaseInfo.caseType = [dataDic objectForKey:@"isCompleted"];
    }
    if ([dataDic.allKeys containsObject:@"lastModifyTime"]) {
        recordBaseInfo.caseState = [dataDic objectForKey:@"lastModifyTime"];
    }
    
    if ([dataDic.allKeys containsObject:@"dID"]) {
        recordBaseInfo.caseType = [dataDic objectForKey:@"dID"];
    }
    if ([dataDic.allKeys containsObject:@"dName"]) {
        recordBaseInfo.caseState = [dataDic objectForKey:@"dName"];
    }
    if ([dataDic.allKeys containsObject:@"pID"]) {
        recordBaseInfo.caseType = [dataDic objectForKey:@"pID"];
    }    if ([dataDic.allKeys containsObject:@"pName"]) {
        recordBaseInfo.caseState = [dataDic objectForKey:@"pName"];
    }
}
///create doctor managedobject

-(void)createDoctorEntityWithDataDic:(NSDictionary*)dataDic inContext:(NSManagedObjectContext*)context successfulCreated:(void (^)())successfully failedToCreated:(void (^)(NSError *error,NSString * errorInfo))failure
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName: [Doctor entityName]inManagedObjectContext:context];
    Doctor *doctor = [[Doctor alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:context];
    if ([dataDic.allKeys containsObject:@"dID" ]) {
        doctor.dID = (NSString*)dataDic[@"dID"];
    }else {
        [self showAlertViewWithTitle:@"需要医生ID"];
        failure(nil,@"需要医生ID");
    }
    if ([dataDic.allKeys containsObject:@"dName"]) {
        doctor.dName = (NSString*)dataDic[@"dName"];
    }else {
        [self showAlertViewWithTitle:@"需要医生姓名"];
        failure(nil,@"需要医生姓名");
    }
    if ([dataDic.allKeys containsObject:@"dProfessionalTitle"]) {
        doctor.dProfessionalTitle = (NSString*)dataDic[@"dProfessionalTitle"];
    }
    if ([dataDic.allKeys containsObject:@"dept"]) {
        doctor.dept = (NSString*)dataDic[@"dept"];
    }
    if ([dataDic.allKeys containsObject:@"medicalTeam"]) {
        doctor.medicalTeam = (NSString*)dataDic[@"medicalTeam"];
    }

    if ([dataDic.allKeys containsObject:@"isAttendingPhysican"]) {
        doctor.dept = (NSString*)dataDic[@"isAttendingPhysican"];
    }
    if ([dataDic.allKeys containsObject:@"isChiefPhysician"]) {
        doctor.medicalTeam = (NSString*)dataDic[@"isChiefPhysician"];
    }
    if ([dataDic.allKeys containsObject:@"isResident"]) {
        doctor.medicalTeam = (NSString*)dataDic[@"isResident"];
    }

    [self saveContextFailToSave:^(NSError *error, NSString *errorInfo) {
        failure(error,errorInfo);
    } successfulCreated:^{
        successfully();
    }];
}
///update doctor info
-(void)updateDoctorEntityWithDataDic:(NSDictionary*)dataDic inContext:(NSManagedObjectContext*)context successfulUpdated:(void (^)())successfully failedToUpdated:(void (^)(NSError *error,NSString * errorInfo))failure
{
    NSPredicate *predicate;
    
    NSString *dID,*dName;
    
    if([dataDic.allKeys containsObject:@"dID"]){
        dID = dataDic[@"dID"];
    }
    if([dataDic.allKeys containsObject:@"dName"]){
        dName = dataDic[@"dName"];
    }

    if (dID != nil && dName!=nil) {
        predicate = [NSPredicate predicateWithFormat:@"dName = %@,dID = %@",dName,dID];
    }
    if(dName == nil){
        predicate = [NSPredicate predicateWithFormat:@"dID = %@",dID];
    }
    if (dID == nil) {
        predicate = [NSPredicate predicateWithFormat:@"dName = %@",dName];
    }

    [self fetchManagedObjectInContext:context WithEntityName:[Doctor entityName] withPredicate:predicate successfulFetched:^(NSArray *resultArray) {
        
        NSLog(@"fetch %@,  with predicate : %@,result array count is %@",[Doctor entityName],predicate,@(resultArray.count));
        
        if (resultArray.count == 1) {
            if ([[resultArray firstObject] isKindOfClass:[Doctor class]]){
                Doctor *doctor = (Doctor*)[resultArray firstObject];
                if ([dataDic.allKeys containsObject:@"dProfessionalTitle"]) {
                    doctor.dProfessionalTitle = (NSString*)dataDic[@"dProfessionalTitle"];
                }
                if ([dataDic.allKeys containsObject:@"dept"]) {
                    doctor.dept = (NSString*)dataDic[@"dept"];
                }
                if ([dataDic.allKeys containsObject:@"medicalTeam"]) {
                    doctor.medicalTeam = (NSString*)dataDic[@"medicalTeam"];
                }
                if ([dataDic.allKeys containsObject:@"isAttendingPhysican"]) {
                    doctor.dept = (NSString*)dataDic[@"isAttendingPhysican"];
                }
                if ([dataDic.allKeys containsObject:@"isChiefPhysician"]) {
                    doctor.medicalTeam = (NSString*)dataDic[@"isChiefPhysician"];
                }
                if ([dataDic.allKeys containsObject:@"isResident"]) {
                    doctor.medicalTeam = (NSString*)dataDic[@"isResident"];
                }

            }
            [self saveContextFailToSave:^(NSError *error, NSString *errorInfo) {
                failure(error,errorInfo);
            } successfulCreated:^{
                successfully();
            }];
        }else {
            NSLog(@"存在多个医生对应相同的名字或ID");
        }
        
    } failedToFetched:^(NSError *error, NSString *errorInfo) {
        failure(error,errorInfo);
    }];
}



- (void)saveContextFailToSave:(void (^)(NSError *error,NSString * errorInfo))failure  successfulCreated:(void (^)())successfully{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            failure(error,@"save to core data error");
            abort();
        }
    }else {
        successfully();
    }
}

///helper
-(void)fetchManagedObjectInContext:(NSManagedObjectContext*)context  WithEntityName:(NSString*)entityString withPredicate:(NSPredicate*)predicate successfulFetched:(void (^)(NSArray *resultArray))successfully failedToFetched:(void (^)(NSError *error,NSString * errorInfo))failure
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityString];
    if (predicate != nil) {
        fetchRequest.predicate = predicate;
    }
    NSError *error;
    
    NSArray *tempArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    if (error) {
        failure(error,[NSString stringWithFormat:@"fetch entity %@ fail",entityString]);
    }else {
        successfully(tempArray);
    }
}


-(void)showAlertViewWithTitle:(NSString*)titleString
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:titleString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        NSLog(@"%@",titleString);
        [alert show];

    });
    
}

@end
