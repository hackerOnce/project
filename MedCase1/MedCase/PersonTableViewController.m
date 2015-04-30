//
//  PersonTableViewController.m
//  MedicalRecord
//
//  Created by ihefe-JF on 14/12/26.
//  Copyright (c) 2014年 JFAppHourse.app. All rights reserved.
//

#import "PersonTableViewController.h"
#import "PersonInfo.h"
#import "HUNavigationBarView.h"
#import "HUPersonTableViewCell.h"
#import "RawDataProcess.h"


@interface PersonTableViewController () <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSMutableArray *persons;
@end


//static NSString *didSelectedRowNotificationName = @"DidSelectedRowNotificationName";

@implementation PersonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preferredContentSize = CGSizeMake(350, 560);
    self.view.autoresizesSubviews = YES;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    //self.tableView.backgroundColor = [UIColor whiteColor];
   // self.view.backgroundColor = [UIColor clearColor];
    //加载数据
    
   
    PersonInfo *p1 = [[PersonInfo alloc] initWithName:@"张三" age:@"22" gender:@"女" location:@"102床" admissionDiagnosis:@"熊猫眼" medicalTreatment:@"不知" allergicHistory:@"青霉素霍敏"];
    p1.ID = @"test1";
    PersonInfo *p2 = [[PersonInfo alloc] initWithName:@"里回到家" age:@"102" gender:@"女" location:@"102床" admissionDiagnosis:@"熊猫眼" medicalTreatment:@"不" allergicHistory:@"青敏"];
    p2.ID = @"test2";
    
     PersonInfo *p3 = [[PersonInfo alloc] initWithName:@"张三" age:@"222" gender:@"男" location:@"10床" admissionDiagnosis:@"猫眼" medicalTreatment:@"知道不" allergicHistory:@"霉素霍敏"];
   
     p3.ID = @"test3";
     PersonInfo *p4 = [[PersonInfo alloc] initWithName:@"张三" age:@"222" gender:@"女" location:@"1床" admissionDiagnosis:@"熊眼" medicalTreatment:@"不知不" allergicHistory:@"青霉敏" ];
    
     p4.ID = @"test4";
     PersonInfo *p5 = [[PersonInfo alloc] initWithName:@"张三" age:@"2" gender:@"女" location:@"102床" admissionDiagnosis:@"熊猫眼" medicalTreatment:@"知不" allergicHistory:@"青素霍敏" ];
    
     p5.ID = @"test5";
    self.persons = [[NSMutableArray alloc] init];
    [self.persons addObject:p1];
    [self.persons addObject:p2];
    [self.persons addObject:p3];
    [self.persons addObject:p4];
    [self.persons addObject:p5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.persons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HUPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HUPersonInfoCell"];

    if(cell == nil){
        
        cell = [[HUPersonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HUPersonInfoCell"];
    }
    PersonInfo *person = [self.persons objectAtIndex:indexPath.row];
    
    // Configure the cell...
//    cell.nameLabel.text = person.name;
//    cell.locationLabel.text = person.loction;
//    cell.ageLabel.text = person.age;
//    cell.genderLabel.text = person.gender;
    
    UILabel *nameLabel = (UILabel*)[cell viewWithTag:1001];
    nameLabel.text = person.name;
    
    UILabel *locationLabel = (UILabel*)[cell viewWithTag:1002];
    locationLabel.text = person.loction;
    
    UILabel *genderLabel = (UILabel*)[cell viewWithTag:1003];
    genderLabel.text = person.gender;
    
    UILabel *ageLabel = (UILabel*)[cell viewWithTag:1004];
    ageLabel.text = person.age;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PersonInfo *person = [self.persons objectAtIndex:indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:didSelectedRowNotificationName object:person];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
