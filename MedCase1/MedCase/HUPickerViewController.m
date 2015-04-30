//
//  HUPickerViewController.m
//  MedCase
//
//  Created by ihefe-JF on 15/1/7.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import "HUPickerViewController.h"

@interface HUPickerViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,strong) NSMutableDictionary *componentsDic;
@property(nonatomic,strong) NSArray *componentsWidth;

@property(nonatomic,strong) NSString *selectedYear;
@property(nonatomic,strong) NSString *selectedMonth;
@property(nonatomic,strong) NSString *selectedDay;
@property(nonatomic,strong) NSString *selectedHour;
@property(nonatomic,strong) NSString *selectedMin;

@property(nonatomic,strong) NSString *durationString;
@end

@implementation HUPickerViewController


-(NSArray *)componentsWidth
{
    if(!_componentsWidth){
        _componentsWidth = [[NSArray alloc] initWithObjects:@(80),@(60), @(95),@(70),@(110),nil];
    }
    return _componentsWidth;
}
-(NSString *)durationString
{
    if(!_durationString){
        _durationString = @"持续了";
    }
    return _durationString;
}
-(NSMutableDictionary *)componentsDic
{
    if(!_componentsDic){
        _componentsDic = [[NSMutableDictionary alloc] init];
        NSArray *temp1 = [self intArray:101 indexFrom:0];
        [_componentsDic setObject:temp1 forKey:@(0)];//year
        temp1 = [self intArray:12 indexFrom:0];
        [_componentsDic setObject:temp1 forKey:@(1)];//month
        temp1 = [self intArray:31 indexFrom:0];
        [_componentsDic setObject:temp1 forKey:@(2)];//day
        temp1 = [self intArray:24 indexFrom:0];
        [_componentsDic setObject:temp1 forKey:@(3)];//hour
        temp1 = [self intArray:60 indexFrom:0];
        [_componentsDic setObject:temp1 forKey:@(4)];//min
    }
    return _componentsDic;
}
-(NSArray*)intArray:(NSInteger)sum indexFrom:(int)index
{
    NSMutableArray *tempA = [[NSMutableArray alloc] init];
    for(int i=index; i< sum; i++){
        [tempA addObject:[NSString stringWithFormat:@"%d",i]];
    }
    return tempA;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.autoresizesSubviews = YES;
    self.pickerView.layer.borderColor = [UIColor blackColor].CGColor;
    self.pickerView.layer.borderWidth = 2;

    
    for(int i=0;i<5;i++){
        [self.pickerView selectRow:0 inComponent:i animated:YES];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    if(self.selectedYear && ![self.selectedYear isEqualToString:@"0年"]){
        [tempArray addObject:self.selectedYear];
    }
    if(self.selectedMonth && ![self.selectedMonth isEqualToString:@"0个月"]){
        [tempArray addObject:self.selectedMonth];
    }
    if(self.selectedDay && ![self.selectedDay isEqualToString:@"0天"]){
        [tempArray addObject:self.selectedDay];
    }
    if(self.selectedHour && ![self.selectedHour isEqualToString:@"0小时"]){
        [tempArray addObject:self.selectedHour];
    }
    if(self.selectedMin && ![self.selectedMin isEqualToString:@"0分钟"]){
        [tempArray addObject:self.selectedMin];
    }
    
    if(tempArray.count == 0){
        self.durationString = @"所选时间为空";
    }else {
        for(NSString *tempStr in tempArray){
            self.durationString = [self.durationString stringByAppendingString:tempStr];
        }
    }
    NSLog(@"%@",self.durationString);
    
    
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 5;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return ((NSArray*)[self.componentsDic objectForKey:@(component)]).count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [((NSArray*)[self.componentsDic objectForKey:@(component)]) objectAtIndex:row];
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [[self.componentsWidth objectAtIndex:component] floatValue];
  
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
   // self.durationString = [NSString stringWithFormat:@"持续了%d年%d月%d日]
//    if(row == 0){
//        return;
//    }
    switch (component) {
        case 0:{
            self.selectedYear = [NSString stringWithFormat:@"%ld年",row];
            break;
        }
        case 1:{
            self.selectedMonth = [NSString stringWithFormat:@"%ld个月",row];
            break;
        }
        case 2:{
            self.selectedDay = [NSString stringWithFormat:@"%ld天",row];
            break;
        }
        case 3:{
           self.selectedHour = [NSString stringWithFormat:@"%ld小时",row];
            break;
        }
        case 4:{
            self.selectedMin = [NSString stringWithFormat:@"%ld分钟",row];
            break;
        }
        default:
            NSLog(@"picker view error");
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
