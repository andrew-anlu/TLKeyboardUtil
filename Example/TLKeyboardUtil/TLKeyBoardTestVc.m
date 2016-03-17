//
//  TLKeyBoardTestVc.m
//  TLKeyboardUtil
//
//  Created by Andrew on 16/3/17.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import "TLKeyBoardTestVc.h"
#import <TLKeyboardUtil/TLKeyboardUtil.h>
#import <TLKeyboardUtil/TL_Config.h>


@interface TLKeyBoardTestVc()
@property (nonatomic,strong)UITextField *field1;
@property (nonatomic,strong)UITextField *field2;
@property (nonatomic,strong)UITextField *field3;
@property (nonatomic,strong)UITextField *field4;
@property (nonatomic,strong)UITextField *field5;

@property (nonatomic,strong)UITextView *descTxtView;
@end

@implementation TLKeyBoardTestVc

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self initView];
    TLKeyboardUtil *keyboardUtil=[TLKeyboardUtil sharedInstance];
    [keyboardUtil addKeyboardAutoPopWithView:self.view];

}

-(void)initView{
    
    CGRect rect=CGRectMake(20, 150, 200, 30);
    _field1=[self createField:rect titie:@"我是输入框1"];
    [self.view addSubview:_field1];
    
    
    rect=CGRectMake(_field1.frame.origin.x, CGRectGetMaxY(_field1.frame)+15, _field1.frame.size.width, _field1.frame.size.height);
    _field2=[self createField:rect titie:@"我是输入框2"];
    
    
    rect=CGRectMake(20, CGRectGetMaxY(_field2.frame)+20, 200, 30);
    _field3=[self createField:rect titie:@"我是输入框3"];
    
    
    rect=CGRectMake(20, 80, 200, 30);
    _field5=[self createField:rect titie:@"我是输入框5"];
    
    
    rect=CGRectMake(10, 10,SCREEN_WIDTH-10*2, 50);
    UIView *mainView=[[UIView alloc]initWithFrame:rect];
    mainView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    
    
    rect=CGRectMake(10, 10, 280, 30);
    _field4=[self createField:rect titie:@"我是嵌套在一个子View的输入框4"];
    
    rect=CGRectMake(10, SCREEN_HEIGHT-64-110, SCREEN_WIDTH-20, 100);
    _descTxtView=[[UITextView alloc]initWithFrame:rect];
    _descTxtView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_descTxtView];
    
    
    [self.view addSubview:_field5];
    [self.view addSubview:mainView];
    [self.view addSubview:_field2];
    [self.view addSubview:_field3];
    
    [mainView addSubview:_field4];
    
    UIWindow *window=[UIApplication sharedApplication].delegate.window;
    
    CGPoint windowPoint = [_field1.superview convertPoint:_field1.frame.origin toView:window];
    NSLog(@"_field1=%@",NSStringFromCGPoint(windowPoint));
    
    windowPoint = [_field2.superview convertPoint:_field2.frame.origin toView:window];
    NSLog(@"_field2=%@",NSStringFromCGPoint(windowPoint));
    
    windowPoint = [_field3.superview convertPoint:_field3.frame.origin toView:[[UIApplication sharedApplication] keyWindow]];
    NSLog(@"_field3=%@",NSStringFromCGPoint(windowPoint));
    
    
    windowPoint = [_field4 convertPoint:_field4.frame.origin toView:[[UIApplication sharedApplication] keyWindow]];
    NSLog(@"_field4=%@",NSStringFromCGPoint(windowPoint));
    
    
    windowPoint = [_field5 convertPoint:_field5.frame.origin toView:[[UIApplication sharedApplication] keyWindow]];
    NSLog(@"_field5=%@",NSStringFromCGPoint(windowPoint));
    
    
}
-(UITextField *)createField:(CGRect)rect titie:(NSString*)title{
    UITextField *field=[[UITextField alloc]initWithFrame:rect];
    field.placeholder=title;
    field.borderStyle=UITextBorderStyleLine;
    return field;
}
@end
