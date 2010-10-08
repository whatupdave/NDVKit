//
//  NSDateFormatter+NDVAdditions.m
//  NDVKit
//
//  Created by Nathan de Vries on 24/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "NSDateFormatter+NDVAdditions.h"


@implementation NSDateFormatter (NDVAdditions)


+ (id)unlocalisedFormatter {
  static NSDateFormatter* formatter = nil;

  if (formatter == nil) {
    formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
  }

  return formatter;
}


+ (id)unlocalisedFormatterWithFormat:(NSString *)dateFormat {
  NSDateFormatter* formatter = [self unlocalisedFormatter];
  formatter.dateFormat = dateFormat;
  return formatter;
}


@end
