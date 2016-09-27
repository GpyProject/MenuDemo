//
//  GPYMenuView.h
//  BeautyMall
//
//  Created by mac on 15/12/7.
//  Copyright (c) 2015年 GPY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPYMenuButton.h"

@protocol GPYMenuManageProtocol<NSObject>

-(void)seletedItemAtIndex:(int)index;
-(void)getNewSortArray:(NSArray *)array;

@end

@interface GPYMenuView : UIView


@property(nonatomic,assign)id <GPYMenuManageProtocol> delegate;

@property(nonatomic,strong)UIScrollView *menuScroll;
@property(nonatomic,strong)NSArray *itemArray;
@property(nonatomic,assign)NSInteger *selectedIndex;
@property(nonatomic,assign)BOOL isEditing;

@property(nonatomic,strong)GPYMenuButton *selectedItem;

-(void)setItemArray:(NSArray *)itemArray;


@end
