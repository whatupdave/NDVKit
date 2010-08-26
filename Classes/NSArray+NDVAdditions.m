//
//  NSArray+NDVAdditions.m
//  NDVKit
//
//  Created by Nathan de Vries on 26/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "NSArray+NDVAdditions.h"


@implementation NSArray (NDVAdditions)


- (BOOL)isEmpty {
  return [self count] == 0;
}


- (BOOL)isNotEmpty {
  return [self count] != 0;
}


- (id)firstObject {
  return [self isNotEmpty] ? [self objectAtIndex:0] : nil;
}


- (BOOL)containsObjectIdenticalTo:(id)anObject {
  return ([self indexOfObjectIdenticalTo:anObject] != NSNotFound);
}


@end
