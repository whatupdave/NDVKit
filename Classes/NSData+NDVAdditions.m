//
//  NSData+NDVAdditions.m
//  NDVKit
//
//  Created by Nathan de Vries on 26/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//

#import "NSData+NDVAdditions.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSData (NDVAdditions)


- (NSString *)MD5Sum {
	unsigned char hashData[CC_MD5_DIGEST_LENGTH];
	CC_MD5([self bytes], [self length], hashData);

	NSMutableString* hashString = [NSMutableString string];
	for (NSUInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
    [hashString appendFormat:@"%02x", hashData[i]];
  }

	return hashString;
}


@end
