//
//  NSString+NDVAdditions.m
//  NDVKit
//
//  Created by Nathan de Vries on 24/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "NSString+NDVAdditions.h"
#import <CommonCrypto/CommonDigest.h>


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


- (NSString *)stringByAddingURLEncodingPercentEscapes {
  CFStringRef encodedString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                      (CFStringRef)self,
                                                                      NULL,
                                                                      CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                      kCFStringEncodingUTF8);
  return [(NSString *)encodedString autorelease];
}


- (NSString *)stringByHashingWithMD5 {
	NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];

	unsigned char hashData[CC_MD5_DIGEST_LENGTH];
	CC_MD5([data bytes], [data length], hashData);

	NSMutableString* hashString = [NSMutableString string];
	for (NSUInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
    [hashString appendFormat:@"%02x", hashData[i]];
  }

	return hashString;
}


@end
