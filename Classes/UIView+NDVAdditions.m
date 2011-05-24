/*
 * UIView+NDVAdditions.m
 *
 * Created by Nathan de Vries on 25/08/10.
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


#import "UIView+NDVAdditions.h"
#import "CGGeometry+NDVAdditions.h"


NSUInteger const UIViewAutoresizingFlexibleBottomRight = (UIViewAutoresizingFlexibleWidth |
                                                          UIViewAutoresizingFlexibleRightMargin |
                                                          UIViewAutoresizingFlexibleHeight |
                                                          UIViewAutoresizingFlexibleBottomMargin);

@implementation UIView (NDVAdditions)


- (CGFloat)left {
  return self.frame.origin.x;
}


- (void)setLeft:(CGFloat)newLeftX {
  self.frame = CGRectSetX(self.frame, newLeftX);
}


- (CGFloat)top {
  return self.frame.origin.y;
}


- (void)setTop:(CGFloat)newTopY {
  self.frame = CGRectSetY(self.frame, newTopY);
}


- (CGFloat)right {
  return self.frame.origin.x + self.width;
}


- (void)setRight:(CGFloat)newRightX {
  self.frame = CGRectSetX(self.frame, (newRightX - self.width));
}


- (CGFloat)bottom {
  return self.frame.origin.y + self.frame.size.height;
}


- (void)setBottom:(CGFloat)newBottomY {
  self.frame = CGRectSetY(self.frame, (newBottomY - self.height));
}


- (CGFloat)width {
  return self.frame.size.width;
}


- (void)setWidth:(CGFloat)width {
  self.frame = CGRectSetWidth(self.frame, width);
}


- (CGFloat)height {
  return self.frame.size.height;
}


- (void)setHeight:(CGFloat)height {
  self.frame = CGRectSetHeight(self.frame, height);
}


- (CGSize)size {
  return self.frame.size;
}


- (void)setSize:(CGSize)size {
  self.frame = CGRectSetSize(self.frame, size);
}


- (CGPoint)origin {
  return self.frame.origin;
}


- (void)setOrigin:(CGPoint)origin {
  self.frame = CGRectSetOrigin(self.frame, origin);
}


- (void)removeAllSubviews {
  [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}


- (NSArray *)descendantsOrSelfWithClass:(Class)theClass {
  NSMutableArray* matches = [NSMutableArray array];

  if ([self isKindOfClass:theClass])
    [matches addObject:self];

  for (UIView* child in self.subviews) {
    [matches addObjectsFromArray:[child descendantsOrSelfWithClass:theClass]];
  }

  return matches;
}


@end
