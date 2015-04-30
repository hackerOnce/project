//
//  Show3DCollectionViewCell.m
//  MedCase
//
//  Created by ihefe-JF on 15/1/16.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import "Show3DCollectionViewCell.h"

@implementation Show3DCollectionViewCell

-(void)drawRect:(CGRect)rect
{
    CGRect insetRect = CGRectInset(rect, 0.5, 0.5);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:insetRect cornerRadius:rect.size.height/2.0];
    
    // white background
    [[UIColor whiteColor] setFill];
    [path fill];
    
    // red outline
    [[UIColor redColor] setStroke];
    [path stroke];
}
@end
