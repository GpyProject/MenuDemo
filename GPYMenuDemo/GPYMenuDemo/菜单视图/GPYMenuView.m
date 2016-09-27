//
//  GPYMenuView.m
//  BeautyMall
//
//  Created by mac on 15/12/7.
//  Copyright (c) 2015年 GPY. All rights reserved.
//

#import "GPYMenuView.h"
#import "DotButtonView.h"
@interface GPYMenuView()
{
    NSArray *showItemsArray;
    NSMutableArray *dropItemsArray;
    NSMutableArray *buttonArray;
    NSMutableArray *dotViewArray;
    NSMutableArray *dropDotViewArray;
    UIView *dropView;
    UIButton *keyButton;
}
@end

@implementation GPYMenuView

-(void)setItemArray:(NSArray *)itemArray{
    [self setBackImage];
    UILabel *leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 30)];
    leftLabel.text=@"切换栏目";
    [self addSubview:leftLabel];
    showItemsArray=itemArray;
    dropItemsArray=[[NSMutableArray alloc]initWithCapacity:0];
    dropDotViewArray=[[NSMutableArray alloc]initWithCapacity:0];
    //排序删除
    [self setKeyButton];
    
    [self setShowItemsView];
    [self setDropView];
}

-(void)setKeyButton{
    keyButton=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-40-100-10, 5, 100, 30)];
    keyButton.layer.borderWidth=1.0;
    keyButton.layer.borderColor=[UIColor purpleColor].CGColor;
    keyButton.layer.cornerRadius=15;
    keyButton.tag=999;
    [keyButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [keyButton setTitle:@"排序删除" forState:UIControlStateNormal];
    [keyButton addTarget:self action:@selector(sortOrDelete:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:keyButton];
}
//排序删除
-(void)sortOrDelete:(UIButton *)sender{
    for(UIView *view in self.subviews){
        if([view isKindOfClass:[UIButton class]]){
            UIButton *btn=(UIButton *)view;
            if(btn.tag==sender.tag){
                self.isEditing=!self.isEditing;
            }
        }
    }
    
    
}

-(void)setBackImage{
    CGSize screenSize=[UIScreen mainScreen].bounds.size;
    UIView* _backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,screenSize.height)];
    _backView.backgroundColor=[UIColor whiteColor];
   
    [self addSubview:_backView];
    
    
}
-(void)setShowItemsView{
    CGFloat btnWidth=(self.frame.size.width-10*5)/4;
    CGFloat btnHeight=30;
    buttonArray=[[NSMutableArray alloc]initWithCapacity:showItemsArray.count-1];
    dotViewArray=[[NSMutableArray alloc]initWithCapacity:buttonArray.count];
    for (int i=0; i<showItemsArray.count; i++) {
          GPYMenuButton *btn=[[GPYMenuButton alloc]initWithFrame:CGRectMake(10+(10+btnWidth)*(i%4), 40+10+(10+btnHeight)*(i/4), btnWidth, btnHeight)];
        [btn addTarget:self action:@selector(buttonTouchUpInSide:) forControlEvents:UIControlEventTouchUpInside];
       
        
        [btn setItemTitle:showItemsArray[i]];
        if(i==0){
            btn.isDeleted=NO;
            btn.itemIndex=-1;
            btn.tag=110;
            [btn setBackgroundImage:[UIImage imageNamed:@"Guide_实点"] forState:UIControlStateHighlighted];
            btn.layer.borderWidth=0;
        }
        else{
            //添加虚线框
            DotButtonView *dotView=[[DotButtonView alloc]initWithFrame:btn.frame];
            dotView.layer.cornerRadius=dotView.bounds.size.height/2;
            dotView.clipsToBounds=YES;
            dotView.tag=i-1;
            dotView.backgroundColor=[UIColor clearColor];
            [self addSubview:dotView];
            dotView.hidden=YES;
            [dotViewArray addObject:dotView];
            
            //button添加拖动事件
            btn.itemIndex=i-1;
            btn.originFrame=btn.frame;
            [btn addTarget:self action:@selector(dragMoving: withEvent:) forControlEvents:UIControlEventTouchDragInside];
            //为每一个butoon添加一个观察者
            [btn addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
            //给每一个button添加一个长按手势
            UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
            longPress.minimumPressDuration=1.0f;
            [btn addGestureRecognizer:longPress];
            [btn.deleteButton addTarget:self action:@selector(deleteItem:) forControlEvents:UIControlEventTouchUpInside];
            [buttonArray addObject:btn];
        }
        

        [self addSubview:btn];
    }
    
}

-(void)longPress:(UILongPressGestureRecognizer *)recognizer{
    self.isEditing=YES;
}
#pragma mark 排序删除
-(void)setIsEditing:(BOOL)isEditing{
    _isEditing=isEditing;
    NSString *title=_isEditing?@"完成":@"排序删除";
    [keyButton setTitle:title forState:UIControlStateNormal];
    if(isEditing==YES){
        dropView.hidden=YES;
        for (DotButtonView *dot in dotViewArray) {
            dot.hidden=NO;
        }
        for (GPYMenuButton *btn in buttonArray) {
            btn.isDeleted=YES;
        }
    }else{
        //编辑完成 得到一个新的数组:
        NSMutableArray *newTitleArray=[[NSMutableArray alloc]initWithCapacity:buttonArray.count+1];
        GPYMenuButton *firstBtn=(GPYMenuButton *)[self viewWithTag:110];
        [newTitleArray addObject:firstBtn.itemTitle];
        [buttonArray enumerateObjectsUsingBlock:^(GPYMenuButton* obj, NSUInteger idx, BOOL *stop) {
            NSString *title=obj.itemTitle;
            [newTitleArray addObject:title];
        }];
        [_delegate getNewSortArray:newTitleArray];
        
        dropView.hidden=NO;
        for (DotButtonView *dot in dotViewArray) {
            dot.hidden=YES;
        }
        for (GPYMenuButton *btn in buttonArray) {
            btn.isDeleted=NO;
        }
    }
    
}
-(void)setDropView{
    GPYMenuButton *lastBtn=[buttonArray lastObject];
    dropView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lastBtn.frame)+10, self.frame.size.width, self.frame.size.height-10-CGRectGetMaxY(lastBtn.frame))];
    [self addSubview:dropView];
    UIImageView *titleImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, dropView.frame.size.width, 40)];
    
    titleImage.image=[UIImage imageNamed:@"yuike_item_bg_alphax_sp"];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 30)];
    label.text=@"点击添加更多栏目";
    [titleImage addSubview:label];
    [dropView addSubview:titleImage];
    UIScrollView *scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, dropView.frame.size.width, dropView.frame.size.height-40)];
    scroll.tag=10;
    [dropView addSubview:scroll];
    [self refreshDropView];
}
-(void)refreshDropView{
    GPYMenuButton *lastBtn=nil;
    if(buttonArray.count!=0){
     lastBtn=[buttonArray lastObject];
    }else{
        lastBtn=(GPYMenuButton *)[self viewWithTag:110];
    }
  
  dropView.frame=CGRectMake(0, CGRectGetMaxY(lastBtn.frame)+10, dropView.frame.size.width, self.frame.size.height-10-CGRectGetMaxY(lastBtn.frame));
    UIScrollView *scroll=(UIScrollView *)[dropView viewWithTag:10];
    scroll.contentSize=CGSizeMake(scroll.frame.size.width, (10+lastBtn.bounds.size.height)* ceil(dropItemsArray.count/4));
    if(dropItemsArray.count!=0){
        for (int i =0 ; i<dropItemsArray.count; i++) {
            GPYMenuButton *btn=dropItemsArray[i];
            btn.itemIndex=i;
            btn.frame=CGRectMake(10+(btn.frame.size.width+10)*(i%4),10+(btn.frame.size.height+10)*(i/4),btn.frame.size.width,btn.frame.size.height );
            btn.originFrame=btn.frame;
            [scroll addSubview:btn];
            btn.hidden=NO;
        }
    }
}
//删除选项
-(void)deleteItem:(UIButton *)sender{
    GPYMenuButton *btn=(GPYMenuButton *)sender.superview ;
    [buttonArray removeObject:btn];
    [btn removeFromSuperview];
    DotButtonView *lastDot=[dotViewArray lastObject];
    [dotViewArray removeObject:lastDot];
    [dropDotViewArray addObject:lastDot];
    lastDot.hidden=YES;
    for (int i = btn.itemIndex; i<buttonArray.count; i++) {
        GPYMenuButton *btn=buttonArray[i];
        btn.itemIndex=i;
        DotButtonView *dot=dotViewArray[i];
        
        [UIView animateWithDuration:0.2 animations:^{
            btn.center=dot.center;
        }];
        btn.originFrame=btn.frame;
        [self bringSubviewToFront:btn];
    }
    btn.isDeleted=YES;
    btn.deleteButton.hidden=YES;
    [dropItemsArray addObject:btn];
    [self refreshDropView];
}
#pragma mark 拖动按钮
-(void)dragMoving:(GPYMenuButton *)btn withEvent:(UIEvent *)event
{
    if(self.isEditing){
        CGPoint point=[[[event allTouches] anyObject] locationInView:self];
        btn.center=point;
    }
}
#pragma mark --点击选项 buttonTouchUpInSide
-(void)buttonTouchUpInSide:(GPYMenuButton *)btn{
    if(self.isEditing){
       //编辑状态下
        if(btn.itemIndex==-1){
            return;
        }
        [UIView animateWithDuration:0.2 animations:^{
              btn.frame=btn.originFrame;
        }];
        
    }else{
    //正常状态下
     //点击下面的button执行上移动画 并刷新数组
        if(btn.isDeleted){
            //移除手势
           // [btn removeGestureRecognizer:<#(UIGestureRecognizer *)#>];
        
            if(btn.itemIndex!=dropItemsArray.count-1){
                for (int i=btn.itemIndex+1; i<dropItemsArray.count-1; i++) {
                    GPYMenuButton *dropItem=dropItemsArray[i];
                    GPYMenuButton *lastItem=dropItemsArray[i-1];
                    [UIView beginAnimations:nil context:nil];
                    //让后面的button补缺空位
                    [UIView setAnimationDuration:0.2];
                    dropItem.frame=lastItem.originFrame;
                    [UIView commitAnimations];
                }
            }
            [dropItemsArray removeObject:btn];
            [btn removeFromSuperview];
            [self addSubview:btn];
            //在上面最后一个button添加一个Dot
            for (DotButtonView *dot in dropDotViewArray) {
                if(dot.tag==buttonArray.count){
                    [dotViewArray addObject:dot];
                    //让button移动到上面
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.2];
                    btn.frame=dot.frame;
                    [UIView commitAnimations];
                    //设置button属性
                    btn.isDeleted=NO;
                    btn.originFrame=btn.frame;
                    btn.itemIndex=(int)buttonArray.count;
                    [buttonArray addObject:btn];
                    [self refreshDropView];
                    break;
                }
            }
            
            //返回刷新后的数组
            NSMutableArray *newTitleArray=[[NSMutableArray alloc]initWithCapacity:buttonArray.count+1];
            GPYMenuButton *firstBtn=(GPYMenuButton *)[self viewWithTag:110];
            [newTitleArray addObject:firstBtn.itemTitle];
            [buttonArray enumerateObjectsUsingBlock:^(GPYMenuButton* obj, NSUInteger idx, BOOL *stop) {
                NSString *title=obj.itemTitle;
                [newTitleArray addObject:title];
            }];
            [_delegate getNewSortArray:newTitleArray];
        }
        else{
            //正常状态下 点击上面的按钮
            //点击选中 并且刷新菜单
           
            if(btn.itemIndex==-1){
                [_delegate seletedItemAtIndex:0];
            }else{
              [_delegate seletedItemAtIndex:btn.itemIndex+1];
            }
        }
    }
    
}
//移动按钮 监听事件
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(GPYMenuButton *)object change:(NSDictionary *)change context:(void *)context{
    NSValue *new=change[@"new"];
    CGPoint point=[new CGPointValue];
   
    int oldIndex=object.itemIndex;
    int newIndex = -1;
    for (GPYMenuButton *btn in buttonArray) {
        if(btn!=object){
            CGRect rect=btn.frame;
            if(CGRectContainsPoint(rect, point)){
                newIndex=btn.itemIndex;
                //NSLog(@"new%d old%d",newIndex,oldIndex);
                break;
            }
        }
        
    }
    if(newIndex!=-1){
        [buttonArray removeObjectAtIndex:oldIndex];
        [buttonArray insertObject:object atIndex:newIndex];
        if(oldIndex>newIndex){
            //从后面往前面移动
            for (int i=newIndex+1; i<oldIndex+1; i++) {
                GPYMenuButton *btn=buttonArray[i];
                DotButtonView *dot=dotViewArray[i];
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.2];
                btn.frame=dot.frame;
                [UIView commitAnimations];
                
            }
        }
        else if(oldIndex <newIndex){
            //从前面往后面移动
            for (int i=newIndex; i>oldIndex; i--) {
                GPYMenuButton *btn=buttonArray[i-1];
                DotButtonView *dot=dotViewArray[i-1];
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.2];
                btn.frame=dot.frame;
                [UIView commitAnimations];
              
            }
            
        }
        DotButtonView *objDot=dotViewArray[newIndex];
        
        object.originFrame=objDot.frame;
        object.center=objDot.center;
        for (int i=0; i<buttonArray.count; i++) {
            GPYMenuButton *btn=buttonArray[i];
            btn.itemIndex=i;
            btn.originFrame=btn.frame;
            [self bringSubviewToFront:btn];
        }
        
     
    }
    
}
@end
