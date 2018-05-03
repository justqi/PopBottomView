//
//  PopBottomView.h
//  PopBottomView
//
//  Created by deco on 2017/9/8.
//  Copyright © 2017年 deco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopBottomView : UIView


/** 类型(字典)ID对应的key   默认key为--itemIdKeyStr--*/
@property (strong, nonatomic)NSString *itemIdKeyStr;
/** 类型（字典）名字对应的key   默认key为--itemNameKeyStr--*/
@property (strong, nonatomic)NSString *itemNameKeyStr;


/** 选择全部按钮对应的名字 不传则默认文字为--全部*/
@property (strong, nonatomic)NSString *allItemName;


/** @brief  --------------单选--------------
 * @param  view 父视图
 * @param  array 类型字典数组  通过属性指定字典成员的key 不指定时使用默认key
 * @param  title 显示在顶部的描述文字（如：选择订单类型）
 * @param  selectedDic 默认选中的项 没有就传nil
 */
-(void)showFromView:(UIView *)view WithData:(NSArray *)array andTitle:(NSString *)title defaultSelectedItem:(NSDictionary *)selectedDic;

//单选--确定回调
@property (strong, nonatomic) void(^SureBtnDidClickBlock)(NSDictionary *);


//从父视图显示时回调
@property (strong, nonatomic) void(^DissmissBlock)();
//点击取消按钮回调
@property (strong, nonatomic) void(^CanceBtnClickBlock)();




/** @brief  --------------多选--------------
 * @param  view 父视图
 * @param  array 类型字典数组  通过属性指定字典成员的key 不指定时使用默认key
 * @param  title 显示在顶部的描述文字（如：选择订单类型）
 * @param  selectedArray 默认选中的数组项 没有就传nil
 */
-(void)showFromView:(UIView *)view WithData:(NSArray *)array andTitle:(NSString *)title defaultSelectedItems:(NSArray<NSDictionary *> *)selectedArray hasAllBtn:(BOOL)hasAllBtn;
//多选--确定回调
@property (strong, nonatomic) void(^SureButtonDidClickBlock)(NSArray *selectedArray,BOOL selectedAll);

@end
