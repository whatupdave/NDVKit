//
//  CGGeometry+NDVAdditions.h
//  NDVKit
//
//  Created by Nathan de Vries on 26/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>


CG_EXTERN CGRect CGRectSetX(CGRect rect, CGFloat x);

CG_EXTERN CGRect CGRectSetY(CGRect rect, CGFloat y);

CG_EXTERN CGRect CGRectSetWidth(CGRect rect, CGFloat width);

CG_EXTERN CGRect CGRectSetHeight(CGRect rect, CGFloat height);

CG_EXTERN CGRect CGRectSetSize(CGRect rect, CGSize size);

CG_EXTERN CGRect CGRectSetOrigin(CGRect rect, CGPoint origin);

CG_EXTERN CGRect CGRectSetZeroOrigin(CGRect rect);

CG_EXTERN CGRect CGRectSetZeroSize(CGRect rect);
