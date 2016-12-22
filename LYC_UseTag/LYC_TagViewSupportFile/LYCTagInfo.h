//
//  LYCTagInfo.h
//  LYC_UseTag
//
//  Created by Lyuci on 2016/10/31.
//  Copyright © 2016年 Lyuci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSInteger
{
    LYCTagDirectionNormal,
    LYCTagDirectionLeft,
    LYCTagDirectionRight,
}LYCTagDirection;

/**
 *  比例
 */
struct LYCPositionProportion
{
    CGFloat x;
    CGFloat y;
};
typedef struct LYCPositionProportion LYCPositionProportion;
LYCPositionProportion LYCPositionProportionMake(CGFloat x, CGFloat y);
@interface LYCTagInfo : NSObject
/**
 *  记录位置点
 */
@property (nonatomic, assign) CGPoint point;
/**
 *  记录位置点在父视图中的比例
 */
@property (nonatomic, assign) LYCPositionProportion proportion;
/**
 *  方向
 */
@property (nonatomic, assign) LYCTagDirection direction;
/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  其他需要存储的数据
 */
@property (nonatomic, copy) id object;
/**
 *  初始化
 */
+ (LYCTagInfo *)tagInfo;
@end
