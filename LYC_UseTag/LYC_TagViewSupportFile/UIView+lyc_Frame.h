//
//  UIView+lyc_Frame.h
//  LYC_UseTag
//
//  Created by Lyuci on 2016/10/28.
//  Copyright © 2016年 Lyuci. All rights reserved.
//

#import <UIKit/UIKit.h>

#define lyc_KScreenW ([UIScreen mainScreen].bounds.size.width)
#define lyc_kScreenH ([UIScreen mainScreen].bounds.size.height)
/**
 *  边框类型设置 可多选
 */
typedef NS_OPTIONS(NSUInteger, LYCBorder)
{
    LYCBorderLeft = 1<< 0,
    LYCBorderRight = 1 << 1,
    LYCBorderTop = 1 << 2,
    LYCBorderBottom = 1 << 3,
    LYCBorderAll    = ~0UL
};

@interface UIView (lyc_Frame)
/**
 *  origin size
 */
@property CGPoint lyc_origin;
@property CGSize lyc_size;
/**
 *  corner poin
 */
@property (readonly) CGPoint lyc_bottomLeft;
@property (readonly) CGPoint lyc_bottomRight;
@property (readonly) CGPoint lyc_topRight;
/**
 *  height
 */
@property CGFloat lyc_height;
@property CGFloat lyc_width;
@property CGFloat lyc_x;
@property CGFloat lyc_y;
@property CGFloat lyc_bottom;
@property CGFloat lyc_right;
@property CGFloat lyc_centerX;
@property CGFloat lyc_centerY;
/**
 *  获取控制器
 */
- (UIViewController *)lyc_viewController;
/**
 *  根据点移动
 */
- (void)moveByPoint:(CGPoint)delta;
/**
 *  放大倍数
 */
- (void)magnifyByScale:(CGFloat)scaleFactor;
/**
 *  适配某一尺寸
 */
- (void)fitInSize:(CGSize)size;
/**
 *  利用mask设置圆角
 */
- (void)setCornerOnTop:(CGFloat)conner;
- (void)setcornerOnBottom:(CGFloat)conner;
- (void)setcornerOnLeft:(CGFloat)conner;
- (void)setcornerOnRight:(CGFloat)conner;
/**
 *  边框 设置好frame再设置边框
 */
- (void)setBorders:(LYCBorder)Borders color:(UIColor *)color width:(CGFloat)width;
@end


