//
//  UIView+lyc_Frame.m
//  LYC_UseTag
//
//  Created by Lyuci on 2016/10/28.
//  Copyright © 2016年 Lyuci. All rights reserved.
//

#import "UIView+lyc_Frame.h"
#import <objc/runtime.h>

const char *lyc_leftBorderKey = "lyc_leftBorderKey";
const char *lyc_rightBorderKey = "lyc_rightBorderKey";
const char *lyc_topBorderKey = "lyc_topBorderKey";
const char *lyc_bottomBorderKey = "lyc_bottomBorderKey";

@implementation UIView (lyc_Frame)

#pragma mark origin size
- (CGPoint)lyc_origin
{
    return self.frame.origin;
}

- (void)setLyc_origin:(CGPoint)aPonit
{
    CGRect newframe = self.frame;
    newframe.origin = aPonit;
    self.frame = newframe;
}

- (CGSize)lyc_size
{
    return self.frame.size;
}

- (void)setLyc_size:(CGSize)aSize
{
    CGRect newframe = self.frame;
    newframe.size = aSize;
    self.frame = newframe;
}

#pragma mark bottomRight bottomLeft topRight
- (CGPoint)lyc_bottomRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint)lyc_bottomLeft
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint)lyc_topRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}

#pragma mark -height width top left bottom right centerX centerY
- (CGFloat)lyc_height
{
    return self.frame.size.height;
}

- (void)setLyc_height:(CGFloat)lyc_height
{
    CGRect newframe = self.frame;
    newframe.size.height = lyc_height;
    self.frame = newframe;
}

- (CGFloat)lyc_width
{
    return self.frame.size.width;
}

- (void)setLyc_width:(CGFloat)lyc_width
{
    CGRect newFrame = self.frame;
    newFrame.size.width = lyc_width;
    self.frame = newFrame;
}

- (CGFloat)lyc_x
{
    return self.frame.origin.x;
}

- (void)setLyc_x:(CGFloat)lyc_x
{
    CGRect newframe = self.frame;
    newframe.origin.x = lyc_x;
    self.frame = newframe;
}

- (CGFloat)lyc_y
{
    return  self.frame.origin.y;
}

- (void)setLyc_y:(CGFloat)lyc_y
{
    CGRect newframe = self.frame;
    newframe.origin.y = lyc_y;
    self.frame = newframe;
}

- (CGFloat)lyc_bottom
{
    return  self.frame.origin.y + self.frame.size.height;
}

- (void)setLyc_bottom:(CGFloat)lyc_bottom
{
    CGRect newframe = self.frame;
    newframe.origin.y = lyc_bottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat)lyc_right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setLyc_right:(CGFloat)lyc_right
{
    CGFloat delta = lyc_right - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta;
    self.frame = newframe;
}

- (CGFloat)lyc_centerX
{
    return self.center.x;
}

- (void)setLyc_centerX:(CGFloat)lyc_centerX
{
    CGRect newframe = self.frame;
    newframe.origin.x = lyc_centerX - newframe.size.width / 2;
    self.frame = newframe;
}

- (CGFloat)lyc_centerY
{
    return  self.center.y;
}

- (void)setLyc_centerY:(CGFloat)lyc_centerY
{
    CGRect newframe = self.frame;
    newframe.origin.y = lyc_centerY - newframe.size.height / 2;
    self.frame = newframe;
}

#pragma mark methods
- (UIViewController *)lyc_viewController
{
    id next = [self nextResponder];
    while (next != nil) {
        
        if ([next isKindOfClass:[UIViewController class]]) {
            return next;
        }
        next = [next nextResponder];
    }
    return nil;
}

- (void)moveByPoint:(CGPoint)delta
{
    CGPoint newcenter = self.center;
    newcenter.x += delta.x;
    newcenter.y += delta.y;
    self.center = newcenter;
}

- (void)magnifyByScale:(CGFloat)scaleFactor
{
    CGRect newframe = self.frame;
    newframe.size.width *= scaleFactor;
    newframe.size.height *= scaleFactor;
    self.frame = newframe;
}

- (void)fitInSize:(CGSize)size
{
    CGFloat scale;
    CGRect newframe = self.frame;
    if (newframe.size.height && (newframe.size.height > size.height)) {
        
        scale = size.height / newframe.size.height;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    if (newframe.size.width && (newframe.size.width >= size.width)) {
        
        scale = size.width / newframe.size.width;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    self.frame = newframe;
}

- (void)setCornerOnTop:(CGFloat)conner
{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(conner, conner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskLayer.path;
    self.layer.mask = maskLayer;
}

- (void)setcornerOnBottom:(CGFloat)conner
{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft |UIRectCornerBottomRight cornerRadii:CGSizeMake(conner, conner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setcornerOnLeft:(CGFloat)conner
{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(conner, conner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setcornerOnRight:(CGFloat)conner
{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(conner, conner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setBorders:(LYCBorder)Borders color:(UIColor *)color width:(CGFloat)width
{
    if ((Borders & LYCBorderLeft) == LYCBorderLeft) {
        
        [self lyc_showBorderViewWithKey:lyc_leftBorderKey frame:CGRectMake(0, 0, width, self.frame.size.height) color:color];
    }
    if ((Borders & LYCBorderRight) == LYCBorderRight) {
        [self lyc_showBorderViewWithKey:lyc_rightBorderKey frame:CGRectMake(self.frame.size.width - width, 0, width, self.frame.size.height) color:color];
    }
    if ((Borders & LYCBorderTop) == LYCBorderTop) {
        
        [self lyc_showBorderViewWithKey:lyc_topBorderKey frame:CGRectMake(0, 0, self.frame.size.width, width) color:color];
    }
    if ((Borders & LYCBorderBottom) == LYCBorderBottom) {
        [self lyc_showBorderViewWithKey:lyc_bottomBorderKey frame:CGRectMake(0, self.frame.size.height - width, self.frame.size.width, width) color:color];
    }
}

#pragma mark pravite methods
- (void)lyc_showBorderViewWithKey:(const void *)key frame:(CGRect)frame color:(UIColor *)color
{
    UIView *border = objc_getAssociatedObject(self, key);
    if (border) {
        
        border.frame = frame;
        border.backgroundColor = color;
        border.hidden = NO;
    }else
    {
        UIView *newBorder = [[UIView alloc] initWithFrame:frame];
        newBorder.backgroundColor = color;
        [self addSubview:newBorder];
        objc_setAssociatedObject(self, key, newBorder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}





















@end
