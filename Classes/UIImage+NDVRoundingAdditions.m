//
//  UIImage+NDVRoundingAdditions.m
//  NDVKit
//
//  Created by Nathan de Vries on 24/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "UIImage+NDVRoundingAdditions.h"
#import "UIImage+NDVAlphaAdditions.h"


NDVRectPathRounding NDVRectPathRoundingTopCorners    = (NDVRectPathRoundingTopLeftCorner | NDVRectPathRoundingTopRightCorner);
NDVRectPathRounding NDVRectPathRoundingBottomCorners = (NDVRectPathRoundingBottomLeftCorner | NDVRectPathRoundingBottomRightCorner);
NDVRectPathRounding NDVRectPathRoundingLeftCorners   = (NDVRectPathRoundingTopLeftCorner | NDVRectPathRoundingBottomLeftCorner);
NDVRectPathRounding NDVRectPathRoundingRightCorners  = (NDVRectPathRoundingTopRightCorner | NDVRectPathRoundingBottomRightCorner);
NDVRectPathRounding NDVRectPathRoundingAllCorners    = (NDVRectPathRoundingTopRightCorner | NDVRectPathRoundingBottomRightCorner |
                                                        NDVRectPathRoundingBottomLeftCorner | NDVRectPathRoundingTopLeftCorner);


@interface UIImage (NDVPrivateRoundingAdditions)

void NDVCGContextAddRoundedRectPath(CGContextRef c, CGRect rect, CGFloat ovalWidth, CGFloat ovalHeight, NDVRectPathRounding roundingMask);

@end


@implementation UIImage (NDVRoundingAdditions)


- (UIImage *)imageByRoundingCornersWithRadius:(CGFloat)cornerRadius
                                   cornerMask:(NDVRectPathRounding)cornerMask {

  return [self imageByRoundingCornersWithRadius:cornerRadius
                                     borderSize:0.f
                                     cornerMask:cornerMask];
}

- (UIImage *)imageByRoundingCornersWithRadius:(CGFloat)cornerRadius
                                   borderSize:(CGFloat)borderSize
                                   cornerMask:(NDVRectPathRounding)cornerMask {

  UIImage* originalImage = [self imageByAddingAlphaChannel];
  CGImageRef originalImageRef = originalImage.CGImage;

  size_t originalWidth = CGImageGetWidth(originalImageRef);
  size_t originalHeight = CGImageGetHeight(originalImageRef);

  CGContextRef bitmapContextRef = CGBitmapContextCreate(NULL,
                                                        originalWidth,
                                                        originalHeight,
                                                        CGImageGetBitsPerComponent(originalImageRef),
                                                        0,
                                                        CGImageGetColorSpace(originalImageRef),
                                                        CGImageGetBitmapInfo(originalImageRef));

  NDVCGContextAddRoundedRectPath(bitmapContextRef,
                                 CGRectMake(borderSize, borderSize, originalWidth - borderSize * 2, originalHeight - borderSize * 2),
                                 cornerRadius,
                                 cornerRadius,
                                 cornerMask);

  CGContextClip(bitmapContextRef);

  CGContextDrawImage(bitmapContextRef, CGRectMake(0, 0, originalWidth, originalHeight), originalImageRef);

  CGImageRef clippedImageRef = CGBitmapContextCreateImage(bitmapContextRef);
  CGContextRelease(bitmapContextRef);

  UIImage* roundedImage = [UIImage imageWithCGImage:clippedImageRef];
  CGImageRelease(clippedImageRef);

  return roundedImage;
}


void NDVCGContextAddRoundedRectPath(CGContextRef c, CGRect rect, CGFloat ovalWidth, CGFloat ovalHeight, NDVRectPathRounding roundingMask) {
  if (ovalWidth == 0 || ovalHeight == 0 || roundingMask == NDVRectPathRoundingNone) {
    CGContextBeginPath(c); {
      CGContextAddRect(c, rect);
    } CGContextClosePath(c);
    return;
  }

  CGContextSaveGState(c); {

    CGContextBeginPath(c); {

      CGContextTranslateCTM(c, CGRectGetMinX(rect), CGRectGetMinY(rect));
      CGContextScaleCTM(c, ovalWidth, ovalHeight);

      CGFloat fw = CGRectGetWidth(rect) / ovalWidth;
      CGFloat fh = CGRectGetHeight(rect) / ovalHeight;

      CGContextMoveToPoint(c, fw, fh/2);

      CGContextAddArcToPoint(c, fw, fh, fw/2, fh, (roundingMask & NDVRectPathRoundingTopRightCorner) ? 1 : 0);
      CGContextAddArcToPoint(c, 0, fh, 0, fh/2, (roundingMask & NDVRectPathRoundingTopLeftCorner) ? 1 : 0);
      CGContextAddArcToPoint(c, 0, 0, fw/2, 0, (roundingMask & NDVRectPathRoundingBottomLeftCorner) ? 1 : 0);
      CGContextAddArcToPoint(c, fw, 0, fw, fh/2, (roundingMask & NDVRectPathRoundingBottomRightCorner) ? 1 : 0);

    } CGContextClosePath(c);

  } CGContextRestoreGState(c);
}


@end
