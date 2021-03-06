//
//  UIButton+DWButtonUtils.h
//  test
//
//  Created by Wicky on 2016/11/16.
//  Copyright © 2016年 Wicky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (DWButtonUtils)

/**
 防重复点击间隔
 */
@property (nonatomic ,assign) NSTimeInterval dw_IgnoreClickInterval;

/**
 扩大按钮响应区域，上左下右，正数扩大负数缩小
 */
@property (nonatomic ,assign) UIEdgeInsets dw_EnlargeRect;

@end
