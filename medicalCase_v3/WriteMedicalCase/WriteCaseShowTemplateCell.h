//
//  WriteCaseShowTemplateCell.h
//  WriteMedicalCase
//
//  Created by ihefe-JF on 15/4/30.
//  Copyright (c) 2015年 GK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteCaseShowTemplateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *createPeople;
@property (weak, nonatomic) IBOutlet AutoHeightTextView *textView;

@end
