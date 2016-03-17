//
//  TLKeyboardUtil.m
//  Pods
//
//  Created by Andrew on 16/3/16.
//
//

#import "TLKeyboardUtil.h"
#import <UIKit/UIKit.h>
#import "TL_Config.h"
#import <objc/objc.h>
#import <objc/runtime.h>

/**
 *  存储所有输入框的字典{"输入框":"输入框的在window坐标系中的originY"}
    这是一个无序的，需要进行排序
 */
static NSString *keyAllSubviewsDict = @"keyAllSubviewsDict";
/**
 *  存储排序的输入框的数组
 */
static NSString *keyInputViewSubViewArray = @"keyInputViewSubViewArray";

//工具条的frame
#define TOOLBAR_FRAME  CGRectMake(0, 0, SCREEN_WIDTH, 40)


@interface TLKeyboardUtil()
/**
 *  键盘=>上一个
 */
@property (nonatomic,strong)UIBarButtonItem *prevBarBtn;
/**
 *  键盘=>下一个
 */
@property (nonatomic,strong)UIBarButtonItem *nextBarBtn;

@property (nonatomic,strong)UIToolbar *keyboardToolbar;

@property (nonatomic,strong)UITapGestureRecognizer *tapGesture;

/**
 *  根视图，里面可能包含了多了个UItextField,也有可能嵌套UITextfield。
 */
@property (nonatomic,weak)UIScrollView *rootScrollView;

@property CGSize scrollViewContentSize;

@end

@implementation TLKeyboardUtil

//初始化方法
-(void)initial{
    _keyboardToolbar=[self createToolbar:TOOLBAR_FRAME];
    
    NSNotificationCenter *notifCenter = [NSNotificationCenter defaultCenter];
    
    [notifCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [notifCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(instancetype)init{
    self=[super init];
    if(self){
        [self initial];
    }
    return self;
}

+(TLKeyboardUtil*)sharedInstance{
    static TLKeyboardUtil *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TLKeyboardUtil alloc]init];
       
    });
    return instance;
}



-(void)addKeyboardAutoPopWithView:(UIView *)rootView{
    if([rootView isKindOfClass:[UIScrollView class]]){
        _rootScrollView=(UIScrollView*)rootView;
    }else{
        //增加一个scrollView，是为了能够上下滑动视图
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:rootView.bounds];
//        scrollView.contentSize = rootView.frame.size;
//        _scrollViewContentSize=scrollView.contentSize;
        for(UIView *sub in rootView.subviews){
            [scrollView addSubview:sub];
        }
        [rootView insertSubview:scrollView atIndex:0];
        _rootScrollView = scrollView;
    }
    
    
    //存储所有输入框的字典
    NSMutableDictionary *subviewDict=[[NSMutableDictionary alloc]init];
    objc_setAssociatedObject(_rootScrollView,&keyAllSubviewsDict, subviewDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //添加子视图所有的输入框
    [self checkedInputViewInRootView:_rootScrollView withOriginY:_rootScrollView.frame.origin.y];
    
    //根据每个输入框的originY排序
    [self sortSubViewByOriginYinWindow];
    
    //设置工具条
    [self setInputAccessViewWithInputView];
    
    
    //添加点击背景的操作
    _tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackground:)];
    [self.rootScrollView addGestureRecognizer:_tapGesture];
}

/**
 *  对所有的输入框在window坐标系中进行排序
 */
