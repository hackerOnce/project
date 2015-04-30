//
//  WLKNetClient.h
//  MedImageReader
//
//  Created by ihefe36 on 14/12/24.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLKNetClient : NSObject <IHGCDSocketDelegate>

#pragma  mark - properties
/**
 * http请求客户端
 */
@property (strong, nonatomic) AFHTTPRequestOperationManager *httpClient;
/**
 * socket请求客户端
 */
@property (strong, nonatomic) IHGCDSocket *socketClient;

@end
