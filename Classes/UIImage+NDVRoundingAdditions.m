//
//  UIImage+NDVRoundingAdditions.m
//  NDVKit
//
//  Created by Nathan de Vries on 24/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "UIImage+NDVRoundingAdditions.h"
#import "UIImage+NDVAlphaAdditions.h"


@interface UIImage (NDVPrivateRoundingAdditions)

- (void)addRoundedRectToPath:(CGRect)rect
                     context:(CGContextRef)context
                   ovalWidth:(CGFloat)ovalWidth
                  ovalHeight:(CGFloat)ovalHeight;

@end


@implementation UIImage (NDVRoundingAdditions)


- (UIImage *)imageByRoundingCornersWithRadius:(CGFloat)cornerRadius
                                   borderSize:(CGFloat)borderSize {

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

  CGContextBeginPath(bitmapContextRef); {

    [self addRoundedRectToPath:CGRectMake(borderSize, borderSize, originalWidth - borderSize * 2, originalHeight - borderSize * 2)
                       context:bitmapContextRef
                     ovalWidth:cornerRadius
                    ovalHeight:cornerRadius];

  } CGContextClosePath(bitmapContextRef);

  CGContextClip(bitmapContextRef);

  CGContextDrawImage(bitmapContextRef, CGRectMake(0, 0, originalWidth, originalHeight), originalImageRef);

  CGImageRef clippedImageRef = CGBitmapContextCreateImage(bitmapContextRef);
  CGContextRelease(bitmapContextRef);

  UIImage* roundedImage = [UIImage imageWithCGImage:clippedImageRef];
  CGImageRelease(clippedImageRef);

  return roundedImage;
}


# pragma mark -
# pragma mark Private helper methods


- (void)addRoundedRectToPath:(CGRect)rect
                     context:(CGContextRef)context
                   ovalWidth:(CGFloat)ovalWidth
                  ovalHeight:(CGFloat)ovalHeight {

  if (ovalWidth == 0 || ovalHeight == 0) {
    CGContextAddRect(context, rect);
    return;
  }

  CGContextSaveGState(context);
  CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
  CGContextScaleCTM(context, ovalWidth, ovalHeight);
  CGFloat fw = CGRectGetWidth(rect) / ovalWidth;
  CGFloat fh = CGRectGetHeight(rect) / ovalHeight;
  CGContextMoveToPoint(context, fw, fh/2);
  CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1); // top right
  CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // bottom right
  CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // bottom left
  CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // top left
  CGContextClosePath(context);
  CGContextRestoreGState(context);
}


@end
