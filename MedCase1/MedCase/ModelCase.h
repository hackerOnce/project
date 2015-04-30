//
//  ModelCase.h
//  MedCase
//
//  Created by ihefe-JF on 15/2/6.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ModelCase : NSManagedObject

@property (nonatomic, retain) NSString * admissionDiagnosis;
@property (nonatomic, retain) NSString * allergicHistory;
@property (nonatomic, retain) NSString * caseContent;
@property (nonatomic, retain) NSString * caseID;
@property (nonatomic, retain) NSString * highAge;
@property (nonatomic, retain) NSString * lowAge;
@property (nonatomic, retain) NSString * medicalTreatment;

+(NSString*)modelCaseEntityName;
+(NSString*)modelCaseID;
@end
