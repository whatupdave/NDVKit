//
//  CGImage+NDVAdditions.m
//  NDVKit
//
//  Created by Nathan de Vries on 25/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CGImage+NDVAdditions.h"


CGImageRef CGImageMaskCreateWithImageRef(CGImageRef imageRef) {
  size_t maskWidth = CGImageGetWidth(imageRef);
  size_t maskHeight = CGImageGetHeight(imageRef);
  size_t bytesPerRow = maskWidth;
  size_t bufferSize = maskWidth * maskHeight;

  CFMutableDataRef dataBuffer = CFDataCreateMutable(kCFAllocatorDefault, 0);
  CFDataSetLength(dataBuffer, bufferSize);

  CGColorSpaceRef greyColorSpaceRef = CGColorSpaceCreateDeviceGray();
  CGContextRef ctx = CGBitmapContextCreate(CFDataGetMutableBytePtr(dataBuffer),
                                           maskWidth,
                                           maskHeight,
                                           8,
                                           bytesPerRow,
                                           greyColorSpaceRef,
                                           kCGImageAlphaNone);

  CGContextDrawImage(ctx, CGRectMake(0, 0, maskWidth, maskHeight), imageRef);
  CGContextRelease(ctx);

  CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData(dataBuffer);
  CGImageRef maskImageRef = CGImageMaskCreate(maskWidth,
                                              maskHeight,
                                              8,
                                              8,
                                              bytesPerRow,
                                              dataProvider,
                                              NULL,
                                              FALSE);

  CGDataProviderRelease(dataProvider);
  CGColorSpaceRelease(greyColorSpaceRef);
  CFRelease(dataBuffer);

  return maskImageRef;
}