-(void)sortSubViewByOriginYinWindow{
    NSMutableDictionary *inputDict=objc_getAssociatedObject(_rootScrollView, &keyAllSubviewsDict);
    if(inputDict.allKeys.count==0){
        return;
    }
    
    NSArray *array=inputDict.allKeys;
    array=[array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *resultArray=[[NSMutableArray alloc]init];
    for (NSString *key in array) {
        UIView *view=inputDict[key];
        [resultArray addObject:view];
        NSLog(@"输入框:%@",view.description);
    }
    
    //将两个对象进行关联
    objc_setAssociatedObject(_rootScrollView, &keyInputViewSubViewArray, resultArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    NSLog(@"排序后的数组为:%@",resultArray);
    
}

/**
 *  在根视图中检查所有子视图的input输入框
 */
-(void)checkedInputViewInRootView:(UIView *)rootView
                      withOriginY:(CGFloat)originY{

    for (UIView *subView in rootView.subviews){
        
        if (subView.hidden == YES) {
            continue;
        }
        
        if ([subView isKindOfClass:[UITextField class]] ||
            [subView isKindOfClass:[UITextView class]] ||
            [subView isKindOfClass:[UISearchBar class]]) {
            
            NSMutableDictionary *subDict=objc_getAssociatedObject(_rootScrollView, &keyAllSubviewsDict);
            
            NSNumber *key = [NSNumber numberWithFloat: originY + subView.frame.origin.y];
            NSLog(@"key=%@",key);
            //放入字典中
            [subDict setObject:subView forKey:key];
        }
        if(subView.subviews.count>0){
            [self checkedInputViewInRootView:subView withOriginY:originY+subView.frame.origin.y];
        }
    }
}
/**
 *  为所有的子视图设置InputAccessView
 */
-(void)setInputAccessViewWithInputView{
    
    NSArray *inputViewArray=objc_getAssociatedObject(_rootScrollView, &keyInputViewSubViewArray);
    
    for (UIView *sub in inputViewArray) {
        if([sub isKindOfClass:[UITextField class]]){
            ((UITextField *)sub).inputAccessoryView=_keyboardToolbar;
        }else if([sub isKindOfClass:[UITextView class]]){
            ((UITextView *)sub).inputAccessoryView=_keyboardToolbar;
        }else if([sub isKindOfClass:[UISearchBar class]]){
            ((UISearchBar *)sub).inputAccessoryView=_keyboardToolbar;
        }
    }
    
}

#pragma mark 创建自定义的工具栏
-(UIToolbar *)createToolbar:(CGRect)rect{
    UIToolbar *toolbar=[[UIToolbar alloc]initWithFrame:rect];
    _nextBarBtn=[[UIBarButtonItem alloc]initWithTitle:@"下一个" style:UIBarButtonItemStylePlain target:self action:@selector(nextAction:)];
    _prevBarBtn=[[UIBarButtonItem alloc]initWithTitle:@"上一个" style:UIBarButtonItemStylePlain target:self action:@selector(prevAction:)];
    
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishAction:)];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    toolbar.items=@[_nextBarBtn,_prevBarBtn,spaceItem,doneBtn];
    return toolbar;
}


-(void)removeKeyboardAutoPop{

}


#pragma mark 下一项
-(void)nextAction:(id)sender{
    NSLog(@"下一个");
    UIView *currentView=[self getFirstResponder];
    NSMutableArray *subviewsArray=(NSMutableArray*)objc_getAssociatedObject(_rootScrollView, &keyInputViewSubViewArray);
    UIView *nextView=nil;
    int nextIndex=1000;
    for (int i=0;i<subviewsArray.count; i++) {
        UIView *subView=subviewsArray[i];
        if(currentView==subView){
            nextIndex=i;
            break;
        }
    }
    if(nextIndex==1000){
    
    }
    else if(nextIndex+1<subviewsArray.count){
        nextView=subviewsArray[nextIndex+1];
        [nextView becomeFirstResponder];
        _prevBarBtn.enabled=YES;
    }else{
        NSLog(@"已经是最后一个了哦~");
        _nextBarBtn.enabled=NO;
    }
}

#pragma mark 上一项
-(void)prevAction:(id)sender{
    NSLog(@"上一个");
    UIView *currentView=[self getFirstResponder];
     NSMutableArray *subviewsArray=(NSMutableArray*)objc_getAssociatedObject(_rootScrollView, &keyInputViewSubViewArray);
    UIView *prevView=nil;
    int index=1000;
    for (int i=0; i<subviewsArray.count; i++) {
        UIView *subView=subviewsArray[i];
        if(currentView==subView){
            index=i;
            break;
        }
    }
    if(index==1000){
    
    }
    else if(index-1>=0){
        prevView=subviewsArray[index-1];
        [prevView becomeFirstResponder];
        _nextBarBtn.enabled=YES;
    }else{
        NSLog(@"已经是第一个了哦~");
        
        _prevBarBtn.enabled=NO;
    }
}

/**
 *  完成
 *
 *  @param sender <#sender description#>
 */
