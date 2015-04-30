
//
//  HUDiseaseClassificationCollectionViewCell.m
//  MedicalRecord
//
//  Created by ihefe-JF on 14/12/31.
//  Copyright (c) 2014年 JFAppHourse.app. All rights reserved.
//

#import "HUDiseaseClassificationCollectionViewCell.h"
#import "KeyValueObserver.h"

@interface HUDiseaseClassificationCollectionViewCell()

@property (nonatomic,strong) id cellStateToken;
@property (weak, nonatomic) IBOutlet UIView *dotView;

@end

@implementation HUDiseaseClassificationCollectionViewCell


-(void)awakeFromNib
{
   
   
    
    UILabel *tempLabel = (UILabel*)[self viewWithTag:1000];

    
    tempLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
   
    self.buttonState = ButtonStateUnKnow;
   
    //tempLabel.layer.borderWidth = 1;
   
    
    //self.clipsToBounds = YES;
  

}

-(void)setCellNode:(WLKCaseNode *)cellNode
{
    _cellNode = nil;
    _cellNode = cellNode;
    
    
}
-(void)setButtonState:(ButtonState)buttonState
{
    _buttonState = buttonState;
    UILabel *tempLabel = (UILabel*)[self viewWithTag:1000];
    
    if(_buttonState == ButtonStateUnKnow){
        
        tempLabel.backgroundColor = [UIColor whiteColor];
        tempLabel.textColor = [UIColor darkGrayColor];

        self.layer.borderColor = [UIColor colorWithRed:179.0/255 green:179.0/255 blue:179.0/255 alpha:1].CGColor;
        self.layer.borderWidth = 1;
        
    }else if(_buttonState == ButtonStateSelected){
        
        tempLabel.backgroundColor = [UIColor whiteColor];
        tempLabel.textColor = [UIColor colorWithRed:74.0/255 green:144.0/255 blue:226.0/255 alpha:1];
       
        self.layer.borderColor = [UIColor colorWithRed:74.0/255 green:144.0/255 blue:226.0/255 alpha:1].CGColor;
        self.layer.borderWidth = 1;
        
    }else if(_buttonState == ButtonStateKeepSelected){
        
        tempLabel.backgroundColor = [UIColor colorWithRed:74.0/255 green:144.0/255 blue:226.0/255 alpha:1];
        tempLabel.textColor = [UIColor whiteColor];
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithRed:74.0/255 green:144.0/255 blue:226.0/255 alpha:1].CGColor;
    }
}

-(void)configCell
{
    UILabel *tempLabel = (UILabel*)[self viewWithTag:1000];
   // [self.cellButton setTitle:self.cellNode.nodeName forState:UIControlStateNormal];
    tempLabel.text  = self.cellNode.nodeName;
}
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    self.layer.cornerRadius = CGRectGetWidth(self.frame)/2;
    self.dotView.layer.cornerRadius = 3;
    self.dotView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.dotView.layer.borderWidth = 1;
    self.dotView.backgroundColor = [UIColor whiteColor];
}
@end
