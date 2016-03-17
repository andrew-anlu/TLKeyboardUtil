//
//  TLViewController.m
//  TLKeyboardUtil
//
//  Created by Andrew on 03/16/2016.
//  Copyright (c) 2016 Andrew. All rights reserved.
//

#import "TLViewController.h"
#import <TLKeyboardUtil/TLKeyboardUtil.h>
#import <TLKeyboardUtil/TL_Config.h>
#import "TLAppDelegate.h"
#import "TLKeyBoardTestVc.h"
#import "TLScrollViewController.h"



@interface TLViewController ()

@end

@implementation TLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    CGFloat originX=SCREEN_WIDTH/2-200/2;
    
    CGRect rect=CGRectMake(originX, 100, 200, 30);
    UIButton *btn1=[self createBtn:rect title:@"普通View"];
    [btn1 addTarget:self action:@selector(skipAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    rect=CGRectMake(originX, CGRectGetMaxY(btn1.frame)+20, 200, 30);
    UIButton *btn2=[self createBtn:rect title:@"在ScrollView中"];
    [btn2 addTarget:self action:@selector(skipScrollViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];

   
}

-(UIButton *)createBtn:(CGRect)rect title:(NSString *)title{
    UIButton *btn=[[UIButton alloc]initWithFrame:rect];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    return btn;
}

-(void)skipAction:(UIButton*)sender{
    TLKeyBoardTestVc *vc=[[TLKeyBoardTestVc alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)skipScrollViewAction:(UIButton*)sender{
    TLScrollViewController *vc=[[TLScrollViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}




@end
