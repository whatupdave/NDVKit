//
//  NSString+NDVAdditions.m
//  NDVKit
//
//  Created by Nathan de Vries on 24/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "NSString+NDVAdditions.h"
#import "NSData+NDVAdditions.h"


@implementation NSString(NDVAdditions)


- (BOOL)isWhitespace {
  NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  for (NSUInteger i = 0; i < self.length; i++) {
    unichar character = [self characterAtIndex:i];
    if (![whitespace characterIsMember:character]) {
      return NO;
    }
  }
  return YES;
}


- (BOOL)isEmptyOrWhitespace {
  return (!self.length ||
          ![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length);
}


- (BOOL)isNumeric {
  NSScanner* scanner = [NSScanner scannerWithString:self];
  return ([scanner scanDouble:NULL] ?
          [scanner isAtEnd] :
          NO);
}


- (BOOL)containsString:(NSString *)aString {
  return [self containsString:aString
                 ignoringCase:NO];
}


- (BOOL)containsString:(NSString *)aString ignoringCase:(BOOL)ignoreCase {
  NSStringCompareOptions compareOptions = ignoreCase ? NSCaseInsensitiveSearch : 0;
  NSRange range = [self rangeOfString:aString
                              options:compareOptions];

  return (range.location != NSNotFound);
}


- (NSString *)stringByAddingURLEncodingPercentEscapes {
  CFStringRef encodedString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                      (CFStringRef)self,
                                                                      NULL,
                                                                      CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                      kCFStringEncodingUTF8);
  return [(NSString *)encodedString autorelease];
}


- (NSString *)MD5Sum {
  return [[self dataUsingEncoding:NSUTF8StringEncoding] MD5Sum];
}


@end
