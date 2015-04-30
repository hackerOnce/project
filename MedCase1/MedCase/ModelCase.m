//
//  ModelCase.m
//  MedCase
//
//  Created by ihefe-JF on 15/2/6.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import "ModelCase.h"


@implementation ModelCase

@dynamic admissionDiagnosis;
@dynamic allergicHistory;
@dynamic caseContent;
@dynamic caseID;
@dynamic highAge;
@dynamic lowAge;
@dynamic medicalTreatment;

+(NSString *)modelCaseEntityName
{
    return @"ModelCase";
}
+(NSString *)modelCaseID
{
    return @"modelCaseID";
}
@end
