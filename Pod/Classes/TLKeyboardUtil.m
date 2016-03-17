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

#define ALLSUBVIEWS @"allSubviews"

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
    
    
    //存储所有输入框的数组
    NSMutableArray *subviewsArray=[[NSMutableArray alloc]init];
    objc_setAssociatedObject(_rootView,ALLSUBVIEWS, subviewsArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //添加子视图所有的输入框
    [self checkedInputViewInRootView:_rootView];
    
}

/**
 *  在根视图中检查所有子视图的input输入框
 */
-(void)checkedInputViewInRootView:(UIView *)rootView{

    for (UIView *subView in rootView.subviews){
        
        if (subView.hidden == YES) {
            continue;
        }
        
        if ([subView isKindOfClass:[UITextField class]] ||
            [subView isKindOfClass:[UITextView class]] ||
            [subView isKindOfClass:[UISearchBar class]]) {
            
            NSMutableArray *subviewsArray=objc_getAssociatedObject(_rootView, ALLSUBVIEWS);
            NSLog(@"呵呵%@",subviewsArray);
            
            [subviewsArray addObject:subView];
            
            
        } else {
            [self checkedInputViewInRootView:subView];
        }
    }
}



-(void)removeKeyboardAutoPop{

}

@end
