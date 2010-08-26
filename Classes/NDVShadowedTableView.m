//
//  NDVShadowedTableView.m
//  NDVKit
//
//  Created by Nathan de Vries on 13/10/09.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  Modifications copyright 2009 Nathan de Vries.
//

#import "NDVShadowedTableView.h"
#import "NDVKit.h"


static const CGFloat kShadowFadeDownHeight = 20.0f;
static const CGFloat kShadowFadeUpHeight = 10.0f;

@implementation NDVShadowedTableView


- (void)layoutSubviews {
	[super layoutSubviews];

	if (!self.originShadow) {
    self.originShadow = [CAGradientLayer shadowWithDarkColor:[UIColor blackColor]
                                                  lightColor:self.backgroundColor
                                                       style:NDVShadowStyleFadingDown];
		[self.layer insertSublayer:self.originShadow atIndex:0];

	} else if (![[self.layer.sublayers objectAtIndex:0] isEqual:self.originShadow]) {
		[self.layer insertSublayer:self.originShadow atIndex:0];
	}

	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue
                   forKey:kCATransactionDisableActions];

  self.originShadow.frame = CGRectMake(0.0f,
                                       self.contentOffset.y,
                                       self.width,
                                       kShadowFadeDownHeight);

	[CATransaction commit];

  if (self.displayOriginShadowOnly) return;

	NSArray* indexPathsForVisibleRows = [self indexPathsForVisibleRows];
	if ([indexPathsForVisibleRows count] == 0) {
		[self.topShadow removeFromSuperlayer];
		self.topShadow = nil;

		[self.bottomShadow removeFromSuperlayer];
		self.bottomShadow = nil;
		return;
	}

	NSIndexPath* firstRow = [indexPathsForVisibleRows objectAtIndex:0];
	if ([firstRow section] == 0 && [firstRow row] == 0) {
		UIView *cell = [self cellForRowAtIndexPath:firstRow];
		if (!self.topShadow) {
      self.topShadow = [CAGradientLayer shadowWithDarkColor:[UIColor blackColor]
                                                 lightColor:self.backgroundColor
                                                      style:NDVShadowStyleFadingUp];
			[cell.layer insertSublayer:self.topShadow atIndex:0];

		} else if ([cell.layer.sublayers indexOfObjectIdenticalTo:self.topShadow] != 0) {
			[cell.layer insertSublayer:self.topShadow atIndex:0];
		}

    self.topShadow.frame = CGRectMake(0.0f,
                                      -kShadowFadeUpHeight,
                                      cell.width,
                                      kShadowFadeUpHeight);

	} else {
		[self.topShadow removeFromSuperlayer];
		self.topShadow = nil;
	}

	NSIndexPath* lastRow = [indexPathsForVisibleRows lastObject];
	if ((NSInteger)[lastRow section] == [self numberOfSections] - 1 &&
      (NSInteger)[lastRow row] == [self numberOfRowsInSection:[lastRow section]] - 1) {

		UIView* cell = [self cellForRowAtIndexPath:lastRow];
		if (!self.bottomShadow) {
      self.bottomShadow = [CAGradientLayer shadowWithDarkColor:[UIColor blackColor]
                                                    lightColor:self.backgroundColor
                                                         style:NDVShadowStyleFadingDown];
			[cell.layer insertSublayer:self.bottomShadow atIndex:0];

		} else if ([cell.layer.sublayers indexOfObjectIdenticalTo:self.bottomShadow] != 0) {
			[cell.layer insertSublayer:self.bottomShadow atIndex:0];
		}

    self.bottomShadow.frame = CGRectMake(0.0f,
                                         cell.height,
                                         cell.width,
                                         kShadowFadeDownHeight);

	} else {
		[self.bottomShadow removeFromSuperlayer];
		self.bottomShadow = nil;
	}
}


- (void)dealloc {
  RELEASE_AND_SET_TO_NIL(_originShadow,
                         _topShadow,
                         _bottomShadow);

  [super dealloc];
}


@synthesize displayOriginShadowOnly=_displayOriginShadowOnly;
@synthesize originShadow=_originShadow;
@synthesize topShadow=_topShadow;
@synthesize bottomShadow=_bottomShadow;


@end
