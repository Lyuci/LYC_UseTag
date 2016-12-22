//
//  LYCTagView.m
//  LYC_UseTag
//
//  Created by Lyuci on 2016/10/31.
//  Copyright © 2016年 Lyuci. All rights reserved.
//

#import "LYCTagView.h"
#import "UIView+lyc_Frame.h"

#define kXSpace 8.0                              /** 距离父视图边界横向最小距离 */
#define kYSpace 0.0                              /** 距离俯视图边界纵向最小距离 */
#define kTagHorizontalSpace 20.0                 /** 标签左右空余距离 */
#define kTagVerticelSpace 10.0                   /** 标签上下空余距离 */
#define kPointWidth 8.0                          /** 白点直径 */
#define kPointSpace 2.0                          /** 白点和阴影尖角距离*/
#define kAngleLength (self.lyc_height / 2.0 - 2) /** 黑色阴影尖角宽度*/
#define kDeleteBtnWidth self.lyc_height          /** 删除按钮宽度*/
#define kBackCornerRadius 2.0                    /** 黑色背景圆角半径*/

typedef NS_ENUM(NSUInteger, LYCTagViewState)
{
    LYCTagViewStateArrowLeft,
    LYCTagViewStateArrowRight,
    LYCTagViewStateArrowLeftWithDelete,
    LYCTagViewStateArrowRightWithDelete,
};

@interface LYCTagView ()
/** 状态 */
@property (nonatomic, assign) LYCTagViewState state;
/** tag 信息 */
@property (nonatomic, strong) LYCTagInfo *tagInfo;
/** 拖动收拾记录初始点 */
@property (nonatomic, assign) CGPoint panTmpPoint;
/** 白点中心 */
@property (nonatomic, assign) CGPoint arrowPoint;

/** 黑色背景*/
@property (nonatomic, weak) CAShapeLayer *blackLayer;
/** 白点 */
@property (nonatomic, weak) CAShapeLayer *pointLayer;
/** 白点动画阴影 */
@property (nonatomic, weak) CAShapeLayer *pointShadowLayer;
/** 标题*/
@property (nonatomic, weak) UILabel *titleLabel;
/** 删除按钮*/
@property (nonatomic, weak) UIButton *deleteBtn;
/** 分割线*/
@property (nonatomic, weak) UIView *cuttingLine;
@end

@implementation LYCTagView

- (instancetype)initWithTagInfo:(LYCTagInfo *)tagInfo
{
    self = [super init];
    if (self) {
        
        self.tagInfo = tagInfo;
        self.isEditEnabled = YES;
//      子控件
        [self createSubviews];
//      手势处理
        [self setUpGesture];
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
//   调整UI
    [self layoutWithTitle:self.tagInfo.title superView:newSuperview];
}

#pragma mark getter and setter methods
- (CGPoint)arrowPoint
{
    CGPoint arrowPoint;
    if (self.state == LYCTagViewStateArrowLeft)
    {
        arrowPoint = CGPointMake(self.lyc_x + kPointWidth / 2.0, self.lyc_centerY);
    }
    else if (self.state == LYCTagViewStateArrowRight)
    {
        arrowPoint = CGPointMake(self.lyc_right - kPointWidth / 2.0, self.lyc_centerY);
    }else if (self.state == LYCTagViewStateArrowLeftWithDelete)
    {
        arrowPoint = CGPointMake(self.lyc_x + kPointWidth / 2.0, self.lyc_centerY);
    }else if (self.state == LYCTagViewStateArrowRightWithDelete)
    {
        arrowPoint = CGPointMake(self.lyc_right - kPointWidth / 2.0, self.lyc_centerY);
        
    }
    
    return arrowPoint;
}

- (void)setArrowPoint:(CGPoint)arrowPoint
{
    self.lyc_centerY = arrowPoint.y;
    if (self.state == LYCTagViewStateArrowLeft) {
        self.lyc_x = arrowPoint.x - kPointWidth / 2.0;
    }
    else if (self.state == LYCTagViewStateArrowRight)
    {
        self.lyc_right = arrowPoint.x + kPointWidth / 2.0;
    }else if (self.state == LYCTagViewStateArrowLeftWithDelete)
    {
        self.lyc_x = arrowPoint.x - kPointWidth / 2.0;
    }else if (self.state == LYCTagViewStateArrowRightWithDelete)
    {
        self.lyc_right = arrowPoint.x + kPointWidth / 2.0;
    }
}

#pragma mark privateMethods
//创建子控件
- (void)createSubviews
{
//    backLayer
    CAShapeLayer *backLayer = [[CAShapeLayer alloc] init];
    backLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:.7].CGColor;
    backLayer.shadowOffset = CGSizeMake(0, 2);
    backLayer.shadowColor = [UIColor blackColor].CGColor;
    backLayer.shadowRadius = 3;
    backLayer.shadowOpacity = 0.5;
    [self.layer addSublayer:backLayer];
    self.blackLayer = backLayer;
    
//    pointShadowLayer
    CAShapeLayer *pointShadowLayer = [[CAShapeLayer alloc] init];
    pointShadowLayer.hidden = YES;
    pointShadowLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3].CGColor;
    [self.layer addSublayer:pointShadowLayer];
    self.pointShadowLayer = pointShadowLayer;
    
