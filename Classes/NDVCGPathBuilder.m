//
//  NDVCGPathBuilder.m
//  NDVKit
//
//  Created by Nathan de Vries on 25/10/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "NDVCGPathBuilder.h"


@implementation NDVCGPathBuilder


+ (id)pathBuilderWithTransform:(CGAffineTransform *)transform_ {
  return [[[self alloc] initWithTransform:transform_] autorelease];
}


- (id)initWithTransform:(CGAffineTransform *)transform_ {
  if ((self = [self init])) {
    transform = transform_;
    path = CGPathCreateMutable();

    ox = oy = 0.f;
    px = py = 0.f;
  }
  return self;
}


-(CGPathRef)path {
  return path;
}


-(void)moveToPointWithX:(CGFloat)x y:(CGFloat)y absolute:(BOOL)isAbsolute {
  if ( !isAbsolute ) {
    x += px;
    y += py;
  }

  CGPathMoveToPoint(path, transform, x, y);

  ox = px;
  oy = py;
  px = x;
  py = y;
}


-(void)addLineToPointWithX:(CGFloat)x y:(CGFloat)y absolute:(BOOL)isAbsolute {
  if ( !isAbsolute ) {
    x += px;
    y += py;
  }

  CGPathAddLineToPoint(path, transform, x, y);

  ox = px;
  oy = py;
  px = x;
  py = y;
}


- (void)addHorizontalLineToPointWithX:(CGFloat)x absolute:(BOOL)isAbsolute {
  [self addLineToPointWithX:x y:(isAbsolute ? py : 0.f) absolute:isAbsolute];
}


- (void)addVerticalLineToPointWithY:(CGFloat)y absolute:(BOOL)isAbsolute {
  [self addLineToPointWithX:(isAbsolute ? px : 0.f) y:y absolute:isAbsolute];
}


-(void)addCubicCurveToPointWithCp1x:(CGFloat)cp1x cp1y:(CGFloat)cp1y cp2x:(CGFloat)cp2x cp2y:(CGFloat)cp2y x:(CGFloat)x y:(CGFloat)y absolute:(BOOL)isAbsolute {
  if ( !isAbsolute ) {
    cp1x += px;
    cp1y += py;
    cp2x += px;
    cp2y += py;
    x += px;
    y += py;
  }

  CGPathAddCurveToPoint(path, transform, cp1x, cp1y, cp2x, cp2y, x, y);

  ox = px;
  oy = py;
  px = x;
  py = y;
}


- (void)addSmoothCubicCurveToPointWithCp2x:(CGFloat)cp2x cp2y:(CGFloat)cp2y x:(CGFloat)x y:(CGFloat)y absolute:(BOOL)isAbsolute {
  CGFloat cp1x;
  CGFloat cp1y;

  if ( isAbsolute ) {
    cp1x = 2 * px - ox;
    cp1y = 2 * py - oy;

  } else {
    cp1x = px - ox;
    cp1y = py - oy;
  }

  [self addCubicCurveToPointWithCp1x:cp1x cp1y:cp1y cp2x:cp2x cp2y:cp2y x:x y:y absolute:isAbsolute];
}


-(void)addQuadraticCurveToPointWithCpx:(CGFloat)cpx cpy:(CGFloat)cpy x:(CGFloat)x y:(CGFloat)y absolute:(BOOL)isAbsolute {
  if ( !isAbsolute ) {
    cpx += px;
    cpy += py;
    x += px;
    y += py;
  }

  CGPathAddQuadCurveToPoint(path, transform, cpx, cpy, x, y);

  ox = px;
  oy = py;
  px = x;
  py = y;
}


- (void)addSmoothQuadraticCurveToPointWithX:(CGFloat)x y:(CGFloat)y absolute:(BOOL)isAbsolute {
  CGFloat cpx;
  CGFloat cpy;

  if ( isAbsolute ) {
    cpx = 2 * px - ox;
    cpy = 2 * py - oy;

  } else {
    cpx = px - ox;
    cpy = py - oy;
  }

  [self addQuadraticCurveToPointWithCpx:cpx cpy:cpy x:x y:y absolute:isAbsolute];
}


-(void)closePath {
  CGPathCloseSubpath(path);
}


-(void)dealloc {
  CGPathRelease(path);
  [super dealloc];
}


@end
