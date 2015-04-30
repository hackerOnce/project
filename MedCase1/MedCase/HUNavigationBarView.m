//
//  HUNavigationBarView.m
//  MedicalRecord
//
//  Created by ihefe-JF on 14/12/26.
//  Copyright (c) 2014年 JFAppHourse.app. All rights reserved.
//

#import "HUNavigationBarView.h"
#import "PersonTableViewController.h"
#import "KeyValueObserver.h"
#import "ConstantVariable.h"

@interface HUNavigationBarView() <UIActionSheetDelegate>

@property(nonatomic,strong) UILabel *dividingLine;

@property(nonatomic,strong) NSMutableArray *labelsArray;


@property(nonatomic,strong) UIView *tempView;

@property(nonatomic,strong) NSArray *keyStrArray;

@property(nonatomic,strong) NSString *indexLabel;;

@property(nonatomic,strong) id indexLabelObserverToken;

@property (nonatomic,strong) PersonInfo *person;
@end

static CGFloat gap = 5;

static  NSString *fontName = @"HelveticaNeue";

#define FONT [UIFont fontWithName:@"HelveticaNeue" size:16];
#define TextColor [UIColor colorWithRed:86.0/255 green:86.0/255 blue:86.0/255 alpha:1];
#define LabelBackgroundColor [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1];

@implementation HUNavigationBarView

//static CGFloat personInfoWidth;

