//
//  HUPersonTableViewCell.h
//  MedicalRecord
//
//  Created by ihefe-JF on 14/12/26.
//  Copyright (c) 2014年 JFAppHourse.app. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonInfo.h"

@interface HUPersonTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

-(void)configCellWith:(PersonInfo*)personInfo;

@end
