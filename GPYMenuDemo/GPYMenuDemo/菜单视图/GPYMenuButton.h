//
//  GPYMenuButton.h
//  BeautyMall
//
//  Created by mac on 15/12/7.
//  Copyright (c) 2015年 GPY. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,GPYMenuButtonState){
  GPYMenuButtonStateNormal,
  GPYMenuButtonStateDelete,
    
};

@interface GPYMenuButton : UIButton

@property(nonatomic,strong)UIButton *deleteButton;
@property(nonatomic,copy)NSString *itemTitle;
@property(nonatomic)CGRect originFrame;
@property(nonatomic)int itemIndex;
@property(nonatomic)BOOL isDeleted;
@property(nonatomic)BOOL isSelected;

@end
