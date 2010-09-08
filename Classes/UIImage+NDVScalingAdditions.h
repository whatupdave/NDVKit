//
//  UIImage+NDVResizeAdditions.h
//  NDVKit
//
//  Created by Nathan de Vries on 8/09/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (NDVResizeAdditions)


- (UIImage *)imageScaledToSizeIgnoringAspectRatio:(CGSize)newSize;
- (UIImage *)imageScaledToFitBounds:(CGSize)bounds;


@end
