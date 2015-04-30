//
//  Person.m
//  MedCase
//
//  Created by ihefe-JF on 15/2/6.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import "Person.h"
#import "MedicalCase.h"


@implementation Person

@dynamic admissionDiagnosis;
@dynamic age;
@dynamic allergicHistory;
@dynamic gender;
@dynamic highAge;
@dynamic location;
@dynamic lowAge;
@dynamic medicalTreatment;
@dynamic name;
@dynamic id;
@dynamic medicalCases;

+(NSString *)personEntityName
{
    return @"Person";
}
@end
