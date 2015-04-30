//
//  WLKFileManager.m
//  MedImageReader
//
//  Created by ihefe36 on 14/12/26.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import "WLKFileHelper.h"

@implementation WLKFileHelper
+ (BOOL)didFileExist:(NSString *)path
{
    BOOL toReturn = NO;
    
    return toReturn;
}

/**
 * 目录是否存在
 */
+ (BOOL)didDirExist:(NSString *)path
{
    BOOL toReturn = NO;
    
    return toReturn;
}

+ (NSURL *)documentURL
{
    NSURL *url = [NSURL fileURLWithPath:[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject isDirectory:YES];
    return url;
}

+ (NSURL *)homeURL
{
    return [NSURL fileURLWithPath:NSHomeDirectory() isDirectory:YES];
}

+ (NSURL *)tempURL
{
    return [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
}

+ (NSURL *)cachesURL
{
    NSURL *url = [NSURL fileURLWithPath:[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask].lastObject isDirectory:YES];
    return url;
}
@end