//    pointLayer
    CAShapeLayer *pointLayer = [[CAShapeLayer alloc] init];
    pointLayer.backgroundColor = [UIColor whiteColor].CGColor;
    pointLayer.shadowOffset = CGSizeMake(0, 1);
    pointLayer.shadowColor = [UIColor blackColor].CGColor;
    pointLayer.shadowRadius = 1.5;
    pointLayer.shadowOpacity = 0.2;
    [self.layer addSublayer:pointLayer];
    self.pointLayer = pointLayer;
    
//    titleLabel
    UILabel *titleLabel = [[UILabel alloc] init];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
//    deleteBtn
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn addTarget:self action:@selector(clickDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setImage:[UIImage imageNamed:@"X"] forState:UIControlStateNormal];
    [self addSubview:deleteBtn];
    self.deleteBtn = deleteBtn;
    
//    cuttingLine
    UIView *cuttingLine = [[UIView alloc] init];
    cuttingLine.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.5];
    [self addSubview:cuttingLine];
    self.cuttingLine = cuttingLine;
    
}

// 手势方法
- (void)setUpGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *lop = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self addGestureRecognizer:lop];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:pan];
}

- (void)layoutWithTitle:(NSString *)title superView:(UIView *)superView
{
//    调整label的大小
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = title;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel sizeToFit];
    self.titleLabel.lyc_width += kTagHorizontalSpace;
    self.titleLabel.lyc_height += kTagVerticelSpace;
    
//    调整子控件UI
    LYCTagViewState state = self.state;
    CGPoint point = self.tagInfo.point;
    if (CGPointEqualToPoint(self.tagInfo.point, CGPointZero))
    {
//        没有point， 利用位置比例proportion
        CGFloat x = superView.lyc_width * self.tagInfo.proportion.x;
        CGFloat y = superView.lyc_height * self.tagInfo.proportion.y;
        point  = CGPointMake(x, y);
    }if(self.tagInfo.direction == LYCTagDirectionNormal)
    {
        if (point.x < superView.lyc_width / 2.0)
        {
            state = LYCTagViewStateArrowLeft;
        }else
        {
            state = LYCTagViewStateArrowRight;
        }
    }else
    {
        if (self.tagInfo.direction == LYCTagDirectionLeft) {
            state = LYCTagViewStateArrowLeft;
        }else
        {
            state = LYCTagViewStateArrowRight;
        }
    }
    [self layoutSubviewsWithState:state arrowPoint:point];
    
//    处理特殊初始点情况
    if (state == LYCTagViewStateArrowLeft) {
        if (self.lyc_x < kXSpace) {
            
            self.lyc_x = kXSpace;
        }
    }else
    {
        if (self.lyc_x > superView.lyc_width - kXSpace - self.lyc_width) {
            
            self.lyc_x = superView.lyc_width - kXSpace - self.lyc_width;
        }
    }
    if (self.lyc_y < kYSpace)
    {
        self.lyc_y = kYSpace;
    }else if (self.lyc_y > (superView.lyc_height - kYSpace - self.lyc_height))
    {
        self.lyc_y = superView.lyc_height - kYSpace - self.lyc_height;
    }
//    更新tag信息
    [self updateLocationInfoWithSuperView:self.superview];
}

