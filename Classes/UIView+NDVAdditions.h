//
//  UIView+NDVAdditions.h
//  NDVKit
//
//  Created by Nathan de Vries on 25/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSUInteger const UIViewAutoresizingFlexibleBottomRight;

@interface UIView (NDVAdditions)


- (CGFloat)left;
- (void)setLeft:(CGFloat)newLeftX;

- (CGFloat)top;
- (void)setTop:(CGFloat)newTopY;

- (CGFloat)right;
- (void)setRight:(CGFloat)newRightX;

- (CGFloat)bottom;
- (void)setBottom:(CGFloat)newBottomY;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGSize)size;
- (void)setSize:(CGSize)size;

- (void)removeAllSubviews;

- (NSArray *)descendantsOrSelfWithClass:(Class)theClass;


@end
