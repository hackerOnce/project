//
//  ManualInputTextViewController.m
//  MedCase
//
//  Created by ihefe-JF on 15/1/22.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import "ManualInputTextViewController.h"
#import "ConstantVariable.h"

@interface ManualInputTextViewController () <UITextViewDelegate>

@property (nonatomic,strong) NSString *inputText;

@property (nonatomic) BOOL interrupt;
@end


@implementation ManualInputTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interrupt = NO;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.inputTextView.text = self.textStrng;
    
    [self registerNotificationForKeyboard];
    
    [self.inputTextView becomeFirstResponder];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if(![self.inputText isEqualToString:@""]){
         [self postNotification];
    }
   
}
-(void)registerNotificationForKeyboard
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

//-(void)keyboardWillShow:(NSNotification *)aNotification
//{
//}
//-(void)keyboardWillHide:(NSNotification *)aNotification
//{
//    
//}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    self.inputText = text;
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    self.inputText = textView.text;
    
}
-(void)postNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kInputTextCompleted object:self.inputText];
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
