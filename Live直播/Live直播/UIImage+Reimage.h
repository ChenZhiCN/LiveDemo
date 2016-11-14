//
//  UIImage+Reimage.h
//
//  Created by cz on 16/8/22.
//  Copyright © 2016年 cz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Reimage)

/**
 *  拉伸图片
 */
- (instancetype)resizableImage;

- (instancetype)cz_circleImage;

+ (instancetype)cz_circleImageNamed:(NSString *)name;

+ (instancetype)imageOriginalWithName:(NSString *)imageName;

@end
