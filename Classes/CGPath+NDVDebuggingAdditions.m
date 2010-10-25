//
//  CGPath+NDVDebuggingAdditions.m
//  NDVKit
//
//  Created by Nathan de Vries on 25/10/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CGPath+NDVDebuggingAdditions.h"
#import "NDVDebuggingMacros.h"


static void CGPathLogElement(void* info, const CGPathElement* element) {
  const CGPoint* points;
  points = element->points;

  switch (element->type) {
    case kCGPathElementMoveToPoint: {
      ALog(@"moveto (%g, %g)", points[0].x, points[0].y);
      break;
    }
    case kCGPathElementAddLineToPoint: {
      ALog(@"lineto (%g, %g)", points[0].x, points[0].y);
      break;
    }
    case kCGPathElementAddQuadCurveToPoint: {
      ALog(@"quadto (%g, %g) (%g, %g)", points[0].x, points[0].y, points[1].x, points[1].y);
      break;
    }
    case kCGPathElementAddCurveToPoint: {
      ALog(@"curveto (%g, %g) (%g, %g) (%g, %g)", points[0].x, points[0].y, points[1].x, points[1].y, points[2].x, points[2].y);
      break;
    }
    case kCGPathElementCloseSubpath: {
      ALog(@"closepath");
      break;
    }
  }
}


void CGPathLogElements(CGPathRef path) {
  CGPathApply(path, NULL, &CGPathLogElement);
}
