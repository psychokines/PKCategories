//
//  UIView+PKExtend.h
//  PKCategories
//
//  Created by jiaohong on 2018/10/28.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (PKFrameAdjust)

@property (nonatomic, assign) CGFloat pk_left;
@property (nonatomic, assign) CGFloat pk_top;
@property (nonatomic, assign) CGFloat pk_right;
@property (nonatomic, assign) CGFloat pk_bottom;
@property (nonatomic, assign) CGFloat pk_width;
@property (nonatomic, assign) CGFloat pk_height;
@property (nonatomic, assign) CGFloat pk_centerX;
@property (nonatomic, assign) CGFloat pk_centerY;
@property (nonatomic, assign) CGPoint pk_origin;
@property (nonatomic, assign) CGSize  pk_size;

@end


typedef NS_OPTIONS(NSUInteger, PKEdgeLinePosition) {
    PKEdgeLinePositionLeft          = 1 << 0,
    PKEdgeLinePositionRight         = 1 << 1,
    PKEdgeLinePositionTop           = 1 << 2,
    PKEdgeLinePositionBottom        = 1 << 3,
    PKEdgeLinePositionAllEdgeLines  = ~0UL
};

@interface UIView (PKVisuals)

/** 为视图指定部分添加圆角 */
- (void)pk_addCornerRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners;

/**
 * @brief 为视图指定位置添加边框线
 *
 * @param position 边线所在位置
 * @param width 边线宽度
 * @param color 边线颜色
 */
- (void)pk_addEdgeLineWidth:(CGFloat)width color:(UIColor *)color byEdgePosition:(PKEdgeLinePosition)position;

/**
 * @brief 为视图指定位置添加默认值边框线
 *
 * @param position 边线所在位置
 *
 * 默认值 lineWidth => 1 / [UIScreen mainScreen].scale
 * 默认值 lineColor => [UIColor grayColor]
 */
- (void)pk_addDefaultEdgeLineByPosition:(PKEdgeLinePosition)position;

@end


@interface UIView (PKExtend)

/** 删除视图的所有子视图 */
- (void)pk_removeAllSubviews;

/** 返回视图所在的视图控制器或nil */
@property (nullable, nonatomic, readonly) UIViewController *pk_inViewController;

@end

NS_ASSUME_NONNULL_END
