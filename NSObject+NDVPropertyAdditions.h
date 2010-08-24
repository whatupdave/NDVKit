//
//  NSObject+NDVPropertyAdditions.h
//  NDVKit
//
//  Created by Nathan de Vries on 24/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (NDVPropertyAdditions)


+ (NSArray *)allPropertyNames;

- (void)encodeAllPropertiesWithCoder:(NSCoder *)encoder;
- (void)decodeAllPropertiesWithCoder:(NSCoder *)decoder;


@end
