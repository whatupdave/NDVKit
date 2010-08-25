//
//  NSObject+NDVPropertyAdditions.m
//  NDVKit
//
//  Created by Nathan de Vries on 24/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "NSObject+NDVPropertyAdditions.h"
#import <objc/runtime.h>


@implementation NSObject (NDVPropertyAdditions)


+ (NSArray *)allPropertyNames {
  NSUInteger propertiesCount;
  objc_property_t* propertyList = class_copyPropertyList(self, &propertiesCount);

  NSMutableArray* allPropertyNames = [NSMutableArray arrayWithCapacity:propertiesCount];

  for (NSUInteger i = 0; i < propertiesCount; i++) {
    objc_property_t property = propertyList[i];
    const char* propertyName = property_getName(property);

    if (propertyName) {
      [allPropertyNames addObject:[NSString stringWithCString:propertyName
                                                     encoding:NSUTF8StringEncoding]];
    }
  }

  free(propertyList);

  return [NSArray arrayWithArray:allPropertyNames];
}


- (void)encodeAllPropertiesWithCoder:(NSCoder *)encoder {
  for (NSString* propertyName in [[self class] allPropertyNames]) {
    [encoder encodeObject:[self valueForKey:propertyName]
                   forKey:propertyName];
  }
}


- (void)decodeAllPropertiesWithCoder:(NSCoder *)decoder {
  for (NSString* propertyName in [[self class] allPropertyNames]) {
    id value = [decoder decodeObjectForKey:propertyName];
    if (value) {
      [self setValue:value forKey:propertyName];
    }
  }
}


@end
