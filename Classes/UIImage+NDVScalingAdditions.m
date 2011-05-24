/*
 * UIImage+NDVScalingAdditions.m
 *
 * Created by Nathan de Vries on 8/09/10.
 *
 * Copyright (c) 2008-2011, Nathan de Vries.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the copyright holder nor the names of any
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */


#import "UIImage+NDVScalingAdditions.h"


@interface UIImage (NDVScalingPrivateAdditions)


- (UIImage *)imageScaledToSize:(CGSize)newSize
                 withTransform:(CGAffineTransform)transform
                drawTransposed:(BOOL)transpose;

- (CGAffineTransform)transformForOrientationWithSize:(CGSize)newSize;


@end


@implementation UIImage (NDVResizeAdditions)


- (UIImage *)imageScaledToSizeIgnoringAspectRatio:(CGSize)newSize {
  BOOL drawTransposed;

  switch (self.imageOrientation) {
    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
      drawTransposed = YES;
      break;

    default:
      drawTransposed = NO;
  }

  return [self imageScaledToSize:newSize
                   withTransform:[self transformForOrientationWithSize:newSize]
                  drawTransposed:drawTransposed];
}


- (UIImage *)imageScaledToFitBounds:(CGSize)bounds {
  CGFloat horizontalRatio = bounds.width / self.size.width;
  CGFloat verticalRatio = bounds.height / self.size.height;
  CGFloat ratio = MIN(horizontalRatio, verticalRatio);

  CGSize newSize = CGSizeMake(self.size.width * ratio,
                              self.size.height * ratio);

  if (self.size.width <= newSize.width &&
      self.size.height <= newSize.height) {

    return self;

  } else {
    return [self imageScaledToSizeIgnoringAspectRatio:newSize];
  }
}


# pragma mark -
# pragma mark Private helper methods


- (UIImage *)imageScaledToSize:(CGSize)newSize
                 withTransform:(CGAffineTransform)transform
                drawTransposed:(BOOL)transpose {

  CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
  CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
  CGImageRef imageRef = self.CGImage;

  // Fix for 24bit non-alpha images
	CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
	if (CGImageGetAlphaInfo(imageRef) == kCGImageAlphaNone) {
		bitmapInfo &= ~kCGBitmapAlphaInfoMask;
		bitmapInfo |= kCGImageAlphaNoneSkipLast;
	}

  CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                              newRect.size.width,
                                              newRect.size.height,
                                              CGImageGetBitsPerComponent(imageRef),
                                              0,
                                              CGImageGetColorSpace(imageRef),
                                              bitmapInfo);

  CGContextConcatCTM(bitmap, transform);
  CGContextSetInterpolationQuality(bitmap, kCGInterpolationHigh);
  CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);

  CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
  UIImage* newImage = [UIImage imageWithCGImage:newImageRef];

  CGContextRelease(bitmap);
  CGImageRelease(newImageRef);

  return newImage;
}


- (CGAffineTransform)transformForOrientationWithSize:(CGSize)newSize {
  CGAffineTransform transform = CGAffineTransformIdentity;

  switch (self.imageOrientation) {
    case UIImageOrientationDown:
    case UIImageOrientationDownMirrored:
      transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
      transform = CGAffineTransformRotate(transform, (CGFloat)M_PI);
      break;

    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
      transform = CGAffineTransformTranslate(transform, newSize.width, 0);
      transform = CGAffineTransformRotate(transform, (CGFloat)M_PI_2);
      break;

    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
      transform = CGAffineTransformTranslate(transform, 0, newSize.height);
      transform = CGAffineTransformRotate(transform, -(CGFloat)M_PI_2);
      break;

    default:
      break;
  }

  switch (self.imageOrientation) {
    case UIImageOrientationUpMirrored:
    case UIImageOrientationDownMirrored:
      transform = CGAffineTransformTranslate(transform, newSize.width, 0);
      transform = CGAffineTransformScale(transform, -1, 1);
      break;

    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRightMirrored:
      transform = CGAffineTransformTranslate(transform, newSize.height, 0);
      transform = CGAffineTransformScale(transform, -1, 1);
      break;

    default:
      break;
  }

  return transform;
}


@end
