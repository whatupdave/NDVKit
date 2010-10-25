//
//  NDVCGPathBuilder.h
//  NDVKit
//
//  Created by Nathan de Vries on 25/10/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NDVCGPathBuilder : NSObject {

  CGMutablePathRef path;
  CGAffineTransform* transform;

  // last control point for the smooth curveTo and quadTo
  CGFloat ox;
  CGFloat oy;

  // last point
  CGFloat px;
  CGFloat py;

}


+ (id)pathBuilderWithTransform:(CGAffineTransform *)transform_;
- (id)initWithTransform:(CGAffineTransform *)transform_;


- (CGPathRef)path;


- (void)moveToPointWithX:(CGFloat)x y:(CGFloat)y absolute:(BOOL)isAbsolute;


- (void)addLineToPointWithX:(CGFloat)x y:(CGFloat)y absolute:(BOOL)isAbsolute;
- (void)addHorizontalLineToPointWithX:(CGFloat)x absolute:(BOOL)isAbsolute;
- (void)addVerticalLineToPointWithY:(CGFloat)y absolute:(BOOL)isAbsolute;


- (void)addCubicCurveToPointWithCp1x:(CGFloat)cp1x cp1y:(CGFloat)cp1y cp2x:(CGFloat)cp2x cp2y:(CGFloat)cp2y x:(CGFloat)x y:(CGFloat)y absolute:(BOOL)isAbsolute;
- (void)addSmoothCubicCurveToPointWithCp2x:(CGFloat)cp2x cp2y:(CGFloat)cp2y x:(CGFloat)x y:(CGFloat)y absolute:(BOOL)isAbsolute;


- (void)addQuadraticCurveToPointWithCpx:(CGFloat)cpx cpy:(CGFloat)cpy x:(CGFloat)x y:(CGFloat)y absolute:(BOOL)isAbsolute;
- (void)addSmoothQuadraticCurveToPointWithX:(CGFloat)x y:(CGFloat)y absolute:(BOOL)isAbsolute;


- (void)closePath;


@end
