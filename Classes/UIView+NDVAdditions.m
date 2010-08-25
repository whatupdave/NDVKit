//
//  UIView+NDVAdditions.m
//  NDVKit
//
//  Created by Nathan de Vries on 25/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "UIView+NDVAdditions.h"


NSUInteger const UIViewAutoresizingFlexibleBottomRight = (UIViewAutoresizingFlexibleWidth |
                                                          UIViewAutoresizingFlexibleRightMargin |
                                                          UIViewAutoresizingFlexibleHeight |
                                                          UIViewAutoresizingFlexibleBottomMargin);

@implementation UIView (NDVAdditions)


- (CGFloat)left {
  return self.frame.origin.x;
}


- (void)setLeft:(CGFloat)newLeftX {
  CGRect frame = self.frame;
  frame.origin.x = newLeftX;
  self.frame = frame;
}


- (CGFloat)top {
  return self.frame.origin.y;
}


- (void)setTop:(CGFloat)newTopY {
  CGRect frame = self.frame;
  frame.origin.y = newTopY;
  self.frame = frame;
}


- (CGFloat)right {
  return self.frame.origin.x + self.frame.size.width;
}


- (void)setRight:(CGFloat)newRightX {
  CGRect frame = self.frame;
  frame.origin.x = newRightX - frame.size.width;
  self.frame = frame;
}


- (CGFloat)bottom {
  return self.frame.origin.y + self.frame.size.height;
}


- (void)setBottom:(CGFloat)newBottomY {
  CGRect frame = self.frame;
  frame.origin.y = newBottomY - frame.size.height;
  self.frame = frame;
}


- (CGFloat)width {
  return self.frame.size.width;
}


- (void)setWidth:(CGFloat)width {
  CGRect frame = self.frame;
  frame.size.width = width;
  self.frame = frame;
}


- (CGFloat)height {
  return self.frame.size.height;
}


- (void)setHeight:(CGFloat)height {
  CGRect frame = self.frame;
  frame.size.height = height;
  self.frame = frame;
}


- (CGSize)size {
  return self.frame.size;
}


- (void)setSize:(CGSize)size {
  CGRect frame = self.frame;
  frame.size = size;
  self.frame = frame;
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
