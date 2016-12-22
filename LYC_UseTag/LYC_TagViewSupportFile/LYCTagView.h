//
//  LYCTagView.h
//  LYC_UseTag
//
//  Created by Lyuci on 2016/10/31.
//  Copyright © 2016年 Lyuci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYCTagInfo.h"
@class LYCTagView;



@protocol LYCTageViewDelegate <NSObject>

@optional
/**
 *  触发轻触手势
 */
- (void)tagViewActiveTapGusture:(LYCTagView *)tagView;
/**
 *  触发长按手势
 */
- (void)tagViewActiveLongPressGesture:(LYCTagView *)tagView;
@end

@interface LYCTagView : UIView
/**
 *  代理
 */
@property (nonatomic, weak) id<LYCTageViewDelegate>delegate;
/**
 *  标记信息
 */
@property (nonatomic, strong, readonly) LYCTagInfo *tagInfo;
/**
 *   是否可编辑 default is YES
 */
@property (nonatomic, assign) BOOL isEditEnabled;

/**
 *  初始化
 */
- (instancetype)initWithTagInfo:(LYCTagInfo *)tagInfo;
/**
 *  更新标题
 */
- (void)updateTitle:(NSString *)title;
/**
 *  显示动画
 */
- (void)showAnimationWithRepeatCount:(float)repeatCount;
/**
 *  移除动画
 */
- (void)removeAnimation;
/**
 *  显示删除按钮
 */
- (void)showDeleteBtn;
/**
 *  隐藏删除按钮
 */
- (void)hiddenDeleteBtn;
/**
 *  切换删除按钮状态
 */
- (void)switchDeleteState;

@end
