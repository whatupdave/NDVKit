//
//  CGPath+NDVCurveFitAdditions.mm
//  NDVKit
//
//  Created by Nathan de Vries on 26/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "CGPath+NDVCurveFitAdditions.h"
#import "bezier-utils.h"


CGPathRef CGPathCreateByFittingCurveThroughCGPoints(NSArray* points, CGFloat smoothing) {

  Geom::Point* rawPoints;
  CGMutablePathRef resultPath = CGPathCreateMutable();

  for (NSUInteger i = 0; i < [points count]; i++) {
    CGPoint point = [(NSValue *)[points objectAtIndex:i] CGPointValue];
    rawPoints[i] = Geom::Point(point.x, point.y);
  }

  NSUInteger maxSegments = 256;
  Geom::Point* fittedPointsBuffer;
  fittedPointsBuffer = ((Geom::Point*) malloc(sizeof(Geom::Point) * maxSegments * 4 ));

  NSUInteger segments = bezier_fit_cubic_r(fittedPointsBuffer, rawPoints, [points count], smoothing, maxSegments);

  if (segments > 0) {
    CGPoint tempPoints[3];
    NSUInteger segmentElement;

		tempPoints[0].x = (CGFloat)fittedPointsBuffer[0][Geom::X];
		tempPoints[0].y = (CGFloat)fittedPointsBuffer[0][Geom::Y];

    CGPathMoveToPoint(resultPath, NULL, tempPoints[0].x, tempPoints[0].y);

		for(NSUInteger i = 0; i < segments; i++) {
			segmentElement = (i * 4) + 1;

			tempPoints[0].x = (CGFloat)fittedPointsBuffer[segmentElement][Geom::X];
			tempPoints[0].y = (CGFloat)fittedPointsBuffer[segmentElement++][Geom::Y];
			tempPoints[1].x = (CGFloat)fittedPointsBuffer[segmentElement][Geom::X];
			tempPoints[1].y = (CGFloat)fittedPointsBuffer[segmentElement++][Geom::Y];
			tempPoints[2].x = (CGFloat)fittedPointsBuffer[segmentElement][Geom::X];
			tempPoints[2].y = (CGFloat)fittedPointsBuffer[segmentElement][Geom::Y];

      CGPathAddCurveToPoint(resultPath,       // path
                            NULL,             // transform
                            tempPoints[0].x,  // cp1x
                            tempPoints[0].y,  // cp1y
                            tempPoints[1].x,  // cp2x
                            tempPoints[1].y,  // cp2y
                            tempPoints[2].x,  // x
                            tempPoints[2].y); // y
		}

  } else {
    // Not sure what went wrong
  }

  free(rawPoints);
  free(fittedPointsBuffer);

  return resultPath;
}
