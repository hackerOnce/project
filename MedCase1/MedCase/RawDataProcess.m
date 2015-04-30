//
//  RawDataProcess.m
//  MedCase
//
//  Created by ihefe-JF on 15/1/30.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import "RawDataProcess.h"
#import "ParseXML.h"
#import "SBJsonWriter.h"

@interface RawDataProcess ()

@end

@implementation RawDataProcess

+(RawDataProcess *)sharedRawData
{
    static dispatch_once_t onceToken;
    static RawDataProcess *sharedRawData;
    
    dispatch_once(&onceToken, ^{
        sharedRawData = [[RawDataProcess alloc] init];
    });
    
    return sharedRawData;
}

-(instancetype)init
{
    if(self = [super init]){
        
        //self.dataNode = [self getRawNodeData];
        ParseXML *pa = [[ParseXML alloc] initWithXMLName:@"病历" extendName:@"opml"];
        self.coreDataManager = [[CoreDataManager alloc] init];
        self.XMLDic = [pa rawDic];
        
        //self.dic =[NSMutableDictionary dictionaryWithDictionary:[pa rawDic]];
    }
    
    return self;
}

-(NSString *)stringFromJsonDic:(NSMutableDictionary *)tempDic
{
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    return [jsonWriter stringWithObject:tempDic];
}
-(NSDictionary*)dicFromJsonString:(NSString*)tempStr
{
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    return [jsonParser objectWithString:tempStr];
}
-(NSManagedObjectContext*)coreDataManagedObjectContext
{
    return self.coreDataManager.managedObjectContext;
}
-(NSMutableDictionary *)dic
{
    if(!_dic){
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSManagedObjectContext *context =[self coreDataManagedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"RawCaseData" inManagedObjectContext:context];
        NSError *error;
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        if(fetchedObjects.count == 0){
            [self.coreDataManager insertNewObjectForEntityName:@"RawCaseData" withDictionary:@{@"caseContent":[self stringFromJsonDic:self.XMLDic]}];
            _dic = [NSMutableDictionary dictionaryWithDictionary:self.XMLDic];

        }else {
            RawCaseData *tempData = (RawCaseData*)[fetchedObjects objectAtIndex:0];
            _dic = [NSMutableDictionary dictionaryWithDictionary:[self dicFromJsonString:tempData.caseContent]];
        }

    }
    
    return _dic;
}
//-(WLKCaseNode*)getRawNodeData
//{
//    //NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"plist"]];
//    ParseXML *pa = [[ParseXML alloc] initWithXMLName:@"病历" extendName:@"opml"];
//    
//    WLKCaseNode *caseNode = [pa getNodeWithKey:@"入院记录（可以做到各科专科内容）"];
//    return caseNode;
//}

@end
