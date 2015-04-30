//
//  Persons.h
//  MedCase
//
//  Created by ihefe-JF on 15/1/30.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Persons : NSObject

@property (nonatomic,strong) NSMutableArray *persons;

+(Persons *)sharedPersons;

@end
