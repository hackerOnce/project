//
//  WLKDataCenter.h
//  MedImageReader
//
//  Created by ihefe36 on 14/12/24.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WLKDatabaseHelper;
@class WLKNetClient;
@class WLKFileHelper;
@interface WLKDataCenter : NSObject

#pragma mark - properties
/**
 * 数据库访问辅助对象
 */
@property (strong, nonatomic) WLKDatabaseHelper *databaseHelper;
/**
 * 网络访问对象
 */
@property (strong, nonatomic) WLKNetClient *netClient;

/**
 * 文件管理辅助对象
 */
@property (strong, nonatomic) WLKFileHelper *fileHelper;

#pragma mark - methods
/**
 * 单例方法
 */
+ (instancetype)getInstance;



@end
