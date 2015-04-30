//
//  RawCaseData.h
//  MedCase
//
//  Created by ihefe-JF on 15/2/6.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RawCaseData : NSManagedObject

@property (nonatomic, retain) NSString * caseContent;
@property (nonatomic, retain) NSDate * updateTime;
@property (nonatomic, retain) NSDate * createTime;

@end