- (void)layoutSubviewsWithState:(LYCTagViewState)state arrowPoint:(CGPoint)arrowPoint
{
    self.state = state;
//  利用事物关闭隐式动画
    [CATransaction setDisableActions:YES];
    UIBezierPath *backPath = [UIBezierPath bezierPath];
    self.pointLayer.bounds = CGRectMake(0, 0, kPointWidth, kPointWidth);
    self.pointLayer.cornerRadius = kPointWidth / 2.0;
    self.lyc_height = self.titleLabel.lyc_height;
    self.lyc_centerY = arrowPoint.y;
    self.titleLabel.lyc_y = 0;
    
    if (state == LYCTagViewStateArrowLeft || state == LYCTagViewStateArrowRight) {
//       无关闭按钮
        self.lyc_width = self.titleLabel.lyc_width + kAngleLength + kPointWidth + kPointSpace;
//       隐藏关闭及分割线
        self.deleteBtn.hidden = YES;
        self.cuttingLine.hidden = YES;
    }else
    {
//        有关闭按钮
        self.lyc_width = self.titleLabel.lyc_width + kAngleLength + kPointWidth + kPointSpace + kDeleteBtnWidth;
//        关闭按钮
        self.deleteBtn.hidden = NO;
        self.cuttingLine.hidden = NO;
    }
    if (state == LYCTagViewStateArrowLeft || state == LYCTagViewStateArrowLeftWithDelete) {
        
//        根据字调整控件大小
        self.lyc_x = arrowPoint.x - kPointWidth / 2.0;
//        背景
        [backPath moveToPoint:CGPointMake(kPointWidth + kPointSpace, self.lyc_height / 2.0)];
        [backPath addLineToPoint:CGPointMake(kPointWidth + kPointSpace + kAngleLength, 0)];
        [backPath addLineToPoint:CGPointMake(self.lyc_width - kBackCornerRadius, 0)];
        [backPath addArcWithCenter:CGPointMake(self.lyc_width - kBackCornerRadius, kBackCornerRadius) radius:kBackCornerRadius startAngle:-M_PI_2 endAngle:0 clockwise:YES];
        [backPath addLineToPoint:CGPointMake(self.lyc_width, self.lyc_height - kBackCornerRadius)];
        [backPath addArcWithCenter:CGPointMake(self.lyc_width - kBackCornerRadius, self.lyc_height - kBackCornerRadius) radius:kBackCornerRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
        [backPath addLineToPoint:CGPointMake(kPointWidth + kPointSpace + kAngleLength, self.lyc_height)];
        [backPath closePath];
//        点
        self.pointLayer.position = CGPointMake(kPointWidth / 2.0, self.lyc_height / 2.0);
//        标签
        self.titleLabel.lyc_x = kPointWidth + kAngleLength;
        if (state == LYCTagViewStateArrowLeftWithDelete) {
//            关闭
            self.deleteBtn.frame = CGRectMake(self.lyc_width - kDeleteBtnWidth, 0, kDeleteBtnWidth, kDeleteBtnWidth);
            self.cuttingLine.frame = CGRectMake(self.deleteBtn.lyc_x - 0.5, 0, 0.5, self.lyc_height);
        }
    }else if (state == LYCTagViewStateArrowRight || state == LYCTagViewStateArrowRightWithDelete)
    {
//        根据字调整控件大小
        self.lyc_right = arrowPoint.x + kPointWidth / 2.0;
//        背景
        [backPath moveToPoint:CGPointMake(self.lyc_width - kPointWidth - kPointSpace, self.lyc_height / 2.0)];
        [backPath addLineToPoint:CGPointMake(self.lyc_width- kAngleLength - kPointWidth - kPointSpace, self.lyc_height)];
        [backPath addLineToPoint:CGPointMake(kBackCornerRadius, self.lyc_height)];
        [backPath addArcWithCenter:CGPointMake(kBackCornerRadius, self.lyc_height - kBackCornerRadius) radius:kBackCornerRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        [backPath addLineToPoint:CGPointMake(kBackCornerRadius, kBackCornerRadius)];
        [backPath addArcWithCenter:CGPointMake(kBackCornerRadius, kBackCornerRadius) radius:kBackCornerRadius startAngle:M_PI endAngle:M_PI + M_PI_2 clockwise:YES];
        [backPath addLineToPoint:CGPointMake(self.lyc_width - kAngleLength - kPointWidth - kPointSpace, 0)];
        [backPath closePath];
        
//        点
        self.pointLayer.position = CGPointMake(self.lyc_width - kPointWidth / 2.0, self.lyc_height / 2.0);
        if (state == LYCTagViewStateArrowRight) {
           //        标签
            self.titleLabel.lyc_x = 0;
        }else
        {
            // 标签
            self.titleLabel.lyc_x = kDeleteBtnWidth;
//            关闭
            self.deleteBtn.frame = CGRectMake(0, 0, kDeleteBtnWidth, kDeleteBtnWidth);
            self.cuttingLine.frame = CGRectMake(self.deleteBtn.lyc_right + 0.5, 0, 0.5, self.lyc_height);
        }
    }
    self.blackLayer.path = backPath.CGPath;
    self.pointShadowLayer.bounds = self.pointLayer.bounds;
    self.pointShadowLayer.position = self.pointLayer.position;
    self.pointShadowLayer.cornerRadius = self.pointLayer.cornerRadius;
    [CATransaction setDisableActions:NO];
    
}

- (void)changeLocationWithGestureState:(UIGestureRecognizerState)gestureState locationPoint:(CGPoint)point
{
    if (self.isEditEnabled == NO)
    {
        return;
    }
    
    CGPoint referencePoint = CGPointMake(0, point.y + self.lyc_height / 2.0);
    switch (self.state) {
        case LYCTagViewStateArrowLeft:
        case LYCTagViewStateArrowLeftWithDelete:
            referencePoint.x = point.x + kPointWidth / 2.0;
            break;
        case LYCTagViewStateArrowRight:
        case LYCTagViewStateArrowRightWithDelete:
            referencePoint.x = point.x + self.lyc_width - kPointWidth / 2.0;
            break;
        default:
            break;
    }
    if (referencePoint.x < kXSpace + kPointWidth / 2.0) {
        referencePoint.x = kXSpace + kPointWidth / 2.0;
    }
    else if (referencePoint.x > self.superview.lyc_width - kXSpace - kPointWidth / 2.0)
    {
        referencePoint.x = self.superview.lyc_width - kXSpace - kPointWidth / 2.0;
    }
    if (referencePoint.y < kYSpace + kPointWidth / 2.0)
    {
        referencePoint.y = kYSpace + self.lyc_height / 2.0;
    }else if (referencePoint.y > self.superview.lyc_height - kYSpace - self.lyc_height / 2.0)
    {
        referencePoint.y = self.superview.lyc_height - kYSpace - self.lyc_height / 2.0;
    }
//    更新位置
    self.arrowPoint = referencePoint;
    if (gestureState == UIGestureRecognizerStateEnded) {
//      翻转
        switch (self.state) {
            case LYCTagViewStateArrowLeft:
            case LYCTagViewStateArrowLeftWithDelete:
            {
                if (self.lyc_right > self.superview.lyc_width - kXSpace - kDeleteBtnWidth && self.arrowPoint.x > self.superview.lyc_width / 2.0) {
                    [self layoutSubviewsWithState:LYCTagViewStateArrowRight arrowPoint:self.arrowPoint];
                }
            }
                break;
            case LYCTagViewStateArrowRight:
            case LYCTagViewStateArrowRightWithDelete:
            {
                if (self.lyc_x < kXSpace + kDeleteBtnWidth && self.arrowPoint.x < self.superview.lyc_width / 2.0) {
                    
                    [self layoutSubviewsWithState:LYCTagViewStateArrowLeft arrowPoint:self.arrowPoint];
                }
            }
                break;
            default:
                break;
        }
        
//        更新tag信息
        [self updateLocationInfoWithSuperView:self.superview];
    }
}

- (void)updateLocationInfoWithSuperView:(UIView *)superView
{
    if(superView == nil)
    {
//       被移除的时候也会调用 willMoveToSuperview
        return;
    }
//    更新point 以及direction
    if (self.state == LYCTagViewStateArrowLeft || self.state == LYCTagViewStateArrowLeftWithDelete) {
        
        self.tagInfo.point = CGPointMake(self.lyc_x + kPointWidth / 2, self.lyc_y + self.lyc_height / 2.0);
        self.tagInfo.direction = LYCTagDirectionLeft;
    }else
    {
        self.tagInfo.point = CGPointMake(self.lyc_right - kPointWidth / 2, self.lyc_y + self.lyc_height / 2.0);
        self.tagInfo.direction = LYCTagDirectionRight;
    }
//    更新proportion
    if (superView.lyc_width > 0 && superView.lyc_height > 0) {
        self.tagInfo.proportion = LYCPositionProportionMake(self.tagInfo.point.x / superView.lyc_width, self.tagInfo.point.y / superView.lyc_height);
    }
}

#pragma mark event response
- (void)handleTapGesture:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded) {
        [self.superview bringSubviewToFront:self];
        if ([self.delegate respondsToSelector:@selector(tagViewActiveTapGusture:)]) {
            [self.delegate tagViewActiveTapGusture:self];
        }else
        {
//            默认切换删除按钮状态
            [self switchDeleteState];
        }
    }
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)lop
{
    if (lop.state == UIGestureRecognizerStateBegan) {
        [self.superview bringSubviewToFront:self];
        if ([self.delegate respondsToSelector:@selector(tagViewActiveLongPressGesture:)]) {
            
            [self.delegate tagViewActiveLongPressGesture:self];
            
        }
    }

}

