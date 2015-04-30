//
//  WLKDatabaseHelper.h
//  MedImageReader
//
//  Created by ihefe36 on 14/12/24.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WLKCase;
@interface WLKDatabaseHelper : NSObject

- (WLKCase *)getCaseByID:(NSString *)ID;

@end
