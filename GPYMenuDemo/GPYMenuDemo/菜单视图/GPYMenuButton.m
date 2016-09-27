//
//  GPYMenuButton.m
//  BeautyMall
//
//  Created by mac on 15/12/7.
//  Copyright (c) 2015年 GPY. All rights reserved.
//

#import "GPYMenuButton.h"

@implementation GPYMenuButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)setItemTitle:(NSString *)itemTitle{
    _itemTitle=itemTitle;
    
    [self setBackgroundImage:[UIImage imageNamed:@"bg_btn_gray"] forState:UIControlStateHighlighted];
    [self setTitle:itemTitle forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //button设置圆角
    self.layer.borderWidth=1.0;
    self.layer.borderColor=[UIColor grayColor].CGColor;
    self.layer.cornerRadius=self.frame.size.height/2;
    self.clipsToBounds=YES;
    
    
    _deleteButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
   
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"closead"] forState:UIControlStateNormal];
    [self addSubview:_deleteButton];
    _deleteButton.hidden=YES;
    
}
-(void)setIsSelected:(BOOL)isSelected{
    _isSelected=isSelected;
    if(isSelected==YES){
    [self setBackgroundColor:[UIColor colorWithRed:251/255.0 green:39/255.0 blue:107/255.0 alpha:1]];
}}

-(void)setIsDeleted:(BOOL)isDeleted{
    _isDeleted=isDeleted;
   
    if(isDeleted){
        _deleteButton.hidden=NO;
    }else{
        _deleteButton.hidden=YES;
    }
}
@end
