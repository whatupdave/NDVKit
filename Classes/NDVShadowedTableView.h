/*
 * NDVShadowedTableView.h
 *
 * Created by Nathan de Vries on 13/10/09.
 * Copyright 2009 Matt Gallagher. All rights reserved.
 *
 * Modifications copyright 2009 Nathan de Vries.
 */

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface NDVShadowedTableView : UITableView {

  BOOL _displayOriginShadowOnly;

  CAGradientLayer* _originShadow;
	CAGradientLayer* _topShadow;
	CAGradientLayer* _bottomShadow;

}


@property (nonatomic, assign) BOOL displayOriginShadowOnly;
@property (nonatomic, retain) CAGradientLayer* originShadow;
@property (nonatomic, retain) CAGradientLayer* topShadow;
@property (nonatomic, retain) CAGradientLayer* bottomShadow;


@end
