//
//  ViewController.m
//  GPYMenuDemo
//
//  Created by mac on 15/12/16.
//  Copyright © 2015年 GPY. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()<GPYMenuManageProtocol,GPYScrollMenuViewProtocol>
{
    GPYScrollMenuView *scrollMenu;
    GPYMenuView *menuManageView;
    CGFloat screenWidth;
    CGFloat screenHeight;
    
    NSArray *menuArray;
    
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    screenWidth=[UIScreen mainScreen].bounds.size.width;
    screenHeight=[UIScreen mainScreen].bounds.size.height;
    
    NSArray *titleArray=@[@"德玛",@"瑞兹",@"寒冰",@"诺克",@"剑圣",@"瑞文",@"武器",@"雷克赛",@"千珏",@"艾克",@"塔姆"];
    menuArray=titleArray;
    
    scrollMenu=[[GPYScrollMenuView alloc]initWithFrame:CGRectMake(0, 20, screenWidth-40, 40)];
    
    [scrollMenu setNameWithArray:titleArray];
    scrollMenu.menuDelegate=self;
    [self.view addSubview:scrollMenu];
    
    
    menuManageView=[[GPYMenuView alloc]initWithFrame:CGRectMake(0, -screenHeight+20, screenWidth, screenHeight-20)];
    menuManageView.itemArray=titleArray;
    menuManageView.delegate=self;
    [self.view addSubview:menuManageView];
    menuManageView.hidden=YES;
    
}
#pragma mark --GPYMenuManageProtocol
-(void)getNewSortArray:(NSArray *)array{
    menuArray=array;
    scrollMenu.menuArray=array;
}
-(void)seletedItemAtIndex:(int)index{
    scrollMenu.selectedIndex=index;
    _showLabel.text=menuArray[index];
    self.isExpandMenuView=NO;
}

#pragma mark --GPYScrollMenuViewProtocol
-(void)gpyScrollMenuSelectItemAtIndex:(NSInteger)index{
    _showLabel.text=menuArray[index];
}


- (IBAction)moreAction:(id)sender {
    self.isExpandMenuView=!_isExpandMenuView;
}

-(void)setIsExpandMenuView:(BOOL)isExpandMenuView{
    _isExpandMenuView=isExpandMenuView;
    if(isExpandMenuView){
        scrollMenu.hidden=YES;
        menuManageView.hidden=NO;
        
        [UIView animateWithDuration:0.2 animations:^{
             menuManageView.frame=CGRectMake(0, 20, screenWidth, screenHeight-20);
        } completion:^(BOOL finished) {
            [self.view bringSubviewToFront:_operateButton];
        }];
    }else{
      [UIView animateWithDuration:0.2 animations:^{
          menuManageView.frame=CGRectMake(0, -screenHeight+20, screenWidth, screenHeight);
      } completion:^(BOOL finished) {
          scrollMenu.hidden=NO;
          menuManageView.hidden=YES;
          
      }];
    }
    
}
@end
