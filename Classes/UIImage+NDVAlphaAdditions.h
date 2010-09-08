//
//  UIImage+NDVAlphaAdditions.h
//  NDVKit
//
//  Created by Nathan de Vries on 8/09/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (NDVAlphaAdditions)


- (BOOL)hasAlphaChannel;
- (UIImage *)imageByAddingAlphaChannel;
- (UIImage *)imageByAddingTransparentBorderOfSize:(NSUInteger)borderSize;


@end
