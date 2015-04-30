//
//  MedicalCase.h
//  MedCase
//
//  Created by ihefe-JF on 15/2/6.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Person;

@interface MedicalCase : NSManagedObject

@property (nonatomic, retain) NSString * caseContent;
@property (nonatomic, retain) NSString * caseID;
@property (nonatomic, retain) Person *owner;

+(NSString*)medicalCaseEntityName;
@end
