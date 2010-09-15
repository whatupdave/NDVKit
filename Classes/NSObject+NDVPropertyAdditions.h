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


# define SYNTHESIZE_ENCODER_AND_DECODER_FOR_ALL_PROPERTIES() \
- (id)initWithCoder:(NSCoder *)decoder { \
  if ((self = [self init])) { \
    [self decodeAllPropertiesWithCoder:decoder]; \
  } \
  return self; \
} \
\
\
- (void)encodeWithCoder:(NSCoder *)encoder { \
  [self encodeAllPropertiesWithCoder:encoder]; \
}
