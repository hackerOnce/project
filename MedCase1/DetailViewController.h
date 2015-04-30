//
//  DetailViewController.h
//  MedCase
//
//  Created by ihefe-JF on 15/3/5.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DetailViewCOntrollerDelegate <NSObject>
@required
-(void)selectedDetailItems:(NSArray*)arr withSring:(NSString*)str withSelectedIndexPath:(NSIndexPath*)indexPath withRemoveItems:(NSArray *)items;

@end

@interface DetailViewController : UIViewController

@property (nonatomic,strong) NSString *titleString;
@property (nonatomic,strong) NSIndexPath *detailSelectedIndexPath;

@property (nonatomic,strong) WLKCaseNode *detailNode;
@property (nonatomic,weak) id <DetailViewCOntrollerDelegate> detailDelegate;
@end
