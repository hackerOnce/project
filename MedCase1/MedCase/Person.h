//
//  Person.h
//  MedCase
//
//  Created by ihefe-JF on 15/2/6.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MedicalCase;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * admissionDiagnosis;
@property (nonatomic, retain) NSString * age;
@property (nonatomic, retain) NSString * allergicHistory;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * highAge;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * lowAge;
@property (nonatomic, retain) NSString * medicalTreatment;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSOrderedSet *medicalCases;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)insertObject:(MedicalCase *)value inMedicalCasesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromMedicalCasesAtIndex:(NSUInteger)idx;
- (void)insertMedicalCases:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeMedicalCasesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInMedicalCasesAtIndex:(NSUInteger)idx withObject:(MedicalCase *)value;
- (void)replaceMedicalCasesAtIndexes:(NSIndexSet *)indexes withMedicalCases:(NSArray *)values;
- (void)addMedicalCasesObject:(MedicalCase *)value;
- (void)removeMedicalCasesObject:(MedicalCase *)value;
- (void)addMedicalCases:(NSOrderedSet *)values;
- (void)removeMedicalCases:(NSOrderedSet *)values;

+(NSString*)personEntityName;
@end
