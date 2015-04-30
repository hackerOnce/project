//
//  WLKFileManager.h
//  MedImageReader
//
//  Created by ihefe36 on 14/12/26.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLKFileHelper : NSObject
/**
 * 文件是否存在
 */
+ (BOOL)didFileExist:(NSString *)path;

/**
 * 目录是否存在
 */
+ (BOOL)didDirExist:(NSString *)path;

/**
 * 返回document文件夹URL
 */
+ (NSURL *)documentURL;

/**
 * 返回主目录URL
 */
+ (NSURL *)homeURL;

/**
 * 返回temple文件夹URL
 */
+ (NSURL *)tempURL;

/**
 * 返回caches文件夹URL
 */
+ (NSURL *)cachesURL;

@end