-(void)finishAction:(id)sender{
    NSLog(@"输入完成，我要退出键盘");
    UIView *currentView=[self getFirstResponder];
    [currentView resignFirstResponder];
}
#pragma mark 获取页面上获取焦点的控件
- (UIView *)getFirstResponder
{
    NSMutableArray *subviewsArray=(NSMutableArray*)objc_getAssociatedObject(_rootScrollView, &keyInputViewSubViewArray);
    for (UIView *tf in subviewsArray) {
        if ([tf isFirstResponder]) {
            return tf;
        }
    }
    return nil;
}
#pragma mark  判断是否 '上一个',‘下一个’ 按钮是否可用
/**
 *  判断是否 '上一个',‘下一个’ 按钮是否可用
 *
 *  @param currentInput
 */
-(void)judgeToolbarItemEnabled:(UIView *)currentView{
    NSMutableArray *subviewsArray=(NSMutableArray*)objc_getAssociatedObject(_rootScrollView, &keyInputViewSubViewArray);
    UIView *prevView=nil;
    int index=1000;
    for (int i=0; i<subviewsArray.count; i++) {
        UIView *subView=subviewsArray[i];
        if(currentView==subView){
            index=i;
            break;
        }
    }
    if(index==0){
      //上一项 按钮不可用
        _prevBarBtn.enabled=NO;
        _nextBarBtn.enabled=YES;
    }else if(index==subviewsArray.count-1){
        //下一项 安妮不可用
        _nextBarBtn.enabled=NO;
        _prevBarBtn.enabled=YES;
    }else{
        _prevBarBtn.enabled=YES;
        _nextBarBtn.enabled=YES;
    }
}
#pragma mark
#pragma mark 监听键盘的弹出事件
- (void)keyboardWillShow:(NSNotification *)notif {
    
    UIView *currentControl=[self getFirstResponder];
    [self judgeToolbarItemEnabled:currentControl];
    
    NSLog(@"当前监控的控件的CGRect=%@",NSStringFromCGRect(currentControl.frame));
    
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"弹出键盘的CGRect=%@",NSStringFromCGRect(rect));
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame=_rootScrollView.frame;
        CGFloat y = frame.origin.y;
        
        float coverHeight=[self isCover:currentControl keyboardHeight:rect.size.height];
        if(coverHeight>=0){
            coverHeight=fabsf(coverHeight);
            y=y-coverHeight;
            
            //设置scrollView可以滚动
         _rootScrollView.contentSize=CGSizeMake(_rootScrollView.frame.size.width,_rootScrollView.frame.size.height+coverHeight);
            
        }else if(coverHeight<0){
            coverHeight=fabsf(coverHeight);
            y+=coverHeight;
        }
        frame.origin.y=y;
        _rootScrollView.frame=frame;
    }];
}

#pragma mark 如果键盘弹出，是否遮盖当前的控件
-(float)isCover:(UIView *)view keyboardHeight:(float)keyboardHeight{
    //屏幕的高度-控件的.y-控件的高度 < 键盘的高度
    
    CGPoint windowPoint = [view.superview convertPoint:view.frame.origin toView:[[UIApplication sharedApplication]keyWindow]];
    NSLog(@"windowPoint.point=%@",NSStringFromCGPoint(windowPoint));
    
    CGFloat topY = 74.0f;
    
    CGFloat buttomY = SCREEN_HEIGHT - keyboardHeight -80;
    float result=0;
    if(windowPoint.y>buttomY){
        result=windowPoint.y-buttomY-20;
    }else if(windowPoint.y<topY){//如果当前的控件被最上面的view或者导航条遮挡的情况
        //让当前View的Y 向下移动，originY增加
        result = windowPoint.y-topY-20;//得到一个负值
    }
    //如果返回0证明没有遮盖，不进行处理
    return result;
}

- (void)keyboardWillHide:(NSNotification *)notif {
    NSLog(@"进入到键盘退出的监听当中");
    
    [UIView animateWithDuration:0.2 animations:^{
        _rootScrollView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _rootScrollView.contentSize=_scrollViewContentSize;
    }];
}

#pragma mark
#pragma mark 点击背景，退出键盘
-(void)tapBackground:(UITapGestureRecognizer *)gesture{
    
    NSMutableArray *subviewsArray=(NSMutableArray*)objc_getAssociatedObject(_rootScrollView, &keyInputViewSubViewArray);
    for (UIView *sub in subviewsArray) {
        [sub resignFirstResponder];
    }
}



@end
