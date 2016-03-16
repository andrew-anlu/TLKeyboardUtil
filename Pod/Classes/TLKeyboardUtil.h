//
//  TLKeyboardUtil.h
//  Pods
//
//  Created by Andrew on 16/3/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TLKeyboardUtil : NSObject


+(TLKeyboardUtil*)sharedInstance;

/**
 *  给根视图添加键盘自动弹出功能
 *
 *  @param rootView 根视图
 */
-(void)addKeyboardAutoPopWithView:(UIView *)rootView;

-(void)removeKeyboardAutoPop;
@end
