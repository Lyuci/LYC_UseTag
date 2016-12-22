//
//  LYCTagInfo.m
//  LYC_UseTag
//
//  Created by Lyuci on 2016/10/31.
//  Copyright © 2016年 Lyuci. All rights reserved.
//

#import "LYCTagInfo.h"

@implementation LYCTagInfo

LYCPositionProportion LYCPositionProportionMake(CGFloat x, CGFloat y)
{
   LYCPositionProportion p; p.x = x; p.y = y; return p;
}

+ (instancetype)tagInfo
{
    return [[self alloc] init];
}

@end
