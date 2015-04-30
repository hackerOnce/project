//
//  WLKNetClient.m
//  MedImageReader
//
//  Created by ihefe36 on 14/12/24.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import "WLKNetClient.h"

@implementation WLKNetClient
- (instancetype)init
{
    if (self = [super init]) {
        //启动网络状态监视
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        //初始化afnet客户端
        self.httpClient = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        self.socketClient = [[IHGCDSocket alloc] init];
        [self.socketClient connectToHost:@"192.168.10.204" onPort:50007];
        self.socketClient.timeout = 3;
        self.socketClient.delegate = self;
        
        return self;
    }
    return nil;
}

#pragma mark - IHGCDSocketDelegate
- (void)ihSocket:(IHGCDSocket *)ihGcdSock didReceive:(NSData *)data
{
    WLKLog(@"receive data");
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    WLKLog(@"error %@", err);
}

@end