-(NSArray *)keyStrArray
{
    if(!_keyStrArray){
        _keyStrArray = @[@"性别",@"年龄段",@"诊断",@"过敏史",@"处置"];
    }
    return _keyStrArray;
}
-(NSMutableArray *)labelsArray
{
    if(!_labelsArray){
        _labelsArray = [[NSMutableArray alloc] init];
    }
    return _labelsArray;
}
-(PersonInfo *)personInfo
{
    if(!_personInfo){
        _person = [[PersonInfo alloc] init];
    }
    
    return _personInfo;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        _changeViewFlag = YES;
        
        [self buildNavigationBarViewUI];
        
        self.layer.cornerRadius = 5;
        self.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        self.layer.borderWidth = 1;
    }
    return self;
}
-(NSArray *)datas
{
    if(!_datas){
        _datas = @[@"男",@"女",@"女",@"男",@"女",@"男",@"女",@"男",@"女",@"男",@"女"];
    }
    return _datas;
}
-(void)presentActionSheet:(NSInteger)indexInt
{
    UILabel *tempLabel = [self.labelsArray objectAtIndex:indexInt];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    for (NSString *tempStr in self.datas) {
        [actionSheet addButtonWithTitle:tempStr];
    }
    CGRect tempRect = CGRectMake(tempLabel.frame.origin.x + 1/2 * tempLabel.frame.size.width  + 10, tempLabel.frame.origin.y + tempLabel.frame.size.height - 25, CGRectGetWidth(tempLabel.frame), CGRectGetHeight(tempLabel.frame));
    
    [actionSheet showFromRect:tempRect inView:self animated:YES];
}
#pragma mask - actionsheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //self.gender = [actionSheet buttonTitleAtIndex:buttonIndex];
    if(buttonIndex <= self.datas.count){
        self.person.gender = [actionSheet buttonTitleAtIndex:buttonIndex];
        [[NSNotificationCenter defaultCenter] postNotificationName:didSelectedRowNotificationName object:self.person];
        [self showData];
    }
  
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
   self = [super initWithCoder:aDecoder];
    if(self){
        _changeViewFlag = NO;
        [self buildNavigationBarViewUI];
    }
    return self;
}
-(void)buildNavigationBarViewUI
{
    [self clearSubviews];
    
   // CGFloat personInfoWidth = 2 * (self.frame.size.width - 2 * gap) / 5;
    if(_changeViewFlag){
        CGFloat personInfoWidth = (2 * (self.frame.size.width-10))/5 ;
        CGFloat  y = 5;
        CGFloat baseX = 5;
        CGFloat  width = personInfoWidth/5;
        CGFloat height = self.frame.size.height - 2 * gap;
        
        
        for(int i=0; i<4; i++)
        {
            CGRect tempRect;
            if(i==0){
                tempRect = CGRectMake(baseX, y, width * 2 , height);
            }else {
                tempRect = CGRectMake(baseX + i * width + width, y, width  , height);
            }
            UILabel *tempLabel = [[UILabel alloc] initWithFrame:tempRect];
            tempLabel.font = FONT;
            tempLabel.backgroundColor = LabelBackgroundColor;
            tempLabel.textColor = TextColor;
            tempLabel.layer.borderColor = [UIColor whiteColor].CGColor;
            tempLabel.layer.borderWidth = 1;
            [self.labelsArray addObject:tempLabel];
            [self addSubview:tempLabel];
            
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(5, y, personInfoWidth, height);
        
        self.button = button;
        [self addSubview:self.button];
        
        CGFloat otherInfoWidth = (3 * (self.frame.size.width-10))/5;
        
        CGFloat baseX1 = personInfoWidth + 5;
        CGFloat width1 = otherInfoWidth/3;
        
        for(int j=0;j<3;j++){
            CGRect labelRect = CGRectMake(baseX1 + j * width1, y, j==2?width1-3:width1, height);
            UILabel *otherLabel = [[UILabel alloc] initWithFrame:labelRect];
            otherLabel.backgroundColor = LabelBackgroundColor;
            otherLabel.textColor = TextColor
            otherLabel.font = FONT;
            [self.labelsArray addObject:otherLabel];
            [self addSubview:otherLabel];
        }

    }else {
        CGFloat medicalModelWidth = (self.frame.size.width-10)/2;
        CGFloat yM = 5;
        CGFloat xM = 5;
        CGFloat medicalModeHeight = self.frame.size.height - 2 * gap;
        
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(xM, yM, self.frame.size.width-5, medicalModeHeight)];
        tempView.backgroundColor = [UIColor redColor];
        self.tempView = tempView;
        
        for(int k=0; k<3;k++) {
            CGRect modelFrame;
//            if(k==0){
//                modelFrame = CGRectMake(xM, yM, medicalModelWidth/2, medicalModeHeight);
//            }else {
//               modelFrame = CGRectMake(xM + medicalModelWidth/2 + (k-1) * medicalModelWidth/4, yM, medicalModelWidth/4, medicalModeHeight);
//            }
            modelFrame = CGRectMake(xM + k * medicalModelWidth/3, yM, medicalModelWidth/3, medicalModeHeight);
            
            UILabel *modelLabel = [[UILabel alloc] initWithFrame:modelFrame];
            modelLabel.backgroundColor = LabelBackgroundColor;
            modelLabel.textColor = TextColor
            modelLabel.font = FONT;
            modelLabel.userInteractionEnabled = YES;
            [self.labelsArray addObject:modelLabel];
            
            [self addSubview:modelLabel];
        }
        
        for(int l=0;l<2;l++){
            UILabel *modelTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(medicalModelWidth + l * medicalModelWidth/2, yM, medicalModelWidth/2, medicalModeHeight)];
            modelTempLabel.backgroundColor = LabelBackgroundColor;
            modelTempLabel.textColor = TextColor
            modelTempLabel.font = FONT;
            modelTempLabel.userInteractionEnabled = YES;
            [self.labelsArray addObject:modelTempLabel];
            [self addSubview:modelTempLabel];

        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectedLabel:)];
        //[self addSubview:self.tempView];
        [self addGestureRecognizer:tap];
        
    }
    
    //[self showData];
}
-(void)didSelectedLabel:(UITapGestureRecognizer*)sender
{
    CGPoint point = [sender locationInView:self];
    for (UILabel *tempLabel in self.labelsArray) {
        if(CGRectContainsPoint(tempLabel.frame, point)){
            NSInteger indexLabel = [self.labelsArray indexOfObject:tempLabel];
            
            [self presentActionSheet:indexLabel];
            NSLog(@"%@ %@",@(indexLabel),tempLabel.text);
            break;
        }
    }
}
-(void)showData
{
    if(_changeViewFlag){
        for (NSUInteger i=0; i<self.labelsArray.count; i++) {
            UILabel *label = (UILabel*)self.labelsArray[i];
            switch (i) {
                case 0:{
                    label.text = self.personInfo.name;
                    break;
                }
                case 1:{
                    label.text = self.personInfo.loction;
                    break;
                }
                case 2:{
                    label.text = self.personInfo.age;
                    break;
                }
                case 3:{
                    label.text = self.personInfo.gender;
                    break;
                }
                case 4:{
                    label.text = [NSString stringWithFormat:@"入院诊断: %@",self.personInfo.admissionDiagnosis];
                    break;
                }
                case 5:{
                    label.text = [NSString stringWithFormat:@"过敏史: %@",self.personInfo.allergicHistory];
                    break;
                }
                case 6:{
                    label.text = [NSString stringWithFormat:@"处置: %@", self.personInfo.medicalTreatment];
                    break;
                }
                default:
                    NSLog(@"error");
                    break;
            }
        }

    }else {
        for (UILabel *tempLabel in self.labelsArray) {
            NSUInteger labelId = [self.labelsArray indexOfObject:tempLabel];
            
            switch (labelId) {
                case 0: {
                     tempLabel.text = [NSString stringWithFormat:@"性别:         %@",self.personInfo.gender];
                   
                     break;
                }case 1:{
                    tempLabel.text = [NSString stringWithFormat:@"年龄段: %@ - %@",self.personInfo.lowAge,self.personInfo.highAge];
                    break;
                }
                case  2:{
                     tempLabel.text = [NSString stringWithFormat:@"诊断: %@",self.personInfo.admissionDiagnosis];
                      break;
                }
                case 3:{
                     tempLabel.text = [NSString stringWithFormat:@"过敏史: %@",self.personInfo.allergicHistory];
                      break;
                }
                case 4:{
                      tempLabel.text = [NSString stringWithFormat:@"处置: %@", self.personInfo.medicalTreatment];
                      break;
                }
                default:{
                    NSLog(@"error");
                    break;
                }
            }
            
        }
    }
    
}
-(void)updateSubviewsFrame
{
    if(_changeViewFlag){
        CGFloat personInfoWidth = (2 * (self.frame.size.width)) / 5 ;
        CGFloat  y = 5;
        CGFloat baseX = 5;
        CGFloat  width = 1 * personInfoWidth/5;
        CGFloat height = self.frame.size.height - 2 * gap;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(baseX, y, personInfoWidth, height);
        
        self.button = button;
        
        for(int i=0; i<4; i++)
        {
            
            CGRect tempRect;
            if(i==0){
                tempRect = CGRectMake(baseX, y, width * 2 , height);
            }else {
                tempRect = CGRectMake(baseX + i * width + width, y, width  , height);
            }
            
            UILabel *tempLabel = [self.labelsArray objectAtIndex:i];
            tempLabel.frame = tempRect;
            
        }
        
        
        CGFloat otherInfoWidth = (3 * (self.frame.size.width-10))/5;
        
        CGFloat baseX1 = personInfoWidth + 5;
        CGFloat width1 = otherInfoWidth/3;
        
        for(int j=4;j<7;j++){
           // CGRect labelRect = CGRectMake(baseX1 + (j-4) * width1, y, j==6?(width1-3):width1, height);
            CGRect labelRect = CGRectMake(baseX1 + (j-4) * width1, y, width1, height);
            UILabel *otherLabel = [self.labelsArray objectAtIndex:j];
            otherLabel.frame = labelRect;
        }
    }else {
       self.tempView.frame = CGRectMake(5, 5, self.frame.size.width-5, self.frame.size.height - 2 * gap);
       
        CGFloat medicalModelWidth = (self.frame.size.width-10)/2;
        CGFloat yM = 5;
        CGFloat xM = 5;
        CGFloat medicalModeHeight = self.frame.size.height - 2 * gap;
        
        for(int k=0; k<3;k++) {
            CGRect modelFrame;
//            if(k==0){
//                modelFrame = CGRectMake(xM, yM, medicalModelWidth/2, medicalModeHeight);
//            }else {
//                modelFrame = CGRectMake(xM + medicalModelWidth/2 + (k-1) * medicalModelWidth/4, yM, medicalModelWidth/4, medicalModeHeight);
//            }
            modelFrame = CGRectMake(xM + k * medicalModelWidth/3, yM, medicalModelWidth/3, medicalModeHeight);
            UILabel *modelLabel = [self.labelsArray objectAtIndex:k];
            modelLabel.frame = modelFrame;
            
        }
        
        for(int l=3;l<5;l++){
            UILabel *modelTempLabel = [self.labelsArray objectAtIndex:l];
            
            modelTempLabel.frame = CGRectMake(medicalModelWidth + (l-3) * medicalModelWidth/2, yM, medicalModelWidth/2 +4, medicalModeHeight);
            
        }
        
    }
   
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateSubviewsFrame];
  
}
-(void)clearSubviews
{
    [super clearSubviews];
    for(UIView *subView in self.subviews){
        [subView removeFromSuperview];
    }
    
    for (UIGestureRecognizer *gestureRec in self.gestureRecognizers) {
        [self removeGestureRecognizer:gestureRec];
    }
    [self.labelsArray removeAllObjects];
    [self.button removeFromSuperview];
}

@end