- (void)handlePanGesture:(UIPanGestureRecognizer *)pan
{
    
    CGPoint panPoint = [pan locationInView:self.superview];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self hiddenDeleteBtn];
            [self.superview bringSubviewToFront:self];
            self.panTmpPoint = [pan locationInView:self];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self changeLocationWithGestureState:UIGestureRecognizerStateChanged locationPoint:CGPointMake(panPoint.x - self.panTmpPoint.x, panPoint.y - self.panTmpPoint.y)];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self changeLocationWithGestureState:UIGestureRecognizerStateEnded locationPoint:CGPointMake(panPoint.x - self.panTmpPoint.x, panPoint.y - self.panTmpPoint.y)];
            self.panTmpPoint = CGPointZero;
        }
            break;
        default:
            break;
    }

}

- (void)clickDeleteBtn
{
    [self removeFromSuperview];
}

#pragma mark public methods
- (void)updateTitle:(NSString *)title
{
    self.tagInfo.title = title;
    [self layoutWithTitle:title superView:self.superview];
}
- (void)showAnimationWithRepeatCount:(float)repeatCount
{  CAKeyframeAnimation *cka = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    cka.values =   @[@0.7, @1.32, @1,   @1];
    cka.keyTimes = @[@0.0, @0.3,  @0.3, @1];
    cka.repeatCount = repeatCount;
    cka.duration = 1.8;
    [self.pointLayer addAnimation:cka forKey:@"cka"];
    
    CAKeyframeAnimation *cka2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    cka2.values =   @[@0.7, @0.9, @0.9, @3.5,  @0.9,  @3.5];
    cka2.keyTimes = @[@0.0, @0.3, @0.3, @0.65, @0.65, @1];
    cka2.repeatCount = repeatCount;
    cka2.duration = 1.8;
    self.pointShadowLayer.hidden = NO;
    [self.pointShadowLayer addAnimation:cka2 forKey:@"cka2"];

    
}
- (void)removeAnimation
{
    [self.pointLayer removeAnimationForKey:@"cka"];
    [self.pointShadowLayer removeAnimationForKey:@"cka2"];
    self.pointShadowLayer.hidden = YES;
}
- (void)showDeleteBtn
{
    if (self.isEditEnabled == NO) {
        return;
    }
    if (self.state == LYCTagViewStateArrowLeft) {
        [self layoutSubviewsWithState:LYCTagViewStateArrowLeftWithDelete arrowPoint:self.arrowPoint];
    }else if (self.state == LYCTagViewStateArrowRight)
    {
        [self layoutSubviewsWithState:LYCTagViewStateArrowRightWithDelete arrowPoint:self.arrowPoint];
    }
}

- (void)hiddenDeleteBtn
{
    if (self.state == LYCTagViewStateArrowRightWithDelete) {
        [self layoutSubviewsWithState:LYCTagViewStateArrowLeft arrowPoint:self.arrowPoint];
    }else if (self.state == LYCTagViewStateArrowRightWithDelete)
    {
        [self layoutSubviewsWithState:LYCTagViewStateArrowRight arrowPoint:self.arrowPoint];
    }
}

- (void)switchDeleteState
{
    if (self.state == LYCTagViewStateArrowLeft || self.state == LYCTagViewStateArrowRight) {
        [self showDeleteBtn];
    }else
    {
        [self hiddenDeleteBtn];
    }
}

@end
