//
//  UIImage+NDVStretchAdditions.m
//  NDVKit
//
//  Created by Nathan de Vries on 8/09/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "UIImage+NDVStretchAdditions.h"


@implementation UIImage (NDVStretchAdditions)


- (UIImage *)stretchableImage {
  return [self stretchableImageWithLeftCapWidth:[self calculatedLeftCapWidth]
                                   topCapHeight:[self calculatedTopCapHeight]];
}


- (UIImage *)horizontallyStretchableImage {
  return [self stretchableImageWithLeftCapWidth:[self calculatedLeftCapWidth]
                                   topCapHeight:0];
}


- (UIImage *)verticallyStretchableImage {
  return [self stretchableImageWithLeftCapWidth:0
                                   topCapHeight:[self calculatedTopCapHeight]];
}


- (CGFloat)calculatedLeftCapWidth {
  return ((self.size.width - 1.f) / 2.f);
}


- (CGFloat)calculatedTopCapHeight {
  return ((self.size.height - 1.f) / 2.f);
}


@end
