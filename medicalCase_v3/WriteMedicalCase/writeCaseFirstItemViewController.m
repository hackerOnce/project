//
//  writeCaseFirstItemViewController.m
//  WriteMedicalCase
//
//  Created by GK on 15/5/2.
//  Copyright (c) 2015年 GK. All rights reserved.
//

#import "writeCaseFirstItemViewController.h"

@interface writeCaseFirstItemViewController ()
@property (weak, nonatomic) IBOutlet UIButton *navButton;
@property (weak, nonatomic) IBOutlet AutoHeightTextView *textView;

@end

@implementation writeCaseFirstItemViewController
- (IBAction)cancelButton:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)saveButtonClicked:(UIButton *)sender
{
    [self.delegate didWriteWithString:self.textView.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navButton.layer.cornerRadius = self.navButton.frame.size.width/2;
    self.navButton.backgroundColor = [UIColor whiteColor];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.textView.text = self.textViewContent;

    self.title = self.titleString;
    [self.textView becomeFirstResponder];
}
 -(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
}
@end
