//
//  TLScrollViewController.m
//  TLKeyboardUtil
//
//  Created by Andrew on 16/3/17.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import "TLScrollViewController.h"
#import <TLKeyboardUtil/TLKeyboardUtil.h>
#import <TLKeyboardUtil/TL_Config.h>

@interface TLScrollViewController ()
@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)UISearchBar *searchBar;

@property (nonatomic,strong)UITextField *nameField;

@end

@implementation TLScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self initView];
    TLKeyboardUtil *keyboardUtil=[TLKeyboardUtil sharedInstance];
    [keyboardUtil addKeyboardAutoPopWithView:self.view];
   
}

-(void)initView{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT-100)];
    _scrollView.backgroundColor=[UIColor yellowColor];
    [self.view addSubview:_scrollView];
    
    CGFloat originX=10;
    CGFloat originY=20;
    
    CGFloat width=SCREEN_WIDTH-originX*2;
    CGFloat height=35;
    
    CGRect rect=CGRectMake(originX, originY, width, height);
    _searchBar=[[UISearchBar alloc]initWithFrame:rect];
    [_scrollView addSubview:_searchBar];
    
    
    rect=CGRectMake(originX, CGRectGetMaxY(_searchBar.frame)+20, width, height);
    _textField=[[UITextField alloc]initWithFrame:rect];
    _textField.borderStyle=UITextBorderStyleLine;
    _textField.placeholder=@"请输入你的格言";
    [_scrollView addSubview:_textField];
    
    rect=CGRectMake(originX, CGRectGetMaxY(_textField.frame)+20, width, height);
    _nameField=[[UITextField alloc]initWithFrame:rect];
    _nameField.borderStyle=UITextBorderStyleLine;
    _nameField.placeholder=@"请输入名字";
    [_scrollView addSubview:_nameField];
    
    rect=CGRectMake(originX,_scrollView.frame.size.height-120-64, width, 100);
    _textView=[[UITextView alloc]initWithFrame:rect];
    _textView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    _textView.font=[UIFont systemFontOfSize:20];
    _textView.text=@"请输入简介";
    [_scrollView addSubview:_textView];
    
}


@end
