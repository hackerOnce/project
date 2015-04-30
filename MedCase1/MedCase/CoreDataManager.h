//
//  CoreDataManager.h
//  MedCase
//
//  Created by ihefe-JF on 15/2/5.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ModelCase.h"
#import "MedicalCase.h"
#import "Person.h"
#import "RawCaseData.h"
#import "ConstantVariable.h"

@interface CoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void)insertNewObjectForEntityName:(NSString *)tableName withDictionary:(NSDictionary*)dic;

-(void)saveContext;
-(NSURL*)applicationDocumnetsDirectory;

//insert data
@end
