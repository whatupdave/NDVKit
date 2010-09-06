//
//  NDVShadowedTableView.h
//  NDVKit
//
//  Created by Nathan de Vries on 13/10/09.
//  Copyright 2009 Nathan de Vries. All rights reserved.
//

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
