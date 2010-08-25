//
//  UINavigationController+NDVAdditions.h
//  NDVKit
//
//  Created by Nathan de Vries on 25/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UINavigationController (NDVAdditions)


+ (id)controllerWithRootViewController:(UIViewController *)viewController;
+ (id)controllerWithRootViewControllerClass:(Class)viewControllerClass;


@end
