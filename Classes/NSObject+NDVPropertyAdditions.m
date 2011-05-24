/*
 * NSObject+NDVPropertyAdditions.m
 *
 * Created by Nathan de Vries on 24/08/10.
 *
 * Copyright (c) 2008-2011, Nathan de Vries.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the copyright holder nor the names of any
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */


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
