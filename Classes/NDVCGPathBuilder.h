/*
 * NDVCGPathBuilder.h
 *
 * Created by Nathan de Vries on 25/10/10.
 *
 * Copyright (c) 2008-2011, Nathan de Vries.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the copyright holder nor the names of any
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */


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
