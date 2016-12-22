//
//  LYCTagImageView.h
//  LYC_UseTag
//
//  Created by Lyuci on 2016/11/8.
//  Copyright © 2016年 Lyuci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYCTagView.h"
#import "LYCTagInfo.h"
@class LYCTagImageView;

@protocol LYCTagImageViewDelegate <NSObject>
/**
 *  轻触imageView空白区域
 */
- (void)tagImageView:(LYCTagImageView *)tagImageView activeTapGesture:(UITapGestureRecognizer *)tapGesture;
@optional
/**
 *  轻触标签
 */
- (void)tagImageView:(LYCTagImageView *)tagImageView tagViewActiveTapGesture:(LYCTagView *)tagView;
/**
 *  长按标签
 */
- (void)tagImageView:(LYCTagImageView *)tagImageView tagViewActiveLongPressGesture:(LYCTagView *)tagView;
@end

@interface LYCTagImageView : UIImageView


@property (nonatomic, weak) id<LYCTagImageViewDelegate> delegate;
@property (nonatomic, assign) BOOL isEditEnable;
/**
 *  添加标签
 */
- (void)addTagsWithTagInfoArray:(NSArray *)tagInfoArray;
/**
 *  添加单个标签
 */
- (void)addTagWithTitle:(NSString *)title point:(CGPoint)point object:(id)object;
/**
 *  设置标签是否可编辑
 */
- (void)setAllTagsEditEnable:(BOOL)isEditEnabled;
/**
 *   隐藏所有标签的删除按钮
 */
- (void)hiddenAllTagsDeleteBtn;
/**
 *  移除所有标签
 */
- (void)removeAllTags;
- (void)hiddenAllTags;
- (void)showAllTags;
/**
 *  获取当前所有标签信息
 */
- (NSArray *)getAllTagInfos;







@end
