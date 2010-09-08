//
//  UIImage+NDVRoundingAdditions.h
//  NDVKit
//
//  Created by Nathan de Vries on 24/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIImage (NDVRoundingAdditions)


- (UIImage *)imageByRoundingCornersWithRadius:(CGFloat)cornerRadius
                                   borderSize:(CGFloat)borderSize;

/*
- (UIImage *)imageByRoundingCornersWithTopLeftRadius:(NSInteger)topLeftRadius
                                      topRightRadius:(NSInteger)topRightRadius
                                   bottomRightRadius:(NSInteger)bottomRightRadius
                                    bottomLeftRadius:(NSInteger)bottomLeftRadius
                                          borderSize:(NSInteger)borderSize;
*/


@end
