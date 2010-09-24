//
//  UIImage+NDVRoundingAdditions.h
//  NDVKit
//
//  Created by Nathan de Vries on 24/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//


#import <UIKit/UIKit.h>


typedef enum _NDVRectPathRounding {
  NDVRectPathRoundingNone              = 0,
  NDVRectPathRoundingTopRightCorner    = 1 << 0,
  NDVRectPathRoundingBottomRightCorner = 1 << 1,
  NDVRectPathRoundingBottomLeftCorner  = 1 << 2,
  NDVRectPathRoundingTopLeftCorner     = 1 << 3,
} NDVRectPathRounding;


extern NDVRectPathRounding NDVRectPathRoundingTopCorners;
extern NDVRectPathRounding NDVRectPathRoundingBottomCorners;
extern NDVRectPathRounding NDVRectPathRoundingLeftCorners;
extern NDVRectPathRounding NDVRectPathRoundingRightCorners;
extern NDVRectPathRounding NDVRectPathRoundingAllCorners;


@interface UIImage (NDVRoundingAdditions)


- (UIImage *)imageByRoundingCornersWithRadius:(CGFloat)cornerRadius
                                   cornerMask:(NDVRectPathRounding)cornerMask;

- (UIImage *)imageByRoundingCornersWithRadius:(CGFloat)cornerRadius
                                   borderSize:(CGFloat)borderSize
                                   cornerMask:(NDVRectPathRounding)cornerMask;


@end
