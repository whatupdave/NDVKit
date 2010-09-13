//
//  UIImage+NDVStretchAdditions.h
//  NDVKit
//
//  Created by Nathan de Vries on 8/09/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (NDVStretchAdditions)


- (UIImage *)stretchableImage;
- (UIImage *)horizontallyStretchableImage;
- (UIImage *)verticallyStretchableImage;

- (CGFloat)calculatedLeftCapWidth;
- (CGFloat)calculatedTopCapHeight;


@end
