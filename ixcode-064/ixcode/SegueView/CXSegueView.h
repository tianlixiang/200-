//
//  CXSegueView.h
//  MyOrder
//
//  Created by Ming on 15/11/24.
//  Copyright © 2015年 戴晨惜. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CXStateButtonBolock)(NSInteger button_tag);

@interface CXSegueView : UIView


@property (nonatomic,copy)  NSArray * title_array;

@property (nonatomic,copy)  NSArray * iconImage_array;

@property (nonatomic,strong) UIColor * separator_Color; /**<- 分割符颜色*/

@property (nonatomic,strong) UIColor * select_Color;     /**<- 选择状态指示符颜色*/

@property (nonatomic,copy) CXStateButtonBolock block;

@property (nonatomic,assign) NSInteger selectImage_index; /**<- 选中的按钮*/


- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray block:(CXStateButtonBolock)block;

@end

