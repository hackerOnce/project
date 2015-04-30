//
//  MedicalCase.m
//  MedCase
//
//  Created by ihefe-JF on 15/2/6.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import "MedicalCase.h"
#import "Person.h"


@implementation MedicalCase

@dynamic caseContent;
@dynamic caseID;
@dynamic owner;

+(NSString *)medicalCaseEntityName
{
    return @"MedicalCase";
}
@end
