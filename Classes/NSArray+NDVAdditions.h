//
//  NSArray+NDVAdditions.h
//  NDVKit
//
//  Created by Nathan de Vries on 26/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (NDVAdditions)


- (BOOL)isEmpty;
- (BOOL)isNotEmpty;

- (id)firstObject;

- (BOOL)containsObjectIdenticalTo:(id)anObject;


@end
