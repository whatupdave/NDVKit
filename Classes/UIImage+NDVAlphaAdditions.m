//
//  UIImage+NDVAlphaAdditions.m
//  NDVKit
//
//  Created by Nathan de Vries on 8/09/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "UIImage+NDVAlphaAdditions.h"


@interface UIImage (NDVPrivateAlphaAdditions)


- (CGImageRef)newBorderMask:(NSUInteger)borderSize size:(CGSize)size;


@end


@implementation UIImage (NDVAlphaAdditions)


- (BOOL)hasAlphaChannel {
  CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
  return (alpha == kCGImageAlphaFirst ||
          alpha == kCGImageAlphaLast ||
          alpha == kCGImageAlphaPremultipliedFirst ||
          alpha == kCGImageAlphaPremultipliedLast);
}


- (UIImage *)imageByAddingAlphaChannel {
  if ([self hasAlphaChannel]) return self;

  CGImageRef currentImageRef = self.CGImage;
  size_t width = CGImageGetWidth(currentImageRef);
  size_t height = CGImageGetHeight(currentImageRef);

  CGColorSpaceRef rgbColorSpaceRef = CGColorSpaceCreateDeviceRGB();
  CGContextRef bitmapContextRef = CGBitmapContextCreate(NULL,
                                                        width,
                                                        height,
                                                        8,
                                                        0,
                                                        rgbColorSpaceRef,
                                                        kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
  CGColorSpaceRelease(rgbColorSpaceRef);

  CGContextDrawImage(bitmapContextRef, CGRectMake(0, 0, width, height), currentImageRef);
  CGImageRef imageRefWithAlphaChannel = CGBitmapContextCreateImage(bitmapContextRef);
  UIImage* imageWithAlphaChannel = [UIImage imageWithCGImage:imageRefWithAlphaChannel];

  CGContextRelease(bitmapContextRef);
  CGImageRelease(imageRefWithAlphaChannel);

  return imageWithAlphaChannel;
}


- (UIImage *)imageByAddingTransparentBorderOfSize:(NSUInteger)borderSize {
  UIImage* originalImage = [self imageByAddingAlphaChannel];

  CGImageRef originalImageRef = originalImage.CGImage;
  size_t originalWidth = CGImageGetWidth(originalImageRef);
  size_t originalHeight = CGImageGetHeight(originalImageRef);


  size_t newWidth = originalWidth + borderSize * 2.f;
  size_t newHeight = originalHeight + borderSize * 2.f;


  // Build a context that's the same dimensions as the new size
  CGContextRef bitmapContextRef = CGBitmapContextCreate(NULL,
                                                        newWidth,
                                                        newHeight,
                                                        CGImageGetBitsPerComponent(originalImageRef),
                                                        0,
                                                        CGImageGetColorSpace(originalImageRef),
                                                        CGImageGetBitmapInfo(originalImageRef));

  CGRect internalRect = CGRectMake(borderSize, borderSize, originalHeight, originalHeight);
  CGContextDrawImage(bitmapContextRef, internalRect, originalImageRef);
  CGImageRef borderImageRef = CGBitmapContextCreateImage(bitmapContextRef);

  // Create a mask to make the border transparent, and combine it with the image
  CGImageRef maskImageRef = [self newBorderMask:borderSize size:CGSizeMake(newWidth, newHeight)];
  CGImageRef transparentBorderImageRef = CGImageCreateWithMask(borderImageRef, maskImageRef);
  UIImage* transparentBorderImage = [UIImage imageWithCGImage:transparentBorderImageRef];

  CGContextRelease(bitmapContextRef);
  CGImageRelease(borderImageRef);
  CGImageRelease(maskImageRef);
  CGImageRelease(transparentBorderImageRef);

  return transparentBorderImage;
}


# pragma mark -
# pragma mark Private helper methods


- (CGImageRef)newBorderMask:(NSUInteger)borderSize size:(CGSize)size {
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();

  // Build a context that's the same dimensions as the new size
  CGContextRef maskContext = CGBitmapContextCreate(NULL,
                                                   size.width,
                                                   size.height,
                                                   8, // 8-bit grayscale
                                                   0,
                                                   colorSpace,
                                                   kCGBitmapByteOrderDefault | kCGImageAlphaNone);

  // Start with a mask that's entirely transparent
  CGContextSetFillColorWithColor(maskContext, [UIColor blackColor].CGColor);
  CGContextFillRect(maskContext, CGRectMake(0, 0, size.width, size.height));

  // Make the inner part (within the border) opaque
  CGContextSetFillColorWithColor(maskContext, [UIColor whiteColor].CGColor);
  CGContextFillRect(maskContext, CGRectMake(borderSize, borderSize, size.width - borderSize * 2, size.height - borderSize * 2));

  CGImageRef maskImageRef = CGBitmapContextCreateImage(maskContext);

  CGContextRelease(maskContext);
  CGColorSpaceRelease(colorSpace);

  return maskImageRef;
}


@end
