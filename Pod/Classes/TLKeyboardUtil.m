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

@property (nonatomic,strong)NSMutableArray *subViews;
/**
 *  根视图，里面可能包含了多了个UItextField,也有可能嵌套UITextfield。
 */
@property (nonatomic,weak)UIView *rootView;
@end

@implementation TLKeyboardUtil

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
        _rootView=rootView;
    }else{
        //增加一个scrollView，是为了能够上下滑动视图
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:rootView.bounds];
        scrollView.contentSize = rootView.frame.size;
        for(UIView *sub in rootView.subviews){
            [scrollView addSubview:sub];
        }
        [rootView insertSubview:scrollView atIndex:0];
        _rootView = scrollView;
    }
    
    objc_setAssociatedObject(_rootView, @"test", rootView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)removeKeyboardAutoPop{

}

@end
