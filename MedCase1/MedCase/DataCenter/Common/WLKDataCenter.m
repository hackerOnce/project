//
//  WLKDataCenter.m
//  MedImageReader
//
//  Created by ihefe36 on 14/12/24.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import "WLKDataCenter.h"
#import "WLKNetClient.h"
#import "WLKDatabaseHelper.h"

@implementation WLKDataCenter
+ (instancetype)getInstance
{
    static WLKDataCenter *center = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[WLKDataCenter alloc] init];
    });
    return center;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        self.netClient = [[WLKNetClient alloc] init];
        
        return self;
    }
    return nil;
}

@end
