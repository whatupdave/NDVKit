//
//  UIView+NDVAdditions.m
//  NDVKit
//
//  Created by Nathan de Vries on 25/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

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
