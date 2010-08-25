//
//  CAGradientLayer+NDVShadowAdditions.h
//  NDVKit
//
//  Created by Nathan de Vries on 25/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


typedef enum _NDVShadowStyle {
  NDVShadowStyleFadingUp,
  NDVShadowStyleFadingDown
} NDVShadowStyle;


@interface CAGradientLayer (NDVShadowAdditions)


+ (id)shadowWithDarkColor:(UIColor *)darkColor
               lightColor:(UIColor *)lightColor
                    style:(NDVShadowStyle)shadowStyle;


@end
