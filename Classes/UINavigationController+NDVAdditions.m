//
//  UINavigationController+NDVAdditions.m
//  NDVKit
//
//  Created by Nathan de Vries on 25/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "UINavigationController+NDVAdditions.h"


@implementation UINavigationController (NDVAdditions)


+ (id)controllerWithRootViewController:(UIViewController *)viewController {
  return [[[[self class] alloc] initWithRootViewController:viewController] autorelease];
}


+ (id)controllerWithRootViewControllerClass:(Class)viewControllerClass {
  return [self controllerWithRootViewController:[[[viewControllerClass alloc] init] autorelease]];
}


@end
