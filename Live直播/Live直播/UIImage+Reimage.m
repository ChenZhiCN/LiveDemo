//
//  UIImage+Resize.m
//
//  Created by cz on 16/8/22.
//  Copyright © 2016年 cz. All rights reserved.
//

#import "UIImage+Reimage.h"

@implementation UIImage (Resize)

/**
 *  圆角图片
 */
+ (instancetype)imageOriginalWithName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}

/**
 *  拉伸图片
 */
- (instancetype)resizableImage
{
    //UIEdgeInsetsMake这个范围不拉伸，其余的部分都拉伸
    //只拉伸一个点（中心点）
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(self.size.height/2, self.size.width/2, self.size.height/2, self.size.width/2)];
}

/**
 *  圆角图片
 */
- (instancetype)cz_circleImage
{
    // 1.开启图形上下文
    // 比例因素:当前点与像素比例
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    // 2.描述裁剪区域
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    // 3.设置裁剪区域;
    [path addClip];
    // 4.画图片
    [self drawAtPoint:CGPointZero];
    // 5.取出图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 6.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+ (instancetype)cz_circleImageNamed:(NSString *)name
{
    return [[self imageNamed:name] cz_circleImage];
}

@end
