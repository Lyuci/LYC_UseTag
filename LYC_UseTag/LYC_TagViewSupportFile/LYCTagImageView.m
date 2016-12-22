//
//  LYCTagImageView.m
//  LYC_UseTag
//
//  Created by Lyuci on 2016/11/8.
//  Copyright © 2016年 Lyuci. All rights reserved.
//

#import "LYCTagImageView.h"

@interface LYCTagImageView ()<LYCTageViewDelegate>

@end

@implementation LYCTagImageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUp];
        
    }return self;
}
- (instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.isEditEnable = YES;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tap];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tap
{
    if (self.isEditEnable == NO) {
        return;
    }
    if (tap.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(tagImageView:activeTapGesture:)]) {
            [self.delegate tagImageView:self activeTapGesture:tap];
        }
    }
}

#pragma mark public methods
- (void)addTagsWithTagInfoArray:(NSArray *)tagInfoArray
{
    for (LYCTagInfo *tagInfo in tagInfoArray) {
        LYCTagView *tagView = [[LYCTagView alloc] initWithTagInfo:tagInfo];
        tagView.delegate = self;
        tagView.isEditEnabled = self.isEditEnable;
        [self addSubview:tagView];
        [tagView showAnimationWithRepeatCount:CGFLOAT_MAX];
    }
}

- (void)addTagWithTitle:(NSString *)title point:(CGPoint)point object:(id)object
{
    LYCTagInfo *tagInfo = [LYCTagInfo tagInfo];
    tagInfo.point = point;
    tagInfo.title = title;
    tagInfo.object = object;
    LYCTagView *tagView = [[LYCTagView alloc] initWithTagInfo:tagInfo];
    tagView.delegate = self;
    tagView.isEditEnabled = self.isEditEnable;
    [self addSubview:tagView];
    [tagView showAnimationWithRepeatCount:CGFLOAT_MAX];
    
}

- (void)setAllTagsEditEnable:(BOOL)isEditEnabled
{
    self.isEditEnable = isEditEnabled;
    for (UIView *view in self.subviews) {
        
        if ([view isKindOfClass:[LYCTagView class]]) {
            ((LYCTagView *)view).isEditEnabled = isEditEnabled;
            if (isEditEnabled == NO) {
                [(LYCTagView *)view hiddenDeleteBtn];
            }
        }
    }
}

- (void)hiddenAllTagsDeleteBtn
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[LYCTagView class]]) {
            [(LYCTagView *)view hiddenDeleteBtn];
        }
    }
}

- (void)removeAllTags
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[LYCTagView class]]) {
            [view removeFromSuperview];
        }
    }
}

- (void)hiddenAllTags
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[LYCTagView class]]) {
            [view setHidden:YES];
        }
    }
}

- (void)showAllTags
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[LYCTagView class]]) {
            [view setHidden:NO];
            //            [view removeFromSuperview];
        }
    }
}

- (NSArray *)getAllTagInfos
{
    NSMutableArray *array = [NSMutableArray array];
    for (UIView *view in self.subviews) {
        
        if ([view isKindOfClass:[LYCTagView class]]) {
            
            [array addObject:((LYCTagView *)view).tagInfo];
        }
    }
    return array;
}

#pragma mark LYCTagViewDelegate
- (void)tagViewActiveTapGusture:(LYCTagView *)tagView
{
    if ([self.delegate respondsToSelector:@selector(tagImageView:tagViewActiveTapGesture:)]) {
        [self.delegate tagImageView:self tagViewActiveTapGesture:tagView];
    }else
    {
//        默认
        [tagView switchDeleteState];
    }
}

- (void)tagViewActiveLongPressGesture:(LYCTagView *)tagView
{
    if ([self.delegate respondsToSelector:@selector(tagImageView:tagViewActiveLongPressGesture:)]) {
        [self.delegate tagImageView:self tagViewActiveLongPressGesture:tagView];
    }
}

@end
