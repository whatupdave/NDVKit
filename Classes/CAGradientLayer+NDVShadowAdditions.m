//
//  CAGradientLayer+NDVShadowAdditions.m
//  NDVKit
//
//  Created by Nathan de Vries on 25/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CAGradientLayer+NDVShadowAdditions.h"


@implementation CAGradientLayer (NDVShadowAdditions)


+ (id)shadowWithDarkColor:(UIColor *)darkColor
               lightColor:(UIColor *)lightColor
                    style:(NDVShadowStyle)shadowStyle {

	CAGradientLayer* shadowLayer = [[[self alloc] init] autorelease];
  shadowLayer.frame = CGRectZero;

  CGColorRef darkColorRef = [darkColor colorWithAlphaComponent:0.5f].CGColor;
  CGColorRef lightColorRef = [lightColor colorWithAlphaComponent:0.0f].CGColor;

	shadowLayer.colors = (shadowStyle == NDVShadowStyleFadingUp ?
                        [NSArray arrayWithObjects:(id)lightColorRef, (id)darkColorRef, nil] :
                        [NSArray arrayWithObjects:(id)darkColorRef, (id)lightColorRef, nil]);

	return shadowLayer;
}


@end
