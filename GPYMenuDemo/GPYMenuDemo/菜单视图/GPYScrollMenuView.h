//
//  GPYScrollMenuView.h
//  BeautyMall
//
//  Created by mac on 15/12/7.
//  Copyright (c) 2015年 GPY. All rights reserved.
//

#import <UIKit/UIKit.h>
//自定义协议
@protocol GPYScrollMenuViewProtocol <NSObject>

-(void)gpyScrollMenuSelectItemAtIndex:(NSInteger)index;

@end
@interface GPYScrollMenuView : UIScrollView

@property(nonatomic,strong)NSArray* menuArray;
@property(nonatomic)NSInteger selectedIndex;
- (void)setNameWithArray:(NSArray *)menuArray;
@property(nonatomic,assign)id <GPYScrollMenuViewProtocol> menuDelegate;

@end
