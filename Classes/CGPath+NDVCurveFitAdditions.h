//
//  CGPath+NDVCurveFitAdditions.h
//  NDVKit
//
//  Created by Nathan de Vries on 26/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>


CG_EXTERN CGPathRef CGPathCreateByFittingCurveThroughCGPoints(NSArray* points, CGFloat smoothing);
