//
//  Persons.m
//  MedCase
//
//  Created by ihefe-JF on 15/1/30.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import "Persons.h"

@implementation Persons

+(Persons *)sharedPersons
{
    static dispatch_once_t onceToken;
    static Persons *sharedPersons;
    
    dispatch_once(&onceToken, ^{
        sharedPersons = [[Persons alloc] init];
    });
    
    return sharedPersons;
}

@end
