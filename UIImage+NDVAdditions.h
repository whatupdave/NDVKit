//
//  UIImage+NDVAdditions.h
//  NDVKit
//
//  Created by Nathan de Vries on 24/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIImage (NDVAdditions)


- (UIImage *)imageScaledToSizeIgnoringAspectRatio:(CGSize)newSize;
- (UIImage *)imageScaledToFitBounds:(CGSize)bounds;

- (UIImage *)stretchableImage;
- (UIImage *)horizontallyStretchableImage;
- (UIImage *)verticallyStretchableImage;


@end
