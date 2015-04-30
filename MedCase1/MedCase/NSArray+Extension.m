//
//  NSArray+Extension.m
//  MedicalRecord
//
//  Created by ihefe-JF on 15/1/4.
//  Copyright (c) 2015年 JFAppHourse.app. All rights reserved.
//

#import "NSArray+Extension.h"

@implementation NSArray(Extensions)

-(NSArray *)difference:(NSArray *)values
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSString *selfString in self){
//        for (NSString *tempString in values){
//            if([selfString isEqualToString:tempString]){
//                continue;
//            }
//            [tempArray addObject:selfString];
//        }
        if([values containsObject:selfString]){
            continue;
        }
        if([selfString isEqualToString:@"添加"]){
            continue;
        }
        [tempArray addObject:selfString];
    }
    return tempArray;
}
-(instancetype)insert:(NSString *)tempStr
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:self];
    [tempArray insertObject:tempStr atIndex:tempArray.count-1];
    if(tempArray.count == 15){
        [tempArray removeLastObject];
    }
    return tempArray;
}
@end
