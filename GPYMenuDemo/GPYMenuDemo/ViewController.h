//
//  ViewController.h
//  GPYMenuDemo
//
//  Created by mac on 15/12/16.
//  Copyright © 2015年 GPY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPYMenuView.h"
#import "GPYScrollMenuView.h"

@interface ViewController : UIViewController

@property(nonatomic,weak)IBOutlet UILabel *showLabel;

@property(nonatomic,weak)IBOutlet UIButton *operateButton;

@property(nonatomic)BOOL isExpandMenuView;

- (IBAction)moreAction:(id)sender;


@end

