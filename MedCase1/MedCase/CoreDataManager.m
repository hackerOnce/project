//
//  CoreDataManager.m
//  MedCase
//
//  Created by ihefe-JF on 15/2/5.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import "CoreDataManager.h"
#import "PersonInfo.h"


@implementation CoreDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

-(void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if(managedObjectContext != nil){
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mask - Core data stack

-(NSManagedObjectContext *)managedObjectContext
{
    if(_managedObjectContext != nil){
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if(coordinator != nil){
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}

-(NSManagedObjectModel*)managedObjectModel
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MedCase" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MedicalCaseModel.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

//-(void)insertNewObjectForEntityName:(NSString *)tableName withCaseContent:(NSString *)caseContent withCaseID:(NSString*)index
-(void)insertNewObjectForEntityName:(NSString *)tableName withDictionary:(NSDictionary*)dic
{
     NSManagedObjectContext *context = [self managedObjectContext];
    
    if([tableName isEqualToString:@"RawCaseData"]){
        
        RawCaseData *rawCaseData = [NSEntityDescription insertNewObjectForEntityForName:tableName inManagedObjectContext:context];
        rawCaseData.createTime = [NSDate date];
        rawCaseData.updateTime = [NSDate date];
        
        
        rawCaseData.caseContent = [dic objectForKey:@"caseContent"];//  caseContent;
        
        [self saveContext];
        
        return;
    }
    if([tableName isEqualToString:@"ModelCase"]){

            //保存model
             ModelCase *modelCase = [NSEntityDescription insertNewObjectForEntityForName:tableName inManagedObjectContext:context];
            NSUInteger modelCount = [self fetchEntityWithEntityName:tableName].count;
            modelCase.caseID = [NSString stringWithFormat:@"%@",@(modelCount)];
        
        modelCase.caseContent = [dic objectForKey:@"caseContent"];
        
        PersonInfo *info = [dic objectForKey:@"personInfo"];
        
        modelCase.allergicHistory = info.allergicHistory;
        modelCase.admissionDiagnosis = info.admissionDiagnosis;
        modelCase.medicalTreatment = info.medicalTreatment;
        
        modelCase.lowAge = info.age;
        modelCase.highAge = info.highAge;
        [self saveContext];
        
        return;
    }
    
    if([tableName isEqualToString:@"Person"]){
      
        PersonInfo *info = [dic objectForKey:@"personInfo"];
        
        Person *person = [NSEntityDescription insertNewObjectForEntityForName:tableName inManagedObjectContext:context];
        
        person.age = info.age;
        person.location = info.loction;
        person.gender = info.gender;
        person.name = info.name;
        
        person.allergicHistory = info.allergicHistory;
        person.medicalTreatment = info.medicalTreatment;
        person.admissionDiagnosis = info.admissionDiagnosis;
        
        person.id = info.ID;
        
        MedicalCase *medicalCase = [NSEntityDescription insertNewObjectForEntityForName:@"MedicalCase" inManagedObjectContext:context];
        medicalCase.caseID = [NSString stringWithFormat:@"%@",@(person.medicalCases.count)];
        medicalCase.caseContent = [dic objectForKey:@"caseContent"];
        
        [person addMedicalCasesObject:medicalCase];
        
        [self saveContext];
        
        return;
    }
}

-(NSArray*)fetchEntityWithEntityName:(NSString*)entityName
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}
-(NSDictionary*)updatePersonEntityWithID:(NSString*)PersonID medicalCaseID:(NSString *)caseID withData:(NSDictionary*)dic
{
    
    NSMutableDictionary *updateDic = [[NSMutableDictionary alloc] init];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id like[cd] %@",PersonID];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:[Person personEntityName] inManagedObjectContext:context]];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    Person *tmpPerson = nil;
    
    if(result.count != 0){
        if(result.count == 1){
            tmpPerson =(Person*)result[0];
            
        }else {
           NSLog(@"core data 用病人id查找到多个病人，请修正查询条件");
        }
    }else {
        //没有找到病人
        [updateDic setObject:@"NoPeople" forKey:[Person personEntityName]];
        [updateDic setObject:@"NOMedicalCase" forKey:[MedicalCase medicalCaseEntityName]];
        
        return updateDic;
    }
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"medicalCases.caseID like[cd] %@",caseID];
        
    NSArray *cases = [result filteredArrayUsingPredicate:filter];
    
    MedicalCase *tempCase = nil;
    if(cases.count != 0){
        if(cases.count == 1){
          tempCase  =(MedicalCase*)cases[0];
          
        }else {
            NSLog(@"core data 用病人id查找到多个病人，请修正查询条件");
            [updateDic setObject:@"NOMedicalCase" forKey:[MedicalCase medicalCaseEntityName]];
        }
    }else {
        //没有找到病历
        [updateDic setObject:@"NOMedicalCase" forKey:[MedicalCase medicalCaseEntityName]];
    }
    
    return updateDic;
}
@end
