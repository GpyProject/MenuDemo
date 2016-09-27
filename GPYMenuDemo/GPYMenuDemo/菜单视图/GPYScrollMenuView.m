//
//  GPYScrollMenuView.m
//  BeautyMall
//
//  Created by mac on 15/12/7.
//  Copyright (c) 2015年 GPY. All rights reserved.
//

#import "GPYScrollMenuView.h"

@interface MenuItem : UIButton
@property(nonatomic,strong)NSString *itemTitle;
@end
@implementation MenuItem



@end

@interface GPYScrollMenuView()
{
    NSMutableArray *showItemArray;
    NSMutableArray *dropItemArray;
    NSMutableArray *allItemArray;
    CGFloat itemWidth;
    CGFloat itemHeight;
}
@end

@implementation GPYScrollMenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setNameWithArray:(NSArray *)menuArray{
    self.showsHorizontalScrollIndicator=NO;
    self.showsVerticalScrollIndicator=NO;
    _menuArray=menuArray;
    allItemArray=[[NSMutableArray alloc]initWithCapacity:menuArray.count];
    showItemArray=[[NSMutableArray alloc]initWithCapacity:menuArray.count];
    dropItemArray=[[NSMutableArray alloc]initWithCapacity:0];
     itemWidth=self.frame.size.width/5;
    itemHeight=self.frame.size.height;
    self.contentSize=CGSizeMake(itemWidth*menuArray.count, itemHeight);
    for (int i=0; i<menuArray.count; i++) {
        MenuItem *menuButton=[[MenuItem alloc]initWithFrame:CGRectMake(itemWidth*i, 5, itemWidth, 30)];
        menuButton.tag=i;
        menuButton.itemTitle=menuArray[i];
        [menuButton setTitle:menuArray[i] forState:UIControlStateNormal];
        [menuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuButton];
        [showItemArray addObject:menuButton];
        [allItemArray addObject:menuButton];
    }

    
    CGFloat height=self.frame.size.height;
    UIImageView *markLine=[[UIImageView alloc]initWithFrame:CGRectMake(5, height-2.5, itemWidth-10, 2.5)];
    markLine.tag=10086;
    markLine.backgroundColor=[UIColor colorWithRed:251/255.0 green:39/255.0 blue:107/255.0 alpha:1];
    
    [self addSubview:markLine];
    
}
-(void)setMenuArray:(NSArray *)menuArray{
    _menuArray=menuArray;
    
    self.contentSize=CGSizeMake(itemWidth*menuArray.count, itemHeight);
     NSInteger oldCount=showItemArray.count;
    //根据得到的新数组重新排序  
    for (int i=0;i<menuArray.count;i++) {
        NSString *titile=menuArray[i];
        for (MenuItem *item in allItemArray) {
            if([item.itemTitle isEqualToString:titile]){
                item.tag=i;
                item.frame=CGRectMake(itemWidth*i, 0, itemWidth, itemHeight);
                if([showItemArray containsObject:item]){
                    [showItemArray removeObject:item];
                    [showItemArray insertObject:item atIndex:i];
                }
//                else if ([dropItemArray containsObject:item]){
//                    [dropItemArray removeObject:item];
//                    [showItemArray insertObject:item atIndex:i];
//                }
            }
        }
    }
  if(menuArray.count<=oldCount){
        //删除菜单选项  放到重用数组中
      
        for (NSInteger i=menuArray.count;i<oldCount;i++) {
            MenuItem *btn=showItemArray[i];
            btn.hidden=YES;
            [dropItemArray addObject:btn];
        }
        for (MenuItem *btn in dropItemArray) {
            [showItemArray removeObject:btn];
        }
      
    }else if(menuArray.count>oldCount&&dropItemArray.count!=0){
       //如果添加了新的菜单选项 在重用数组中找到选项并且添加到showItemArray的最后面
        for (NSInteger i=oldCount; i<menuArray.count; i++) {
            NSString *itemTitle=menuArray[i];
            for (MenuItem *item in dropItemArray) {
                if([item.itemTitle isEqualToString:itemTitle]){
                    item.hidden=NO;
                    [showItemArray addObject:item];
                    [dropItemArray removeObject:item];
                    break;
                }
            }
        }
        
    }
    
    for (int i = 0; i<menuArray.count; i++) {
        MenuItem *btn=showItemArray[i];
        btn.tag=i;
        btn.frame=CGRectMake(itemWidth*i, 0, itemWidth, itemHeight);
    }
    if(menuArray.count<=_selectedIndex){
        self.selectedIndex=menuArray.count-1;
    }
}
-(void)btnClick:(UIButton *)sender{
    
    self.selectedIndex=(int)sender.tag;
    
 
    if([self.menuDelegate respondsToSelector:@selector(gpyScrollMenuSelectItemAtIndex:)]){
        [self.menuDelegate gpyScrollMenuSelectItemAtIndex:sender.tag];
    }
}
-(void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex=selectedIndex;
    
    MenuItem *btn=showItemArray[selectedIndex];
    
    
    for (MenuItem *item in showItemArray) {
        if (item==btn) {
            [item setTitleColor:[UIColor colorWithRed:250/255.0 green:42/255.0 blue:111/255.0 alpha:1] forState:UIControlStateNormal];
        }else{
          [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
    UIImageView *markView=(UIImageView *)[self viewWithTag:10086];
    
    [UIView animateWithDuration:0.2f animations:^{
        
        markView.center=CGPointMake(btn.center.x, markView.center.y);
        
        
    } completion:^(BOOL finished) {
        if( selectedIndex>2&&selectedIndex<=_menuArray.count-3){
            [UIView animateWithDuration:0.1f animations:^{
                
                self.contentOffset=CGPointMake(itemWidth*(selectedIndex-2), 0);
                
            }];
        }else if(selectedIndex<=2){
            [UIView animateWithDuration:0.1f animations:^{
                
                self.contentOffset=CGPointMake(0, 0);
                
            }];
        }else if(selectedIndex>showItemArray.count-3){
            self.contentOffset=CGPointMake(itemWidth*(_menuArray.count-3-2), 0);
        }
    }];
}
@end
