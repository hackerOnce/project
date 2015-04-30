//
//  AppDelegate.h
//  MedCase
//
//  Created by ihefe36 on 14/12/29.
//  Copyright (c) 2014年 ihefe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//
//- (void)saveContext;
//- (NSURL *)applicationDocumentsDirectory;

@property (nonatomic, strong) IHGCDSocket *socket;
@end

